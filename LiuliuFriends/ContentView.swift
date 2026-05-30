import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = GameViewModel()
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        ZStack {
            BackgroundView(eyeComfortEnabled: viewModel.settings.eyeComfortEnabled)

            switch viewModel.screen {
            case .play:
                GameScreen(viewModel: viewModel)
                    .transition(.opacity.combined(with: .scale(scale: 0.98)))
            case .settings:
                SettingsScreen(viewModel: viewModel)
                    .transition(.move(edge: .trailing).combined(with: .opacity))
            }

            if let reminder = viewModel.breakReminder {
                BreakReminderOverlay(reminder: reminder) {
                    viewModel.continueAfterBreak()
                }
                .transition(.opacity.combined(with: .scale(scale: 0.98)))
                .zIndex(2)
            }
        }
        .animation(viewModel.settings.reducedMotion ? nil : .spring(response: 0.42, dampingFraction: 0.86), value: viewModel.screen)
        .animation(viewModel.settings.reducedMotion ? nil : .spring(response: 0.38, dampingFraction: 0.86), value: viewModel.breakReminder)
        .onAppear {
            viewModel.playInitialPromptIfNeeded()
        }
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
            guard scenePhase == .active else { return }
            viewModel.recordActiveUsageTick()
        }
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
                    showsCompactPrompt: metrics.showsCompactPrompt,
                    sidePadding: metrics.sidePadding
                )
                    .frame(width: geometry.size.width, alignment: .leading)
                    .padding(.top, geometry.safeAreaInsets.top + metrics.topPadding)

                Spacer(minLength: metrics.minimumSpacer)

                PlayPanel(viewModel: viewModel, metrics: metrics)
                    .frame(maxWidth: metrics.maxBoardWidth)
                    .padding(.horizontal, metrics.sidePadding)

                Spacer(minLength: 0)
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .topLeading)
            .padding(.bottom, metrics.bottomPadding)
        }
    }
}

private struct HeaderView: View {
    @ObservedObject var viewModel: GameViewModel
    let isCompact: Bool
    let showsCompactPrompt: Bool
    let sidePadding: CGFloat

    var body: some View {
        if isCompact {
            ZStack {
                compactHeaderActions(spacing: 6, buttonSize: 40, showsProgress: true)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, sidePadding + 54)
            }
            .frame(height: 40)
        } else {
            HStack {
                titleBlock(titleSize: 34, promptSize: 20, showsPrompt: true)

                Spacer()

                HStack(spacing: 12) {
                    ProgressBadge(completedRounds: viewModel.completedRounds, isCompact: false)
                    headerActions(spacing: 12, buttonSize: 52)
                }
            }
            .padding(.horizontal, sidePadding)
        }
    }

    private func titleBlock(titleSize: CGFloat, promptSize: CGFloat, showsPrompt: Bool) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("六六找朋友")
                .font(.system(size: titleSize, weight: .heavy, design: .rounded))
                .foregroundStyle(Color(red: 0.35, green: 0.27, blue: 0.20))
                .lineLimit(1)
                .minimumScaleFactor(0.82)

            if showsPrompt {
                Text("\(viewModel.round.mode.prompt) · \(viewModel.round.mode.ageLabel)")
                    .font(.system(size: promptSize, weight: .semibold, design: .rounded))
                    .foregroundStyle(viewModel.round.mode.accentColor)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 5)
                    .background(viewModel.round.mode.accentColor.opacity(0.14), in: Capsule())
                    .lineLimit(2)
            }
        }
    }

    private func headerActions(spacing: CGFloat, buttonSize: CGFloat) -> some View {
        HStack(spacing: spacing) {
            IconButton(systemName: "gearshape.fill", size: buttonSize) {
                viewModel.screen = .settings
            }
            .accessibilityLabel("家长设置")
        }
    }

    private func compactHeaderActions(spacing: CGFloat, buttonSize: CGFloat, showsProgress: Bool = false) -> some View {
        HStack(spacing: spacing) {
            if showsProgress {
                ProgressBadge(completedRounds: viewModel.completedRounds, isCompact: true)
            }

            IconButton(systemName: "gearshape.fill", size: buttonSize) {
                viewModel.screen = .settings
            }
            .accessibilityLabel("家长设置")
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
        ZStack(alignment: .bottomTrailing) {
            panelContent
            .padding(metrics.panelPadding)
            .background(
                RoundedRectangle(cornerRadius: metrics.boardCornerRadius)
                    .fill(
                        LinearGradient(
                            colors: viewModel.round.mode.usesNeutralBackground ? neutralPanelColors : warmPanelColors,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: metrics.boardCornerRadius)
                    .stroke(Color(red: 1.0, green: 0.86, blue: 0.62).opacity(metrics.isCompact ? 0.12 : 0.18), lineWidth: 1)
            )
            .shadow(color: Color(red: 0.58, green: 0.40, blue: 0.22).opacity(metrics.isCompact ? 0.06 : 0.10), radius: 22, y: 14)

            if metrics.showsPendant && viewModel.completedCandidateID == nil {
                LiuliuPendant(mood: viewModel.wrongCandidateID == nil ? .waiting : .encourage)
                    .scaleEffect(metrics.pendantScale)
                    .frame(width: 150 * metrics.pendantScale, height: 190 * metrics.pendantScale)
                    .offset(x: metrics.pendantOffsetX, y: metrics.pendantOffsetY)
                    .rotationEffect(.degrees(-7))
                    .animation(viewModel.settings.reducedMotion ? nil : .spring(response: 0.36, dampingFraction: 0.62), value: viewModel.celebrationSeed)
                    .accessibilityHidden(true)
            }

            if viewModel.completedCandidateID != nil {
                LiuliuPendant(mood: .happy)
                    .frame(width: metrics.celebrationMascotSize, height: metrics.celebrationMascotSize * 1.22)
                    .shadow(color: Color(red: 1.0, green: 0.82, blue: 0.35).opacity(0.55), radius: 26)
                    .scaleEffect(viewModel.settings.reducedMotion ? 1 : 1.08)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    .padding(.top, metrics.celebrationTopPadding)
                    .allowsHitTesting(false)
                    .transition(.scale(scale: 0.78).combined(with: .opacity))
                    .animation(viewModel.settings.reducedMotion ? nil : .spring(response: 0.42, dampingFraction: 0.62), value: viewModel.celebrationSeed)
            }
        }
    }

    @ViewBuilder
    private var panelContent: some View {
        if metrics.usesWidePanel {
            HStack(alignment: .center, spacing: metrics.panelSpacing) {
                TargetArea(viewModel: viewModel, round: viewModel.round, metrics: metrics)
                    .frame(width: metrics.wideTargetWidth, height: metrics.targetHeight)

                VStack(spacing: metrics.candidateSpacing) {
                    candidateButtons
                }
            }
        } else {
            VStack(spacing: metrics.panelSpacing) {
                TargetArea(viewModel: viewModel, round: viewModel.round, metrics: metrics)
                    .frame(height: metrics.targetHeight)

                if metrics.stacksCandidates {
                    VStack(spacing: metrics.candidateSpacing) {
                        candidateButtons
                    }
                } else {
                    HStack(spacing: metrics.candidateSpacing) {
                        candidateButtons
                    }
                }
            }
        }
    }

    private var neutralPanelColors: [Color] {
        [
            Color(red: 1.0, green: 0.98, blue: 0.92).opacity(0.88),
            Color(red: 1.0, green: 0.94, blue: 0.86).opacity(0.78)
        ]
    }

    private var warmPanelColors: [Color] {
        [
            Color(red: 1.0, green: 0.98, blue: 0.92).opacity(0.88),
            Color(red: 1.0, green: 0.94, blue: 0.82).opacity(0.76),
            Color(red: 1.0, green: 0.88, blue: 0.86).opacity(0.68)
        ]
    }

    @ViewBuilder
    private var candidateButtons: some View {
        ForEach(viewModel.round.candidates) { candidate in
            CandidateButton(
                round: viewModel.round,
                candidate: candidate,
                size: metrics.candidateSize,
                isCompleted: viewModel.completedCandidateID == candidate.id,
                isWrong: viewModel.wrongCandidateID == candidate.id,
                isHinted: viewModel.hintCandidateID == candidate.id,
                isLocked: viewModel.wrongCandidateID != nil,
                reducedMotion: viewModel.settings.reducedMotion
            ) {
                viewModel.choose(candidate)
            }
        }
    }
}

private struct TargetArea: View {
    @ObservedObject var viewModel: GameViewModel
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
                        .stroke(Color(red: 1.0, green: 0.86, blue: 0.60).opacity(0.20), lineWidth: 1)
                )
                .shadow(color: Color(red: 0.95, green: 0.62, blue: 0.22).opacity(0.08), radius: 18, y: 8)

            switch round.mode {
            case .animal:
                VStack(spacing: metrics.targetContentSpacing) {
                    FriendShape(kind: round.targetKind, color: round.targetColor, isShadow: false)
                        .frame(width: metrics.targetIconSize, height: metrics.targetIconSize)
                    TargetCaption(title: "找\(viewModel.displayName(for: round.targetKind))", mode: round.mode)
                }
                .padding(.vertical, metrics.targetVerticalInset)
            case .sound:
                VStack(spacing: metrics.targetContentSpacing) {
                    SoundBubble(text: viewModel.soundPrompt(for: round.targetKind))
                        .frame(width: metrics.targetIconSize * 1.08, height: metrics.targetIconSize * 0.78)
                    TargetCaption(title: "听声音找朋友", mode: round.mode)
                }
                .padding(.vertical, metrics.targetVerticalInset)
            case .color:
                VStack(spacing: metrics.targetContentSpacing) {
                    ColorFriendTarget(color: round.targetColor)
                        .frame(width: metrics.targetIconSize, height: metrics.targetIconSize)
                    TargetCaption(title: "找一样的颜色", mode: round.mode)
                }
                .padding(.vertical, metrics.targetVerticalInset)
            case .shape:
                VStack(spacing: metrics.targetContentSpacing) {
                    FriendShape(kind: round.targetKind, color: round.targetColor, isShadow: false)
                        .frame(width: metrics.targetIconSize, height: metrics.targetIconSize)
                    TargetCaption(title: "找一样的形状", mode: round.mode)
                }
                .padding(.vertical, metrics.targetVerticalInset)
            case .size:
                VStack(spacing: metrics.targetContentSpacing) {
                    FriendShape(kind: round.targetKind, color: round.targetColor, isShadow: false)
                        .scaleEffect(round.targetSizeScale)
                        .frame(width: metrics.targetIconSize, height: metrics.targetIconSize)
                    TargetCaption(title: "找一样大的朋友", mode: round.mode)
                }
                .padding(.vertical, metrics.targetVerticalInset)
            case .shadow:
                VStack(spacing: metrics.targetContentSpacing) {
                    FriendShape(kind: round.targetKind, color: Color(red: 0.28, green: 0.25, blue: 0.22), isShadow: true)
                        .frame(width: metrics.targetIconSize, height: metrics.targetIconSize)
                    TargetCaption(title: "找这个影子", mode: round.mode)
                }
                .padding(.vertical, metrics.targetVerticalInset)
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
                        .fill(mode.accentColor)
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
    let isHinted: Bool
    let isLocked: Bool
    let reducedMotion: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: min(40, size * 0.22))
                    .fill(
                        LinearGradient(
                            colors: isCompleted ? [.white, Color(red: 1.0, green: 0.97, blue: 0.88)] : [.white, Color(red: 1.0, green: 0.98, blue: 0.93)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: min(40, size * 0.22))
                            .stroke(isCompleted || isHinted ? Color(red: 1.0, green: 0.78, blue: 0.26) : Color(red: 1.0, green: 0.88, blue: 0.66).opacity(0.34), lineWidth: isCompleted || isHinted ? 4 : 1)
                    )
                    .shadow(color: Color(red: 0.72, green: 0.50, blue: 0.24).opacity(isCompleted ? 0.18 : 0.08), radius: isCompleted ? 22 : 12, y: isCompleted ? 14 : 8)
                    .shadow(color: Color(red: 1.0, green: 0.78, blue: 0.28).opacity(isCompleted || isHinted ? 0.38 : 0), radius: isCompleted ? 24 : 16)

                GameObjectView(round: round, kind: candidate.kind, color: candidate.color, isTarget: false)
                    .scaleEffect(displayScale)
                    .padding(objectPadding)

                if isCompleted {
                    SparkleBurst()
                }
            }
            .frame(width: size, height: size)
            .scaleEffect(!reducedMotion ? (isCompleted ? 1.08 : (isHinted ? 1.03 : 1)) : 1)
            .rotationEffect(.degrees(!reducedMotion && isWrong ? -5 : 0))
            .animation(.spring(response: 0.3, dampingFraction: 0.45), value: isCompleted)
            .animation(.easeInOut(duration: 0.08).repeatCount(isWrong ? 4 : 0, autoreverses: true), value: isWrong)
            .animation(.easeInOut(duration: 0.65), value: isHinted)
        }
        .buttonStyle(.plain)
        .disabled(isCompleted || isLocked)
        .accessibilityLabel(candidate.kind.name)
    }

    private var displayScale: CGFloat {
        round.mode == .size ? candidate.sizeScale : 1
    }

    private var objectPadding: CGFloat {
        switch round.mode {
        case .shape:
            max(30, size * 0.22)
        case .size:
            max(14, size * 0.13)
        default:
            max(14, size * 0.13)
        }
    }
}

private struct GameObjectView: View {
    let round: GameRound
    let kind: FriendKind
    let color: Color
    let isTarget: Bool

    var body: some View {
        switch round.mode {
        case .color:
            ColorFriendTarget(color: color)
        case .shape, .size:
            FriendShape(kind: kind, color: color, isShadow: false)
        case .shadow:
            FriendShape(kind: kind, color: color, isShadow: isTarget)
        case .animal, .sound:
            FriendShape(kind: kind, color: color, isShadow: false)
        }
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
                .lineLimit(1)
                .minimumScaleFactor(0.78)
                .frame(minWidth: isCompact ? 30 : 38, alignment: .center)
        }
        .padding(.horizontal, isCompact ? 10 : 14)
        .frame(minWidth: isCompact ? 72 : 92, minHeight: isCompact ? 40 : 54)
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

private struct BreakReminderOverlay: View {
    let reminder: BreakReminder
    let continueAction: () -> Void
    @State private var isHolding = false

    var body: some View {
        ZStack {
            Color(red: 0.34, green: 0.26, blue: 0.18)
                .opacity(0.24)
                .ignoresSafeArea()

            VStack(spacing: 18) {
                ZStack {
                    Circle()
                        .fill(Color(red: 1.0, green: 0.92, blue: 0.76))
                        .frame(width: 96, height: 96)

                    Image(systemName: reminder == .dailyLimit ? "moon.zzz.fill" : "eye.fill")
                        .font(.system(size: 42, weight: .heavy))
                        .foregroundStyle(Color(red: 0.95, green: 0.42, blue: 0.24))
                }

                Text(reminder.title)
                    .font(.system(size: 32, weight: .heavy, design: .rounded))
                    .foregroundStyle(Color(red: 0.26, green: 0.19, blue: 0.13))

                Text(reminder.message)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color(red: 0.48, green: 0.38, blue: 0.29))
                    .lineSpacing(4)

                Text("家长长按 3 秒继续")
                    .font(.system(size: 17, weight: .heavy, design: .rounded))
                    .foregroundStyle(Color(red: 0.95, green: 0.26, blue: 0.24))

                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(isHolding ? Color(red: 0.95, green: 0.26, blue: 0.24) : Color(red: 1.0, green: 0.84, blue: 0.70))
                    .frame(height: 58)
                    .overlay {
                        Label(isHolding ? "继续按住" : "长按继续", systemImage: "hand.point.up.left.fill")
                            .font(.system(size: 20, weight: .heavy, design: .rounded))
                            .foregroundStyle(isHolding ? .white : Color(red: 0.38, green: 0.24, blue: 0.15))
                    }
                    .gesture(
                        LongPressGesture(minimumDuration: 3)
                            .onChanged { _ in isHolding = true }
                            .onEnded { _ in
                                isHolding = false
                                continueAction()
                            }
                    )
            }
            .frame(maxWidth: 430)
            .padding(28)
            .background(.white.opacity(0.94), in: RoundedRectangle(cornerRadius: 32, style: .continuous))
            .shadow(color: .black.opacity(0.16), radius: 24, y: 12)
            .padding(.horizontal, 24)
        }
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
        isCompact ? -24 : 20
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
        if isCompact {
            return 14
        }
        return usesWidePanel ? 28 : 34
    }

    var panelSpacing: CGFloat {
        if isCompact {
            return 12
        }
        return usesWidePanel ? 24 : 30
    }

    var candidateSpacing: CGFloat {
        if isCompact {
            return 12
        }
        return usesWidePanel ? 22 : 28
    }

    var targetHeight: CGFloat {
        if usesWidePanel {
            return candidateSize * 2 + candidateSpacing
        }
        if isCompact && size.height < 700 {
            return 158
        }
        return isCompact ? 184 : min(360, max(300, size.height * 0.34))
    }

    var maxBoardWidth: CGFloat {
        if isCompact {
            return .infinity
        }
        return usesWidePanel ? min(1120, effectiveLandscapeWidth - sidePadding * 2) : 1240
    }

    var showsCompactPrompt: Bool {
        !isCompact || size.height >= 720
    }

    var showsPendant: Bool {
        !usesWidePanel
    }

    var candidateSize: CGFloat {
        if usesWidePanel {
            let reservedHeaderHeight: CGFloat = 108
            let availableHeight = effectiveLandscapeHeight - topPadding - bottomPadding - reservedHeaderHeight - minimumSpacer - panelPadding * 2
            let heightBoundSize = floor((availableHeight - candidateSpacing) / 2)
            let widthBoundSize = floor((effectiveLandscapeWidth - sidePadding * 2 - panelPadding * 2 - wideTargetWidth - panelSpacing) * 0.82)
            return min(250, max(206, min(heightBoundSize, widthBoundSize)))
        }
        let availableWidth = min(size.width - sidePadding * 2, maxBoardWidth) - panelPadding * 2 - candidateSpacing
        let compactSize = floor(availableWidth / 2)
        return isCompact ? min(154, max(124, compactSize)) : min(260, max(210, compactSize * 0.42))
    }

    var targetIconSize: CGFloat {
        if usesWidePanel {
            return 178
        }
        return isCompact ? 112 : 190
    }

    var targetContentSpacing: CGFloat {
        isCompact ? 8 : 12
    }

    var targetVerticalInset: CGFloat {
        isCompact ? 10 : 12
    }

    var stacksCandidates: Bool {
        isCompact && size.height >= 690
    }

    var usesWidePanel: Bool {
        !isCompact && effectiveLandscapeWidth >= 900
    }

    var wideTargetWidth: CGFloat {
        min(430, max(340, effectiveLandscapeWidth * 0.36))
    }

    private var effectiveLandscapeWidth: CGFloat {
        max(size.width, size.height)
    }

    private var effectiveLandscapeHeight: CGFloat {
        min(size.width, size.height)
    }

    var celebrationMascotSize: CGFloat {
        isCompact ? 132 : 190
    }

    var celebrationTopPadding: CGFloat {
        isCompact ? 8 : 24
    }

    var boardCornerRadius: CGFloat {
        isCompact ? 28 : 44
    }

    var cardCornerRadius: CGFloat {
        isCompact ? 24 : 36
    }

    var pendantScale: CGFloat {
        if isCompact {
            return 0.34
        }
        return size.width >= 1000 ? 0.52 : 0.46
    }

    var pendantOffsetX: CGFloat {
        isCompact ? -74 : 24
    }

    var pendantOffsetY: CGFloat {
        isCompact ? -24 : 12
    }
}

private struct SettingsScreen: View {
    @ObservedObject var viewModel: GameViewModel

    var body: some View {
        GeometryReader { geometry in
            let isCompact = geometry.size.width < 700
            let compactContentWidth = min(geometry.size.width - 48, 330)

            ScrollView {
                VStack(spacing: isCompact ? 18 : 22) {
                    AdaptiveScreenHeader(title: "家长设置", actionTitle: "返回", isCompact: isCompact) {
                        viewModel.screen = .play
                    }
                    .frame(maxWidth: .infinity)

                    if isCompact {
                        LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)], spacing: 10) {
                            SettingsTile(title: "音效", systemName: "speaker.wave.2.fill", isOn: $viewModel.settings.soundEnabled)
                            SettingsTile(title: "语音", systemName: "bubble.left.and.soundwave.right.fill", isOn: $viewModel.settings.voicePromptEnabled)
                            SettingsTile(title: "休息", systemName: "timer", isOn: $viewModel.settings.restReminderEnabled)
                            SettingsTile(title: "护眼", systemName: "eye.fill", isOn: $viewModel.settings.eyeComfortEnabled)
                            SettingsTile(title: "自动", systemName: "arrow.right.circle.fill", isOn: $viewModel.settings.autoAdvanceEnabled)
                            SettingsTile(title: "动画", systemName: "sparkles", isOn: Binding(
                                get: { !viewModel.settings.reducedMotion },
                                set: { viewModel.settings.reducedMotion = !$0 }
                            ))
                        }
                    } else {
                        VStack(spacing: 16) {
                            SettingsToggle(
                                title: "音效",
                                systemName: "speaker.wave.2.fill",
                                isOn: $viewModel.settings.soundEnabled,
                                isCompact: false
                            )
                            SettingsToggle(
                                title: "语音提示",
                                systemName: "bubble.left.and.soundwave.right.fill",
                                isOn: $viewModel.settings.voicePromptEnabled,
                                isCompact: false
                            )
                            SettingsToggle(
                                title: "自动下一题",
                                systemName: "arrow.right.circle.fill",
                                isOn: $viewModel.settings.autoAdvanceEnabled,
                                isCompact: false
                            )
                            SettingsToggle(
                                title: "休息提醒",
                                systemName: "timer",
                                isOn: $viewModel.settings.restReminderEnabled,
                                isCompact: false
                            )
                            SettingsToggle(
                                title: "护眼模式",
                                systemName: "eye.fill",
                                isOn: $viewModel.settings.eyeComfortEnabled,
                                isCompact: false
                            )
                            SettingsToggle(
                                title: "减少动画",
                                systemName: "slowmo",
                                isOn: $viewModel.settings.reducedMotion,
                                isCompact: false
                            )
                        }
                        .frame(maxWidth: 640, alignment: .leading)
                        .padding(24)
                        .background(.white.opacity(0.88), in: RoundedRectangle(cornerRadius: 22, style: .continuous))
                        .shadow(color: .black.opacity(0.08), radius: 16, y: 8)
                    }

                    ParentSummarySection(isCompact: isCompact)

                    Button {
                        viewModel.resetProgress()
                        viewModel.screen = .play
                    } label: {
                        Label("重新开始", systemImage: "arrow.counterclockwise")
                            .font(.system(size: isCompact ? 19 : 22, weight: .heavy, design: .rounded))
                            .frame(maxWidth: isCompact ? 300 : 360, minHeight: isCompact ? 54 : 64)
                            .background(Color(red: 0.95, green: 0.26, blue: 0.24), in: RoundedRectangle(cornerRadius: 22, style: .continuous))
                            .foregroundStyle(.white)
                    }
                    .buttonStyle(.plain)

                    Spacer(minLength: 0)
                }
                .frame(maxWidth: isCompact ? compactContentWidth : 720)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, isCompact ? 24 : 28)
                .padding(.top, geometry.safeAreaInsets.top + (isCompact ? 10 : 28))
                .padding(.bottom, geometry.safeAreaInsets.bottom + 28)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

private struct ParentSummarySection: View {
    let isCompact: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: isCompact ? 14 : 18) {
            HStack(spacing: isCompact ? 12 : 16) {
                LiuliuAppIconConcept()
                    .frame(width: isCompact ? 58 : 82, height: isCompact ? 58 : 82)

                VStack(alignment: .leading, spacing: 5) {
                    Text("肚兜启蒙")
                        .font(.system(size: isCompact ? 21 : 25, weight: .heavy, design: .rounded))
                        .foregroundStyle(Color(red: 0.25, green: 0.19, blue: 0.14))
                    Text("六六找朋友")
                        .font(.system(size: isCompact ? 15 : 19, weight: .bold, design: .rounded))
                        .foregroundStyle(Color(red: 0.45, green: 0.38, blue: 0.32))
                }
            }

            Divider().opacity(0.3)

            if isCompact {
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)], spacing: 10) {
                    ParentInfoTile(icon: "hand.tap.fill", title: "适龄", value: "1.5-3 岁")
                    ParentInfoTile(icon: "wifi.slash", title: "网络", value: "无联网")
                    ParentInfoTile(icon: "person.crop.circle.badge.xmark", title: "隐私", value: "不收集")
                    ParentInfoTile(icon: "megaphone.fill", title: "广告", value: "无广告")
                    ParentInfoTile(icon: "square.grid.2x2.fill", title: "内容", value: "\(GameContent.rounds.count) 轮")
                    ParentInfoTile(icon: "cart.badge.minus", title: "内购", value: "无内购")
                }
            } else {
                InfoRow(icon: "hand.tap.fill", title: "适龄", value: "1.5-3 岁，轻点为主", isCompact: false)
                InfoRow(icon: "wifi.slash", title: "网络", value: "当前版本无网络请求", isCompact: false)
                InfoRow(icon: "person.crop.circle.badge.xmark", title: "隐私", value: "不收集账号、位置或通讯录", isCompact: false)
                InfoRow(icon: "megaphone.fill", title: "广告", value: "无广告、无内购入口", isCompact: false)
                InfoRow(icon: "square.grid.2x2.fill", title: "内容", value: "\(GameContent.rounds.count) 轮循环启蒙互动", isCompact: false)
            }
        }
        .frame(maxWidth: isCompact ? .infinity : 640, alignment: .leading)
        .padding(isCompact ? 16 : 24)
        .background(.white.opacity(0.88), in: RoundedRectangle(cornerRadius: isCompact ? 20 : 22, style: .continuous))
        .shadow(color: .black.opacity(0.08), radius: 16, y: 8)
    }
}

private struct VoiceRecordingSection: View {
    @ObservedObject var viewModel: GameViewModel
    @ObservedObject private var voiceStore: VoicePromptStore
    @ObservedObject private var promptAliasStore: PromptAliasStore
    @State private var selectedRecordingGroup: VoicePromptGroup
    @State private var customNameDraft = ""
    let isCompact: Bool

    init(viewModel: GameViewModel, isCompact: Bool) {
        self.viewModel = viewModel
        self.voiceStore = viewModel.voiceStore
        self.promptAliasStore = viewModel.promptAliasStore
        _selectedRecordingGroup = State(initialValue: viewModel.selectedRecordingTarget.group)
        _customNameDraft = State(initialValue: viewModel.customPromptName(for: viewModel.selectedRecordingTarget))
        self.isCompact = isCompact
    }

    var body: some View {
        let selectedTarget = viewModel.selectedRecordingTarget
        let isRecording = voiceStore.recordingID == selectedTarget.id
        let isRecordingAnotherTarget = voiceStore.recordingID != nil && !isRecording
        let hasRecording = voiceStore.hasRecording(for: selectedTarget.id)

        VStack(alignment: .leading, spacing: isCompact ? 12 : 16) {
            HStack(spacing: 12) {
                Image(systemName: isRecording ? "record.circle.fill" : "mic.circle.fill")
                    .font(.system(size: isCompact ? 30 : 36, weight: .heavy))
                    .foregroundStyle(isRecording ? Color(red: 0.95, green: 0.26, blue: 0.24) : Color(red: 0.24, green: 0.65, blue: 0.94))

                VStack(alignment: .leading, spacing: 4) {
                    Text("家长录音")
                        .font(.system(size: isCompact ? 19 : 23, weight: .heavy, design: .rounded))
                        .foregroundStyle(Color(red: 0.25, green: 0.19, blue: 0.14))
                    Text("先选择颜色或物体，再录它的专属读音。已录 \(voiceStore.recordingCount) 个。")
                        .font(.system(size: isCompact ? 14 : 17, weight: .bold, design: .rounded))
                        .foregroundStyle(Color(red: 0.48, green: 0.40, blue: 0.33))
                        .lineLimit(2)
                }
            }

            SelectedRecordingCard(
                target: selectedTarget,
                displayName: viewModel.displayName(for: selectedTarget),
                defaultName: selectedTarget.name,
                isRecording: isRecording,
                hasRecording: hasRecording,
                isCompact: isCompact
            )

            CustomPromptNameEditor(
                target: selectedTarget,
                displayName: viewModel.displayName(for: selectedTarget),
                draftName: $customNameDraft,
                isCompact: isCompact
            ) {
                viewModel.setCustomPromptName(customNameDraft, for: selectedTarget)
                customNameDraft = viewModel.customPromptName(for: selectedTarget)
            } reset: {
                viewModel.resetCustomPromptName(for: selectedTarget)
                customNameDraft = ""
            }

            RecordingGroupPicker(
                selectedGroup: selectedRecordingGroup,
                voiceStore: voiceStore,
                isCompact: isCompact,
                isDisabled: voiceStore.recordingID != nil
            ) { group in
                selectedRecordingGroup = group
                if selectedTarget.group != group, let firstTarget = VoicePromptTarget.firstTarget(in: group) {
                    viewModel.selectRecordingTarget(firstTarget)
                }
            }

            RecordingTargetSection(
                group: selectedRecordingGroup,
                selectedTargetID: selectedTarget.id,
                voiceStore: voiceStore,
                displayName: { viewModel.displayName(for: $0) },
                isCompact: isCompact,
                isSelectionLocked: voiceStore.recordingID != nil
            ) { target in
                viewModel.selectRecordingTarget(target)
            }

            if voiceStore.authorizationDenied {
                Text("麦克风权限未开启，请到系统设置允许麦克风。")
                    .font(.system(size: isCompact ? 14 : 16, weight: .bold, design: .rounded))
                    .foregroundStyle(Color(red: 0.95, green: 0.26, blue: 0.24))
            }

            HStack(spacing: isCompact ? 8 : 12) {
                VoiceActionButton(
                    title: isRecording ? "停止" : "录\(viewModel.displayName(for: selectedTarget))",
                    systemName: isRecording ? "stop.fill" : "mic.fill",
                    isPrimary: true,
                    isCompact: isCompact,
                    isDisabled: isRecordingAnotherTarget
                ) {
                    viewModel.toggleRecordingForSelectedKind()
                }

                VoiceActionButton(
                    title: "试听",
                    systemName: "play.fill",
                    isPrimary: false,
                    isCompact: isCompact,
                    isDisabled: !hasRecording || isRecording
                ) {
                    viewModel.playRecordingForSelectedKind()
                }

                VoiceActionButton(
                    title: "删除",
                    systemName: "trash.fill",
                    isPrimary: false,
                    isCompact: isCompact,
                    isDisabled: !hasRecording || isRecording
                ) {
                    viewModel.deleteRecordingForSelectedKind()
                }
            }
        }
        .frame(maxWidth: isCompact ? .infinity : 640, alignment: .leading)
        .padding(isCompact ? 16 : 22)
        .background(.white.opacity(0.88), in: RoundedRectangle(cornerRadius: isCompact ? 20 : 22, style: .continuous))
        .shadow(color: .black.opacity(0.08), radius: 16, y: 8)
        .onChange(of: selectedTarget.id) { _, _ in
            selectedRecordingGroup = selectedTarget.group
            customNameDraft = viewModel.customPromptName(for: selectedTarget)
        }
        .onChange(of: promptAliasStore.aliases) { _, _ in
            customNameDraft = viewModel.customPromptName(for: selectedTarget)
        }
    }
}

private struct CustomPromptNameEditor: View {
    let target: VoicePromptTarget
    let displayName: String
    @Binding var draftName: String
    let isCompact: Bool
    let save: () -> Void
    let reset: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: "textformat")
                    .foregroundStyle(Color(red: 0.95, green: 0.38, blue: 0.28))
                Text("自定义称呼")
                    .font(.system(size: isCompact ? 15 : 17, weight: .heavy, design: .rounded))
                    .foregroundStyle(Color(red: 0.25, green: 0.19, blue: 0.14))
                Spacer()
                Text("当前：\(displayName)")
                    .font(.system(size: isCompact ? 12 : 13, weight: .bold, design: .rounded))
                    .foregroundStyle(Color(red: 0.55, green: 0.45, blue: 0.36))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }

            HStack(spacing: isCompact ? 8 : 10) {
                TextField("默认：\(target.name)", text: $draftName)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .font(.system(size: isCompact ? 16 : 18, weight: .bold, design: .rounded))
                    .padding(.horizontal, 12)
                    .frame(minHeight: isCompact ? 44 : 50)
                    .background(.white.opacity(0.82), in: RoundedRectangle(cornerRadius: isCompact ? 14 : 16, style: .continuous))

                Button(action: save) {
                    Text("保存")
                        .font(.system(size: isCompact ? 14 : 16, weight: .heavy, design: .rounded))
                        .padding(.horizontal, isCompact ? 12 : 16)
                        .frame(minHeight: isCompact ? 44 : 50)
                        .background(Color(red: 0.95, green: 0.38, blue: 0.28), in: RoundedRectangle(cornerRadius: isCompact ? 14 : 16, style: .continuous))
                        .foregroundStyle(.white)
                }
                .buttonStyle(.plain)

                Button(action: reset) {
                    Image(systemName: "arrow.uturn.backward")
                        .font(.system(size: isCompact ? 15 : 17, weight: .heavy))
                        .frame(width: isCompact ? 44 : 50, height: isCompact ? 44 : 50)
                        .background(.white.opacity(0.72), in: RoundedRectangle(cornerRadius: isCompact ? 14 : 16, style: .continuous))
                        .foregroundStyle(Color(red: 0.55, green: 0.45, blue: 0.36))
                }
                .buttonStyle(.plain)
                .accessibilityLabel("恢复默认称呼")
            }
        }
        .padding(isCompact ? 12 : 14)
        .background(Color(red: 1.0, green: 0.96, blue: 0.88).opacity(0.78), in: RoundedRectangle(cornerRadius: isCompact ? 18 : 20, style: .continuous))
    }
}

private struct RecordingGroupPicker: View {
    let selectedGroup: VoicePromptGroup
    @ObservedObject var voiceStore: VoicePromptStore
    let isCompact: Bool
    let isDisabled: Bool
    let select: (VoicePromptGroup) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: isCompact ? 8 : 10) {
                ForEach(VoicePromptGroup.allCases, id: \.self) { group in
                    RecordingGroupButton(
                        group: group,
                        isSelected: group == selectedGroup,
                        recordingCount: VoicePromptTarget.targets(in: group).filter { voiceStore.hasRecording(for: $0.id) }.count,
                        isCompact: isCompact
                    ) {
                        select(group)
                    }
                    .disabled(isDisabled)
                    .opacity(isDisabled && group != selectedGroup ? 0.48 : 1)
                }
            }
            .padding(.vertical, 2)
        }
    }
}

private struct RecordingGroupButton: View {
    let group: VoicePromptGroup
    let isSelected: Bool
    let recordingCount: Int
    let isCompact: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: iconName)
                    .font(.system(size: isCompact ? 14 : 16, weight: .heavy))

                Text(group.title)
                    .font(.system(size: isCompact ? 14 : 16, weight: .heavy, design: .rounded))

                if recordingCount > 0 {
                    Text("\(recordingCount)")
                        .font(.system(size: isCompact ? 11 : 12, weight: .heavy, design: .rounded))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(.white.opacity(isSelected ? 0.46 : 0.74), in: Capsule())
                }
            }
            .foregroundStyle(isSelected ? .white : Color(red: 0.43, green: 0.34, blue: 0.26))
            .padding(.horizontal, isCompact ? 12 : 14)
            .padding(.vertical, isCompact ? 8 : 10)
            .background(backgroundColor, in: Capsule())
            .overlay(
                Capsule()
                    .stroke(Color.white.opacity(isSelected ? 0.58 : 0.36), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }

    private var backgroundColor: Color {
        isSelected ? Color(red: 0.95, green: 0.38, blue: 0.28) : .white.opacity(0.76)
    }

    private var iconName: String {
        switch group {
        case .color:
            return "paintpalette.fill"
        case .animal:
            return "pawprint.fill"
        case .vehicle:
            return "car.fill"
        case .fruit:
            return "apple.logo"
        case .shape:
            return "square.on.circle.fill"
        case .object:
            return "house.fill"
        }
    }
}

private struct SelectedRecordingCard: View {
    let target: VoicePromptTarget
    let displayName: String
    let defaultName: String
    let isRecording: Bool
    let hasRecording: Bool
    let isCompact: Bool

    var body: some View {
        HStack(spacing: isCompact ? 12 : 16) {
            RecordingTargetArtwork(target: target, isCompact: isCompact, isLarge: true)
                .frame(width: isCompact ? 64 : 78, height: isCompact ? 64 : 78)
                .padding(8)
                .background(Color.white.opacity(0.72), in: RoundedRectangle(cornerRadius: isCompact ? 20 : 24, style: .continuous))

            VStack(alignment: .leading, spacing: 6) {
                Text(displayName)
                    .font(.system(size: isCompact ? 24 : 29, weight: .heavy, design: .rounded))
                    .foregroundStyle(Color(red: 0.25, green: 0.19, blue: 0.14))

                Label(statusText, systemImage: statusIcon)
                    .font(.system(size: isCompact ? 14 : 17, weight: .heavy, design: .rounded))
                    .foregroundStyle(statusColor)

                if displayName != defaultName {
                    Text("默认：\(defaultName)")
                        .font(.system(size: isCompact ? 12 : 14, weight: .bold, design: .rounded))
                        .foregroundStyle(Color(red: 0.55, green: 0.45, blue: 0.36))
                }
            }

            Spacer()
        }
        .padding(isCompact ? 12 : 14)
        .background(Color(red: 1.0, green: 0.93, blue: 0.80).opacity(0.82), in: RoundedRectangle(cornerRadius: isCompact ? 22 : 26, style: .continuous))
    }

    private var statusText: String {
        if isRecording { return "正在录这个目标" }
        return hasRecording ? "已有专属录音" : "还没有录音"
    }

    private var statusIcon: String {
        if isRecording { return "record.circle.fill" }
        return hasRecording ? "checkmark.seal.fill" : "mic.badge.plus"
    }

    private var statusColor: Color {
        if isRecording { return Color(red: 0.95, green: 0.26, blue: 0.24) }
        return hasRecording ? Color(red: 0.18, green: 0.58, blue: 0.34) : Color(red: 0.55, green: 0.45, blue: 0.36)
    }
}

private struct RecordingTargetSection: View {
    let group: VoicePromptGroup
    let selectedTargetID: String
    @ObservedObject var voiceStore: VoicePromptStore
    let displayName: (VoicePromptTarget) -> String
    let isCompact: Bool
    let isSelectionLocked: Bool
    let select: (VoicePromptTarget) -> Void

    private var targets: [VoicePromptTarget] {
        VoicePromptTarget.all.filter { $0.group == group }
    }

    private var columns: [GridItem] {
        let count = isCompact ? 3 : 5
        return Array(repeating: GridItem(.flexible(), spacing: isCompact ? 8 : 10), count: count)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(group.title)
                .font(.system(size: isCompact ? 16 : 18, weight: .heavy, design: .rounded))
                .foregroundStyle(Color(red: 0.43, green: 0.34, blue: 0.26))

            LazyVGrid(columns: columns, spacing: isCompact ? 8 : 10) {
                ForEach(targets) { target in
                    RecordingTargetButton(
                        target: target,
                        displayName: displayName(target),
                        isSelected: target.id == selectedTargetID,
                        hasRecording: voiceStore.hasRecording(for: target.id),
                        isLocked: isSelectionLocked && target.id != selectedTargetID,
                        isCompact: isCompact
                    ) {
                        select(target)
                    }
                }
            }
        }
    }
}

private struct RecordingTargetButton: View {
    let target: VoicePromptTarget
    let displayName: String
    let isSelected: Bool
    let hasRecording: Bool
    let isLocked: Bool
    let isCompact: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                ZStack(alignment: .topTrailing) {
                    RecordingTargetArtwork(target: target, isCompact: isCompact, isLarge: false)
                        .frame(width: isCompact ? 44 : 54, height: isCompact ? 44 : 54)
                        .padding(6)

                    if hasRecording {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: isCompact ? 15 : 17, weight: .heavy))
                            .foregroundStyle(Color(red: 0.18, green: 0.58, blue: 0.34))
                            .background(.white, in: Circle())
                    }
                }

                Text(displayName)
                    .font(.system(size: isCompact ? 13 : 15, weight: .heavy, design: .rounded))
                    .foregroundStyle(Color(red: 0.25, green: 0.19, blue: 0.14))
                    .lineLimit(1)
                    .minimumScaleFactor(0.72)
            }
            .frame(maxWidth: .infinity, minHeight: isCompact ? 86 : 98)
            .background(backgroundColor, in: RoundedRectangle(cornerRadius: isCompact ? 16 : 18, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: isCompact ? 16 : 18, style: .continuous)
                    .stroke(isSelected ? Color(red: 0.95, green: 0.26, blue: 0.24) : Color(red: 1.0, green: 0.84, blue: 0.60).opacity(0.36), lineWidth: isSelected ? 3 : 1)
            )
            .opacity(isLocked ? 0.46 : 1)
        }
        .buttonStyle(.plain)
        .disabled(isLocked)
    }

    private var backgroundColor: Color {
        isSelected ? Color(red: 1.0, green: 0.86, blue: 0.76).opacity(0.9) : .white.opacity(0.76)
    }
}

private struct RecordingTargetArtwork: View {
    let target: VoicePromptTarget
    let isCompact: Bool
    let isLarge: Bool

    var body: some View {
        Group {
            if let color = target.color {
                RoundedRectangle(cornerRadius: isLarge ? 20 : 15, style: .continuous)
                    .fill(color)
                    .overlay(
                        RoundedRectangle(cornerRadius: isLarge ? 20 : 15, style: .continuous)
                            .stroke(.white.opacity(0.88), lineWidth: isLarge ? 5 : 3)
                    )
                    .shadow(color: color.opacity(0.24), radius: 8, y: 5)
            } else if let kind = target.kind, let imageAssetName = kind.imageAssetName {
                Image(imageAssetName)
                    .resizable()
                    .scaledToFit()
                    .padding(imageInset(for: kind))
                    .clipped()
            } else if let kind = target.kind {
                Group {
                    if kind.category == .shape {
                        RecordingShapeArtwork(kind: kind, color: fallbackColor(for: kind))
                            .padding(isLarge ? 8 : 7)
                    } else {
                        FriendShape(kind: kind, color: fallbackColor(for: kind), isShadow: false)
                            .padding(isLarge ? 10 : 8)
                    }
                }
                .clipped()
            }
        }
    }

    private func imageInset(for kind: FriendKind) -> CGFloat {
        switch kind {
        case .oval, .rectangle, .diamond, .moon, .flower, .book, .umbrella, .cloud, .ball:
            return isLarge ? 8 : 7
        default:
            return isLarge ? 5 : 4
        }
    }

    private func fallbackColor(for kind: FriendKind) -> Color {
        switch kind.category {
        case .animal:
            return Color(red: 1.0, green: 0.60, blue: 0.34)
        case .vehicle:
            return Color(red: 0.22, green: 0.65, blue: 0.94)
        case .fruit:
            return Color(red: 1.0, green: 0.43, blue: 0.34)
        case .shape:
            return Color(red: 1.0, green: 0.74, blue: 0.18)
        case .object:
            return Color(red: 0.58, green: 0.72, blue: 0.36)
        }
    }
}

private struct RecordingShapeArtwork: View {
    let kind: FriendKind
    let color: Color

    var body: some View {
        GeometryReader { proxy in
            let side = min(proxy.size.width, proxy.size.height)

            shapeContent(side: side)
                .foregroundStyle(color)
                .frame(width: proxy.size.width, height: proxy.size.height)
                .shadow(color: color.opacity(0.16), radius: max(3, side * 0.08), y: max(2, side * 0.04))
        }
        .aspectRatio(1, contentMode: .fit)
    }

    @ViewBuilder
    private func shapeContent(side: CGFloat) -> some View {
        switch kind {
        case .circle:
            Circle()
                .frame(width: side * 0.78, height: side * 0.78)
        case .square:
            RoundedRectangle(cornerRadius: side * 0.16, style: .continuous)
                .frame(width: side * 0.78, height: side * 0.78)
        case .triangle:
            RecordingTriangle()
                .frame(width: side * 0.82, height: side * 0.76)
        case .star:
            Image(systemName: "star.fill")
                .font(.system(size: side * 0.66, weight: .heavy))
                .frame(width: side, height: side)
        case .heart:
            Image(systemName: "heart.fill")
                .font(.system(size: side * 0.74, weight: .heavy))
        case .rectangle:
            RoundedRectangle(cornerRadius: side * 0.13, style: .continuous)
                .frame(width: side * 0.86, height: side * 0.54)
        case .oval:
            Ellipse()
                .frame(width: side * 0.88, height: side * 0.58)
        case .diamond:
            Rectangle()
                .rotationEffect(.degrees(45))
                .frame(width: side * 0.58, height: side * 0.58)
        default:
            Circle()
                .frame(width: side * 0.78, height: side * 0.78)
        }
    }
}

private struct RecordingTriangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

private struct VoiceActionButton: View {
    let title: String
    let systemName: String
    let isPrimary: Bool
    let isCompact: Bool
    var isDisabled = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Label(title, systemImage: systemName)
                .font(.system(size: isCompact ? 15 : 18, weight: .heavy, design: .rounded))
                .lineLimit(1)
                .minimumScaleFactor(0.82)
                .frame(maxWidth: .infinity, minHeight: isCompact ? 42 : 48)
                .background(backgroundColor, in: RoundedRectangle(cornerRadius: isCompact ? 15 : 17, style: .continuous))
                .foregroundStyle(foregroundColor)
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.46 : 1)
    }

    private var backgroundColor: Color {
        isPrimary ? Color(red: 0.95, green: 0.26, blue: 0.24) : Color(red: 1.0, green: 0.88, blue: 0.76)
    }

    private var foregroundColor: Color {
        isPrimary ? .white : Color(red: 0.38, green: 0.24, blue: 0.15)
    }
}

private struct AdaptiveScreenHeader: View {
    let title: String
    let actionTitle: String
    let isCompact: Bool
    let action: () -> Void

    var body: some View {
        if isCompact {
            HStack(spacing: 12) {
                Button(action: action) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .heavy))
                        .foregroundStyle(Color(red: 0.20, green: 0.16, blue: 0.12))
                        .frame(width: 44, height: 44)
                        .background(.white.opacity(0.88), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
                .buttonStyle(.plain)

                Text(title)
                    .font(.system(size: 25, weight: .heavy, design: .rounded))
                    .foregroundStyle(Color(red: 0.25, green: 0.19, blue: 0.14))

                Spacer()
            }
        } else {
            HStack {
                Text(title)
                    .font(.system(size: 34, weight: .heavy, design: .rounded))
                    .foregroundStyle(Color(red: 0.25, green: 0.19, blue: 0.14))
                Spacer()
                Button(action: action) {
                    Label(actionTitle, systemImage: "chevron.left")
                        .font(.system(size: 20, weight: .heavy, design: .rounded))
                        .foregroundStyle(Color(red: 0.20, green: 0.16, blue: 0.12))
                        .frame(minWidth: 116, minHeight: 52)
                        .background(.white.opacity(0.88), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                }
                .buttonStyle(.plain)
            }
        }
    }
}

private struct SettingsTile: View {
    let title: String
    let systemName: String
    @Binding var isOn: Bool

    var body: some View {
        Button {
            isOn.toggle()
        } label: {
            VStack(spacing: 10) {
                Image(systemName: systemName)
                    .font(.system(size: 24, weight: .heavy))
                    .foregroundStyle(isOn ? Color(red: 0.95, green: 0.26, blue: 0.24) : Color(red: 0.55, green: 0.50, blue: 0.46))
                    .frame(width: 44, height: 44)
                    .background((isOn ? Color(red: 1.0, green: 0.86, blue: 0.76) : Color.white).opacity(0.72), in: Circle())

                Text(title)
                    .font(.system(size: 17, weight: .heavy, design: .rounded))
                    .foregroundStyle(Color(red: 0.20, green: 0.16, blue: 0.12))

                Text(isOn ? "开" : "关")
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundStyle(isOn ? Color(red: 0.95, green: 0.26, blue: 0.24) : Color(red: 0.55, green: 0.50, blue: 0.46))
            }
            .frame(maxWidth: .infinity, minHeight: 112)
            .background(.white.opacity(0.88), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            .shadow(color: .black.opacity(0.06), radius: 12, y: 6)
        }
        .buttonStyle(.plain)
    }
}

private struct SettingsToggle: View {
    let title: String
    let systemName: String
    @Binding var isOn: Bool
    let isCompact: Bool

    var body: some View {
        Toggle(isOn: $isOn) {
            Label(title, systemImage: systemName)
                .font(.system(size: isCompact ? 19 : 22, weight: .bold, design: .rounded))
                .foregroundStyle(Color(red: 0.20, green: 0.16, blue: 0.12))
        }
        .toggleStyle(.switch)
        .tint(Color(red: 0.95, green: 0.26, blue: 0.24))
        .padding(.vertical, isCompact ? 6 : 8)
    }
}

private struct InfoRow: View {
    let icon: String
    let title: String
    let value: String
    let isCompact: Bool

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: isCompact ? 18 : 20, weight: .bold))
                .frame(width: isCompact ? 32 : 36, height: isCompact ? 32 : 36)
                .foregroundStyle(Color(red: 0.95, green: 0.26, blue: 0.24))
            Text(title)
                .font(.system(size: isCompact ? 16 : 18, weight: .heavy, design: .rounded))
                .foregroundStyle(Color(red: 0.20, green: 0.16, blue: 0.12))
                .frame(width: isCompact ? 58 : 72, alignment: .leading)
            Text(value)
                .font(.system(size: isCompact ? 15 : 18, weight: .semibold, design: .rounded))
                .foregroundStyle(Color(red: 0.45, green: 0.38, blue: 0.32))
                .fixedSize(horizontal: false, vertical: true)
            Spacer()
        }
    }
}

private struct ParentInfoTile: View {
    let icon: String
    let title: String
    let value: String

    var body: some View {
        VStack(spacing: 7) {
            Image(systemName: icon)
                .font(.system(size: 19, weight: .heavy))
                .foregroundStyle(Color(red: 0.95, green: 0.26, blue: 0.24))
                .frame(width: 38, height: 38)
                .background(Color(red: 1.0, green: 0.88, blue: 0.78).opacity(0.72), in: Circle())

            Text(title)
                .font(.system(size: 14, weight: .heavy, design: .rounded))
                .foregroundStyle(Color(red: 0.20, green: 0.16, blue: 0.12))

            Text(value)
                .font(.system(size: 13, weight: .bold, design: .rounded))
                .foregroundStyle(Color(red: 0.45, green: 0.38, blue: 0.32))
                .lineLimit(1)
                .minimumScaleFactor(0.75)
        }
        .frame(maxWidth: .infinity, minHeight: 100)
        .background(.white.opacity(0.74), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}
