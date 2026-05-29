import XCTest
@testable import LiuliuFriends

final class GameViewModelTests: XCTestCase {
    func testRoundsHaveExactlyOneCorrectCandidate() {
        for round in GameContent.rounds {
            let correctCount = round.candidates.filter { $0.isCorrect }.count
            XCTAssertEqual(correctCount, 1, "\(round.mode.title) should have exactly one correct candidate.")
            XCTAssertLessThanOrEqual(round.candidates.count, 2, "1-2 岁玩法每轮最多保留两个选项。")
        }
    }

    func testCorrectSelectionCompletesRoundWithoutAutoAdvanceWhenDisabled() {
        let feedback = TestFeedbackPlayer()
        let viewModel = GameViewModel(feedbackPlayer: feedback)
        viewModel.settings.autoAdvanceEnabled = false

        let correct = viewModel.round.candidates.first { $0.isCorrect }!
        let result = viewModel.choose(correct)

        XCTAssertEqual(result, .correct)
        XCTAssertEqual(viewModel.completedCandidateID, correct.id)
        XCTAssertEqual(viewModel.completedRounds, 1)
        XCTAssertEqual(viewModel.celebrationSeed, 1)
        XCTAssertEqual(feedback.correctCount, 1)
    }

    func testWrongSelectionMarksRetryAndDoesNotAdvanceProgress() {
        let feedback = TestFeedbackPlayer()
        let viewModel = GameViewModel(feedbackPlayer: feedback)

        let wrong = viewModel.round.candidates.first { !$0.isCorrect }!
        let result = viewModel.choose(wrong)

        XCTAssertEqual(result, .retry)
        XCTAssertEqual(viewModel.wrongCandidateID, wrong.id)
        XCTAssertEqual(viewModel.completedRounds, 0)
        XCTAssertEqual(feedback.retryCount, 1)
    }

    func testNextRoundCyclesThroughContent() {
        let viewModel = GameViewModel(feedbackPlayer: TestFeedbackPlayer())
        let firstRoundID = viewModel.round.id

        viewModel.nextRound()

        XCTAssertNotEqual(viewModel.round.id, firstRoundID)
    }

    func testResetProgressReturnsToFirstRound() {
        let viewModel = GameViewModel(feedbackPlayer: TestFeedbackPlayer())
        let firstRoundID = viewModel.round.id
        viewModel.nextRound()

        viewModel.resetProgress()

        XCTAssertEqual(viewModel.round.id, firstRoundID)
        XCTAssertEqual(viewModel.completedRounds, 0)
        XCTAssertNil(viewModel.completedCandidateID)
        XCTAssertNil(viewModel.wrongCandidateID)
    }

    func testResetProgressCancelsPendingAutoAdvance() async throws {
        let viewModel = GameViewModel(feedbackPlayer: TestFeedbackPlayer(), autoAdvanceDelay: 0.05)
        let firstRoundID = viewModel.round.id
        let correct = viewModel.round.candidates.first { $0.isCorrect }!

        viewModel.choose(correct)
        viewModel.resetProgress()

        try await Task.sleep(nanoseconds: 120_000_000)

        XCTAssertEqual(viewModel.round.id, firstRoundID)
        XCTAssertEqual(viewModel.completedRounds, 0)
        XCTAssertNil(viewModel.completedCandidateID)
    }

    func testCorrectSelectionClearsPendingWrongFeedback() {
        let viewModel = GameViewModel(feedbackPlayer: TestFeedbackPlayer())
        let wrong = viewModel.round.candidates.first { !$0.isCorrect }!
        let correct = viewModel.round.candidates.first { $0.isCorrect }!

        viewModel.choose(wrong)
        viewModel.choose(correct)

        XCTAssertNil(viewModel.wrongCandidateID)
        XCTAssertEqual(viewModel.completedCandidateID, correct.id)
    }
}

private final class TestFeedbackPlayer: FeedbackPlaying {
    private(set) var correctCount = 0
    private(set) var retryCount = 0
    private(set) var promptCount = 0

    func playCorrect(settings: GameSettings) {
        correctCount += 1
    }

    func playRetry(settings: GameSettings) {
        retryCount += 1
    }

    func playPrompt(for round: GameRound, settings: GameSettings) {
        promptCount += 1
    }
}
