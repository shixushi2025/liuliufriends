import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = GameViewModel()
    @State private var mascotBounce = false

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                BackgroundView()

                VStack(spacing: 0) {
                    HeaderView(round: viewModel.round)
                        .padding(.horizontal, 28)
                        .padding(.top, 20)

                    Spacer(minLength: 8)

                    HStack(spacing: 24) {
                        MascotPanel(
                            round: viewModel.round,
                            celebrationSeed: viewModel.celebrationSeed,
                            isCelebrating: viewModel.completedCandidateID != nil
                        )
                        .frame(width: geometry.size.width * 0.34)

                        PlayPanel(viewModel: viewModel)
                            .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal, 28)
                    .padding(.bottom, 24)

                    Spacer(minLength: 0)
                }
            }
        }
    }
}

private struct HeaderView: View {
    let round: GameRound

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text("六六找朋友")
                    .font(.system(size: 34, weight: .heavy, design: .rounded))
                    .foregroundStyle(.primary)

                Text(round.mode.prompt)
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text(round.mode.title)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .padding(.horizontal, 18)
                .padding(.vertical, 10)
                .background(.white.opacity(0.72), in: Capsule())
        }
    }
}

private struct PlayPanel: View {
    @ObservedObject var viewModel: GameViewModel

    var body: some View {
        VStack(spacing: 28) {
            TargetArea(round: viewModel.round)
                .frame(height: 210)

            HStack(spacing: 28) {
                ForEach(viewModel.round.candidates) { candidate in
                    CandidateButton(
                        round: viewModel.round,
                        candidate: candidate,
                        isCompleted: viewModel.completedCandidateID == candidate.id,
                        isWrong: viewModel.wrongCandidateID == candidate.id
                    ) {
                        viewModel.choose(candidate)
                    }
                }
            }
        }
        .padding(24)
        .background(.white.opacity(0.58), in: RoundedRectangle(cornerRadius: 8))
    }
}

private struct TargetArea: View {
    let round: GameRound

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(.white.opacity(0.6))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.white.opacity(0.85), lineWidth: 3)
                )

            switch round.mode {
            case .color:
                VStack(spacing: 12) {
                    ColorFriendTarget(color: round.targetColor)
                        .frame(width: 150, height: 150)
                    Text("找一样的颜色")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundStyle(.secondary)
                }
            case .shadow:
                VStack(spacing: 12) {
                    FriendShape(kind: round.targetKind, color: .black.opacity(0.18), isShadow: true)
                        .frame(width: 160, height: 150)
                    Text("找这个影子")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundStyle(.secondary)
                }
            case .sound:
                VStack(spacing: 12) {
                    SoundBubble(text: round.targetKind.soundText)
                        .frame(width: 170, height: 150)
                    Text("听声音找朋友")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}

private struct CandidateButton: View {
    let round: GameRound
    let candidate: FriendCandidate
    let isCompleted: Bool
    let isWrong: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.white.opacity(0.78))
                    .shadow(color: .black.opacity(0.08), radius: 10, y: 6)

                FriendShape(kind: candidate.kind, color: candidate.color, isShadow: false)
                    .padding(24)

                if isCompleted {
                    SparkleBurst()
                }
            }
            .frame(width: 190, height: 190)
            .scaleEffect(isCompleted ? 1.08 : 1)
            .rotationEffect(.degrees(isWrong ? -5 : 0))
            .animation(.spring(response: 0.3, dampingFraction: 0.45), value: isCompleted)
            .animation(.easeInOut(duration: 0.08).repeatCount(isWrong ? 4 : 0, autoreverses: true), value: isWrong)
        }
        .buttonStyle(.plain)
        .disabled(isCompleted)
        .accessibilityLabel(candidate.kind.name)
    }
}
