import SwiftUI

enum GameContent {
    static let rounds: [GameRound] = [
        animal(.cat, .catOrange, .dog, .dogTan),
        sound(.duck, .duckYellow, .cat, .catOrange),
        color(.balloon, .coral, .skyBlue),
        shape(.heart, .skyBlue, .star),
        size(.circle, .purple, correctScale: 1.05, wrongScale: 0.62, correctFirst: false),
        shadow(.rabbit, .rabbitCream, .frog, .frogGreen),

        color(.apple, .mintGreen, .sunYellow, correctFirst: false),
        animal(.frog, .frogGreen, .bear, .bearBrown, correctFirst: false),
        shape(.star, .skyBlue, .triangle, correctFirst: false),
        sound(.dog, .dogTan, .frog, .frogGreen),
        shadow(.bear, .bearBrown, .duck, .duckYellow, correctFirst: false),
        size(.square, .mintGreen, correctScale: 0.68, wrongScale: 1.08),

        animal(.rabbit, .rabbitCream, .duck, .duckYellow),
        sound(.cat, .catOrange, .dog, .dogTan, correctFirst: false),
        color(.fish, .skyBlue, .coral),
        shape(.circle, .purple, .square),
        size(.triangle, .coral, correctScale: 1.10, wrongScale: 0.66, correctFirst: false),
        shadow(.cat, .catOrange, .dog, .dogTan),

        animal(.duck, .duckYellow, .frog, .frogGreen, correctFirst: false),
        sound(.frog, .frogGreen, .rabbit, .rabbitCream),
        color(.balloon, .sunYellow, .purple, correctFirst: false),
        shape(.square, .mintGreen, .circle, correctFirst: false),
        size(.star, .sunYellow, correctScale: 0.72, wrongScale: 1.12),
        shadow(.fish, .skyBlue, .apple, .mintGreen, correctFirst: false),

        animal(.bear, .bearBrown, .cat, .catOrange),
        sound(.bear, .bearBrown, .duck, .duckYellow, correctFirst: false),
        color(.apple, .coral, .mintGreen),
        shape(.triangle, .coral, .heart),
        size(.heart, .coral, correctScale: 1.08, wrongScale: 0.64, correctFirst: false),
        shadow(.balloon, .sunYellow, .star, .sunYellow),

        animal(.fish, .skyBlue, .rabbit, .rabbitCream, correctFirst: false),
        sound(.fish, .skyBlue, .bear, .bearBrown),
        color(.duck, .purple, .duckYellow, correctFirst: false),
        shape(.balloon, .coral, .apple, correctFirst: false),
        size(.balloon, .skyBlue, correctScale: 0.66, wrongScale: 1.10),
        shadow(.square, .mintGreen, .circle, .mintGreen, correctFirst: false)
    ]

    private static func animal(
        _ target: FriendKind,
        _ targetColor: Color,
        _ distractor: FriendKind,
        _ distractorColor: Color,
        correctFirst: Bool = true
    ) -> GameRound {
        matchingRound(.animal, target, targetColor, distractor, distractorColor, correctFirst: correctFirst)
    }

    private static func sound(
        _ target: FriendKind,
        _ targetColor: Color,
        _ distractor: FriendKind,
        _ distractorColor: Color,
        correctFirst: Bool = true
    ) -> GameRound {
        matchingRound(.sound, target, targetColor, distractor, distractorColor, correctFirst: correctFirst)
    }

    private static func shadow(
        _ target: FriendKind,
        _ targetColor: Color,
        _ distractor: FriendKind,
        _ distractorColor: Color,
        correctFirst: Bool = true
    ) -> GameRound {
        matchingRound(.shadow, target, targetColor, distractor, distractorColor, correctFirst: correctFirst)
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
}
