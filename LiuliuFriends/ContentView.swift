import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = GameViewModel()

    var body: some View {
        ZStack {
            BackgroundView()

            switch viewModel.screen {
            case .play:
                GameScreen(viewModel: viewModel)
                    .transition(.opacity.combined(with: .scale(scale: 0.98)))
            case .settings:
                SettingsScreen(viewModel: viewModel)
                    .transition(.move(edge: .trailing).combined(with: .opacity))
            case .parent:
                ParentScreen(viewModel: viewModel)
                    .transition(.move(edge: .trailing).combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.42, dampingFraction: 0.86), value: viewModel.screen)
    }
}

private struct GameScreen: View {
    @ObservedObject var viewModel: GameViewModel

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                HeaderView(viewModel: viewModel)
                    .padding(.horizontal, 28)
                    .padding(.top, 20)

                Spacer(minLength: 8)

                HStack(spacing: 24) {
                    MascotPanel(
                        round: viewModel.round,
                        celebrationSeed: viewModel.celebrationSeed,
                        isCelebrating: viewModel.completedCandidateID != nil,
                        reducedMotion: viewModel.settings.reducedMotion
                    )
                    .frame(width: max(250, geometry.size.width * 0.32))

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

private struct HeaderView: View {
    @ObservedObject var viewModel: GameViewModel

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text("六六找朋友")
                    .font(.system(size: 34, weight: .heavy, design: .rounded))
                    .foregroundStyle(.primary)

                Text(viewModel.round.mode.prompt)
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .foregroundStyle(.secondary)
            }

            Spacer()

            HStack(spacing: 12) {
                ProgressBadge(completedRounds: viewModel.completedRounds)

                IconButton(systemName: "speaker.wave.2.fill") {
                    viewModel.replayPrompt()
                }
                .accessibilityLabel("重播提示")

                IconButton(systemName: "gearshape.fill") {
                    viewModel.screen = .settings
                }
                .accessibilityLabel("设置")

                IconButton(systemName: "lock.shield.fill") {
                    viewModel.screen = .parent
                }
                .accessibilityLabel("家长区")
            }
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
                        isWrong: viewModel.wrongCandidateID == candidate.id,
                        reducedMotion: viewModel.settings.reducedMotion
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
            case .size:
                VStack(spacing: 12) {
                    FriendShape(kind: round.targetKind, color: round.targetColor.opacity(0.28), isShadow: true)
                        .scaleEffect(round.targetSizeScale)
                        .frame(width: 170, height: 150)
                    Text("找一样大的朋友")
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
    let reducedMotion: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.white.opacity(0.78))
                    .shadow(color: .black.opacity(0.08), radius: 10, y: 6)

                FriendShape(kind: candidate.kind, color: candidate.color, isShadow: false)
                    .scaleEffect(candidate.sizeScale)
                    .padding(24)

                if isCompleted {
                    SparkleBurst()
                }
            }
            .frame(width: 190, height: 190)
            .scaleEffect(!reducedMotion && isCompleted ? 1.08 : 1)
            .rotationEffect(.degrees(!reducedMotion && isWrong ? -5 : 0))
            .animation(.spring(response: 0.3, dampingFraction: 0.45), value: isCompleted)
            .animation(.easeInOut(duration: 0.08).repeatCount(isWrong ? 4 : 0, autoreverses: true), value: isWrong)
        }
        .buttonStyle(.plain)
        .disabled(isCompleted)
        .accessibilityLabel(candidate.kind.name)
    }
}

private struct ProgressBadge: View {
    let completedRounds: Int

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "star.fill")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(.yellow)
            Text("\(completedRounds)")
                .font(.system(size: 18, weight: .heavy, design: .rounded))
                .monospacedDigit()
        }
        .frame(minWidth: 70, minHeight: 48)
        .background(.white.opacity(0.72), in: RoundedRectangle(cornerRadius: 8))
    }
}

private struct IconButton: View {
    let systemName: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(Color(red: 0.12, green: 0.22, blue: 0.32))
                .frame(width: 52, height: 52)
                .background(.white.opacity(0.72), in: RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.plain)
    }
}

private struct SettingsScreen: View {
    @ObservedObject var viewModel: GameViewModel

    var body: some View {
        VStack(spacing: 22) {
            ScreenHeader(title: "设置", actionTitle: "返回") {
                viewModel.screen = .play
            }

            VStack(spacing: 16) {
                SettingsToggle(
                    title: "音效",
                    systemName: "speaker.wave.2.fill",
                    isOn: $viewModel.settings.soundEnabled
                )
                SettingsToggle(
                    title: "提示音",
                    systemName: "bubble.left.and.soundwave.right.fill",
                    isOn: $viewModel.settings.voicePromptEnabled
                )
                SettingsToggle(
                    title: "自动下一题",
                    systemName: "arrow.right.circle.fill",
                    isOn: $viewModel.settings.autoAdvanceEnabled
                )
                SettingsToggle(
                    title: "减少动画",
                    systemName: "slowmo",
                    isOn: $viewModel.settings.reducedMotion
                )
            }
            .padding(24)
            .background(.white.opacity(0.72), in: RoundedRectangle(cornerRadius: 8))

            Button {
                viewModel.resetProgress()
                viewModel.screen = .play
            } label: {
                Label("重新开始", systemImage: "arrow.counterclockwise")
                    .font(.system(size: 22, weight: .heavy, design: .rounded))
                    .frame(maxWidth: 360, minHeight: 64)
                    .background(Color(red: 0.95, green: 0.26, blue: 0.24), in: RoundedRectangle(cornerRadius: 8))
                    .foregroundStyle(.white)
            }
            .buttonStyle(.plain)

            Spacer()
        }
        .padding(28)
    }
}

private struct ParentScreen: View {
    @ObservedObject var viewModel: GameViewModel
    @State private var gateTaps = 0

    var body: some View {
        VStack(spacing: 22) {
            ScreenHeader(title: "家长区", actionTitle: "返回") {
                viewModel.screen = .play
            }

            VStack(alignment: .leading, spacing: 18) {
                HStack(spacing: 16) {
                    LiuliuAppIconConcept()
                        .frame(width: 96, height: 96)

                    VStack(alignment: .leading, spacing: 6) {
                        Text("肚兜游戏")
                            .font(.system(size: 26, weight: .heavy, design: .rounded))
                        Text("六六找朋友")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundStyle(.secondary)
                    }
                }

                Divider().opacity(0.3)

                InfoRow(icon: "hand.tap.fill", title: "适龄", value: "1-2 岁，轻点为主")
                InfoRow(icon: "wifi.slash", title: "网络", value: "当前版本无网络请求")
                InfoRow(icon: "person.crop.circle.badge.xmark", title: "隐私", value: "不收集账号、位置或通讯录")
                InfoRow(icon: "megaphone.fill", title: "广告", value: "无广告、无内购入口")
                InfoRow(icon: "square.grid.2x2.fill", title: "内容", value: "\(GameContent.rounds.count) 轮循环启蒙互动")

                Button {
                    gateTaps += 1
                } label: {
                    Label(gateTaps >= 3 ? "已解锁家长操作" : "连续点三下解锁", systemImage: gateTaps >= 3 ? "lock.open.fill" : "lock.fill")
                        .font(.system(size: 20, weight: .heavy, design: .rounded))
                        .frame(maxWidth: .infinity, minHeight: 58)
                        .background(.white.opacity(0.78), in: RoundedRectangle(cornerRadius: 8))
                }
                .buttonStyle(.plain)

                if gateTaps >= 3 {
                    Button {
                        viewModel.resetProgress()
                    } label: {
                        Label("清除本次进度", systemImage: "trash.fill")
                            .font(.system(size: 20, weight: .heavy, design: .rounded))
                            .frame(maxWidth: .infinity, minHeight: 58)
                            .background(Color(red: 0.95, green: 0.26, blue: 0.24), in: RoundedRectangle(cornerRadius: 8))
                            .foregroundStyle(.white)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(24)
            .frame(maxWidth: 720)
            .background(.white.opacity(0.72), in: RoundedRectangle(cornerRadius: 8))

            Spacer()
        }
        .padding(28)
    }
}

private struct ScreenHeader: View {
    let title: String
    let actionTitle: String
    let action: () -> Void

    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 34, weight: .heavy, design: .rounded))
            Spacer()
            Button(action: action) {
                Label(actionTitle, systemImage: "chevron.left")
                    .font(.system(size: 20, weight: .heavy, design: .rounded))
                    .frame(minWidth: 116, minHeight: 52)
                    .background(.white.opacity(0.72), in: RoundedRectangle(cornerRadius: 8))
            }
            .buttonStyle(.plain)
        }
    }
}

private struct SettingsToggle: View {
    let title: String
    let systemName: String
    @Binding var isOn: Bool

    var body: some View {
        Toggle(isOn: $isOn) {
            Label(title, systemImage: systemName)
                .font(.system(size: 22, weight: .bold, design: .rounded))
        }
        .toggleStyle(.switch)
        .tint(Color(red: 0.95, green: 0.26, blue: 0.24))
        .padding(.vertical, 8)
    }
}

private struct InfoRow: View {
    let icon: String
    let title: String
    let value: String

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .bold))
                .frame(width: 36, height: 36)
                .foregroundStyle(Color(red: 0.95, green: 0.26, blue: 0.24))
            Text(title)
                .font(.system(size: 18, weight: .heavy, design: .rounded))
                .frame(width: 72, alignment: .leading)
            Text(value)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundStyle(.secondary)
            Spacer()
        }
    }
}
