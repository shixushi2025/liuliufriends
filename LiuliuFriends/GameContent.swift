import SwiftUI

enum GameContent {
    static let rounds: [GameRound] = makeRounds()
    static let sessionRoundTotalLimit = 36
    private static let warmupModes: [GameMode] = [.animal, .sound, .color, .shape]

    static func sessionRounds() -> [GameRound] {
        warmupFirst(balancedShuffled(limitedForSession(rounds)))
    }

    static func sessionRoundLimit(for mode: GameMode) -> Int {
        switch mode.ageBand {
        case .starter18Months:
            return 10
        case .explorer24Months:
            return 7
        case .matcher30Months:
            return 5
        case .preschool36Months:
            return 4
        }
    }

    private static let palette: [Color] = [
        .coral,
        .skyBlue,
        .mintGreen,
        .sunYellow,
        .purple,
        .rosePink,
        .leafGreen,
        .orange,
        .milkBrown,
        .berryRed,
        .aqua,
        .softGray
    ]

    private static let colorPracticeKinds: [FriendKind] = [
        .balloon,
        .ball,
        .book,
        .cup,
        .flower,
        .umbrella
    ]
    private static let colorLearningPalette = VoicePromptTarget.colorTargets.compactMap(\.color)

    private static let shapePracticeColor = Color(red: 0.24, green: 0.65, blue: 0.94)

    private static let baseColors: [FriendKind: Color] = [
        .balloon: .coral,
        .cat: .catOrange,
        .dog: .dogTan,
        .duck: .duckYellow,
        .bear: .bearBrown,
        .rabbit: .rabbitCream,
        .frog: .frogGreen,
        .apple: .berryRed,
        .fish: .skyBlue,
        .circle: .purple,
        .square: .mintGreen,
        .triangle: .coral,
        .star: .sunYellow,
        .heart: .rosePink,
        .bird: .skyBlue,
        .cow: .softGray,
        .sheep: .rabbitCream,
        .horse: .milkBrown,
        .pig: .rosePink,
        .monkey: .milkBrown,
        .panda: .softGray,
        .tiger: .orange,
        .lion: .sunYellow,
        .elephant: .softGray,
        .turtle: .leafGreen,
        .bee: .sunYellow,
        .butterfly: .purple,
        .car: .coral,
        .bus: .sunYellow,
        .train: .skyBlue,
        .truck: .mintGreen,
        .airplane: .aqua,
        .boat: .skyBlue,
        .bicycle: .orange,
        .fireTruck: .berryRed,
        .ambulance: .softGray,
        .tractor: .leafGreen,
        .rocket: .purple,
        .banana: .sunYellow,
        .orange: .orange,
        .pear: .leafGreen,
        .strawberry: .berryRed,
        .watermelon: .leafGreen,
        .grape: .purple,
        .peach: .rosePink,
        .pineapple: .sunYellow,
        .cherry: .berryRed,
        .lemon: .sunYellow,
        .rectangle: .skyBlue,
        .oval: .mintGreen,
        .diamond: .purple,
        .moon: .sunYellow,
        .flower: .rosePink,
        .tree: .leafGreen,
        .sun: .sunYellow,
        .cloud: .softGray,
        .umbrella: .purple,
        .ball: .coral,
        .book: .skyBlue,
        .cup: .aqua
    ]

    private static var animals: [FriendKind] {
        FriendKind.allCases.filter { $0.category == .animal }
    }

    private static var shapes: [FriendKind] {
        FriendKind.allCases.filter { $0.category == .shape }
    }

    private static var visibleKinds: [FriendKind] {
        FriendKind.allCases
    }

    private static let countPracticeKinds: [FriendKind] = [
        .cat,
        .dog,
        .fish,
        .apple,
        .banana,
        .ball,
        .book,
        .car
    ]

    private static let categoryPracticeGroups: [FriendCategory: [FriendKind]] = [
        .animal: [.cat, .dog, .duck, .rabbit, .fish, .bird],
        .vehicle: [.car, .bus, .train, .truck, .airplane, .boat],
        .fruit: [.apple, .banana, .orange, .pear, .strawberry, .watermelon],
        .object: [.balloon, .flower, .tree, .umbrella, .ball, .book]
    ]

    private static let differencePracticePairs: [(category: FriendCategory, same: FriendKind, different: FriendKind)] = [
        (.animal, .cat, .car),
        (.animal, .dog, .apple),
        (.vehicle, .bus, .banana),
        (.vehicle, .train, .fish),
        (.fruit, .apple, .book),
        (.fruit, .watermelon, .car),
        (.object, .book, .rabbit),
        (.object, .umbrella, .banana)
    ]

    private static let positionPracticeKinds: [FriendKind] = [
        .cat,
        .dog,
        .fish,
        .ball,
        .car,
        .apple
    ]

    private static let purposePracticePairs: [(purpose: FriendPurpose, correct: FriendKind, wrong: FriendKind)] = [
        (.drink, .cup, .book),
        (.read, .book, .ball),
        (.rain, .umbrella, .flower),
        (.fly, .airplane, .truck),
        (.ride, .bus, .apple),
        (.eat, .banana, .car),
        (.play, .ball, .cup),
        (.plant, .tree, .train)
    ]

    private static let scenePracticePairs: [(scene: FriendScene, correct: FriendKind, wrong: FriendKind)] = [
        (.sea, .fish, .car),
        (.sky, .bird, .cup),
        (.road, .bus, .watermelon),
        (.home, .book, .airplane),
        (.garden, .flower, .truck),
        (.rainyDay, .umbrella, .sun)
    ]

    private static let weatherPracticePairs: [(weather: FriendWeather, correct: FriendKind, wrong: FriendKind)] = [
        (.sunny, .sun, .umbrella),
        (.sunny, .sun, .cloud),
        (.rainy, .umbrella, .sun),
        (.rainy, .cloud, .ball),
        (.cloudy, .cloud, .apple),
        (.cloudy, .cloud, .book),
        (.windy, .balloon, .cup),
        (.windy, .balloon, .tree)
    ]

    private static let routinePracticePairs: [(routine: FriendRoutine, correct: FriendKind, wrong: FriendKind)] = [
        (.morning, .sun, .moon),
        (.morning, .sun, .book),
        (.drinkWater, .cup, .ball),
        (.reading, .book, .banana),
        (.playing, .ball, .cup),
        (.goingOut, .car, .flower),
        (.bedtime, .moon, .sun),
        (.bedtime, .moon, .bus)
    ]

    private static let emotionPracticePairs: [(target: FriendEmotion, distractor: FriendEmotion)] = [
        (.happy, .calm),
        (.calm, .happy),
        (.encouraged, .calm),
        (.happy, .encouraged),
        (.calm, .encouraged),
        (.encouraged, .happy)
    ]

    private static let actionPracticePairs: [(action: FriendAction, correct: FriendKind, wrong: FriendKind)] = [
        (.fly, .bird, .fish),
        (.fly, .airplane, .cup),
        (.swim, .fish, .car),
        (.roll, .ball, .book),
        (.jump, .frog, .tree),
        (.drive, .bus, .banana),
        (.drive, .car, .flower),
        (.grow, .tree, .truck)
    ]

    private static let rhythmPracticePairs: [(target: FriendRhythm, distractor: FriendRhythm)] = [
        (.clap, .step),
        (.step, .shake),
        (.shake, .tap),
        (.tap, .clap),
        (.clap, .shake),
        (.step, .tap)
    ]

    private static let sequencePracticePairs: [(target: FriendSequence, distractor: FriendSequence)] = [
        (.first, .second),
        (.second, .last),
        (.last, .first),
        (.first, .last),
        (.second, .first),
        (.last, .second)
    ]

    private static func makeRounds() -> [GameRound] {
        var result: [GameRound] = []

        result += animals.enumerated().map { index, kind in
            matchingRound(.animal, kind, color(for: kind), distractor(for: kind, in: animals, offset: 5), color(for: distractor(for: kind, in: animals, offset: 5)), correctFirst: index.isMultiple(of: 2))
        }

        result += visibleKinds.enumerated().map { index, kind in
            matchingRound(.sound, kind, color(for: kind), distractor(for: kind, in: visibleKinds, offset: 9), color(for: distractor(for: kind, in: visibleKinds, offset: 9)), correctFirst: !index.isMultiple(of: 3))
        }

        result += colorLearningPalette.enumerated().map { colorIndex, targetColor in
            color(
                colorPracticeKinds[colorIndex % colorPracticeKinds.count],
                targetColor,
                colorLearningPalette[(colorIndex + 3) % colorLearningPalette.count],
                correctFirst: colorIndex.isMultiple(of: 2)
            )
        }

        result += shapes.enumerated().map { kindIndex, kind in
            shape(kind, shapePracticeColor, distractor(for: kind, in: shapes, offset: 1), correctFirst: kindIndex.isMultiple(of: 2))
        }

        result += visibleKinds.enumerated().flatMap { index, kind in
            [
                size(kind, color(for: kind), correctScale: 1.10, wrongScale: 0.66, correctFirst: index.isMultiple(of: 2)),
                size(kind, palette[(index + 4) % palette.count], correctScale: 0.68, wrongScale: 1.12, correctFirst: !index.isMultiple(of: 2))
            ]
        }

        result += visibleKinds.enumerated().map { index, kind in
            matchingRound(.shadow, kind, color(for: kind), distractor(for: kind, in: visibleKinds, offset: 7), color(for: distractor(for: kind, in: visibleKinds, offset: 7)), correctFirst: !index.isMultiple(of: 2))
        }

        result += countPracticeKinds.enumerated().flatMap { index, kind in
            [
                count(kind, color(for: kind), targetCount: (index % 4) + 1, distractorCount: ((index + 1) % 4) + 1, correctFirst: index.isMultiple(of: 2)),
                count(kind, color(for: kind), targetCount: ((index + 2) % 4) + 1, distractorCount: ((index + 3) % 4) + 1, correctFirst: !index.isMultiple(of: 2))
            ]
        }

        let categoryRounds = categoryPracticeGroups.keys.sorted { $0.rawValue < $1.rawValue }.flatMap { category in
            categoryPracticeGroups[category, default: []].enumerated().map { index, kind in
                categoryRound(
                    category,
                    correctKind: kind,
                    wrongKind: categoryDistractor(for: category, offset: index + 2),
                    correctFirst: index.isMultiple(of: 2)
                )
            }
        }
        result += categoryRounds

        result += differencePracticePairs.enumerated().map { index, pair in
            difference(pair.category, sameKind: pair.same, differentKind: pair.different, correctFirst: !index.isMultiple(of: 2))
        }

        result += positionPracticeKinds.enumerated().flatMap { index, kind in
            let firstTarget = SpatialPosition.allCases[index % SpatialPosition.allCases.count]
            let secondTarget = SpatialPosition.allCases[(index + 2) % SpatialPosition.allCases.count]
            return [
                position(kind, color(for: kind), targetPosition: firstTarget, distractorPosition: distractorPosition(for: firstTarget), correctFirst: index.isMultiple(of: 2)),
                position(kind, color(for: kind), targetPosition: secondTarget, distractorPosition: distractorPosition(for: secondTarget), correctFirst: !index.isMultiple(of: 2))
            ]
        }

        result += purposePracticePairs.enumerated().map { index, pair in
            purpose(pair.purpose, correctKind: pair.correct, wrongKind: pair.wrong, correctFirst: index.isMultiple(of: 2))
        }

        result += scenePracticePairs.enumerated().map { index, pair in
            scene(pair.scene, correctKind: pair.correct, wrongKind: pair.wrong, correctFirst: !index.isMultiple(of: 2))
        }

        result += weatherPracticePairs.enumerated().map { index, pair in
            weather(pair.weather, correctKind: pair.correct, wrongKind: pair.wrong, correctFirst: index.isMultiple(of: 2))
        }

        result += routinePracticePairs.enumerated().map { index, pair in
            routine(pair.routine, correctKind: pair.correct, wrongKind: pair.wrong, correctFirst: !index.isMultiple(of: 2))
        }

        result += emotionPracticePairs.enumerated().map { index, pair in
            emotion(pair.target, distractor: pair.distractor, correctFirst: index.isMultiple(of: 2))
        }

        result += actionPracticePairs.enumerated().map { index, pair in
            action(pair.action, correctKind: pair.correct, wrongKind: pair.wrong, correctFirst: !index.isMultiple(of: 2))
        }

        result += rhythmPracticePairs.enumerated().map { index, pair in
            rhythm(pair.target, distractor: pair.distractor, correctFirst: index.isMultiple(of: 2))
        }

        result += sequencePracticePairs.enumerated().map { index, pair in
            sequence(pair.target, distractor: pair.distractor, correctFirst: !index.isMultiple(of: 2))
        }

        result += FriendPattern.allCases.enumerated().map { index, pattern in
            patternRound(pattern, correctFirst: index.isMultiple(of: 2))
        }

        return result
    }

    private static func color(
        _ kind: FriendKind,
        _ targetColor: Color,
        _ distractorColor: Color,
        correctFirst: Bool = true
    ) -> GameRound {
        let correct = FriendCandidate(kind: kind, color: targetColor, isCorrect: true)
        let wrong = FriendCandidate(kind: kind, color: distractorColor, isCorrect: false)
        return GameRound(
            mode: .color,
            targetKind: kind,
            targetColor: targetColor,
            candidates: ordered(correct: correct, wrong: wrong, correctFirst: correctFirst)
        )
    }

    private static func shape(
        _ target: FriendKind,
        _ color: Color,
        _ distractor: FriendKind,
        correctFirst: Bool = true
    ) -> GameRound {
        matchingRound(.shape, target, color, distractor, color, correctFirst: correctFirst)
    }

    private static func size(
        _ kind: FriendKind,
        _ color: Color,
        correctScale: CGFloat,
        wrongScale: CGFloat,
        correctFirst: Bool = true
    ) -> GameRound {
        let correct = FriendCandidate(kind: kind, color: color, isCorrect: true, sizeScale: correctScale)
        let wrong = FriendCandidate(kind: kind, color: color, isCorrect: false, sizeScale: wrongScale)
        return GameRound(
            mode: .size,
            targetKind: kind,
            targetColor: color,
            targetSizeScale: correctScale,
            candidates: ordered(correct: correct, wrong: wrong, correctFirst: correctFirst)
        )
    }

    private static func count(
        _ kind: FriendKind,
        _ color: Color,
        targetCount: Int,
        distractorCount: Int,
        correctFirst: Bool = true
    ) -> GameRound {
        let correct = FriendCandidate(kind: kind, color: color, isCorrect: true, count: targetCount)
        let wrong = FriendCandidate(kind: kind, color: color, isCorrect: false, count: distractorCount)
        return GameRound(
            mode: .count,
            targetKind: kind,
            targetColor: color,
            targetCount: targetCount,
            candidates: ordered(correct: correct, wrong: wrong, correctFirst: correctFirst)
        )
    }

    private static func categoryRound(
        _ category: FriendCategory,
        correctKind: FriendKind,
        wrongKind: FriendKind,
        correctFirst: Bool
    ) -> GameRound {
        let correct = FriendCandidate(kind: correctKind, color: color(for: correctKind), isCorrect: true)
        let wrong = FriendCandidate(kind: wrongKind, color: color(for: wrongKind), isCorrect: false)
        return GameRound(
            mode: .category,
            targetKind: correctKind,
            targetColor: color(for: correctKind),
            targetCategory: category,
            candidates: ordered(correct: correct, wrong: wrong, correctFirst: correctFirst)
        )
    }

    private static func difference(
        _ baseCategory: FriendCategory,
        sameKind: FriendKind,
        differentKind: FriendKind,
        correctFirst: Bool
    ) -> GameRound {
        let correct = FriendCandidate(kind: differentKind, color: color(for: differentKind), isCorrect: true)
        let wrong = FriendCandidate(kind: sameKind, color: color(for: sameKind), isCorrect: false)
        return GameRound(
            mode: .difference,
            targetKind: differentKind,
            targetColor: color(for: differentKind),
            targetCategory: baseCategory,
            candidates: ordered(correct: correct, wrong: wrong, correctFirst: correctFirst)
        )
    }

    private static func position(
        _ kind: FriendKind,
        _ color: Color,
        targetPosition: SpatialPosition,
        distractorPosition: SpatialPosition,
        correctFirst: Bool
    ) -> GameRound {
        let correct = FriendCandidate(kind: kind, color: color, isCorrect: true, position: targetPosition)
        let wrong = FriendCandidate(kind: kind, color: color, isCorrect: false, position: distractorPosition)
        return GameRound(
            mode: .position,
            targetKind: kind,
            targetColor: color,
            targetPosition: targetPosition,
            candidates: ordered(correct: correct, wrong: wrong, correctFirst: correctFirst)
        )
    }

    private static func purpose(
        _ purpose: FriendPurpose,
        correctKind: FriendKind,
        wrongKind: FriendKind,
        correctFirst: Bool
    ) -> GameRound {
        let correct = FriendCandidate(kind: correctKind, color: color(for: correctKind), isCorrect: true)
        let wrong = FriendCandidate(kind: wrongKind, color: color(for: wrongKind), isCorrect: false)
        return GameRound(
            mode: .purpose,
            targetKind: correctKind,
            targetColor: color(for: correctKind),
            targetPurpose: purpose,
            candidates: ordered(correct: correct, wrong: wrong, correctFirst: correctFirst)
        )
    }

    private static func scene(
        _ scene: FriendScene,
        correctKind: FriendKind,
        wrongKind: FriendKind,
        correctFirst: Bool
    ) -> GameRound {
        let correct = FriendCandidate(kind: correctKind, color: color(for: correctKind), isCorrect: true)
        let wrong = FriendCandidate(kind: wrongKind, color: color(for: wrongKind), isCorrect: false)
        return GameRound(
            mode: .scene,
            targetKind: correctKind,
            targetColor: color(for: correctKind),
            targetScene: scene,
            candidates: ordered(correct: correct, wrong: wrong, correctFirst: correctFirst)
        )
    }

    private static func weather(
        _ weather: FriendWeather,
        correctKind: FriendKind,
        wrongKind: FriendKind,
        correctFirst: Bool
    ) -> GameRound {
        let correct = FriendCandidate(kind: correctKind, color: color(for: correctKind), isCorrect: true)
        let wrong = FriendCandidate(kind: wrongKind, color: color(for: wrongKind), isCorrect: false)
        return GameRound(
            mode: .weather,
            targetKind: correctKind,
            targetColor: color(for: correctKind),
            targetWeather: weather,
            candidates: ordered(correct: correct, wrong: wrong, correctFirst: correctFirst)
        )
    }

    private static func routine(
        _ routine: FriendRoutine,
        correctKind: FriendKind,
        wrongKind: FriendKind,
        correctFirst: Bool
    ) -> GameRound {
        let correct = FriendCandidate(kind: correctKind, color: color(for: correctKind), isCorrect: true)
        let wrong = FriendCandidate(kind: wrongKind, color: color(for: wrongKind), isCorrect: false)
        return GameRound(
            mode: .routine,
            targetKind: correctKind,
            targetColor: color(for: correctKind),
            targetRoutine: routine,
            candidates: ordered(correct: correct, wrong: wrong, correctFirst: correctFirst)
        )
    }

    private static func emotion(
        _ target: FriendEmotion,
        distractor: FriendEmotion,
        correctFirst: Bool
    ) -> GameRound {
        let correct = FriendCandidate(kind: .cat, color: .coral, isCorrect: true, emotion: target)
        let wrong = FriendCandidate(kind: .dog, color: .skyBlue, isCorrect: false, emotion: distractor)
        return GameRound(
            mode: .emotion,
            targetKind: .cat,
            targetColor: .coral,
            targetEmotion: target,
            candidates: ordered(correct: correct, wrong: wrong, correctFirst: correctFirst)
        )
    }

    private static func action(
        _ action: FriendAction,
        correctKind: FriendKind,
        wrongKind: FriendKind,
        correctFirst: Bool
    ) -> GameRound {
        let correct = FriendCandidate(kind: correctKind, color: color(for: correctKind), isCorrect: true)
        let wrong = FriendCandidate(kind: wrongKind, color: color(for: wrongKind), isCorrect: false)
        return GameRound(
            mode: .action,
            targetKind: correctKind,
            targetColor: color(for: correctKind),
            targetAction: action,
            candidates: ordered(correct: correct, wrong: wrong, correctFirst: correctFirst)
        )
    }

    private static func rhythm(
        _ target: FriendRhythm,
        distractor: FriendRhythm,
        correctFirst: Bool
    ) -> GameRound {
        let correct = FriendCandidate(kind: .ball, color: .rosePink, isCorrect: true, rhythm: target)
        let wrong = FriendCandidate(kind: .book, color: .skyBlue, isCorrect: false, rhythm: distractor)
        return GameRound(
            mode: .rhythm,
            targetKind: .ball,
            targetColor: .rosePink,
            targetRhythm: target,
            candidates: ordered(correct: correct, wrong: wrong, correctFirst: correctFirst)
        )
    }

    private static func sequence(
        _ target: FriendSequence,
        distractor: FriendSequence,
        correctFirst: Bool
    ) -> GameRound {
        let correct = FriendCandidate(kind: .star, color: .skyBlue, isCorrect: true, sequence: target)
        let wrong = FriendCandidate(kind: .star, color: .softGray, isCorrect: false, sequence: distractor)
        return GameRound(
            mode: .sequence,
            targetKind: .star,
            targetColor: .skyBlue,
            targetSequence: target,
            candidates: ordered(correct: correct, wrong: wrong, correctFirst: correctFirst)
        )
    }

    private static func patternRound(
        _ pattern: FriendPattern,
        correctFirst: Bool
    ) -> GameRound {
        let correct = FriendCandidate(kind: pattern.correctKind, color: color(for: pattern.correctKind), isCorrect: true)
        let wrong = FriendCandidate(kind: pattern.distractorKind, color: color(for: pattern.distractorKind), isCorrect: false)
        return GameRound(
            mode: .pattern,
            targetKind: pattern.correctKind,
            targetColor: color(for: pattern.correctKind),
            targetPattern: pattern,
            candidates: ordered(correct: correct, wrong: wrong, correctFirst: correctFirst)
        )
    }

    private static func matchingRound(
        _ mode: GameMode,
        _ target: FriendKind,
        _ targetColor: Color,
        _ distractor: FriendKind,
        _ distractorColor: Color,
        correctFirst: Bool
    ) -> GameRound {
        let correct = FriendCandidate(kind: target, color: targetColor, isCorrect: true)
        let wrong = FriendCandidate(kind: distractor, color: distractorColor, isCorrect: false)
        return GameRound(
            mode: mode,
            targetKind: target,
            targetColor: targetColor,
            candidates: ordered(correct: correct, wrong: wrong, correctFirst: correctFirst)
        )
    }

    private static func ordered(correct: FriendCandidate, wrong: FriendCandidate, correctFirst: Bool) -> [FriendCandidate] {
        correctFirst ? [correct, wrong] : [wrong, correct]
    }

    private static func color(for kind: FriendKind) -> Color {
        baseColors[kind] ?? .coral
    }

    private static func distractor(for kind: FriendKind, in kinds: [FriendKind], offset: Int) -> FriendKind {
        guard let index = kinds.firstIndex(of: kind), kinds.count > 1 else {
            return kind
        }
        return kinds[(index + offset) % kinds.count]
    }

    private static func categoryDistractor(for category: FriendCategory, offset: Int) -> FriendKind {
        let otherKinds = categoryPracticeGroups
            .filter { $0.key != category }
            .flatMap(\.value)
        guard !otherKinds.isEmpty else {
            return visibleKinds.first { $0.category != category } ?? .cat
        }
        return otherKinds[offset % otherKinds.count]
    }

    private static func distractorPosition(for position: SpatialPosition) -> SpatialPosition {
        switch position {
        case .top:
            return .bottom
        case .bottom:
            return .top
        case .left:
            return .right
        case .right:
            return .left
        }
    }

    private static func balancedShuffled(_ sourceRounds: [GameRound]) -> [GameRound] {
        var buckets = Dictionary(grouping: sourceRounds, by: \.mode)
            .mapValues { $0.shuffled() }
        var result: [GameRound] = []

        while buckets.values.contains(where: { !$0.isEmpty }) {
            for mode in GameMode.allCases.shuffled() {
                guard var bucket = buckets[mode], !bucket.isEmpty else {
                    continue
                }
                result.append(bucket.removeLast())
                buckets[mode] = bucket
            }
        }

        return result
    }

    private static func limitedForSession(_ sourceRounds: [GameRound]) -> [GameRound] {
        var buckets = Dictionary(grouping: sourceRounds, by: \.mode)
            .mapValues { $0.shuffled() }
        var selectedRounds: [GameRound] = []
        var selectedCountsByMode: [GameMode: Int] = [:]

        for mode in GameMode.allCases {
            guard var bucket = buckets[mode], !bucket.isEmpty else {
                continue
            }
            selectedRounds.append(bucket.removeLast())
            selectedCountsByMode[mode, default: 0] += 1
            buckets[mode] = bucket
        }

        let weightedModes = GameMode.allCases.flatMap { mode in
            Array(repeating: mode, count: sessionRoundLimit(for: mode))
        }

        while selectedRounds.count < sessionRoundTotalLimit, buckets.values.contains(where: { !$0.isEmpty }) {
            var didAddRound = false

            for mode in weightedModes.shuffled() {
                guard selectedRounds.count < sessionRoundTotalLimit else {
                    break
                }
                guard selectedCountsByMode[mode, default: 0] < sessionRoundLimit(for: mode) else {
                    continue
                }
                guard var bucket = buckets[mode], !bucket.isEmpty else {
                    continue
                }

                selectedRounds.append(bucket.removeLast())
                selectedCountsByMode[mode, default: 0] += 1
                buckets[mode] = bucket
                didAddRound = true
            }

            guard didAddRound else {
                break
            }
        }

        return selectedRounds
    }

    private static func warmupFirst(_ sourceRounds: [GameRound]) -> [GameRound] {
        var remainingRounds = sourceRounds
        var warmupRounds: [GameRound] = []

        for mode in warmupModes {
            guard let index = remainingRounds.firstIndex(where: { $0.mode == mode }) else {
                continue
            }
            warmupRounds.append(remainingRounds.remove(at: index))
        }

        return warmupRounds + remainingRounds
    }
}

private extension Color {
    static let catOrange = Color(red: 0.94, green: 0.63, blue: 0.30)
    static let dogTan = Color(red: 0.84, green: 0.63, blue: 0.42)
    static let duckYellow = Color(red: 1.0, green: 0.79, blue: 0.24)
    static let bearBrown = Color(red: 0.73, green: 0.54, blue: 0.39)
    static let rabbitCream = Color(red: 0.95, green: 0.91, blue: 0.89)
    static let frogGreen = Color(red: 0.48, green: 0.78, blue: 0.42)
    static let skyBlue = Color(red: 0.22, green: 0.65, blue: 0.94)
    static let coral = Color(red: 1.0, green: 0.42, blue: 0.37)
    static let mintGreen = Color(red: 0.14, green: 0.76, blue: 0.54)
    static let sunYellow = Color(red: 1.0, green: 0.75, blue: 0.18)
    static let purple = Color(red: 0.61, green: 0.45, blue: 0.91)
    static let rosePink = Color(red: 1.0, green: 0.55, blue: 0.70)
    static let leafGreen = Color(red: 0.38, green: 0.68, blue: 0.32)
    static let orange = Color(red: 1.0, green: 0.60, blue: 0.02)
    static let milkBrown = Color(red: 0.70, green: 0.48, blue: 0.30)
    static let berryRed = Color(red: 0.92, green: 0.18, blue: 0.24)
    static let aqua = Color(red: 0.20, green: 0.72, blue: 0.78)
    static let softGray = Color(red: 0.72, green: 0.75, blue: 0.78)
}
