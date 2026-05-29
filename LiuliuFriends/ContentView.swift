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
        .animation(viewModel.settings.reducedMotion ? nil : .spring(response: 0.42, dampingFraction: 0.86), value: viewModel.screen)
    }
}

private struct GameScreen: View {
    @ObservedObject var viewModel: GameViewModel
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    var body: some View {
        GeometryReader { geometry in
            let metrics = GameLayoutMetrics(size: geometry.size, horizontalSizeClass: horizontalSizeClass)

            VStack(spacing: 0) {
                HeaderView(
                    viewModel: viewModel,
                    isCompact: metrics.isCompact,
                    showsCompactPrompt: metrics.showsCompactPrompt
                )
                    .padding(.horizontal, metrics.sidePadding)
                    .padding(.top, metrics.topPadding)

                Spacer(minLength: metrics.minimumSpacer)

                PlayPanel(viewModel: viewModel, metrics: metrics)
                    .frame(maxWidth: metrics.maxBoardWidth)
                    .padding(.horizontal, metrics.sidePadding)

                Spacer(minLength: 0)
            }
            .padding(.bottom, metrics.bottomPadding)
        }
    }
}

private struct HeaderView: View {
    @ObservedObject var viewModel: GameViewModel
    let isCompact: Bool
    let showsCompactPrompt: Bool

    var body: some View {
        if isCompact {
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .center, spacing: 12) {
                    titleBlock(titleSize: 28, promptSize: 17, showsPrompt: false)

                    Spacer()

                    ProgressBadge(completedRounds: viewModel.completedRounds, isCompact: true)
                }

                if showsCompactPrompt {
                    Text(viewModel.round.mode.prompt)
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }

                headerActions(spacing: 10, buttonSize: 48)
            }
        } else {
            HStack {
                titleBlock(titleSize: 34, promptSize: 20, showsPrompt: true)

                Spacer()

                HStack(spacing: 12) {
                    ProgressBadge(completedRounds: viewModel.completedRounds, isCompact: false)
                    headerActions(spacing: 12, buttonSize: 52)
                }
            }
        }
    }

    private func titleBlock(titleSize: CGFloat, promptSize: CGFloat, showsPrompt: Bool) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("六六找朋友")
                .font(.system(size: titleSize, weight: .heavy, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            Color(red: 0.08, green: 0.10, blue: 0.16),
                            Color(red: 0.95, green: 0.18, blue: 0.16)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .lineLimit(1)
                .minimumScaleFactor(0.82)

            if showsPrompt {
                Text(viewModel.round.mode.prompt)
                    .font(.system(size: promptSize, weight: .semibold, design: .rounded))
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
        }
    }

    private func headerActions(spacing: CGFloat, buttonSize: CGFloat) -> some View {
        HStack(spacing: spacing) {
            IconButton(systemName: "speaker.wave.2.fill", size: buttonSize) {
                viewModel.replayPrompt()
            }
            .accessibilityLabel("重播提示")

            IconButton(systemName: "gearshape.fill", size: buttonSize) {
                viewModel.screen = .settings
            }
            .accessibilityLabel("设置")

            IconButton(systemName: "lock.shield.fill", size: buttonSize) {
                viewModel.screen = .parent
            }
            .accessibilityLabel("家长区")
        }
    }
}

private struct CompactMascotStrip: View {
    let round: GameRound
    let celebrationSeed: Int
    let isCelebrating: Bool
    let reducedMotion: Bool

    var body: some View {
        HStack(spacing: 14) {
            LiuliuMascot(mood: isCelebrating ? .happy : .waiting)
                .frame(width: 92, height: 108)
                .scaleEffect(reducedMotion ? 1 : (celebrationSeed == 0 ? 1 : 1.03))
                .animation(.spring(response: 0.35, dampingFraction: 0.42), value: celebrationSeed)

            VStack(alignment: .leading, spacing: 4) {
                Text("六六")
                    .font(.system(size: 24, weight: .heavy, design: .rounded))
                    .foregroundStyle(.primary)

                Text(round.mode.title)
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                    .foregroundStyle(.secondary)
            }

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(.white.opacity(0.52), in: RoundedRectangle(cornerRadius: 8))
    }
}

private struct PlayPanel: View {
    @ObservedObject var viewModel: GameViewModel
    let metrics: GameLayoutMetrics

    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack(spacing: metrics.panelSpacing) {
                TargetArea(round: viewModel.round, metrics: metrics)
                    .frame(height: metrics.targetHeight)

                HStack(spacing: metrics.candidateSpacing) {
                    ForEach(viewModel.round.candidates) { candidate in
                        CandidateButton(
                            round: viewModel.round,
                            candidate: candidate,
                            size: metrics.candidateSize,
                            isCompleted: viewModel.completedCandidateID == candidate.id,
                            isWrong: viewModel.wrongCandidateID == candidate.id,
                            reducedMotion: viewModel.settings.reducedMotion
                        ) {
                            viewModel.choose(candidate)
                        }
                    }
                }
            }
            .padding(metrics.panelPadding)
            .background(
                RoundedRectangle(cornerRadius: metrics.boardCornerRadius)
                    .fill(
                        LinearGradient(
                            colors: [
                                .white.opacity(0.82),
                                Color(red: 1.0, green: 0.94, blue: 0.78).opacity(0.62),
                                Color(red: 0.82, green: 0.93, blue: 1.0).opacity(0.70)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: metrics.boardCornerRadius)
                    .stroke(.white.opacity(0.76), lineWidth: 3)
            )
            .shadow(color: Color(red: 0.14, green: 0.22, blue: 0.34).opacity(0.14), radius: 26, y: 18)

            if metrics.showsPendant {
                LiuliuPendant(mood: viewModel.completedCandidateID == nil ? .waiting : .happy)
                    .scaleEffect(metrics.pendantScale)
                    .frame(width: 150 * metrics.pendantScale, height: 190 * metrics.pendantScale)
                    .offset(x: metrics.pendantOffsetX, y: metrics.pendantOffsetY)
                    .rotationEffect(.degrees(viewModel.completedCandidateID == nil ? -7 : 5))
                    .animation(viewModel.settings.reducedMotion ? nil : .spring(response: 0.36, dampingFraction: 0.62), value: viewModel.celebrationSeed)
                    .accessibilityHidden(true)
            }
        }
    }
}

private struct TargetArea: View {
    let round: GameRound
    let metrics: GameLayoutMetrics

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: metrics.cardCornerRadius)
                .fill(
                    LinearGradient(
                        colors: [
                            .white.opacity(0.94),
                            Color(red: 1.0, green: 0.96, blue: 0.86).opacity(0.76)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: metrics.cardCornerRadius)
                        .stroke(.white.opacity(0.86), lineWidth: 3)
                )
                .shadow(color: Color(red: 0.95, green: 0.22, blue: 0.12).opacity(0.10), radius: 20, y: 10)

            switch round.mode {
            case .color:
                VStack(spacing: 12) {
                    ColorFriendTarget(color: round.targetColor)
                        .frame(width: metrics.targetIconSize, height: metrics.targetIconSize)
                    TargetCaption(title: "找一样的颜色", mode: round.mode)
                }
            case .shadow:
                VStack(spacing: 12) {
                    FriendShape(kind: round.targetKind, color: .black.opacity(0.18), isShadow: true)
                        .frame(width: metrics.targetIconSize, height: metrics.targetIconSize * 0.94)
                    TargetCaption(title: "找这个影子", mode: round.mode)
                }
            case .sound:
                VStack(spacing: 12) {
                    SoundBubble(text: round.targetKind.soundText)
                        .frame(width: metrics.targetIconSize * 1.08, height: metrics.targetIconSize * 0.94)
                    TargetCaption(title: "听声音找朋友", mode: round.mode)
                }
            case .size:
                VStack(spacing: 12) {
                    FriendShape(kind: round.targetKind, color: round.targetColor.opacity(0.28), isShadow: true)
                        .scaleEffect(round.targetSizeScale)
                        .frame(width: metrics.targetIconSize, height: metrics.targetIconSize * 0.94)
                    TargetCaption(title: "找一样大的朋友", mode: round.mode)
                }
            }
        }
    }
}

private struct TargetCaption: View {
    let title: String
    let mode: GameMode

    var body: some View {
        VStack(spacing: 6) {
            Text(mode.title)
                .font(.system(size: 15, weight: .black, design: .rounded))
                .foregroundStyle(.white)
                .padding(.horizontal, 14)
                .padding(.vertical, 7)
                .background(
                    Capsule()
                        .fill(Color(red: 0.95, green: 0.20, blue: 0.18))
                )

            Text(title)
                .font(.system(size: 22, weight: .black, design: .rounded))
                .foregroundStyle(Color(red: 0.30, green: 0.32, blue: 0.38))
        }
    }
}

private struct CandidateButton: View {
    let round: GameRound
    let candidate: FriendCandidate
    let size: CGFloat
    let isCompleted: Bool
    let isWrong: Bool
    let reducedMotion: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: min(36, size * 0.18))
                    .fill(.white.opacity(0.92))
                    .overlay(
                        RoundedRectangle(cornerRadius: min(36, size * 0.18))
                            .stroke(isCompleted ? Color(red: 0.95, green: 0.20, blue: 0.18) : .white.opacity(0.88), lineWidth: isCompleted ? 6 : 3)
                    )
                    .shadow(color: candidate.color.opacity(0.18), radius: 20, y: 14)

                FriendShape(kind: candidate.kind, color: candidate.color, isShadow: false)
                    .scaleEffect(candidate.sizeScale)
                    .padding(max(14, size * 0.13))

                if isCompleted {
                    SparkleBurst()
                }
            }
            .frame(width: size, height: size)
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
    let isCompact: Bool

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "star.fill")
                .font(.system(size: isCompact ? 14 : 16, weight: .bold))
                .foregroundStyle(Color(red: 1.0, green: 0.74, blue: 0.02))
            Text("\(completedRounds)")
                .font(.system(size: isCompact ? 16 : 18, weight: .heavy, design: .rounded))
                .monospacedDigit()
        }
        .frame(minWidth: isCompact ? 58 : 74, minHeight: isCompact ? 44 : 54)
        .background(.white.opacity(0.78), in: RoundedRectangle(cornerRadius: isCompact ? 18 : 22))
        .shadow(color: .black.opacity(0.08), radius: 12, y: 7)
    }
}

private struct IconButton: View {
    let systemName: String
    let size: CGFloat
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(Color(red: 0.12, green: 0.22, blue: 0.32))
                .frame(width: size, height: size)
                .background(.white.opacity(0.78), in: RoundedRectangle(cornerRadius: size * 0.38))
                .shadow(color: .black.opacity(0.07), radius: 12, y: 7)
        }
        .buttonStyle(.plain)
    }
}

private struct GameLayoutMetrics {
    let size: CGSize
    let horizontalSizeClass: UserInterfaceSizeClass?

    var isCompact: Bool {
        horizontalSizeClass == .compact || size.width < 700 || size.height < 560
    }

    var sidePadding: CGFloat {
        isCompact ? 16 : 42
    }

    var topPadding: CGFloat {
        isCompact ? 14 : 20
    }

    var bottomPadding: CGFloat {
        isCompact ? 16 : 24
    }

    var minimumSpacer: CGFloat {
        isCompact ? 8 : 12
    }

    var contentSpacing: CGFloat {
        isCompact ? 14 : 26
    }

    var panelPadding: CGFloat {
        isCompact ? 16 : 34
    }

    var panelSpacing: CGFloat {
        isCompact ? 18 : 30
    }

    var candidateSpacing: CGFloat {
        isCompact ? 16 : 28
    }

    var targetHeight: CGFloat {
        if isCompact && size.height < 700 {
            return 178
        }
        return isCompact ? 210 : min(360, max(300, size.height * 0.34))
    }

    var maxBoardWidth: CGFloat {
        isCompact ? .infinity : 1240
    }

    var showsCompactPrompt: Bool {
        !isCompact || size.height >= 720
    }

    var showsPendant: Bool {
        !isCompact
    }

    var candidateSize: CGFloat {
        let availableWidth = min(size.width - sidePadding * 2, maxBoardWidth) - panelPadding * 2 - candidateSpacing
        let compactSize = floor(availableWidth / 2)
        return isCompact ? min(172, max(132, compactSize)) : min(260, max(210, compactSize * 0.42))
    }

    var targetIconSize: CGFloat {
        isCompact ? 160 : 190
    }

    var boardCornerRadius: CGFloat {
        isCompact ? 28 : 44
    }

    var cardCornerRadius: CGFloat {
        isCompact ? 24 : 36
    }

    var pendantScale: CGFloat {
        size.width >= 1000 ? 0.52 : 0.46
    }

    var pendantOffsetX: CGFloat {
        isCompact ? 0 : 24
    }

    var pendantOffsetY: CGFloat {
        isCompact ? 0 : 12
    }
}

private struct SettingsScreen: View {
    @ObservedObject var viewModel: GameViewModel

    var body: some View {
        ScrollView {
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

                Spacer(minLength: 0)
            }
            .padding(28)
        }
    }
}

private struct ParentScreen: View {
    @ObservedObject var viewModel: GameViewModel
    @State private var gateTaps = 0

    var body: some View {
        ScrollView {
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

                Spacer(minLength: 0)
            }
            .padding(28)
        }
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
                .fixedSize(horizontal: false, vertical: true)
            Spacer()
        }
    }
}
