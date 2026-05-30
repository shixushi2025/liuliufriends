import SwiftUI

enum GameContent {
    static let rounds: [GameRound] = [
        GameRound(
            mode: .animal,
            targetKind: .cat,
            targetColor: Color(red: 0.94, green: 0.63, blue: 0.30),
            candidates: [
                FriendCandidate(kind: .cat, color: Color(red: 0.94, green: 0.63, blue: 0.30), isCorrect: true),
                FriendCandidate(kind: .dog, color: Color(red: 0.84, green: 0.63, blue: 0.42), isCorrect: false)
            ]
        ),
        GameRound(
            mode: .sound,
            targetKind: .duck,
            targetColor: Color(red: 1.0, green: 0.79, blue: 0.24),
            candidates: [
                FriendCandidate(kind: .duck, color: Color(red: 1.0, green: 0.79, blue: 0.24), isCorrect: true),
                FriendCandidate(kind: .cat, color: Color(red: 0.94, green: 0.63, blue: 0.30), isCorrect: false)
            ]
        ),
        GameRound(
            mode: .color,
            targetKind: .balloon,
            targetColor: Color(red: 1.0, green: 0.42, blue: 0.37),
            candidates: [
                FriendCandidate(kind: .balloon, color: Color(red: 1.0, green: 0.42, blue: 0.37), isCorrect: true),
                FriendCandidate(kind: .balloon, color: Color(red: 0.21, green: 0.65, blue: 0.94), isCorrect: false)
            ]
        ),
        GameRound(
            mode: .shape,
            targetKind: .heart,
            targetColor: Color(red: 0.22, green: 0.65, blue: 0.94),
            candidates: [
                FriendCandidate(kind: .heart, color: Color(red: 0.22, green: 0.65, blue: 0.94), isCorrect: true),
                FriendCandidate(kind: .star, color: Color(red: 0.22, green: 0.65, blue: 0.94), isCorrect: false)
            ]
        ),
        GameRound(
            mode: .size,
            targetKind: .circle,
            targetColor: Color(red: 0.61, green: 0.45, blue: 0.91),
            targetSizeScale: 1.05,
            candidates: [
                FriendCandidate(kind: .circle, color: Color(red: 0.61, green: 0.45, blue: 0.91), isCorrect: false, sizeScale: 0.62),
                FriendCandidate(kind: .circle, color: Color(red: 0.61, green: 0.45, blue: 0.91), isCorrect: true, sizeScale: 1.05)
            ]
        ),
        GameRound(
            mode: .shadow,
            targetKind: .rabbit,
            targetColor: Color(red: 0.95, green: 0.91, blue: 0.89),
            candidates: [
                FriendCandidate(kind: .frog, color: Color(red: 0.48, green: 0.78, blue: 0.42), isCorrect: false),
                FriendCandidate(kind: .rabbit, color: Color(red: 0.95, green: 0.91, blue: 0.89), isCorrect: true)
            ]
        ),
        GameRound(
            mode: .color,
            targetKind: .apple,
            targetColor: Color(red: 0.14, green: 0.76, blue: 0.54),
            candidates: [
                FriendCandidate(kind: .apple, color: Color(red: 1.0, green: 0.75, blue: 0.18), isCorrect: false),
                FriendCandidate(kind: .apple, color: Color(red: 0.14, green: 0.76, blue: 0.54), isCorrect: true)
            ]
        ),
        GameRound(
            mode: .animal,
            targetKind: .frog,
            targetColor: Color(red: 0.48, green: 0.78, blue: 0.42),
            candidates: [
                FriendCandidate(kind: .bear, color: Color(red: 0.73, green: 0.54, blue: 0.39), isCorrect: false),
                FriendCandidate(kind: .frog, color: Color(red: 0.48, green: 0.78, blue: 0.42), isCorrect: true)
            ]
        ),
        GameRound(
            mode: .shape,
            targetKind: .star,
            targetColor: Color(red: 0.22, green: 0.65, blue: 0.94),
            candidates: [
                FriendCandidate(kind: .triangle, color: Color(red: 0.22, green: 0.65, blue: 0.94), isCorrect: false),
                FriendCandidate(kind: .star, color: Color(red: 0.22, green: 0.65, blue: 0.94), isCorrect: true)
            ]
        ),
        GameRound(
            mode: .sound,
            targetKind: .dog,
            targetColor: Color(red: 0.84, green: 0.63, blue: 0.42),
            candidates: [
                FriendCandidate(kind: .dog, color: Color(red: 0.84, green: 0.63, blue: 0.42), isCorrect: true),
                FriendCandidate(kind: .frog, color: Color(red: 0.48, green: 0.78, blue: 0.42), isCorrect: false)
            ]
        ),
        GameRound(
            mode: .shadow,
            targetKind: .bear,
            targetColor: Color(red: 0.73, green: 0.54, blue: 0.39),
            candidates: [
                FriendCandidate(kind: .duck, color: Color(red: 1.0, green: 0.79, blue: 0.24), isCorrect: false),
                FriendCandidate(kind: .bear, color: Color(red: 0.73, green: 0.54, blue: 0.39), isCorrect: true)
            ]
        )
    ]
}
