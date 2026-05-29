import Foundation
import SwiftUI

final class GameViewModel: ObservableObject {
    @Published var round: GameRound
    @Published var completedCandidateID: UUID?
    @Published var wrongCandidateID: UUID?
    @Published var celebrationSeed = 0
    @Published var completedRounds = 0
    @Published var screen: AppScreen = .play
    @Published var settings = GameSettings()

    private var roundIndex = 0
    private let rounds: [GameRound]
    private let feedbackPlayer: FeedbackPlaying
    private let autoAdvanceDelay: TimeInterval
    private var pendingAutoAdvanceWorkItem: DispatchWorkItem?
    private var pendingRetryClearWorkItem: DispatchWorkItem?

    init(
        rounds: [GameRound] = GameContent.rounds,
        feedbackPlayer: FeedbackPlaying = SystemFeedbackPlayer(),
        autoAdvanceDelay: TimeInterval = 1.15
    ) {
        precondition(!rounds.isEmpty, "Game requires at least one round.")
        self.rounds = rounds
        self.feedbackPlayer = feedbackPlayer
        self.autoAdvanceDelay = autoAdvanceDelay
        round = rounds[0]
    }

    @discardableResult
    func choose(_ candidate: FriendCandidate) -> SelectionResult {
        guard completedCandidateID == nil else {
            return .ignored
        }

        if candidate.isCorrect {
            cancelPendingRetryClear()
            wrongCandidateID = nil
            completedCandidateID = candidate.id
            celebrationSeed += 1
            completedRounds += 1
            feedbackPlayer.playCorrect(settings: settings)

            if settings.autoAdvanceEnabled {
                scheduleAutoAdvance()
            }
            return .correct
        } else {
            wrongCandidateID = candidate.id
            feedbackPlayer.playRetry(settings: settings)

            cancelPendingRetryClear()
            let workItem = DispatchWorkItem { [weak self] in
                self?.pendingRetryClearWorkItem = nil
                self?.wrongCandidateID = nil
            }
            pendingRetryClearWorkItem = workItem
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.45, execute: workItem)
            return .retry
        }
    }

    func nextRound() {
        cancelPendingAutoAdvance()
        cancelPendingRetryClear()
        roundIndex = (roundIndex + 1) % rounds.count
        completedCandidateID = nil
        wrongCandidateID = nil

        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            round = rounds[roundIndex]
        }
        feedbackPlayer.playPrompt(for: round, settings: settings)
    }

    func replayPrompt() {
        feedbackPlayer.playPrompt(for: round, settings: settings)
    }

    func resetProgress() {
        cancelPendingAutoAdvance()
        cancelPendingRetryClear()
        roundIndex = 0
        completedRounds = 0
        completedCandidateID = nil
        wrongCandidateID = nil
        celebrationSeed = 0

        withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
            round = rounds[0]
        }
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
}
