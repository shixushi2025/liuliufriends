import AudioToolbox
import Foundation
import SwiftUI

final class GameViewModel: ObservableObject {
    @Published var round: GameRound
    @Published var completedCandidateID: UUID?
    @Published var wrongCandidateID: UUID?
    @Published var celebrationSeed = 0

    private var roundIndex = 0

    private let rounds: [GameRound] = [
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
        )
    ]

    init() {
        round = rounds[0]
    }

    func choose(_ candidate: FriendCandidate) {
        if candidate.isCorrect {
            completedCandidateID = candidate.id
            celebrationSeed += 1
            AudioServicesPlaySystemSound(1057)

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.15) {
                self.nextRound()
            }
        } else {
            wrongCandidateID = candidate.id
            AudioServicesPlaySystemSound(1104)

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
                self.wrongCandidateID = nil
            }
        }
    }

    func nextRound() {
        roundIndex = (roundIndex + 1) % rounds.count
        completedCandidateID = nil
        wrongCandidateID = nil

        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            round = rounds[roundIndex]
        }
    }
}
