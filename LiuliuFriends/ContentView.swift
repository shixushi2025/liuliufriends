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

            if !viewModel.hasStartedPlaying, viewModel.screen == .play {
                StartPlayOverlay {
                    viewModel.startPlaying()
                }
                .transition(.opacity.combined(with: .scale(scale: 0.96)))
                .zIndex(3)
            }
        }
        .animation(viewModel.settings.reducedMotion ? nil : .spring(response: 0.42, dampingFraction: 0.86), value: viewModel.screen)
        .animation(viewModel.settings.reducedMotion ? nil : .spring(response: 0.38, dampingFraction: 0.86), value: viewModel.breakReminder)
        .animation(viewModel.settings.reducedMotion ? nil : .spring(response: 0.42, dampingFraction: 0.86), value: viewModel.hasStartedPlaying)
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
            guard scenePhase == .active else { return }
            viewModel.recordActiveUsageTick()
        }
    }
}

private struct StartPlayOverlay: View {
    let onStart: () -> Void

    var body: some View {
        GeometryReader { geometry in
            let isCompact = geometry.size.width < 520

            ZStack {
                Color.white.opacity(0.44)
                    .ignoresSafeArea()

                VStack(spacing: isCompact ? 18 : 22) {
                    HStack(spacing: 14) {
                        FriendShape(kind: .cat, color: Color(red: 0.94, green: 0.63, blue: 0.30), isShadow: false)
                            .frame(width: isCompact ? 70 : 88, height: isCompact ? 70 : 88)
                            .accessibilityHidden(true)

                        VStack(alignment: .leading, spacing: 6) {
                            Text("准备好了吗？")
                                .font(.system(size: isCompact ? 28 : 36, weight: .heavy, design: .rounded))
                                .foregroundStyle(Color(red: 0.34, green: 0.25, blue: 0.18))
                                .lineLimit(1)
                                .minimumScaleFactor(0.82)

                            Text("点一下，我们一起找朋友")
                                .font(.system(size: isCompact ? 16 : 20, weight: .bold, design: .rounded))
                                .foregroundStyle(Color(red: 0.67, green: 0.49, blue: 0.32))
                                .lineLimit(2)
                                .minimumScaleFactor(0.86)
                        }
                    }

                    Button(action: onStart) {
                        HStack(spacing: 10) {
                            Image(systemName: "play.fill")
                                .font(.system(size: isCompact ? 18 : 22, weight: .heavy))
                            Text("开始玩")
                                .font(.system(size: isCompact ? 22 : 26, weight: .heavy, design: .rounded))
                        }
                        .foregroundStyle(.white)
                        .padding(.horizontal, isCompact ? 34 : 46)
                        .padding(.vertical, isCompact ? 16 : 18)
                        .background(
                            LinearGradient(
                                colors: [
                                    Color(red: 1.0, green: 0.48, blue: 0.34),
                                    Color(red: 1.0, green: 0.67, blue: 0.26)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            in: Capsule()
                        )
                        .shadow(color: Color(red: 0.98, green: 0.38, blue: 0.25).opacity(0.24), radius: 16, y: 8)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("开始玩")
                }
                .padding(.horizontal, isCompact ? 24 : 34)
                .padding(.vertical, isCompact ? 28 : 38)
                .frame(maxWidth: isCompact ? 340 : 460)
                .background(
                    RoundedRectangle(cornerRadius: isCompact ? 34 : 42, style: .continuous)
                        .fill(.white.opacity(0.94))
                        .shadow(color: Color(red: 0.55, green: 0.34, blue: 0.18).opacity(0.16), radius: 28, y: 16)
                )
                .padding(.horizontal, 22)
            }
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

            if viewModel.completedCandidateID != nil && metrics.showsCelebrationMascot {
                LiuliuPendant(mood: .happy)
                    .frame(width: metrics.celebrationMascotSize, height: metrics.celebrationMascotSize * 1.22)
                    .shadow(color: Color(red: 1.0, green: 0.82, blue: 0.35).opacity(0.55), radius: 26)
                    .scaleEffect(viewModel.settings.reducedMotion ? 1 : 1.08)
                    .offset(x: metrics.celebrationOffsetX, y: metrics.celebrationOffsetY)
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
                    ColorLearningObjectView(kind: round.targetKind, color: round.targetColor)
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
            case .count:
                VStack(spacing: metrics.targetContentSpacing) {
                    CountClusterView(kind: round.targetKind, color: round.targetColor, count: round.targetCount)
                        .frame(width: metrics.targetIconSize * 1.1, height: metrics.targetIconSize * 0.96)
                    TargetCaption(title: "找\(round.targetCount.cnNumberName)个", mode: round.mode)
                }
                .padding(.vertical, metrics.targetVerticalInset)
            case .quantityCompare:
                VStack(spacing: metrics.targetContentSpacing) {
                    QuantityCompareTargetView(target: round.targetQuantityCompare ?? .more, accentColor: round.mode.accentColor)
                        .frame(width: metrics.targetIconSize * 1.12, height: metrics.targetIconSize * 0.92)
                    TargetCaption(title: "找\(round.targetQuantityCompare?.speechTitle ?? "多的")", mode: round.mode)
                }
                .padding(.vertical, metrics.targetVerticalInset)
            case .category:
                VStack(spacing: metrics.targetContentSpacing) {
                    CategoryTargetView(category: round.targetCategory ?? round.targetKind.category, sampleKind: round.targetKind, color: round.mode.accentColor)
                        .frame(width: metrics.targetIconSize * 1.18, height: metrics.targetIconSize * 0.95)
                    TargetCaption(title: "找\(round.targetCategory?.childPromptTitle ?? round.targetKind.category.childPromptTitle)", mode: round.mode)
                }
                .padding(.vertical, metrics.targetVerticalInset)
            case .difference:
                VStack(spacing: metrics.targetContentSpacing) {
                    DifferenceTargetView(category: round.targetCategory ?? .animal, accentColor: round.mode.accentColor)
                        .frame(width: metrics.targetIconSize * 1.18, height: metrics.targetIconSize * 0.95)
                    TargetCaption(title: "找不一样的", mode: round.mode)
                }
                .padding(.vertical, metrics.targetVerticalInset)
            case .position:
                VStack(spacing: metrics.targetContentSpacing) {
                    PositionTargetView(position: round.targetPosition, kind: round.targetKind, color: round.targetColor, accentColor: round.mode.accentColor)
                        .frame(width: metrics.targetIconSize * 1.18, height: metrics.targetIconSize * 0.98)
                    TargetCaption(title: "找\(round.targetPosition.name)", mode: round.mode)
                }
                .padding(.vertical, metrics.targetVerticalInset)
            case .purpose:
                VStack(spacing: metrics.targetContentSpacing) {
                    PurposeTargetView(purpose: round.targetPurpose ?? .drink, accentColor: round.mode.accentColor)
                        .frame(width: metrics.targetIconSize * 1.12, height: metrics.targetIconSize * 0.92)
                    TargetCaption(title: "找\(round.targetPurpose?.speechTitle ?? "有用的朋友")", mode: round.mode)
                }
                .padding(.vertical, metrics.targetVerticalInset)
            case .scene:
                VStack(spacing: metrics.targetContentSpacing) {
                    SceneTargetView(scene: round.targetScene ?? .home, accentColor: round.mode.accentColor)
                        .frame(width: metrics.targetIconSize * 1.12, height: metrics.targetIconSize * 0.92)
                    TargetCaption(title: "找\(round.targetScene?.speechTitle ?? "场景朋友")", mode: round.mode)
                }
                .padding(.vertical, metrics.targetVerticalInset)
            case .weather:
                VStack(spacing: metrics.targetContentSpacing) {
                    WeatherTargetView(weather: round.targetWeather ?? .sunny, accentColor: round.mode.accentColor)
                        .frame(width: metrics.targetIconSize * 1.12, height: metrics.targetIconSize * 0.92)
                    TargetCaption(title: "找\(round.targetWeather?.speechTitle ?? "天气朋友")", mode: round.mode)
                }
                .padding(.vertical, metrics.targetVerticalInset)
            case .routine:
                VStack(spacing: metrics.targetContentSpacing) {
                    RoutineTargetView(routine: round.targetRoutine ?? .morning, accentColor: round.mode.accentColor)
                        .frame(width: metrics.targetIconSize * 1.12, height: metrics.targetIconSize * 0.92)
                    TargetCaption(title: "找\(round.targetRoutine?.speechTitle ?? "作息朋友")", mode: round.mode)
                }
                .padding(.vertical, metrics.targetVerticalInset)
            case .emotion:
                VStack(spacing: metrics.targetContentSpacing) {
                    EmotionTargetView(emotion: round.targetEmotion ?? .happy, accentColor: round.mode.accentColor)
                        .frame(width: metrics.targetIconSize * 1.12, height: metrics.targetIconSize * 0.92)
                    TargetCaption(title: "找\(round.targetEmotion?.speechTitle ?? "情绪朋友")", mode: round.mode)
                }
                .padding(.vertical, metrics.targetVerticalInset)
            case .action:
                VStack(spacing: metrics.targetContentSpacing) {
                    ActionTargetView(action: round.targetAction ?? .fly, accentColor: round.mode.accentColor)
                        .frame(width: metrics.targetIconSize * 1.12, height: metrics.targetIconSize * 0.92)
                    TargetCaption(title: "找\(round.targetAction?.speechTitle ?? "动作朋友")", mode: round.mode)
                }
                .padding(.vertical, metrics.targetVerticalInset)
            case .texture:
                VStack(spacing: metrics.targetContentSpacing) {
                    TextureTargetView(texture: round.targetTexture ?? .soft, accentColor: round.mode.accentColor)
                        .frame(width: metrics.targetIconSize * 1.12, height: metrics.targetIconSize * 0.92)
                    TargetCaption(title: "找\(round.targetTexture?.speechTitle ?? "触感朋友")", mode: round.mode)
                }
                .padding(.vertical, metrics.targetVerticalInset)
            case .pairing:
                VStack(spacing: metrics.targetContentSpacing) {
                    PairingTargetView(pairing: round.targetPairing ?? .beeFlower, cueColor: targetCueColor(for: round.targetPairing?.cueKind ?? .bee), accentColor: round.mode.accentColor)
                        .frame(width: metrics.targetIconSize * 1.22, height: metrics.targetIconSize * 0.92)
                    TargetCaption(title: "找\(round.targetPairing?.speechTitle ?? "好搭档")", mode: round.mode)
                }
                .padding(.vertical, metrics.targetVerticalInset)
            case .opposite:
                VStack(spacing: metrics.targetContentSpacing) {
                    OppositeTargetView(opposite: round.targetOpposite ?? .dayNight, accentColor: round.mode.accentColor)
                        .frame(width: metrics.targetIconSize * 1.18, height: metrics.targetIconSize * 0.92)
                    TargetCaption(title: "找\(round.targetOpposite?.speechTitle ?? "相反的朋友")", mode: round.mode)
                }
                .padding(.vertical, metrics.targetVerticalInset)
            case .rhythm:
                VStack(spacing: metrics.targetContentSpacing) {
                    RhythmTargetView(rhythm: round.targetRhythm ?? .clap, accentColor: round.mode.accentColor)
                        .frame(width: metrics.targetIconSize * 1.12, height: metrics.targetIconSize * 0.92)
                    TargetCaption(title: "找\(round.targetRhythm?.speechTitle ?? "节奏朋友")", mode: round.mode)
                }
                .padding(.vertical, metrics.targetVerticalInset)
            case .sequence:
                VStack(spacing: metrics.targetContentSpacing) {
                    SequenceTargetView(sequence: round.targetSequence ?? .first, accentColor: round.mode.accentColor)
                        .frame(width: metrics.targetIconSize * 1.12, height: metrics.targetIconSize * 0.92)
                    TargetCaption(title: "找\(round.targetSequence?.speechTitle ?? "顺序朋友")", mode: round.mode)
                }
                .padding(.vertical, metrics.targetVerticalInset)
            case .pattern:
                VStack(spacing: metrics.targetContentSpacing) {
                    PatternTargetView(pattern: round.targetPattern ?? .catDog, accentColor: round.mode.accentColor)
                        .frame(width: metrics.targetIconSize * 1.30, height: metrics.targetIconSize * 0.92)
                    TargetCaption(title: "找\(round.targetPattern?.speechTitle ?? "下一个")", mode: round.mode)
                }
                .padding(.vertical, metrics.targetVerticalInset)
            }

        }
        .contentShape(RoundedRectangle(cornerRadius: metrics.cardCornerRadius, style: .continuous))
        .onTapGesture {
            viewModel.replayPrompt()
        }
        .accessibilityAddTraits(.isButton)
        .accessibilityHint("重新播放本轮提示")
    }

    private func targetCueColor(for kind: FriendKind) -> Color {
        switch kind {
        case .bee:
            return Color(red: 1.0, green: 0.75, blue: 0.18)
        case .butterfly:
            return Color(red: 0.61, green: 0.45, blue: 0.91)
        case .monkey, .cup:
            return Color(red: 0.70, green: 0.48, blue: 0.30)
        case .umbrella:
            return Color(red: 0.61, green: 0.45, blue: 0.91)
        case .fish:
            return Color(red: 0.22, green: 0.65, blue: 0.94)
        default:
            return round.mode.accentColor
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
                .lineLimit(1)
                .minimumScaleFactor(0.68)
                .multilineTextAlignment(.center)
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

                GameObjectView(round: round, candidate: candidate, isTarget: false)
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
        .accessibilityLabel(accessibilityLabel)
    }

    private var displayScale: CGFloat {
        round.mode == .size ? candidate.sizeScale : 1
    }

    private var objectPadding: CGFloat {
        switch round.mode {
        case .shape:
            max(30, size * 0.22)
        case .count:
            max(10, size * 0.10)
        case .position:
            max(8, size * 0.08)
        case .size:
            max(14, size * 0.13)
        default:
            max(14, size * 0.13)
        }
    }

    private var accessibilityLabel: String {
        if round.mode == .emotion, let emotion = candidate.emotion {
            return emotion.promptTitle
        }
        if round.mode == .rhythm, let rhythm = candidate.rhythm {
            return rhythm.promptTitle
        }
        if round.mode == .sequence, let sequence = candidate.sequence {
            return sequence.promptTitle
        }
        return candidate.kind.name
    }
}

private struct GameObjectView: View {
    let round: GameRound
    let candidate: FriendCandidate
    let isTarget: Bool

    var body: some View {
        switch round.mode {
        case .color:
            ColorLearningObjectView(kind: candidate.kind, color: candidate.color)
        case .count, .quantityCompare:
            CountClusterView(kind: candidate.kind, color: candidate.color, count: candidate.count)
        case .category:
            FriendShape(kind: candidate.kind, color: candidate.color, isShadow: false)
        case .position:
            PositionStageView(kind: candidate.kind, color: candidate.color, position: candidate.position)
        case .shape, .size, .purpose, .scene, .weather, .routine, .action, .texture, .pairing, .pattern, .difference:
            FriendShape(kind: candidate.kind, color: candidate.color, isShadow: false)
        case .emotion:
            EmotionChoiceView(emotion: candidate.emotion ?? .happy, accentColor: round.mode.accentColor)
        case .opposite:
            OppositeChoiceView(opposite: candidate.opposite ?? .dayNight, accentColor: round.mode.accentColor)
        case .rhythm:
            RhythmChoiceView(rhythm: candidate.rhythm ?? .clap, accentColor: round.mode.accentColor)
        case .sequence:
            SequenceChoiceView(sequence: candidate.sequence ?? .first, accentColor: round.mode.accentColor)
        case .shadow:
            FriendShape(kind: candidate.kind, color: candidate.color, isShadow: isTarget)
        case .animal, .sound:
            FriendShape(kind: candidate.kind, color: candidate.color, isShadow: false)
        }
    }
}

private struct CountClusterView: View {
    let kind: FriendKind
    let color: Color
    let count: Int

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<max(count, 1), id: \.self) { itemIndex in
                    FriendShape(kind: kind, color: color, isShadow: false)
                        .padding(itemPadding(in: geometry.size))
                        .frame(width: itemSize(in: geometry.size), height: itemSize(in: geometry.size))
                        .background(.white.opacity(0.58), in: Circle())
                        .shadow(color: Color(red: 0.72, green: 0.50, blue: 0.24).opacity(0.08), radius: 8, y: 5)
                        .position(position(for: itemIndex, in: geometry.size))
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }

    private func itemSize(in size: CGSize) -> CGFloat {
        let shortSide = min(size.width, size.height)
        switch count {
        case 1:
            return shortSide * 0.72
        case 2:
            return shortSide * 0.58
        default:
            return shortSide * 0.46
        }
    }

    private func itemPadding(in size: CGSize) -> CGFloat {
        max(3, itemSize(in: size) * 0.08)
    }

    private func position(for itemIndex: Int, in size: CGSize) -> CGPoint {
        let positions: [CGPoint]
        switch count {
        case 1:
            positions = [CGPoint(x: 0.5, y: 0.5)]
        case 2:
            positions = [
                CGPoint(x: 0.34, y: 0.52),
                CGPoint(x: 0.66, y: 0.48)
            ]
        case 3:
            positions = [
                CGPoint(x: 0.5, y: 0.32),
                CGPoint(x: 0.34, y: 0.68),
                CGPoint(x: 0.66, y: 0.68)
            ]
        default:
            positions = [
                CGPoint(x: 0.35, y: 0.34),
                CGPoint(x: 0.65, y: 0.34),
                CGPoint(x: 0.35, y: 0.68),
                CGPoint(x: 0.65, y: 0.68)
            ]
        }
        let unitPoint = positions[min(itemIndex, positions.count - 1)]
        return CGPoint(x: unitPoint.x * size.width, y: unitPoint.y * size.height)
    }
}

private struct QuantityCompareTargetView: View {
    let target: FriendQuantityCompare
    let accentColor: Color

    var body: some View {
        ConceptTargetCard(
            title: target.promptTitle,
            subtitle: "比一比",
            systemName: target.iconName,
            accentColor: accentColor,
            motif: .quantity
        )
    }
}

private struct CategoryTargetView: View {
    let category: FriendCategory
    let sampleKind: FriendKind
    let color: Color

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [.white.opacity(0.72), color.opacity(0.18)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .stroke(color.opacity(0.24), lineWidth: 2)
                )

            VStack(spacing: 10) {
                HStack(spacing: 8) {
                    ForEach(sampleKinds.prefix(3), id: \.self) { kind in
                        FriendShape(kind: kind, color: categoryColor(for: kind), isShadow: false)
                            .padding(6)
                            .frame(width: 42, height: 42)
                            .background(.white.opacity(0.68), in: Circle())
                    }
                }

                Text(category.childPromptTitle)
                    .font(.system(size: 22, weight: .black, design: .rounded))
                    .foregroundStyle(Color(red: 0.24, green: 0.26, blue: 0.30))
                    .lineLimit(1)
                    .minimumScaleFactor(0.72)
            }
            .padding(14)
        }
    }

    private var sampleKinds: [FriendKind] {
        switch category {
        case .animal:
            return [sampleKind, .cat, .dog, .fish].uniqued()
        case .vehicle:
            return [sampleKind, .car, .bus, .train].uniqued()
        case .fruit:
            return [sampleKind, .apple, .banana, .watermelon].uniqued()
        case .shape:
            return [sampleKind, .circle, .star, .triangle].uniqued()
        case .object:
            return [sampleKind, .balloon, .book, .umbrella].uniqued()
        }
    }

    private func categoryColor(for kind: FriendKind) -> Color {
        switch kind.category {
        case .animal:
            return Color(red: 1.0, green: 0.62, blue: 0.30)
        case .vehicle:
            return Color(red: 0.22, green: 0.65, blue: 0.94)
        case .fruit:
            return Color(red: 0.96, green: 0.32, blue: 0.34)
        case .shape:
            return Color(red: 0.61, green: 0.45, blue: 0.91)
        case .object:
            return Color(red: 0.14, green: 0.66, blue: 0.54)
        }
    }
}

private struct DifferenceTargetView: View {
    let category: FriendCategory
    let accentColor: Color

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [.white.opacity(0.76), accentColor.opacity(0.18)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .stroke(accentColor.opacity(0.24), lineWidth: 2)
                )

            VStack(spacing: 10) {
                HStack(spacing: 8) {
                    ForEach(sampleKinds.prefix(2), id: \.self) { kind in
                        FriendShape(kind: kind, color: categoryColor(for: kind), isShadow: false)
                            .padding(6)
                            .frame(width: 42, height: 42)
                            .background(.white.opacity(0.70), in: Circle())
                    }

                    Text("?")
                        .font(.system(size: 28, weight: .black, design: .rounded))
                        .foregroundStyle(accentColor)
                        .frame(width: 42, height: 42)
                        .background(accentColor.opacity(0.14), in: Circle())
                }

                Text("找不一样")
                    .font(.system(size: 22, weight: .black, design: .rounded))
                    .foregroundStyle(Color(red: 0.24, green: 0.26, blue: 0.30))
                    .lineLimit(1)
                    .minimumScaleFactor(0.72)
            }
            .padding(14)
        }
    }

    private var sampleKinds: [FriendKind] {
        switch category {
        case .animal:
            return [.cat, .dog]
        case .vehicle:
            return [.car, .bus]
        case .fruit:
            return [.apple, .banana]
        case .shape:
            return [.circle, .triangle]
        case .object:
            return [.book, .umbrella]
        }
    }

    private func categoryColor(for kind: FriendKind) -> Color {
        switch kind.category {
        case .animal:
            return Color(red: 1.0, green: 0.62, blue: 0.30)
        case .vehicle:
            return Color(red: 0.22, green: 0.65, blue: 0.94)
        case .fruit:
            return Color(red: 0.96, green: 0.32, blue: 0.34)
        case .shape:
            return Color(red: 0.61, green: 0.45, blue: 0.91)
        case .object:
            return Color(red: 0.14, green: 0.66, blue: 0.54)
        }
    }
}

private struct PositionTargetView: View {
    let position: SpatialPosition
    let kind: FriendKind
    let color: Color
    let accentColor: Color

    var body: some View {
        ZStack {
            PositionStageView(kind: kind, color: color, position: position)
                .opacity(0.28)
                .padding(4)

            VStack(spacing: 8) {
                Text(position.name)
                    .font(.system(size: 26, weight: .black, design: .rounded))
                    .foregroundStyle(Color(red: 0.24, green: 0.26, blue: 0.30))
                    .lineLimit(1)
                    .minimumScaleFactor(0.72)

                DirectionGlyph(position: position)
                    .fill(accentColor)
                    .frame(width: 42, height: 42)
                    .shadow(color: accentColor.opacity(0.22), radius: 8, y: 4)
            }
            .padding(18)
            .background(.white.opacity(0.78), in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        }
    }
}

private struct PurposeTargetView: View {
    let purpose: FriendPurpose
    let accentColor: Color

    var body: some View {
        ConceptTargetCard(
            title: purpose.promptTitle,
            subtitle: "做什么",
            systemName: purpose.iconName,
            accentColor: accentColor,
            motif: .spark
        )
    }
}

private struct SceneTargetView: View {
    let scene: FriendScene
    let accentColor: Color

    var body: some View {
        ConceptTargetCard(
            title: scene.promptTitle,
            subtitle: "在哪里",
            systemName: scene.iconName,
            accentColor: accentColor,
            motif: .bubble
        )
    }
}

private struct WeatherTargetView: View {
    let weather: FriendWeather
    let accentColor: Color

    var body: some View {
        ConceptTargetCard(
            title: weather.promptTitle,
            subtitle: "什么天气",
            systemName: weather.iconName,
            accentColor: accentColor,
            motif: .weather
        )
    }
}

private struct RoutineTargetView: View {
    let routine: FriendRoutine
    let accentColor: Color

    var body: some View {
        ConceptTargetCard(
            title: routine.promptTitle,
            subtitle: "每天做什么",
            systemName: routine.iconName,
            accentColor: accentColor,
            motif: .clock
        )
    }
}

private struct EmotionTargetView: View {
    let emotion: FriendEmotion
    let accentColor: Color

    var body: some View {
        ConceptTargetCard(
            title: emotion.promptTitle,
            subtitle: "什么表情",
            systemName: emotion.iconName,
            accentColor: accentColor,
            motif: .heart
        )
    }
}

private struct ActionTargetView: View {
    let action: FriendAction
    let accentColor: Color

    var body: some View {
        ConceptTargetCard(
            title: action.promptTitle,
            subtitle: "怎么动",
            systemName: action.iconName,
            accentColor: accentColor,
            motif: .motion
        )
    }
}

private struct TextureTargetView: View {
    let texture: FriendTexture
    let accentColor: Color

    var body: some View {
        ConceptTargetCard(
            title: texture.promptTitle,
            subtitle: "摸起来",
            systemName: texture.iconName,
            accentColor: accentColor,
            motif: .texture
        )
    }
}

private struct PairingTargetView: View {
    let pairing: FriendPairing
    let cueColor: Color
    let accentColor: Color

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [.white.opacity(0.84), accentColor.opacity(0.16)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .stroke(accentColor.opacity(0.24), lineWidth: 2)
                )

            VStack(spacing: 8) {
                Text("好搭档")
                    .font(.system(size: 13, weight: .black, design: .rounded))
                    .foregroundStyle(accentColor)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(accentColor.opacity(0.14), in: Capsule())

                HStack(spacing: 10) {
                    FriendShape(kind: pairing.cueKind, color: cueColor, isShadow: false)
                        .padding(5)
                        .frame(width: 52, height: 52)
                        .background(.white.opacity(0.74), in: Circle())

                    Image(systemName: "plus")
                        .font(.system(size: 18, weight: .black))
                        .foregroundStyle(accentColor)
                        .frame(width: 34, height: 34)
                        .background(accentColor.opacity(0.12), in: Circle())

                    Text("?")
                        .font(.system(size: 30, weight: .black, design: .rounded))
                        .foregroundStyle(.white)
                        .frame(width: 52, height: 52)
                        .background(accentColor, in: Circle())
                        .shadow(color: accentColor.opacity(0.22), radius: 10, y: 6)
                }
            }
            .padding(14)
        }
    }
}

private struct OppositeTargetView: View {
    let opposite: FriendOpposite
    let accentColor: Color

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [.white.opacity(0.84), accentColor.opacity(0.16)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .stroke(accentColor.opacity(0.24), lineWidth: 2)
                )

            HStack(spacing: 10) {
                OppositeConceptPill(
                    title: opposite.cueTitle,
                    systemName: opposite.cueIconName,
                    accentColor: accentColor,
                    isEmphasized: false
                )

                Image(systemName: "arrow.left.arrow.right")
                    .font(.system(size: 26, weight: .black))
                    .foregroundStyle(accentColor)
                    .padding(8)
                    .background(accentColor.opacity(0.12), in: Circle())

                OppositeConceptPill(
                    title: "?",
                    systemName: opposite.answerIconName,
                    accentColor: accentColor,
                    isEmphasized: true
                )
            }
            .padding(14)
        }
    }
}

private struct OppositeConceptPill: View {
    let title: String
    let systemName: String
    let accentColor: Color
    let isEmphasized: Bool

    var body: some View {
        VStack(spacing: 7) {
            Image(systemName: systemName)
                .font(.system(size: isEmphasized ? 34 : 30, weight: .heavy))
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(isEmphasized ? .white : accentColor)
                .frame(width: 48, height: 40)

            Text(title)
                .font(.system(size: 18, weight: .black, design: .rounded))
                .foregroundStyle(isEmphasized ? .white : Color(red: 0.24, green: 0.26, blue: 0.30))
                .lineLimit(1)
                .minimumScaleFactor(0.70)
        }
        .frame(width: 72, height: 88)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(isEmphasized ? accentColor : .white.opacity(0.76))
        )
        .shadow(color: accentColor.opacity(isEmphasized ? 0.22 : 0.10), radius: 10, y: 6)
    }
}

private struct RhythmTargetView: View {
    let rhythm: FriendRhythm
    let accentColor: Color

    var body: some View {
        ConceptTargetCard(
            title: rhythm.promptTitle,
            subtitle: "跟节奏",
            systemName: rhythm.iconName,
            accentColor: accentColor,
            motif: .rhythm
        )
    }
}

private struct SequenceTargetView: View {
    let sequence: FriendSequence
    let accentColor: Color

    var body: some View {
        ConceptTargetCard(
            title: sequence.promptTitle,
            subtitle: "前后顺序",
            systemName: sequence.iconName,
            accentColor: accentColor,
            motif: .sequence
        )
    }
}

private struct PatternTargetView: View {
    let pattern: FriendPattern
    let accentColor: Color

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [.white.opacity(0.84), accentColor.opacity(0.16)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .stroke(accentColor.opacity(0.24), lineWidth: 2)
                )

            VStack(spacing: 10) {
                Text("下一个")
                    .font(.system(size: 13, weight: .black, design: .rounded))
                    .foregroundStyle(accentColor)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(accentColor.opacity(0.14), in: Capsule())

                HStack(spacing: 8) {
                    ForEach(Array(pattern.sequencePrefix.enumerated()), id: \.offset) { _, kind in
                        FriendShape(kind: kind, color: patternColor(for: kind), isShadow: false)
                            .padding(5)
                            .frame(width: 42, height: 42)
                            .background(.white.opacity(0.70), in: Circle())
                    }

                    Text("?")
                        .font(.system(size: 28, weight: .black, design: .rounded))
                        .foregroundStyle(accentColor)
                        .frame(width: 42, height: 42)
                        .background(accentColor.opacity(0.14), in: Circle())
                }
            }
            .padding(14)
        }
    }

    private func patternColor(for kind: FriendKind) -> Color {
        switch kind.category {
        case .animal:
            return Color(red: 1.0, green: 0.62, blue: 0.30)
        case .vehicle:
            return Color(red: 0.22, green: 0.65, blue: 0.94)
        case .fruit:
            return Color(red: 0.96, green: 0.32, blue: 0.34)
        case .shape:
            return accentColor
        case .object:
            return Color(red: 0.14, green: 0.66, blue: 0.54)
        }
    }
}

private struct EmotionChoiceView: View {
    let emotion: FriendEmotion
    let accentColor: Color

    var body: some View {
        VStack(spacing: 8) {
            LiuliuMascot(mood: mood)
                .frame(width: 118, height: 132)
                .scaleEffect(0.72)
                .background(
                    Circle()
                        .fill(accentColor.opacity(0.10))
                        .frame(width: 112, height: 112)
                )

            Text(emotion.promptTitle)
                .font(.system(size: 22, weight: .heavy, design: .rounded))
                .foregroundStyle(Color(red: 0.48, green: 0.28, blue: 0.16))
                .padding(.horizontal, 14)
                .padding(.vertical, 6)
                .background(.white.opacity(0.74), in: Capsule())
        }
    }

    private var mood: LiuliuMood {
        switch emotion {
        case .happy:
            return .happy
        case .calm:
            return .waiting
        case .encouraged:
            return .encourage
        }
    }
}

private struct OppositeChoiceView: View {
    let opposite: FriendOpposite
    let accentColor: Color

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: opposite.answerIconName)
                .font(.system(size: 52, weight: .heavy))
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(accentColor)
                .frame(width: 96, height: 80)
                .background(
                    Circle()
                        .fill(accentColor.opacity(0.12))
                        .frame(width: 108, height: 108)
                )
                .shadow(color: accentColor.opacity(0.20), radius: 12, y: 8)

            Text(opposite.answerTitle)
                .font(.system(size: 22, weight: .heavy, design: .rounded))
                .foregroundStyle(Color(red: 0.48, green: 0.28, blue: 0.16))
                .padding(.horizontal, 14)
                .padding(.vertical, 6)
                .background(.white.opacity(0.74), in: Capsule())
        }
    }
}

private struct RhythmChoiceView: View {
    let rhythm: FriendRhythm
    let accentColor: Color

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: rhythm.iconName)
                .font(.system(size: 54, weight: .heavy))
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(accentColor)
                .frame(width: 96, height: 80)
                .background(
                    Circle()
                        .fill(accentColor.opacity(0.12))
                        .frame(width: 108, height: 108)
                )
                .shadow(color: accentColor.opacity(0.20), radius: 12, y: 8)

            Text(rhythm.promptTitle)
                .font(.system(size: 22, weight: .heavy, design: .rounded))
                .foregroundStyle(Color(red: 0.48, green: 0.28, blue: 0.16))
                .padding(.horizontal, 14)
                .padding(.vertical, 6)
                .background(.white.opacity(0.74), in: Capsule())
        }
    }
}

private struct SequenceChoiceView: View {
    let sequence: FriendSequence
    let accentColor: Color

    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 10) {
                ForEach(0..<3, id: \.self) { index in
                    VStack(spacing: 6) {
                        Circle()
                            .fill(index == sequence.highlightedIndex ? accentColor : accentColor.opacity(0.18))
                            .frame(width: index == sequence.highlightedIndex ? 38 : 28, height: index == sequence.highlightedIndex ? 38 : 28)
                            .overlay {
                                Text("\(index + 1)")
                                    .font(.system(size: 15, weight: .black, design: .rounded))
                                    .foregroundStyle(index == sequence.highlightedIndex ? .white : accentColor.opacity(0.70))
                            }
                            .shadow(color: accentColor.opacity(index == sequence.highlightedIndex ? 0.24 : 0), radius: 10, y: 6)

                        RoundedRectangle(cornerRadius: 6, style: .continuous)
                            .fill(index == sequence.highlightedIndex ? accentColor.opacity(0.38) : accentColor.opacity(0.10))
                            .frame(width: 30, height: 8)
                    }
                }
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 16)
            .background(.white.opacity(0.72), in: RoundedRectangle(cornerRadius: 24, style: .continuous))

            Text(sequence.promptTitle)
                .font(.system(size: 22, weight: .heavy, design: .rounded))
                .foregroundStyle(Color(red: 0.48, green: 0.28, blue: 0.16))
                .padding(.horizontal, 14)
                .padding(.vertical, 6)
                .background(.white.opacity(0.74), in: Capsule())
        }
    }
}

private struct ConceptTargetCard: View {
    enum Motif {
        case spark
        case bubble
        case weather
        case clock
        case heart
        case motion
        case quantity
        case texture
        case rhythm
        case sequence
    }

    let title: String
    let subtitle: String
    let systemName: String
    let accentColor: Color
    let motif: Motif

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [.white.opacity(0.84), accentColor.opacity(0.16)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .stroke(accentColor.opacity(0.24), lineWidth: 2)
                )

            decorativeMotif
                .opacity(0.22)
                .padding(10)

            VStack(spacing: 8) {
                Text(subtitle)
                    .font(.system(size: 13, weight: .black, design: .rounded))
                    .foregroundStyle(accentColor)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(accentColor.opacity(0.14), in: Capsule())

                Image(systemName: systemName)
                    .font(.system(size: 38, weight: .heavy))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(accentColor)
                    .frame(width: 58, height: 46)
                    .shadow(color: accentColor.opacity(0.18), radius: 8, y: 4)

                Text(title)
                    .font(.system(size: 24, weight: .black, design: .rounded))
                    .foregroundStyle(Color(red: 0.24, green: 0.26, blue: 0.30))
                    .lineLimit(1)
                    .minimumScaleFactor(0.72)
            }
            .padding(14)
        }
    }

    @ViewBuilder
    private var decorativeMotif: some View {
        switch motif {
        case .spark:
            ZStack {
                Circle()
                    .fill(accentColor)
                    .frame(width: 28, height: 28)
                    .offset(x: -48, y: -34)
                Circle()
                    .fill(accentColor)
                    .frame(width: 16, height: 16)
                    .offset(x: 46, y: 38)
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(accentColor)
                    .frame(width: 38, height: 12)
                    .rotationEffect(.degrees(-24))
                    .offset(x: 42, y: -36)
            }
        case .bubble:
            ZStack {
                Circle()
                    .stroke(accentColor, lineWidth: 5)
                    .frame(width: 50, height: 50)
                    .offset(x: -48, y: 36)
                Circle()
                    .fill(accentColor)
                    .frame(width: 20, height: 20)
                    .offset(x: 50, y: -36)
                Capsule()
                    .fill(accentColor)
                    .frame(width: 46, height: 14)
                    .offset(x: 34, y: 38)
            }
        case .weather:
            ZStack {
                Circle()
                    .fill(accentColor)
                    .frame(width: 34, height: 34)
                    .offset(x: -48, y: -34)
                CloudMotif()
                    .fill(accentColor)
                    .frame(width: 76, height: 44)
                    .offset(x: 34, y: 34)
                ForEach(0..<3, id: \.self) { index in
                    Capsule()
                        .fill(accentColor)
                        .frame(width: 6, height: 18)
                        .offset(x: CGFloat(index * 16 - 14), y: -6)
                }
            }
        case .clock:
            ZStack {
                Circle()
                    .stroke(accentColor, lineWidth: 6)
                    .frame(width: 72, height: 72)
                    .offset(x: -42, y: 18)
                Capsule()
                    .fill(accentColor)
                    .frame(width: 8, height: 30)
                    .offset(x: -42, y: 8)
                Capsule()
                    .fill(accentColor)
                    .frame(width: 32, height: 8)
                    .offset(x: -28, y: 20)
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(accentColor)
                    .frame(width: 42, height: 18)
                    .rotationEffect(.degrees(18))
                    .offset(x: 46, y: -36)
            }
        case .heart:
            ZStack {
                Image(systemName: "heart.fill")
                    .font(.system(size: 42, weight: .heavy))
                    .foregroundStyle(accentColor)
                    .offset(x: -46, y: -34)
                Image(systemName: "face.smiling.fill")
                    .font(.system(size: 36, weight: .heavy))
                    .foregroundStyle(accentColor)
                    .offset(x: 46, y: 36)
                Circle()
                    .fill(accentColor)
                    .frame(width: 14, height: 14)
                    .offset(x: 38, y: -38)
            }
        case .motion:
            ZStack {
                ForEach(0..<3, id: \.self) { index in
                    Capsule()
                        .fill(accentColor)
                        .frame(width: CGFloat(54 - index * 10), height: 8)
                        .offset(x: CGFloat(index * 12 - 42), y: CGFloat(index * 22 - 26))
                }
                Circle()
                    .stroke(accentColor, style: StrokeStyle(lineWidth: 6, lineCap: .round, dash: [16, 12]))
                    .frame(width: 74, height: 74)
                    .rotationEffect(.degrees(-18))
                    .offset(x: 36, y: 22)
                Image(systemName: "arrow.up.right")
                    .font(.system(size: 34, weight: .black))
                    .foregroundStyle(accentColor)
                    .offset(x: 46, y: -34)
            }
        case .quantity:
            ZStack {
                ForEach(0..<4, id: \.self) { index in
                    Circle()
                        .fill(accentColor)
                        .frame(width: CGFloat(18 + index * 4), height: CGFloat(18 + index * 4))
                        .offset(x: CGFloat(index * 24 - 40), y: CGFloat(index * 8 - 20))
                }
                Image(systemName: "arrow.up.arrow.down")
                    .font(.system(size: 38, weight: .black))
                    .foregroundStyle(accentColor)
                    .offset(x: 44, y: 28)
            }
        case .texture:
            ZStack {
                ForEach(0..<5, id: \.self) { index in
                    Circle()
                        .fill(accentColor)
                        .frame(width: CGFloat(12 + index * 3), height: CGFloat(12 + index * 3))
                        .offset(x: CGFloat(index * 22 - 44), y: CGFloat((index % 2) * 34 - 18))
                }
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(accentColor, style: StrokeStyle(lineWidth: 6, lineCap: .round, dash: [12, 10]))
                    .frame(width: 84, height: 52)
                    .rotationEffect(.degrees(-12))
                    .offset(x: 24, y: 20)
            }
        case .rhythm:
            ZStack {
                ForEach(0..<3, id: \.self) { index in
                    Circle()
                        .stroke(accentColor, lineWidth: 5)
                        .frame(width: CGFloat(30 + index * 18), height: CGFloat(30 + index * 18))
                        .offset(x: -42, y: CGFloat(index * 14 - 18))
                }
                Capsule()
                    .fill(accentColor)
                    .frame(width: 52, height: 10)
                    .rotationEffect(.degrees(-18))
                    .offset(x: 42, y: -36)
                Capsule()
                    .fill(accentColor)
                    .frame(width: 38, height: 10)
                    .rotationEffect(.degrees(18))
                    .offset(x: 46, y: 32)
            }
        case .sequence:
            ZStack {
                ForEach(0..<3, id: \.self) { index in
                    Circle()
                        .fill(accentColor)
                        .frame(width: CGFloat(20 + index * 8), height: CGFloat(20 + index * 8))
                        .offset(x: CGFloat(index * 36 - 42), y: CGFloat(index * 12 - 20))
                }
                Capsule()
                    .fill(accentColor)
                    .frame(width: 82, height: 8)
                    .offset(x: 0, y: 32)
                Image(systemName: "arrow.right")
                    .font(.system(size: 30, weight: .black))
                    .foregroundStyle(accentColor)
                    .offset(x: 46, y: -36)
            }
        }
    }
}

private struct CloudMotif: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let baseY = rect.midY + rect.height * 0.14
        path.addRoundedRect(
            in: CGRect(x: rect.minX + rect.width * 0.14, y: baseY - rect.height * 0.20, width: rect.width * 0.74, height: rect.height * 0.34),
            cornerSize: CGSize(width: rect.height * 0.18, height: rect.height * 0.18)
        )
        path.addEllipse(in: CGRect(x: rect.minX + rect.width * 0.16, y: rect.minY + rect.height * 0.28, width: rect.width * 0.34, height: rect.height * 0.42))
        path.addEllipse(in: CGRect(x: rect.minX + rect.width * 0.40, y: rect.minY + rect.height * 0.12, width: rect.width * 0.42, height: rect.height * 0.56))
        return path
    }
}

private struct PositionStageView: View {
    let kind: FriendKind
    let color: Color
    let position: SpatialPosition

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: min(28, min(geometry.size.width, geometry.size.height) * 0.20), style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [.white.opacity(0.72), Color(red: 0.91, green: 0.96, blue: 1.0).opacity(0.62)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay {
                        PositionGuideLines()
                            .stroke(Color(red: 0.38, green: 0.49, blue: 0.68).opacity(0.18), style: StrokeStyle(lineWidth: 2, lineCap: .round, dash: [6, 8]))
                            .padding(8)
                    }

                Circle()
                    .fill(Color(red: 0.36, green: 0.55, blue: 0.95).opacity(0.12))
                    .frame(width: itemSize(in: geometry.size) * 1.12, height: itemSize(in: geometry.size) * 1.12)
                    .position(point(for: position, in: geometry.size))

                FriendShape(kind: kind, color: color, isShadow: false)
                    .padding(max(4, itemSize(in: geometry.size) * 0.08))
                    .frame(width: itemSize(in: geometry.size), height: itemSize(in: geometry.size))
                    .position(point(for: position, in: geometry.size))
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }

    private func itemSize(in size: CGSize) -> CGFloat {
        min(size.width, size.height) * 0.46
    }

    private func point(for position: SpatialPosition, in size: CGSize) -> CGPoint {
        switch position {
        case .top:
            return CGPoint(x: size.width * 0.5, y: size.height * 0.25)
        case .bottom:
            return CGPoint(x: size.width * 0.5, y: size.height * 0.75)
        case .left:
            return CGPoint(x: size.width * 0.27, y: size.height * 0.5)
        case .right:
            return CGPoint(x: size.width * 0.73, y: size.height * 0.5)
        }
    }
}

private struct PositionGuideLines: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        return path
    }
}

private struct DirectionGlyph: Shape {
    let position: SpatialPosition

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let tip: CGPoint
        switch position {
        case .top:
            tip = CGPoint(x: rect.midX, y: rect.minY)
            path.move(to: tip)
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.midX + rect.width * 0.16, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.midX + rect.width * 0.16, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.midX - rect.width * 0.16, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.midX - rect.width * 0.16, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        case .bottom:
            path = DirectionGlyph(position: .top).path(in: rect).applying(CGAffineTransform(translationX: -center.x, y: -center.y).rotated(by: .pi).translatedBy(x: center.x, y: center.y))
        case .left:
            path = DirectionGlyph(position: .top).path(in: rect).applying(CGAffineTransform(translationX: -center.x, y: -center.y).rotated(by: -.pi / 2).translatedBy(x: center.x, y: center.y))
        case .right:
            path = DirectionGlyph(position: .top).path(in: rect).applying(CGAffineTransform(translationX: -center.x, y: -center.y).rotated(by: .pi / 2).translatedBy(x: center.x, y: center.y))
        }
        path.closeSubpath()
        return path
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
        GeometryReader { geometry in
            let isCompact = geometry.size.width < 520 || geometry.size.height < 700
            let isVeryShort = geometry.size.height < 620
            let iconSize: CGFloat = isVeryShort ? 44 : (isCompact ? 56 : 96)
            let cardWidth = min(max(geometry.size.width - (isCompact ? 32 : 64), 260), isCompact ? 300 : 430)

            ZStack {
                Color(red: 0.34, green: 0.26, blue: 0.18)
                    .opacity(0.24)
                    .ignoresSafeArea()

                VStack(spacing: isVeryShort ? 8 : (isCompact ? 10 : 18)) {
                    ZStack {
                        Circle()
                            .fill(Color(red: 1.0, green: 0.92, blue: 0.76))
                            .frame(width: iconSize, height: iconSize)

                        Image(systemName: reminder == .dailyLimit ? "moon.zzz.fill" : "eye.fill")
                            .font(.system(size: isVeryShort ? 22 : (isCompact ? 26 : 42), weight: .heavy))
                            .foregroundStyle(Color(red: 0.95, green: 0.42, blue: 0.24))
                    }

                    Text(reminder.title)
                        .font(.system(size: isVeryShort ? 20 : (isCompact ? 22 : 32), weight: .heavy, design: .rounded))
                        .foregroundStyle(Color(red: 0.26, green: 0.19, blue: 0.13))
                        .lineLimit(2)
                        .minimumScaleFactor(0.72)
                        .multilineTextAlignment(.center)

                    Text(reminder.message)
                        .font(.system(size: isVeryShort ? 14 : (isCompact ? 15 : 20), weight: .bold, design: .rounded))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color(red: 0.48, green: 0.38, blue: 0.29))
                        .lineLimit(isVeryShort ? 3 : nil)
                        .minimumScaleFactor(0.78)
                        .lineSpacing(isVeryShort ? 1 : (isCompact ? 2 : 4))

                    Text("家长长按 3 秒继续")
                        .font(.system(size: isVeryShort ? 12 : (isCompact ? 13 : 17), weight: .heavy, design: .rounded))
                        .foregroundStyle(Color(red: 0.95, green: 0.26, blue: 0.24))
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)

                    RoundedRectangle(cornerRadius: isCompact ? 18 : 24, style: .continuous)
                        .fill(isHolding ? Color(red: 0.95, green: 0.26, blue: 0.24) : Color(red: 1.0, green: 0.84, blue: 0.70))
                        .frame(height: isVeryShort ? 42 : (isCompact ? 46 : 58))
                        .overlay {
                            Label(isHolding ? "继续按住" : "长按继续", systemImage: "hand.point.up.left.fill")
                                .font(.system(size: isVeryShort ? 15 : (isCompact ? 16 : 20), weight: .heavy, design: .rounded))
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
                .padding(isVeryShort ? 14 : (isCompact ? 18 : 28))
                .frame(width: cardWidth)
                .fixedSize(horizontal: false, vertical: true)
                .background(.white.opacity(0.94), in: RoundedRectangle(cornerRadius: isCompact ? 26 : 32, style: .continuous))
                .shadow(color: .black.opacity(0.16), radius: isCompact ? 18 : 24, y: isCompact ? 8 : 12)
                .padding(.horizontal, isCompact ? 16 : 32)
                .padding(.vertical, isCompact ? 20 : 40)
            }
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

    var showsCelebrationMascot: Bool {
        !usesWidePanel
    }

    var celebrationOffsetX: CGFloat {
        isCompact ? -22 : 0
    }

    var celebrationOffsetY: CGFloat {
        isCompact ? -28 : -120
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
                        VStack(spacing: 12) {
                            LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)], spacing: 10) {
                                SettingsTile(title: "音效", systemName: "speaker.wave.2.fill", isOn: $viewModel.settings.soundEnabled)
                                SettingsTile(title: "语音", systemName: "bubble.left.fill", isOn: $viewModel.settings.voicePromptEnabled)
                                SettingsTile(title: "休息", systemName: "timer", isOn: $viewModel.settings.restReminderEnabled)
                                SettingsTile(title: "护眼", systemName: "eye.fill", isOn: $viewModel.settings.eyeComfortEnabled)
                                SettingsTile(title: "自动", systemName: "arrow.right.circle.fill", isOn: $viewModel.settings.autoAdvanceEnabled)
                                SettingsTile(title: "动画", systemName: "sparkles", isOn: Binding(
                                    get: { !viewModel.settings.reducedMotion },
                                    set: { viewModel.settings.reducedMotion = !$0 }
                                ))
                            }

                            LearningStageSelector(viewModel: viewModel, isCompact: true)

                            SettingsGroupTitle(text: "开启玩法（阶段外暂不出现）", isCompact: true)
                            VStack(spacing: 12) {
                                ForEach(modeGroups) { group in
                                    VStack(alignment: .leading, spacing: 8) {
                                        SettingsGroupTitle(text: group.title, isCompact: true)
                                        LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)], spacing: 10) {
                                            ForEach(group.modes, id: \.self) { mode in
                                                SettingsTile(
                                                    title: shortModeTitle(for: mode),
                                                    systemName: modeIcon(for: mode),
                                                    isOn: gameModeBinding(for: mode),
                                                    isEnabled: isModeAvailableInSelectedStage(mode),
                                                    statusText: modeStatusText(for: mode)
                                                )
                                            }
                                        }
                                    }
                                }
                            }
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
                                systemName: "bubble.left.fill",
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

                            LearningStageSelector(viewModel: viewModel, isCompact: false)

                            Divider()
                                .padding(.vertical, 4)

                            SettingsGroupTitle(text: "开启玩法（阶段外暂不出现）", isCompact: false)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            ForEach(modeGroups) { group in
                                VStack(alignment: .leading, spacing: 6) {
                                    SettingsGroupTitle(text: group.title, isCompact: false)
                                        .frame(maxWidth: .infinity, alignment: .leading)

                                    ForEach(group.modes, id: \.self) { mode in
                                        SettingsToggle(
                                            title: mode.title,
                                            systemName: modeIcon(for: mode),
                                            isOn: gameModeBinding(for: mode),
                                            isCompact: false,
                                            isEnabled: isModeAvailableInSelectedStage(mode),
                                            detail: modeStatusText(for: mode)
                                        )
                                    }
                                }
                                .padding(.vertical, 4)
                            }
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

    private func gameModeBinding(for mode: GameMode) -> Binding<Bool> {
        Binding(
            get: { viewModel.settings.enabledGameModes.contains(mode) },
            set: { viewModel.setGameMode(mode, enabled: $0) }
        )
    }

    private func isModeAvailableInSelectedStage(_ mode: GameMode) -> Bool {
        mode.ageBand.isIncluded(in: viewModel.settings.maximumAgeBand)
    }

    private func modeStatusText(for mode: GameMode) -> String {
        isModeAvailableInSelectedStage(mode) ? mode.ageLabel : "阶段外"
    }

    private var modeGroups: [ModeSettingsGroup] {
        GameMode.settingsGroupOrder.map { groupTitle in
            ModeSettingsGroup(
                title: groupTitle,
                modes: GameMode.allCases.filter { $0.settingsGroupTitle == groupTitle }
            )
        }
        .filter { !$0.modes.isEmpty }
    }

    private func shortModeTitle(for mode: GameMode) -> String {
        switch mode {
        case .animal:
            return "动物"
        case .sound:
            return "声音"
        case .color:
            return "颜色"
        case .shape:
            return "形状"
        case .size:
            return "大小"
        case .shadow:
            return "影子"
        case .count:
            return "数量"
        case .quantityCompare:
            return "多少"
        case .category:
            return "分类"
        case .difference:
            return "不同"
        case .position:
            return "位置"
        case .purpose:
            return "用途"
        case .scene:
            return "场景"
        case .weather:
            return "天气"
        case .routine:
            return "作息"
        case .emotion:
            return "情绪"
        case .action:
            return "动作"
        case .texture:
            return "触感"
        case .pairing:
            return "搭配"
        case .opposite:
            return "相反"
        case .rhythm:
            return "节奏"
        case .sequence:
            return "顺序"
        case .pattern:
            return "规律"
        }
    }

    private func modeIcon(for mode: GameMode) -> String {
        switch mode {
        case .animal:
            return "pawprint.fill"
        case .sound:
            return "ear.fill"
        case .color:
            return "paintpalette.fill"
        case .shape:
            return "triangle.fill"
        case .size:
            return "arrow.up.left.and.arrow.down.right"
        case .shadow:
            return "moon.fill"
        case .count:
            return "number.circle.fill"
        case .quantityCompare:
            return "plusminus.circle.fill"
        case .category:
            return "square.grid.2x2.fill"
        case .difference:
            return "questionmark.circle.fill"
        case .position:
            return "location.fill"
        case .purpose:
            return "lightbulb.fill"
        case .scene:
            return "map.fill"
        case .weather:
            return "cloud.sun.fill"
        case .routine:
            return "sunrise.fill"
        case .emotion:
            return "face.smiling.fill"
        case .action:
            return "figure.run"
        case .texture:
            return "hand.raised.fill"
        case .pairing:
            return "link.circle.fill"
        case .opposite:
            return "arrow.left.arrow.right.circle.fill"
        case .rhythm:
            return "music.note"
        case .sequence:
            return "arrow.right.circle.fill"
        case .pattern:
            return "repeat.circle.fill"
        }
    }
}

private struct ModeSettingsGroup: Identifiable {
    let title: String
    let modes: [GameMode]

    var id: String { title }
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
    var isEnabled: Bool = true
    var statusText: String? = nil

    var body: some View {
        Button {
            guard isEnabled else { return }
            isOn.toggle()
        } label: {
            VStack(spacing: 10) {
                Image(systemName: systemName)
                    .font(.system(size: 24, weight: .heavy))
                    .foregroundStyle(iconColor)
                    .frame(width: 44, height: 44)
                    .background(iconBackground.opacity(0.72), in: Circle())

                Text(title)
                    .font(.system(size: 17, weight: .heavy, design: .rounded))
                    .foregroundStyle(Color(red: 0.20, green: 0.16, blue: 0.12))

                Text(statusText ?? (isOn ? "开" : "关"))
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundStyle(statusColor)
            }
            .frame(maxWidth: .infinity, minHeight: 112)
            .background(.white.opacity(0.88), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            .shadow(color: .black.opacity(0.06), radius: 12, y: 6)
            .opacity(isEnabled ? 1 : 0.56)
        }
        .buttonStyle(.plain)
        .accessibilityHint(isEnabled ? "" : "当前启蒙阶段暂不出现")
    }

    private var iconColor: Color {
        guard isEnabled else { return Color(red: 0.62, green: 0.58, blue: 0.54) }
        return isOn ? Color(red: 0.95, green: 0.26, blue: 0.24) : Color(red: 0.55, green: 0.50, blue: 0.46)
    }

    private var iconBackground: Color {
        guard isEnabled else { return Color(red: 0.92, green: 0.90, blue: 0.86) }
        return isOn ? Color(red: 1.0, green: 0.86, blue: 0.76) : Color.white
    }

    private var statusColor: Color {
        guard isEnabled else { return Color(red: 0.62, green: 0.58, blue: 0.54) }
        return isOn ? Color(red: 0.95, green: 0.26, blue: 0.24) : Color(red: 0.55, green: 0.50, blue: 0.46)
    }
}

private struct SettingsGroupTitle: View {
    let text: String
    let isCompact: Bool

    var body: some View {
        Text(text)
            .font(.system(size: isCompact ? 15 : 17, weight: .heavy, design: .rounded))
            .foregroundStyle(Color(red: 0.55, green: 0.43, blue: 0.32))
            .padding(.top, isCompact ? 2 : 0)
    }
}

private struct LearningStageSelector: View {
    @ObservedObject var viewModel: GameViewModel
    let isCompact: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: isCompact ? 10 : 12) {
            HStack {
                Label("启蒙阶段", systemImage: "slider.horizontal.3")
                    .font(.system(size: isCompact ? 17 : 20, weight: .heavy, design: .rounded))
                    .foregroundStyle(Color(red: 0.20, green: 0.16, blue: 0.12))

                Spacer()

                Text(viewModel.settings.maximumAgeBand.label)
                    .font(.system(size: isCompact ? 15 : 17, weight: .black, design: .rounded))
                    .foregroundStyle(Color(red: 0.95, green: 0.26, blue: 0.24))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color(red: 1.0, green: 0.86, blue: 0.76), in: Capsule())
            }

            if isCompact {
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 8), GridItem(.flexible(), spacing: 8)], spacing: 8) {
                    ForEach(LearningAgeBand.allCases, id: \.self) { ageBand in
                        stageButton(for: ageBand)
                    }
                }
            } else {
                HStack(spacing: 10) {
                    ForEach(LearningAgeBand.allCases, id: \.self) { ageBand in
                        stageButton(for: ageBand)
                    }
                }
            }

            Text(viewModel.settings.maximumAgeBand.focus)
                .font(.system(size: isCompact ? 13 : 15, weight: .bold, design: .rounded))
                .foregroundStyle(Color(red: 0.50, green: 0.42, blue: 0.35))
                .lineLimit(2)
                .minimumScaleFactor(0.78)
        }
        .padding(isCompact ? 14 : 18)
        .background(.white.opacity(0.88), in: RoundedRectangle(cornerRadius: isCompact ? 20 : 22, style: .continuous))
        .shadow(color: .black.opacity(0.06), radius: 12, y: 6)
    }

    private func stageButton(for ageBand: LearningAgeBand) -> some View {
        let isSelected = viewModel.settings.maximumAgeBand == ageBand
        return Button {
            viewModel.setMaximumAgeBand(ageBand)
        } label: {
            VStack(spacing: 4) {
                Text(ageBand.label)
                    .font(.system(size: isCompact ? 18 : 17, weight: .black, design: .rounded))
                Text(shortFocus(for: ageBand))
                    .font(.system(size: isCompact ? 12 : 13, weight: .bold, design: .rounded))
                    .lineLimit(1)
                    .minimumScaleFactor(0.72)
            }
            .foregroundStyle(isSelected ? .white : Color(red: 0.42, green: 0.34, blue: 0.27))
            .frame(maxWidth: .infinity, minHeight: isCompact ? 58 : 56)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(isSelected ? Color(red: 0.95, green: 0.26, blue: 0.24) : Color.white.opacity(0.74))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(isSelected ? Color(red: 1.0, green: 0.78, blue: 0.26) : Color(red: 1.0, green: 0.88, blue: 0.66).opacity(0.35), lineWidth: isSelected ? 2 : 1)
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel("启蒙阶段 \(ageBand.label)")
    }

    private func shortFocus(for ageBand: LearningAgeBand) -> String {
        switch ageBand {
        case .starter18Months:
            return "识物"
        case .explorer24Months:
            return "颜色形状"
        case .matcher30Months:
            return "匹配关系"
        case .preschool36Months:
            return "全部内容"
        }
    }
}

private struct SettingsToggle: View {
    let title: String
    let systemName: String
    @Binding var isOn: Bool
    let isCompact: Bool
    var isEnabled: Bool = true
    var detail: String? = nil

    var body: some View {
        Toggle(isOn: Binding(
            get: { isOn },
            set: { newValue in
                guard isEnabled else { return }
                isOn = newValue
            }
        )) {
            HStack(spacing: 10) {
                Label(title, systemImage: systemName)
                    .font(.system(size: isCompact ? 19 : 22, weight: .bold, design: .rounded))
                    .foregroundStyle(Color(red: 0.20, green: 0.16, blue: 0.12))

                if let detail {
                    Text(detail)
                        .font(.system(size: isCompact ? 13 : 15, weight: .heavy, design: .rounded))
                        .foregroundStyle(isEnabled ? Color(red: 0.95, green: 0.26, blue: 0.24) : Color(red: 0.62, green: 0.58, blue: 0.54))
                        .padding(.horizontal, 9)
                        .padding(.vertical, 4)
                        .background((isEnabled ? Color(red: 1.0, green: 0.86, blue: 0.76) : Color(red: 0.92, green: 0.90, blue: 0.86)), in: Capsule())
                }
            }
        }
        .toggleStyle(.switch)
        .tint(Color(red: 0.95, green: 0.26, blue: 0.24))
        .padding(.vertical, isCompact ? 6 : 8)
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1 : 0.58)
    }
}

private extension Array where Element: Hashable {
    func uniqued() -> [Element] {
        var seen = Set<Element>()
        return filter { seen.insert($0).inserted }
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
