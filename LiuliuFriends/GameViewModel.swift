import Foundation
import SwiftUI

final class GameViewModel: ObservableObject {
    @Published var round: GameRound
    @Published var completedCandidateID: UUID?
    @Published var wrongCandidateID: UUID?
    @Published var hintCandidateID: UUID?
    @Published var celebrationSeed = 0
    @Published var completedRounds = 0
    @Published var screen: AppScreen = .play
    @Published var settings = GameSettings() {
        didSet {
            persistSettings()
        }
    }
    @Published var breakReminder: BreakReminder?
    @Published var hasStartedPlaying = false

    let voiceStore: VoicePromptStore
    let promptAliasStore: PromptAliasStore
    private var roundIndex = 0
    private let rounds: [GameRound]
    private let feedbackPlayer: FeedbackPlaying
    private let autoAdvanceDelay: TimeInterval
    private let nextPromptDelayAfterAutoAdvance: TimeInterval
    private let initialPromptDelay: TimeInterval
    private let sessionLimit: TimeInterval
    private let dailyLimit: TimeInterval
    private let defaults: UserDefaults
    private var hasPlayedInitialPrompt = false
    private var sessionUsage: TimeInterval = 0
    private var dailyUsage: TimeInterval
    private var dailyUsageDate: String
    private var dismissedDailyLimitDate: String?
    private var pendingAutoAdvanceWorkItem: DispatchWorkItem?
    private var pendingRetryClearWorkItem: DispatchWorkItem?
    private var pendingHintWorkItem: DispatchWorkItem?
    private var pendingHintClearWorkItem: DispatchWorkItem?
    private var pendingPromptWorkItem: DispatchWorkItem?
    private var roundHadWrongAttempt = false
    private var reviewQueue: [ReviewRound] = []
    private var nextReviewAllowedAfterCompletedRounds = 0

    private static let adaptiveWarmupCompletionCount = 8
    private static let adaptiveWarmupAgeBands: Set<LearningAgeBand> = [.starter18Months, .explorer24Months]
    private static let reviewDelayInCompletedRounds = 3
    private static let completedRoundsBetweenReviews = 1

    private var activeRounds: [GameRound] {
        let stageRounds = rounds.filter { $0.mode.ageBand.isIncluded(in: settings.maximumAgeBand) }
        let enabledRounds = stageRounds.filter { settings.enabledGameModes.contains($0.mode) }
        let baseRounds = enabledRounds.isEmpty ? (stageRounds.isEmpty ? rounds : stageRounds) : enabledRounds
        guard completedRounds < Self.adaptiveWarmupCompletionCount else {
            return baseRounds
        }

        let warmupRounds = baseRounds.filter { Self.isAdaptiveWarmupMode($0.mode) }
        return warmupRounds.isEmpty ? baseRounds : warmupRounds
    }

    var stageGameModes: [GameMode] {
        GameMode.allCases.filter { $0.ageBand.isIncluded(in: settings.maximumAgeBand) }
    }

    var playableGameModes: [GameMode] {
        let enabledModes = stageGameModes.filter { settings.enabledGameModes.contains($0) }
        return enabledModes.isEmpty ? stageGameModes : enabledModes
    }

    var playableRoundCount: Int {
        let playableModes = Set(playableGameModes)
        return rounds.filter { playableModes.contains($0.mode) }.count
    }

    var showsManualNextRoundControl: Bool {
        completedCandidateID != nil && !settings.autoAdvanceEnabled && breakReminder == nil
    }

    var completionMessage: String? {
        guard completedCandidateID != nil else { return nil }
        return successSpeechText(for: round)
    }

    init(
        rounds: [GameRound] = GameContent.sessionRounds(),
        voiceStore: VoicePromptStore = .shared,
        promptAliasStore: PromptAliasStore = .shared,
        feedbackPlayer: FeedbackPlaying? = nil,
        autoAdvanceDelay: TimeInterval = 1.15,
        nextPromptDelayAfterAutoAdvance: TimeInterval = 0.75,
        initialPromptDelay: TimeInterval = 0.25,
        sessionLimit: TimeInterval = 10 * 60,
        dailyLimit: TimeInterval = 20 * 60,
        defaults: UserDefaults = .standard
    ) {
        precondition(!rounds.isEmpty, "Game requires at least one round.")
        self.rounds = rounds
        self.voiceStore = voiceStore
        self.promptAliasStore = promptAliasStore
        self.feedbackPlayer = feedbackPlayer ?? SystemFeedbackPlayer(voiceStore: voiceStore)
        self.autoAdvanceDelay = autoAdvanceDelay
        self.nextPromptDelayAfterAutoAdvance = nextPromptDelayAfterAutoAdvance
        self.initialPromptDelay = initialPromptDelay
        self.sessionLimit = sessionLimit
        self.dailyLimit = dailyLimit
        self.defaults = defaults
        let today = Self.todayKey()
        dailyUsageDate = defaults.string(forKey: Self.dailyUsageDateKey) ?? today
        if dailyUsageDate == today {
            dailyUsage = defaults.double(forKey: Self.dailyUsageSecondsKey)
        } else {
            dailyUsageDate = today
            dailyUsage = 0
            defaults.set(today, forKey: Self.dailyUsageDateKey)
            defaults.set(0, forKey: Self.dailyUsageSecondsKey)
        }
        dismissedDailyLimitDate = defaults.string(forKey: Self.dismissedDailyLimitDateKey)
        settings = Self.loadSettings(from: defaults)
        round = rounds.first { Self.isAdaptiveWarmupMode($0.mode) } ?? rounds[0]
    }

    func playInitialPromptIfNeeded() {
        guard !hasPlayedInitialPrompt else { return }
        hasPlayedInitialPrompt = true
        scheduleInitialPrompt()
    }

    func startPlaying() {
        guard !hasStartedPlaying else { return }
        hasStartedPlaying = true
        playInitialPromptIfNeeded()
    }

    func recordActiveUsageTick(_ seconds: TimeInterval = 1) {
        guard settings.restReminderEnabled else { return }
        guard hasStartedPlaying else { return }
        guard screen == .play, breakReminder == nil else { return }

        rolloverDailyUsageIfNeeded()
        sessionUsage += seconds
        dailyUsage += seconds
        defaults.set(dailyUsage, forKey: Self.dailyUsageSecondsKey)

        if dailyUsage >= dailyLimit, dismissedDailyLimitDate != dailyUsageDate {
            pauseForBreak(.dailyLimit)
        } else if sessionUsage >= sessionLimit {
            pauseForBreak(.sessionLimit)
        }
    }

    func continueAfterBreak() {
        if breakReminder == .dailyLimit {
            dismissedDailyLimitDate = dailyUsageDate
            defaults.set(dailyUsageDate, forKey: Self.dismissedDailyLimitDateKey)
        }
        sessionUsage = 0
        breakReminder = nil
        playPrompt(for: round)
    }

    @discardableResult
    func choose(_ candidate: FriendCandidate) -> SelectionResult {
        guard breakReminder == nil else {
            return .ignored
        }

        guard completedCandidateID == nil else {
            return .ignored
        }

        guard wrongCandidateID == nil else {
            return .ignored
        }

        if candidate.isCorrect {
            cancelPendingRetryClear()
            cancelPendingHint()
            let shouldScheduleReview = roundHadWrongAttempt
            wrongCandidateID = nil
            hintCandidateID = nil
            completedCandidateID = candidate.id
            celebrationSeed += 1
            completedRounds += 1
            if shouldScheduleReview {
                scheduleReview(for: round)
            }
            feedbackPlayer.playCorrect(text: successSpeechText(for: round), recordingID: round.voicePromptID, settings: settings)

            if settings.autoAdvanceEnabled {
                scheduleAutoAdvance()
            }
            return .correct
        } else {
            roundHadWrongAttempt = true
            wrongCandidateID = candidate.id
            hintCandidateID = nil
            feedbackPlayer.playRetry(settings: settings)

            cancelPendingRetryClear()
            cancelPendingHint()
            let correctID = round.candidates.first { $0.isCorrect }?.id
            let hintWorkItem = DispatchWorkItem { [weak self] in
                self?.pendingHintWorkItem = nil
                self?.hintCandidateID = correctID
            }
            pendingHintWorkItem = hintWorkItem
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.45, execute: hintWorkItem)

            let workItem = DispatchWorkItem { [weak self] in
                self?.pendingRetryClearWorkItem = nil
                self?.wrongCandidateID = nil
            }
            pendingRetryClearWorkItem = workItem
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8, execute: workItem)
            return .retry
        }
    }

    func nextRound() {
        advanceToNextRound(promptDelay: 0)
    }

    private func advanceToNextRound(promptDelay: TimeInterval) {
        cancelPendingAutoAdvance()
        cancelPendingRetryClear()
        cancelPendingHint()
        cancelPendingPrompt()
        let availableRounds = activeRounds
        let currentIndex = availableRounds.firstIndex { $0.id == round.id } ?? -1
        roundIndex = (currentIndex + 1) % availableRounds.count
        completedCandidateID = nil
        wrongCandidateID = nil
        hintCandidateID = nil
        roundHadWrongAttempt = false

        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            round = nextReviewRound(from: availableRounds) ?? availableRounds[roundIndex]
        }
        playPromptAfterDelay(promptDelay)
    }

    func replayPrompt() {
        playPrompt(for: round)
        showCorrectHint(duration: 1.5)
    }

    func setGameMode(_ mode: GameMode, enabled: Bool) {
        var enabledModes = settings.enabledGameModes
        if enabled {
            enabledModes.insert(mode)
        } else {
            guard enabledModes.count > 1 else { return }
            enabledModes.remove(mode)
        }
        settings.enabledGameModes = enabledModes

        guard !enabledModes.contains(round.mode) else { return }
        moveToFirstActiveRound()
    }

    func setMaximumAgeBand(_ ageBand: LearningAgeBand) {
        settings.maximumAgeBand = ageBand

        guard !round.mode.ageBand.isIncluded(in: ageBand) else { return }
        moveToFirstActiveRound()
    }

    func displayName(for target: VoicePromptTarget) -> String {
        guard settings.customPromptAliasEnabled else { return target.name }
        return promptAliasStore.displayName(for: target)
    }

    func displayName(for kind: FriendKind) -> String {
        guard settings.customPromptAliasEnabled else { return kind.name }
        return promptAliasStore.displayName(for: kind)
    }

    func soundPrompt(for kind: FriendKind) -> String {
        guard settings.customPromptAliasEnabled else {
            return LearningPromptTextCatalog.soundPrompt(for: kind)
        }
        return promptAliasStore.soundPrompt(for: kind)
    }

    func soundRoundPrompt(for kind: FriendKind) -> String {
        "找\(soundPrompt(for: kind))"
    }

    func customPromptName(for target: VoicePromptTarget) -> String {
        promptAliasStore.customName(for: target.id) ?? ""
    }

    func setCustomPromptName(_ name: String, for target: VoicePromptTarget) {
        promptAliasStore.setCustomName(name, for: target.id)
    }

    func resetCustomPromptName(for target: VoicePromptTarget) {
        promptAliasStore.resetCustomName(for: target.id)
    }

    func resetProgress() {
        cancelPendingAutoAdvance()
        cancelPendingRetryClear()
        cancelPendingHint()
        cancelPendingPrompt()
        roundIndex = 0
        completedRounds = 0
        completedCandidateID = nil
        wrongCandidateID = nil
        hintCandidateID = nil
        roundHadWrongAttempt = false
        celebrationSeed = 0
        sessionUsage = 0
        breakReminder = nil
        reviewQueue.removeAll()
        nextReviewAllowedAfterCompletedRounds = 0

        withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
            round = activeRounds[0]
        }
        playPrompt(for: round)
    }

    private func moveToFirstActiveRound() {
        cancelPendingAutoAdvance()
        cancelPendingRetryClear()
        cancelPendingHint()
        cancelPendingPrompt()
        roundIndex = 0
        completedCandidateID = nil
        wrongCandidateID = nil
        hintCandidateID = nil
        roundHadWrongAttempt = false
        pruneReviewQueue()
        nextReviewAllowedAfterCompletedRounds = completedRounds

        withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
            round = activeRounds[0]
        }
        if hasStartedPlaying {
            playPrompt(for: round)
        }
    }

    private static func isAdaptiveWarmupMode(_ mode: GameMode) -> Bool {
        adaptiveWarmupAgeBands.contains(mode.ageBand)
    }

    private func scheduleReview(for round: GameRound) {
        guard round.mode.ageBand.isIncluded(in: settings.maximumAgeBand) else { return }
        guard settings.enabledGameModes.contains(round.mode) else { return }
        guard !reviewQueue.contains(where: { $0.roundID == round.id }) else { return }

        reviewQueue.append(
            ReviewRound(
                roundID: round.id,
                availableAfterCompletedRounds: completedRounds + Self.reviewDelayInCompletedRounds
            )
        )
    }

    private func nextReviewRound(from availableRounds: [GameRound]) -> GameRound? {
        pruneReviewQueue()
        guard completedRounds >= nextReviewAllowedAfterCompletedRounds else {
            return nil
        }
        guard let reviewIndex = reviewQueue.firstIndex(where: { $0.availableAfterCompletedRounds <= completedRounds }) else {
            return nil
        }

        let review = reviewQueue.remove(at: reviewIndex)
        guard let reviewRound = availableRounds.first(where: { $0.id == review.roundID }), reviewRound.id != round.id else {
            return nil
        }

        roundIndex = availableRounds.firstIndex { $0.id == reviewRound.id } ?? roundIndex
        nextReviewAllowedAfterCompletedRounds = completedRounds + Self.completedRoundsBetweenReviews + 1
        return reviewRound
    }

    private func pruneReviewQueue() {
        reviewQueue.removeAll { review in
            guard let reviewRound = rounds.first(where: { $0.id == review.roundID }) else { return true }
            return !settings.enabledGameModes.contains(reviewRound.mode) || !reviewRound.mode.ageBand.isIncluded(in: settings.maximumAgeBand)
        }
    }

    private func scheduleAutoAdvance() {
        cancelPendingAutoAdvance()
        let workItem = DispatchWorkItem { [weak self] in
            self?.pendingAutoAdvanceWorkItem = nil
            self?.advanceToNextRound(promptDelay: self?.nextPromptDelayAfterAutoAdvance ?? 0)
        }
        pendingAutoAdvanceWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + autoAdvanceDelay, execute: workItem)
    }

    private func cancelPendingAutoAdvance() {
        pendingAutoAdvanceWorkItem?.cancel()
        pendingAutoAdvanceWorkItem = nil
    }

    private func playPromptAfterDelay(_ delay: TimeInterval) {
        guard delay > 0 else {
            playPrompt(for: round)
            return
        }

        let roundID = round.id
        let workItem = DispatchWorkItem { [weak self] in
            guard let self, self.round.id == roundID else { return }
            self.pendingPromptWorkItem = nil
            self.playPrompt(for: self.round)
        }
        pendingPromptWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: workItem)
    }

    private func scheduleInitialPrompt() {
        guard initialPromptDelay > 0 else {
            playPrompt(for: round)
            return
        }

        let roundID = round.id
        let workItem = DispatchWorkItem { [weak self] in
            guard let self, self.round.id == roundID, self.screen == .play, self.breakReminder == nil else { return }
            self.pendingPromptWorkItem = nil
            self.playPrompt(for: self.round)
        }
        pendingPromptWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + initialPromptDelay, execute: workItem)
    }

    private func playPrompt(for round: GameRound) {
        feedbackPlayer.playPrompt(text: promptSpeechText(for: round), recordingID: round.voicePromptID, settings: settings)
    }

    func promptSpeechText(for round: GameRound) -> String {
        switch round.mode {
        case .animal:
            return "找\(displayName(for: round.targetKind))"
        case .vehicle:
            return "找\(displayName(for: round.targetKind))"
        case .fruit:
            return "找\(displayName(for: round.targetKind))"
        case .sound:
            return soundRoundPrompt(for: round.targetKind)
        case .color:
            return "找\(displayName(for: VoicePromptTarget.target(for: round.targetColor)))"
        case .shape:
            return "找\(displayName(for: round.targetKind))"
        case .colorShape:
            return "找\(displayName(for: VoicePromptTarget.target(for: round.targetColor)))\(displayName(for: round.targetKind))"
        case .body:
            return "找\(displayName(for: round.targetKind))"
        case .clothing:
            return "找\(displayName(for: round.targetKind))"
        case .vegetable:
            return "找\(displayName(for: round.targetKind))"
        case .food:
            return "找\(displayName(for: round.targetKind))"
        case .tableware:
            return "找\(displayName(for: round.targetKind))"
        case .hygiene:
            return "找\(displayName(for: round.targetKind))"
        case .home:
            return "找\(displayName(for: round.targetKind))"
        case .stationery:
            return "找\(displayName(for: round.targetKind))"
        case .instrument:
            return "找\(displayName(for: round.targetKind))"
        case .toy:
            return "找\(displayName(for: round.targetKind))"
        case .nature:
            return "找\(displayName(for: round.targetKind))"
        case .place:
            return "找\(displayName(for: round.targetKind))"
        case .profession:
            return "找\(displayName(for: round.targetKind))"
        case .size:
            return "找一样大的\(displayName(for: round.targetKind))"
        case .length:
            return round.targetSizeScale > 1 ? "找长长的" : "找短短的"
        case .height:
            return round.targetSizeScale > 1 ? "找高高的" : "找矮矮的"
        case .shadow:
            return "找\(displayName(for: round.targetKind))的影子"
        case .number:
            return "找数字\(round.targetCount.cnNumberName)"
        case .count:
            return "找\(round.targetCount.cnNumberName)个\(displayName(for: round.targetKind))"
        case .quantityCompare:
            return "找\(round.targetQuantityCompare?.speechTitle ?? "多的")"
        case .category:
            return "找\(round.targetCategory?.childPromptTitle ?? round.targetKind.category.childPromptTitle)"
        case .difference:
            return "找不一样的"
        case .position:
            return "找在\(round.targetPosition.name)的\(displayName(for: round.targetKind))"
        case .insideOutside:
            return "找在\(round.targetPosition.name)的\(displayName(for: round.targetKind))"
        case .frontBack:
            return "找在\(round.targetPosition.name)的\(displayName(for: round.targetKind))"
        case .purpose:
            return "找\(round.targetPurpose?.speechTitle ?? displayName(for: round.targetKind))"
        case .safety:
            return "找\(round.targetSafety?.speechTitle ?? displayName(for: round.targetKind))"
        case .scene:
            return "找\(round.targetScene?.speechTitle ?? displayName(for: round.targetKind))"
        case .weather:
            return "找\(round.targetWeather?.speechTitle ?? displayName(for: round.targetKind))"
        case .routine:
            return "找\(round.targetRoutine?.speechTitle ?? displayName(for: round.targetKind))"
        case .emotion:
            return "找\(round.targetEmotion?.speechTitle ?? displayName(for: round.targetKind))"
        case .action:
            return "找\(round.targetAction?.speechTitle ?? displayName(for: round.targetKind))"
        case .texture:
            return "找\(round.targetTexture?.speechTitle ?? displayName(for: round.targetKind))"
        case .taste:
            return "找\(round.targetTaste?.speechTitle ?? displayName(for: round.targetKind))"
        case .pairing:
            return "找\(round.targetPairing?.speechTitle ?? displayName(for: round.targetKind))"
        case .animalHome:
            return "找\(round.targetAnimalHome?.speechTitle ?? displayName(for: round.targetKind))的\(displayName(for: round.targetKind))"
        case .animalBaby:
            return "找\(round.targetAnimalBaby?.speechTitle ?? displayName(for: round.targetKind))"
        case .animalFood:
            return "找\(round.targetAnimalFood?.speechTitle ?? displayName(for: round.targetKind))"
        case .itemHome:
            return "找\(round.targetItemHome?.speechTitle ?? displayName(for: round.targetKind))"
        case .origin:
            return "找\(round.targetOrigin?.speechTitle ?? displayName(for: round.targetKind))"
        case .opposite:
            return "找\(round.targetOpposite?.speechTitle ?? displayName(for: round.targetKind))"
        case .rhythm:
            return "找\(round.targetRhythm?.speechTitle ?? displayName(for: round.targetKind))"
        case .sequence:
            return "找\(round.targetSequence?.speechTitle ?? displayName(for: round.targetKind))"
        case .pattern:
            return "找\(round.targetPattern?.speechTitle ?? displayName(for: round.targetKind))"
        }
    }

    private func successSpeechText(for round: GameRound) -> String {
        switch round.mode {
        case .vehicle:
            return "\(displayName(for: round.targetKind))，找到了"
        case .fruit:
            return "\(displayName(for: round.targetKind))，找到了"
        case .color:
            return "\(displayName(for: VoicePromptTarget.target(for: round.targetColor)))，找到了"
        case .colorShape:
            return "\(displayName(for: VoicePromptTarget.target(for: round.targetColor)))\(displayName(for: round.targetKind))，找到了"
        case .body:
            return "\(displayName(for: round.targetKind))，找到了"
        case .clothing:
            return "\(displayName(for: round.targetKind))，找到了"
        case .vegetable:
            return "\(displayName(for: round.targetKind))，找到了"
        case .food:
            return "\(displayName(for: round.targetKind))，找到了"
        case .tableware:
            return "\(displayName(for: round.targetKind))，找到了"
        case .hygiene:
            return "\(displayName(for: round.targetKind))，找到了"
        case .home:
            return "\(displayName(for: round.targetKind))，找到了"
        case .stationery:
            return "\(displayName(for: round.targetKind))，找到了"
        case .instrument:
            return "\(displayName(for: round.targetKind))，找到了"
        case .toy:
            return "\(displayName(for: round.targetKind))，找到了"
        case .nature:
            return "\(displayName(for: round.targetKind))，找到了"
        case .place:
            return "\(displayName(for: round.targetKind))，找到了"
        case .profession:
            return "\(displayName(for: round.targetKind))，找到了"
        case .length:
            return round.targetSizeScale > 1 ? "长长的，找到了" : "短短的，找到了"
        case .height:
            return round.targetSizeScale > 1 ? "高高的，找到了" : "矮矮的，找到了"
        case .number:
            return "数字\(round.targetCount.cnNumberName)，找到了"
        case .count:
            return "\(round.targetCount.cnNumberName)个\(displayName(for: round.targetKind))，找到了"
        case .quantityCompare:
            return "\(round.targetQuantityCompare?.promptTitle ?? "多的")，找到了"
        case .category:
            return "\(displayName(for: round.targetKind))，是\(round.targetKind.category.childPromptTitle)"
        case .difference:
            return "\(displayName(for: round.targetKind))，不一样"
        case .position:
            return "\(displayName(for: round.targetKind))在\(round.targetPosition.name)，找到了"
        case .insideOutside:
            return "\(displayName(for: round.targetKind))在\(round.targetPosition.name)，找到了"
        case .frontBack:
            return "\(displayName(for: round.targetKind))在\(round.targetPosition.name)，找到了"
        case .purpose:
            return "\(displayName(for: round.targetKind))，找到了"
        case .safety:
            return "\(displayName(for: round.targetKind))，\(round.targetSafety?.promptTitle ?? "找到了")"
        case .emotion:
            return "\(round.targetEmotion?.promptTitle ?? displayName(for: round.targetKind))，找到了"
        case .texture:
            return "\(displayName(for: round.targetKind))，摸起来\(round.targetTexture?.promptTitle ?? "找到了")"
        case .taste:
            return "\(displayName(for: round.targetKind))，尝起来\(round.targetTaste?.promptTitle ?? "找到了")"
        case .pairing:
            return "\(displayName(for: round.targetKind))，是好搭档"
        case .animalHome:
            return "\(displayName(for: round.targetKind))\(round.targetAnimalHome?.speechTitle ?? "找到了")，找到了"
        case .animalBaby:
            return "\(displayName(for: round.targetKind))，是\(round.targetAnimalBaby?.speechTitle ?? "宝宝")"
        case .animalFood:
            return "\(displayName(for: round.targetKind))，是\(round.targetAnimalFood?.speechTitle ?? "爱吃的")"
        case .itemHome:
            return "\(displayName(for: round.targetKind))，是\(round.targetItemHome?.speechTitle ?? "放好的")"
        case .origin:
            return "\(displayName(for: round.targetKind))，是\(round.targetOrigin?.speechTitle ?? "来源")"
        case .opposite:
            return "\(round.targetOpposite?.answerTitle ?? displayName(for: round.targetKind))，找到了"
        case .rhythm:
            return "\(round.targetRhythm?.promptTitle ?? displayName(for: round.targetKind))，找到了"
        case .sequence:
            return "\(round.targetSequence?.promptTitle ?? displayName(for: round.targetKind))，找到了"
        case .pattern:
            return "\(displayName(for: round.targetKind))，找到了"
        default:
            return "\(displayName(for: round.targetKind))，找到了"
        }
    }

    private func cancelPendingPrompt() {
        pendingPromptWorkItem?.cancel()
        pendingPromptWorkItem = nil
    }

    private func cancelPendingRetryClear() {
        pendingRetryClearWorkItem?.cancel()
        pendingRetryClearWorkItem = nil
    }

    private func showCorrectHint(duration: TimeInterval) {
        cancelPendingHint()
        hintCandidateID = round.candidates.first { $0.isCorrect }?.id
        let workItem = DispatchWorkItem { [weak self] in
            self?.pendingHintClearWorkItem = nil
            self?.hintCandidateID = nil
        }
        pendingHintClearWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: workItem)
    }

    private func cancelPendingHint() {
        pendingHintWorkItem?.cancel()
        pendingHintWorkItem = nil
        pendingHintClearWorkItem?.cancel()
        pendingHintClearWorkItem = nil
    }

    private func pauseForBreak(_ reminder: BreakReminder) {
        cancelPendingAutoAdvance()
        cancelPendingRetryClear()
        cancelPendingHint()
        cancelPendingPrompt()
        breakReminder = reminder
    }

    private func rolloverDailyUsageIfNeeded() {
        let today = Self.todayKey()
        guard dailyUsageDate != today else { return }
        dailyUsageDate = today
        dailyUsage = 0
        dismissedDailyLimitDate = nil
        defaults.set(today, forKey: Self.dailyUsageDateKey)
        defaults.set(0, forKey: Self.dailyUsageSecondsKey)
        defaults.removeObject(forKey: Self.dismissedDailyLimitDateKey)
    }

    private static var dailyUsageDateKey: String {
        "liuliufriends.dailyUsageDate"
    }

    private static var dailyUsageSecondsKey: String {
        "liuliufriends.dailyUsageSeconds"
    }

    private static var dismissedDailyLimitDateKey: String {
        "liuliufriends.dismissedDailyLimitDate"
    }

    private static var settingsKey: String {
        "liuliufriends.gameSettings.v1"
    }

    private static func loadSettings(from defaults: UserDefaults) -> GameSettings {
        guard let data = defaults.data(forKey: settingsKey) else {
            return GameSettings()
        }

        do {
            var settings = try JSONDecoder().decode(GameSettings.self, from: data)
            if settings.enabledGameModes.isEmpty {
                settings.enabledGameModes = Set(GameMode.allCases)
            }
            return settings
        } catch {
            return GameSettings()
        }
    }

    private func persistSettings() {
        guard let data = try? JSONEncoder().encode(settings) else { return }
        defaults.set(data, forKey: Self.settingsKey)
    }

    private static func todayKey() -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
}
