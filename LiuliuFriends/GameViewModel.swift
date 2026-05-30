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

    let voiceStore: VoicePromptStore
    private var roundIndex = 0
    private let rounds: [GameRound]
    private let feedbackPlayer: FeedbackPlaying
    private let autoAdvanceDelay: TimeInterval
    private var hasPlayedInitialPrompt = false
    private var pendingAutoAdvanceWorkItem: DispatchWorkItem?
    private var pendingRetryClearWorkItem: DispatchWorkItem?
    private var pendingHintWorkItem: DispatchWorkItem?
    private var pendingHintClearWorkItem: DispatchWorkItem?

    init(
        rounds: [GameRound] = GameContent.rounds,
        voiceStore: VoicePromptStore = .shared,
        feedbackPlayer: FeedbackPlaying? = nil,
        autoAdvanceDelay: TimeInterval = 1.15
    ) {
        precondition(!rounds.isEmpty, "Game requires at least one round.")
        self.rounds = rounds
        self.voiceStore = voiceStore
        self.feedbackPlayer = feedbackPlayer ?? SystemFeedbackPlayer(voiceStore: voiceStore)
        self.autoAdvanceDelay = autoAdvanceDelay
        round = rounds[0]
    }

    func playInitialPromptIfNeeded() {
        guard !hasPlayedInitialPrompt else { return }
        hasPlayedInitialPrompt = true
        feedbackPlayer.playPrompt(for: round, settings: settings)
    }

    @discardableResult
    func choose(_ candidate: FriendCandidate) -> SelectionResult {
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
            feedbackPlayer.playCorrect(for: round, settings: settings)

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
        cancelPendingAutoAdvance()
        cancelPendingRetryClear()
        cancelPendingHint()
        roundIndex = (roundIndex + 1) % rounds.count
        completedCandidateID = nil
        wrongCandidateID = nil
        hintCandidateID = nil

        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            round = rounds[roundIndex]
        }
        feedbackPlayer.playPrompt(for: round, settings: settings)
    }

    func replayPrompt() {
        feedbackPlayer.playPrompt(for: round, settings: settings)
        showCorrectHint(duration: 1.5)
    }

    func toggleRecordingForCurrentTarget() {
        if voiceStore.recordingKind == round.targetKind {
            voiceStore.stopRecording()
        } else {
            voiceStore.startRecording(for: round.targetKind)
        }
    }

    func playRecordingForCurrentTarget() {
        _ = voiceStore.playRecording(for: round.targetKind)
    }

    func deleteRecordingForCurrentTarget() {
        voiceStore.deleteRecording(for: round.targetKind)
    }

    func resetProgress() {
        cancelPendingAutoAdvance()
        cancelPendingRetryClear()
        cancelPendingHint()
        roundIndex = 0
        completedRounds = 0
        completedCandidateID = nil
        wrongCandidateID = nil
        hintCandidateID = nil
        celebrationSeed = 0

        withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
            round = rounds[0]
        }
        feedbackPlayer.playPrompt(for: round, settings: settings)
    }

    private func scheduleAutoAdvance() {
        cancelPendingAutoAdvance()
        let workItem = DispatchWorkItem { [weak self] in
            self?.pendingAutoAdvanceWorkItem = nil
            self?.nextRound()
        }
        pendingAutoAdvanceWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + autoAdvanceDelay, execute: workItem)
    }

    private func cancelPendingAutoAdvance() {
        pendingAutoAdvanceWorkItem?.cancel()
        pendingAutoAdvanceWorkItem = nil
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
}
