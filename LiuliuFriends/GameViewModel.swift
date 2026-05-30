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
    @Published var settings = GameSettings()
    @Published var breakReminder: BreakReminder?
    @Published var selectedRecordingTargetID = VoicePromptTarget.defaultTarget.id

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

    init(
        rounds: [GameRound] = GameContent.sessionRounds(),
        voiceStore: VoicePromptStore = .shared,
        promptAliasStore: PromptAliasStore = .shared,
        feedbackPlayer: FeedbackPlaying? = nil,
        autoAdvanceDelay: TimeInterval = 1.15,
        nextPromptDelayAfterAutoAdvance: TimeInterval = 0.75,
        initialPromptDelay: TimeInterval = 0.9,
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
        round = rounds[0]
    }

    func playInitialPromptIfNeeded() {
        guard !hasPlayedInitialPrompt else { return }
        hasPlayedInitialPrompt = true
        scheduleInitialPrompt()
    }

    func recordActiveUsageTick(_ seconds: TimeInterval = 1) {
        guard settings.restReminderEnabled else { return }
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
            wrongCandidateID = nil
            hintCandidateID = nil
            completedCandidateID = candidate.id
            celebrationSeed += 1
            completedRounds += 1
            feedbackPlayer.playCorrect(text: successSpeechText(for: round), recordingID: round.voicePromptID, settings: settings)

            if settings.autoAdvanceEnabled {
                scheduleAutoAdvance()
            }
            return .correct
        } else {
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
        roundIndex = (roundIndex + 1) % rounds.count
        completedCandidateID = nil
        wrongCandidateID = nil
        hintCandidateID = nil

        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            round = rounds[roundIndex]
        }
        playPromptAfterDelay(promptDelay)
    }

    func replayPrompt() {
        playPrompt(for: round)
        showCorrectHint(duration: 1.5)
    }

    var selectedRecordingTarget: VoicePromptTarget {
        VoicePromptTarget.target(for: selectedRecordingTargetID)
    }

    func selectRecordingTarget(_ target: VoicePromptTarget) {
        guard voiceStore.recordingID == nil else { return }
        selectedRecordingTargetID = target.id
    }

    func toggleRecordingForSelectedKind() {
        if voiceStore.recordingID == selectedRecordingTargetID {
            voiceStore.stopRecording()
        } else {
            voiceStore.startRecording(for: selectedRecordingTargetID)
        }
    }

    func playRecordingForSelectedKind() {
        _ = voiceStore.playRecording(for: selectedRecordingTargetID)
    }

    func deleteRecordingForSelectedKind() {
        voiceStore.deleteRecording(for: selectedRecordingTargetID)
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
        celebrationSeed = 0
        sessionUsage = 0
        breakReminder = nil

        withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
            round = rounds[0]
        }
        playPrompt(for: round)
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
        case .sound:
            return soundPrompt(for: round.targetKind)
        case .color:
            return "找\(displayName(for: VoicePromptTarget.target(for: round.targetColor)))"
        case .shape:
            return "找\(displayName(for: round.targetKind))"
        case .size:
            return "找一样大的\(displayName(for: round.targetKind))"
        case .shadow:
            return "找\(displayName(for: round.targetKind))的影子"
        }
    }

    private func successSpeechText(for round: GameRound) -> String {
        switch round.mode {
        case .color:
            return "\(displayName(for: VoicePromptTarget.target(for: round.targetColor)))，找到了"
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

    private static func todayKey() -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
}
