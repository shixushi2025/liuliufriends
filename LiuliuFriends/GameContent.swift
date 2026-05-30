import SwiftUI

enum GameContent {
    static let rounds: [GameRound] = makeRounds()

    static func sessionRounds() -> [GameRound] {
        balancedShuffled(rounds)
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
        .cup
    ]

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

    private static func makeRounds() -> [GameRound] {
        var result: [GameRound] = []

        result += animals.enumerated().map { index, kind in
            matchingRound(.animal, kind, color(for: kind), distractor(for: kind, in: animals, offset: 5), color(for: distractor(for: kind, in: animals, offset: 5)), correctFirst: index.isMultiple(of: 2))
        }

        result += visibleKinds.enumerated().map { index, kind in
            matchingRound(.sound, kind, color(for: kind), distractor(for: kind, in: visibleKinds, offset: 9), color(for: distractor(for: kind, in: visibleKinds, offset: 9)), correctFirst: !index.isMultiple(of: 3))
        }

        result += colorPracticeKinds.enumerated().flatMap { kindIndex, kind in
            palette.enumerated().map { colorIndex, targetColor in
                color(kind, targetColor, palette[(colorIndex + kindIndex + 3) % palette.count], correctFirst: (kindIndex + colorIndex).isMultiple(of: 2))
            }
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
