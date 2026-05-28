import SwiftUI

enum GameContent {
    static let rounds: [GameRound] = [
        GameRound(
            mode: .color,
            targetKind: .balloon,
            targetColor: .red,
            candidates: [
                FriendCandidate(kind: .balloon, color: .red, isCorrect: true),
                FriendCandidate(kind: .balloon, color: .blue, isCorrect: false)
            ]
        ),
        GameRound(
            mode: .shadow,
            targetKind: .cat,
            targetColor: .orange,
            candidates: [
                FriendCandidate(kind: .cat, color: .orange, isCorrect: true),
                FriendCandidate(kind: .dog, color: .mint, isCorrect: false)
            ]
        ),
        GameRound(
            mode: .sound,
            targetKind: .duck,
            targetColor: .yellow,
            candidates: [
                FriendCandidate(kind: .duck, color: .yellow, isCorrect: true),
                FriendCandidate(kind: .cat, color: .pink, isCorrect: false)
            ]
        ),
        GameRound(
            mode: .color,
            targetKind: .apple,
            targetColor: .green,
            candidates: [
                FriendCandidate(kind: .apple, color: .purple, isCorrect: false),
                FriendCandidate(kind: .apple, color: .green, isCorrect: true)
            ]
        ),
        GameRound(
            mode: .shadow,
            targetKind: .bear,
            targetColor: .brown,
            candidates: [
                FriendCandidate(kind: .duck, color: .yellow, isCorrect: false),
                FriendCandidate(kind: .bear, color: .brown, isCorrect: true)
            ]
        ),
        GameRound(
            mode: .size,
            targetKind: .star,
            targetColor: .yellow,
            targetSizeScale: 1.18,
            candidates: [
                FriendCandidate(kind: .star, color: .yellow, isCorrect: false, sizeScale: 0.78),
                FriendCandidate(kind: .star, color: .yellow, isCorrect: true, sizeScale: 1.18)
            ]
        ),
        GameRound(
            mode: .sound,
            targetKind: .dog,
            targetColor: .mint,
            candidates: [
                FriendCandidate(kind: .fish, color: .cyan, isCorrect: false),
                FriendCandidate(kind: .dog, color: .mint, isCorrect: true)
            ]
        )
    ]
}
