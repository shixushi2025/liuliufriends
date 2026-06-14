import XCTest
import UIKit
import SwiftUI
@testable import LiuliuFriends

final class GameViewModelTests: XCTestCase {
    func testRoundsHaveExactlyOneCorrectCandidate() {
        for round in GameContent.rounds {
            let correctCount = round.candidates.filter { $0.isCorrect }.count
            XCTAssertEqual(correctCount, 1, "\(round.mode.title) should have exactly one correct candidate.")
            XCTAssertLessThanOrEqual(round.candidates.count, 2, "1.5-3 岁玩法每轮最多保留两个选项。")
        }
    }

    func testContentCoversAllDesignGameModes() {
        let modes = Set(GameContent.rounds.map(\.mode))
        XCTAssertEqual(modes, Set(GameMode.allCases))
    }

    func testEachGameModeHasEnoughRounds() {
        for mode in GameMode.allCases {
            let count = GameContent.rounds.filter { $0.mode == mode }.count
            XCTAssertGreaterThanOrEqual(count, 6, "\(mode.title) should have enough variety.")
        }
    }

    func testContentHasBroadRoundCoverage() {
        XCTAssertGreaterThanOrEqual(GameContent.rounds.count, 250)
    }

    func testColorRoundsUseEachSpokenColorOnce() {
        let colorRounds = GameContent.rounds.filter { $0.mode == .color }
        let colorPromptIDs = colorRounds.map(\.voicePromptID)

        XCTAssertEqual(colorRounds.count, VoicePromptTarget.colorTargets.count)
        XCTAssertEqual(Set(colorPromptIDs), Set(VoicePromptTarget.colorTargets.map(\.id)))
    }

    func testContentCoversCoreFriendCategories() {
        let categories = Set(FriendKind.allCases.map(\.category))

        XCTAssertEqual(categories, [.animal, .vehicle, .fruit, .shape, .object])
    }

    func testGameModesUseStructuredAgeBands() {
        XCTAssertEqual(GameMode.animal.ageBand, .starter18Months)
        XCTAssertEqual(GameMode.sound.ageBand, .starter18Months)
        XCTAssertEqual(GameMode.color.ageBand, .explorer24Months)
        XCTAssertEqual(GameMode.shape.ageBand, .explorer24Months)
        XCTAssertEqual(GameMode.category.ageBand, .explorer24Months)
        XCTAssertEqual(GameMode.position.ageBand, .explorer24Months)
        XCTAssertEqual(GameMode.size.ageBand, .matcher30Months)
        XCTAssertEqual(GameMode.shadow.ageBand, .matcher30Months)
        XCTAssertEqual(GameMode.purpose.ageBand, .matcher30Months)
        XCTAssertEqual(GameMode.scene.ageBand, .matcher30Months)
        XCTAssertEqual(GameMode.count.ageBand, .preschool36Months)
        XCTAssertEqual(FutureLearningModule.numbers.recommendedAgeBand, .preschool36Months)
        XCTAssertEqual(FutureLearningModule.nurseryRhymes.recommendedAgeBand, .preschool36Months)
    }

    func testLearningAgeBandsHaveStableProgressionOrder() {
        XCTAssertTrue(LearningAgeBand.starter18Months.isIncluded(in: .starter18Months))
        XCTAssertTrue(LearningAgeBand.starter18Months.isIncluded(in: .explorer24Months))
        XCTAssertTrue(LearningAgeBand.explorer24Months.isIncluded(in: .matcher30Months))
        XCTAssertTrue(LearningAgeBand.matcher30Months.isIncluded(in: .preschool36Months))
        XCTAssertFalse(LearningAgeBand.preschool36Months.isIncluded(in: .matcher30Months))
        XCTAssertFalse(LearningAgeBand.matcher30Months.isIncluded(in: .explorer24Months))
    }

    func testPurposeRoundsHaveExplicitPurposeTargets() {
        let purposeRounds = GameContent.rounds.filter { $0.mode == .purpose }

        XCTAssertFalse(purposeRounds.isEmpty)
        XCTAssertEqual(Set(purposeRounds.compactMap(\.targetPurpose)), Set(FriendPurpose.allCases))
        for round in purposeRounds {
            XCTAssertNotNil(round.targetPurpose)
            XCTAssertTrue(round.promptSpeechText.hasPrefix("找"))
            XCTAssertTrue(round.promptSpeechText.contains(round.targetPurpose!.speechTitle))
            XCTAssertTrue(round.successSpeechText.contains("找到了") || round.successSpeechText.contains(round.targetPurpose!.speechTitle))
        }
    }

    func testSceneRoundsHaveExplicitSceneTargets() {
        let sceneRounds = GameContent.rounds.filter { $0.mode == .scene }

        XCTAssertFalse(sceneRounds.isEmpty)
        XCTAssertEqual(Set(sceneRounds.compactMap(\.targetScene)), Set(FriendScene.allCases))
        for round in sceneRounds {
            XCTAssertNotNil(round.targetScene)
            XCTAssertTrue(round.promptSpeechText.hasPrefix("找"))
            XCTAssertTrue(round.promptSpeechText.contains(round.targetScene!.speechTitle))
            XCTAssertTrue(round.successSpeechText.contains("找到了"))
        }
    }

    func testSessionRoundsLimitLargeModesAndKeepAllModesVisible() {
        let sessionRounds = GameContent.sessionRounds()
        let countsByMode = Dictionary(grouping: sessionRounds, by: \.mode).mapValues(\.count)

        XCTAssertEqual(Set(countsByMode.keys), Set(GameMode.allCases))
        for mode in GameMode.allCases {
            XCTAssertLessThanOrEqual(countsByMode[mode, default: 0], 12, "\(mode.title) should not dominate one session.")
        }
    }

    func testSessionStartsWithBasicWarmupModes() {
        let warmupModes = GameContent.sessionRounds().prefix(4).map(\.mode)

        XCTAssertEqual(Array(warmupModes), [.animal, .sound, .color, .shape])
    }

    func testAdaptiveWarmupKeepsEarlyRoundsSimple() {
        let viewModel = GameViewModel(feedbackPlayer: TestFeedbackPlayer())
        let simpleAgeBands: Set<LearningAgeBand> = [.starter18Months, .explorer24Months]

        for _ in 0..<10 {
            XCTAssertTrue(simpleAgeBands.contains(viewModel.round.mode.ageBand), "\(viewModel.round.mode.title) should not appear during early warmup.")
            viewModel.nextRound()
        }
    }

    func testAdaptiveWarmupUnlocksHarderRoundsAfterProgress() {
        let hardRound = GameContent.rounds.first { $0.mode == .purpose }!
        let easyRound = GameContent.rounds.first { $0.mode == .animal }!
        let viewModel = GameViewModel(rounds: [hardRound, easyRound], feedbackPlayer: TestFeedbackPlayer())

        XCTAssertEqual(viewModel.round.mode, .animal)
        viewModel.nextRound()
        XCTAssertEqual(viewModel.round.mode, .animal)

        viewModel.completedRounds = 8
        viewModel.nextRound()

        XCTAssertEqual(viewModel.round.mode, .purpose)
    }

    func testMaximumAgeBandFiltersHarderRounds() {
        let viewModel = GameViewModel(feedbackPlayer: TestFeedbackPlayer())
        viewModel.setMaximumAgeBand(.explorer24Months)
        viewModel.completedRounds = 8

        for _ in 0..<30 {
            XCTAssertTrue(viewModel.round.mode.ageBand.isIncluded(in: .explorer24Months), "\(viewModel.round.mode.title) should be filtered by the selected learning stage.")
            viewModel.nextRound()
        }
    }

    func testChangingMaximumAgeBandMovesAwayFromHardCurrentRound() {
        let easyRound = GameContent.rounds.first { $0.mode == .animal }!
        let hardRound = GameContent.rounds.first { $0.mode == .purpose }!
        let viewModel = GameViewModel(rounds: [easyRound, hardRound], feedbackPlayer: TestFeedbackPlayer())
        viewModel.completedRounds = 8
        viewModel.nextRound()

        XCTAssertEqual(viewModel.round.mode, .purpose)
        viewModel.setMaximumAgeBand(.explorer24Months)

        XCTAssertEqual(viewModel.round.mode, .animal)
    }

    func testContentUsesAllFriendKinds() {
        let usedKinds = Set(GameContent.rounds.flatMap { round in
            [round.targetKind] + round.candidates.map(\.kind)
        })

        XCTAssertEqual(usedKinds, Set(FriendKind.allCases))
    }

    func testDeclaredImageAssetsCanLoad() {
        for kind in FriendKind.allCases {
            guard let imageAssetName = kind.imageAssetName else {
                continue
            }

            XCTAssertNotNil(UIImage(named: imageAssetName), "\(kind.name) image asset should load: \(imageAssetName)")
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
        XCTAssertEqual(feedback.correctRecordingID, viewModel.round.voicePromptID)
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

    func testSelectionIsIgnoredWhileWrongFeedbackIsVisible() {
        let viewModel = GameViewModel(feedbackPlayer: TestFeedbackPlayer())
        let wrong = viewModel.round.candidates.first { !$0.isCorrect }!
        let correct = viewModel.round.candidates.first { $0.isCorrect }!

        XCTAssertEqual(viewModel.choose(wrong), .retry)
        XCTAssertEqual(viewModel.choose(correct), .ignored)
        XCTAssertNil(viewModel.completedCandidateID)
        XCTAssertEqual(viewModel.completedRounds, 0)
    }

    func testWrongSelectionShowsCorrectHint() async throws {
        let viewModel = GameViewModel(feedbackPlayer: TestFeedbackPlayer())
        let wrong = viewModel.round.candidates.first { !$0.isCorrect }!
        let correct = viewModel.round.candidates.first { $0.isCorrect }!

        viewModel.choose(wrong)
        try await Task.sleep(nanoseconds: 520_000_000)

        XCTAssertEqual(viewModel.hintCandidateID, correct.id)
    }

    func testWrongThenCorrectRoundReturnsForGentleReview() async throws {
        let rounds = makeAnimalReviewRounds()
        let viewModel = GameViewModel(rounds: rounds, feedbackPlayer: TestFeedbackPlayer(), autoAdvanceDelay: 60)
        let firstRoundID = viewModel.round.id

        viewModel.choose(viewModel.round.candidates.first { !$0.isCorrect }!)
        try await Task.sleep(nanoseconds: 900_000_000)
        viewModel.choose(viewModel.round.candidates.first { $0.isCorrect }!)

        viewModel.nextRound()
        XCTAssertNotEqual(viewModel.round.id, firstRoundID)
        viewModel.choose(viewModel.round.candidates.first { $0.isCorrect }!)

        viewModel.nextRound()
        XCTAssertNotEqual(viewModel.round.id, firstRoundID)
        viewModel.choose(viewModel.round.candidates.first { $0.isCorrect }!)

        viewModel.nextRound()
        XCTAssertNotEqual(viewModel.round.id, firstRoundID)
        viewModel.choose(viewModel.round.candidates.first { $0.isCorrect }!)

        viewModel.nextRound()

        XCTAssertEqual(viewModel.round.id, firstRoundID)
    }

    func testResetProgressClearsQueuedReview() async throws {
        let rounds = makeAnimalReviewRounds()
        let viewModel = GameViewModel(rounds: rounds, feedbackPlayer: TestFeedbackPlayer(), autoAdvanceDelay: 60)

        viewModel.nextRound()
        let reviewedRoundID = viewModel.round.id
        viewModel.choose(viewModel.round.candidates.first { !$0.isCorrect }!)
        try await Task.sleep(nanoseconds: 900_000_000)
        viewModel.choose(viewModel.round.candidates.first { $0.isCorrect }!)
        viewModel.resetProgress()

        for _ in 0..<4 {
            viewModel.nextRound()
            viewModel.choose(viewModel.round.candidates.first { $0.isCorrect }!)
        }

        viewModel.nextRound()

        XCTAssertNotEqual(viewModel.round.id, reviewedRoundID, "Reset should clear pending review rounds instead of jumping back to the reviewed round.")
    }

    func testNextRoundCyclesThroughContent() {
        let viewModel = GameViewModel(feedbackPlayer: TestFeedbackPlayer())
        let firstRoundID = viewModel.round.id

        viewModel.nextRound()

        XCTAssertNotEqual(viewModel.round.id, firstRoundID)
    }

    func testDisabledGameModeIsSkippedWhenAdvancing() {
        let rounds = [
            GameRound(
                mode: .animal,
                targetKind: .cat,
                targetColor: .red,
                candidates: [
                    FriendCandidate(kind: .cat, color: .red, isCorrect: true),
                    FriendCandidate(kind: .dog, color: .red, isCorrect: false)
                ]
            ),
            GameRound(
                mode: .shadow,
                targetKind: .truck,
                targetColor: .gray,
                candidates: [
                    FriendCandidate(kind: .truck, color: .gray, isCorrect: true),
                    FriendCandidate(kind: .bus, color: .gray, isCorrect: false)
                ]
            )
        ]
        let viewModel = GameViewModel(rounds: rounds, feedbackPlayer: TestFeedbackPlayer())

        viewModel.setGameMode(.shadow, enabled: false)
        viewModel.nextRound()

        XCTAssertEqual(viewModel.round.mode, .animal)
    }

    func testDisablingCurrentModeMovesToEnabledRound() {
        let rounds = [
            GameRound(
                mode: .animal,
                targetKind: .cat,
                targetColor: .red,
                candidates: [
                    FriendCandidate(kind: .cat, color: .red, isCorrect: true),
                    FriendCandidate(kind: .dog, color: .red, isCorrect: false)
                ]
            ),
            GameRound(
                mode: .shadow,
                targetKind: .truck,
                targetColor: .gray,
                candidates: [
                    FriendCandidate(kind: .truck, color: .gray, isCorrect: true),
                    FriendCandidate(kind: .bus, color: .gray, isCorrect: false)
                ]
            )
        ]
        let viewModel = GameViewModel(rounds: rounds, feedbackPlayer: TestFeedbackPlayer())
        viewModel.completedRounds = 8
        viewModel.nextRound()

        XCTAssertEqual(viewModel.round.mode, .shadow)
        viewModel.setGameMode(.shadow, enabled: false)

        XCTAssertEqual(viewModel.round.mode, .animal)
    }

    func testCannotDisableLastEnabledGameMode() {
        let viewModel = GameViewModel(feedbackPlayer: TestFeedbackPlayer())

        for mode in GameMode.allCases where mode != .animal {
            viewModel.setGameMode(mode, enabled: false)
        }
        viewModel.setGameMode(.animal, enabled: false)

        XCTAssertEqual(viewModel.settings.enabledGameModes, [.animal])
    }

    func testInitialPromptPlaysOnlyOnce() {
        let feedback = TestFeedbackPlayer()
        let viewModel = GameViewModel(feedbackPlayer: feedback, initialPromptDelay: 0)

        viewModel.playInitialPromptIfNeeded()
        viewModel.playInitialPromptIfNeeded()

        XCTAssertEqual(feedback.promptCount, 1)
    }

    func testStartPlayingTriggersFirstPromptOnce() {
        let feedback = TestFeedbackPlayer()
        let viewModel = GameViewModel(feedbackPlayer: feedback, initialPromptDelay: 0)

        XCTAssertFalse(viewModel.hasStartedPlaying)
        XCTAssertEqual(feedback.promptCount, 0)

        viewModel.startPlaying()
        viewModel.startPlaying()

        XCTAssertTrue(viewModel.hasStartedPlaying)
        XCTAssertEqual(feedback.promptCount, 1)
    }

    func testRoundSpeechTextCoversPromptAndSuccess() {
        let colorRound = GameContent.rounds.first { $0.mode == .color }!
        let soundRound = GameContent.rounds.first { $0.mode == .sound }!

        XCTAssertTrue(colorRound.promptSpeechText.hasPrefix("找"))
        XCTAssertTrue(colorRound.successSpeechText.contains("找到了"))
        XCTAssertTrue(colorRound.voicePromptID.hasPrefix("color."))
        XCTAssertEqual(soundRound.promptSpeechText, "找\(soundRound.targetKind.soundText)")
        XCTAssertEqual(soundRound.voicePromptID, soundRound.targetKind.rawValue)
    }


    func testSoundRoundPromptsAlwaysUseFindPrefix() {
        let viewModel = GameViewModel(feedbackPlayer: TestFeedbackPlayer())

        XCTAssertEqual(viewModel.soundRoundPrompt(for: .cat), "找喵喵")
        XCTAssertEqual(viewModel.soundRoundPrompt(for: .peach), "找桃子")
    }

    func testSoundPromptsUseOnlyRecognizedSoundsOrCanonicalNames() {
        XCTAssertEqual(FriendKind.sheep.soundText, "咩咩")
        XCTAssertEqual(FriendKind.cat.soundText, "喵喵")
        XCTAssertEqual(FriendKind.dog.soundText, "汪汪")
        XCTAssertEqual(FriendKind.grape.soundText, "葡萄")
        XCTAssertEqual(FriendKind.circle.soundText, "圆形")
        XCTAssertEqual(FriendKind.watermelon.soundText, "西瓜")
        XCTAssertEqual(FriendKind.butterfly.soundText, "蝴蝶")
    }

    func testRecognizedSoundPromptCatalogDoesNotOverrideShapesOrFruit() {
        for kind in FriendKind.allCases where kind.category == .shape || kind.category == .fruit {
            XCTAssertFalse(LearningPromptTextCatalog.usesRecognizedSoundPrompt(kind), "\(kind.name) should default to canonical name unless parents customize it.")
            XCTAssertEqual(kind.soundText, kind.name)
        }
    }

    func testCustomPromptAliasOverridesSpokenPromptWithoutChangingDefaultName() {
        let defaults = UserDefaults(suiteName: "liuliufriends.tests.alias")!
        defaults.removePersistentDomain(forName: "liuliufriends.tests.alias")
        let aliasStore = PromptAliasStore(defaults: defaults)
        let feedback = TestFeedbackPlayer()
        let rounds = [
            GameRound(
                mode: .sound,
                targetKind: .grape,
                targetColor: .red,
                candidates: [
                    FriendCandidate(kind: .grape, color: .red, isCorrect: true),
                    FriendCandidate(kind: .apple, color: .red, isCorrect: false)
                ]
            )
        ]
        let viewModel = GameViewModel(rounds: rounds, promptAliasStore: aliasStore, feedbackPlayer: feedback, initialPromptDelay: 0)

        XCTAssertEqual(viewModel.soundPrompt(for: .grape), "葡萄")
        XCTAssertEqual(viewModel.soundRoundPrompt(for: .grape), "找葡萄")

        viewModel.setCustomPromptName("串串", for: VoicePromptTarget(kind: .grape))
        XCTAssertEqual(viewModel.soundPrompt(for: .grape), "葡萄")

        viewModel.settings.customPromptAliasEnabled = true

        XCTAssertEqual(FriendKind.grape.name, "葡萄")
        XCTAssertEqual(viewModel.soundPrompt(for: .grape), "串串")
        XCTAssertEqual(viewModel.soundRoundPrompt(for: .grape), "找串串")
        viewModel.playInitialPromptIfNeeded()
        XCTAssertEqual(feedback.promptText, "找串串")
    }

    func testEyeComfortDefaultsToEnabled() {
        XCTAssertTrue(GameSettings().eyeComfortEnabled)
    }

    func testUsageTickShowsSessionBreakReminder() {
        let defaults = UserDefaults(suiteName: "liuliufriends.tests.session")!
        defaults.removePersistentDomain(forName: "liuliufriends.tests.session")
        let viewModel = GameViewModel(feedbackPlayer: TestFeedbackPlayer(), initialPromptDelay: 60, sessionLimit: 2, dailyLimit: 60, defaults: defaults)

        viewModel.recordActiveUsageTick()
        XCTAssertNil(viewModel.breakReminder)

        viewModel.startPlaying()
        viewModel.recordActiveUsageTick()
        XCTAssertNil(viewModel.breakReminder)

        viewModel.recordActiveUsageTick()
        XCTAssertEqual(viewModel.breakReminder, .sessionLimit)
    }

    func testBreakReminderBlocksSelectionUntilParentContinues() {
        let defaults = UserDefaults(suiteName: "liuliufriends.tests.break")!
        defaults.removePersistentDomain(forName: "liuliufriends.tests.break")
        let feedback = TestFeedbackPlayer()
        let viewModel = GameViewModel(feedbackPlayer: feedback, initialPromptDelay: 60, sessionLimit: 1, dailyLimit: 60, defaults: defaults)
        viewModel.startPlaying()
        viewModel.recordActiveUsageTick()
        let correct = viewModel.round.candidates.first { $0.isCorrect }!

        XCTAssertEqual(viewModel.choose(correct), .ignored)

        viewModel.continueAfterBreak()

        XCTAssertNil(viewModel.breakReminder)
        XCTAssertEqual(viewModel.choose(correct), .correct)
        XCTAssertEqual(feedback.promptCount, 1)
    }

    func testDailyBreakCanBeDismissedForCurrentDay() {
        let defaults = UserDefaults(suiteName: "liuliufriends.tests.daily")!
        defaults.removePersistentDomain(forName: "liuliufriends.tests.daily")
        let viewModel = GameViewModel(feedbackPlayer: TestFeedbackPlayer(), initialPromptDelay: 60, sessionLimit: 60, dailyLimit: 2, defaults: defaults)

        viewModel.startPlaying()
        viewModel.recordActiveUsageTick()
        viewModel.recordActiveUsageTick()
        XCTAssertEqual(viewModel.breakReminder, .dailyLimit)

        viewModel.continueAfterBreak()
        viewModel.recordActiveUsageTick()

        XCTAssertNil(viewModel.breakReminder)
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
        XCTAssertNil(viewModel.hintCandidateID)
    }

    func testAutoAdvanceDelaysNextPrompt() async throws {
        let feedback = TestFeedbackPlayer()
        let viewModel = GameViewModel(feedbackPlayer: feedback, autoAdvanceDelay: 0.05, nextPromptDelayAfterAutoAdvance: 0.2)
        let firstRoundID = viewModel.round.id
        let correct = viewModel.round.candidates.first { $0.isCorrect }!

        viewModel.choose(correct)
        try await Task.sleep(nanoseconds: 90_000_000)

        XCTAssertNotEqual(viewModel.round.id, firstRoundID)
        XCTAssertEqual(feedback.promptCount, 0)

        try await Task.sleep(nanoseconds: 180_000_000)

        XCTAssertEqual(feedback.promptCount, 1)
    }

    func testCorrectSelectionClearsPendingWrongFeedbackAfterRetryDelay() async throws {
        let viewModel = GameViewModel(feedbackPlayer: TestFeedbackPlayer())
        let wrong = viewModel.round.candidates.first { !$0.isCorrect }!
        let correct = viewModel.round.candidates.first { $0.isCorrect }!

        viewModel.choose(wrong)
        try await Task.sleep(nanoseconds: 900_000_000)
        viewModel.choose(correct)

        XCTAssertNil(viewModel.wrongCandidateID)
        XCTAssertEqual(viewModel.completedCandidateID, correct.id)
    }

    private func makeAnimalReviewRounds() -> [GameRound] {
        [
            GameRound(
                mode: .animal,
                targetKind: .cat,
                targetColor: .orange,
                candidates: [
                    FriendCandidate(kind: .cat, color: .orange, isCorrect: true),
                    FriendCandidate(kind: .dog, color: .brown, isCorrect: false)
                ]
            ),
            GameRound(
                mode: .animal,
                targetKind: .dog,
                targetColor: .brown,
                candidates: [
                    FriendCandidate(kind: .dog, color: .brown, isCorrect: true),
                    FriendCandidate(kind: .duck, color: .yellow, isCorrect: false)
                ]
            ),
            GameRound(
                mode: .animal,
                targetKind: .duck,
                targetColor: .yellow,
                candidates: [
                    FriendCandidate(kind: .duck, color: .yellow, isCorrect: true),
                    FriendCandidate(kind: .rabbit, color: .white, isCorrect: false)
                ]
            ),
            GameRound(
                mode: .animal,
                targetKind: .rabbit,
                targetColor: .white,
                candidates: [
                    FriendCandidate(kind: .rabbit, color: .white, isCorrect: true),
                    FriendCandidate(kind: .cat, color: .orange, isCorrect: false)
                ]
            ),
            GameRound(
                mode: .animal,
                targetKind: .fish,
                targetColor: .blue,
                candidates: [
                    FriendCandidate(kind: .fish, color: .blue, isCorrect: true),
                    FriendCandidate(kind: .cat, color: .orange, isCorrect: false)
                ]
            )
        ]
    }
}

private final class TestFeedbackPlayer: FeedbackPlaying {
    private(set) var correctCount = 0
    private(set) var retryCount = 0
    private(set) var promptCount = 0
    private(set) var correctRecordingID: String?
    private(set) var promptText: String?

    func playCorrect(text: String, recordingID: String, settings: GameSettings) {
        correctCount += 1
        correctRecordingID = recordingID
    }

    func playRetry(settings: GameSettings) {
        retryCount += 1
    }

    func playPrompt(text: String, recordingID: String, settings: GameSettings) {
        promptCount += 1
        promptText = text
    }
}
