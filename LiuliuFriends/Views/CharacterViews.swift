import Foundation
import SwiftUI

struct BackgroundView: View {
    var eyeComfortEnabled = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: eyeComfortEnabled ? eyeComfortColors : defaultColors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            Circle()
                .fill(Color(red: 1.0, green: 0.42, blue: 0.34).opacity(eyeComfortEnabled ? 0.08 : 0.16))
                .frame(width: 420, height: 420)
                .blur(radius: eyeComfortEnabled ? 58 : 42)
                .offset(x: -180, y: -260)

            Circle()
                .fill(Color(red: 0.22, green: 0.65, blue: 0.94).opacity(eyeComfortEnabled ? 0.07 : 0.13))
                .frame(width: 520, height: 520)
                .blur(radius: eyeComfortEnabled ? 70 : 54)
                .offset(x: 210, y: 260)
        }
        .ignoresSafeArea()
    }

    private var defaultColors: [Color] {
        [
            Color(red: 1.0, green: 0.96, blue: 0.86),
            Color(red: 1.0, green: 0.90, blue: 0.88),
            Color(red: 0.98, green: 0.89, blue: 0.94)
        ]
    }

    private var eyeComfortColors: [Color] {
        [
            Color(red: 0.99, green: 0.96, blue: 0.88),
            Color(red: 0.98, green: 0.94, blue: 0.86),
            Color(red: 0.95, green: 0.93, blue: 0.87)
        ]
    }
}

enum LiuliuMood {
    case waiting
    case happy
    case encourage
}

struct MascotPanel: View {
    let round: GameRound
    let celebrationSeed: Int
    let isCelebrating: Bool
    let reducedMotion: Bool

    var body: some View {
        VStack(spacing: 18) {
            LiuliuMascot(mood: isCelebrating ? .happy : .waiting)
                .frame(width: 220, height: 260)
                .scaleEffect(reducedMotion ? 1 : (celebrationSeed == 0 ? 1 : 1.03))
                .animation(.spring(response: 0.35, dampingFraction: 0.42), value: celebrationSeed)

            Text("六六")
                .font(.system(size: 30, weight: .heavy, design: .rounded))
                .foregroundStyle(.primary)

            Text(round.mode.prompt)
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .frame(maxWidth: 260)

            Text("肚兜游戏")
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundStyle(.secondary.opacity(0.8))
                .padding(.top, 2)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct LiuliuMascot: View {
    let mood: LiuliuMood

    init(mood: LiuliuMood = .waiting) {
        self.mood = mood
    }

    var body: some View {
        LiuliuPendant(mood: mood)
    }
}

struct LiuliuPendant: View {
    let mood: LiuliuMood

    init(mood: LiuliuMood = .waiting) {
        self.mood = mood
    }

    var body: some View {
        Image(assetName)
            .resizable()
            .scaledToFit()
        .frame(width: 150, height: 190)
            .shadow(color: Color(red: 0.60, green: 0.36, blue: 0.14).opacity(0.12), radius: 12, y: 8)
    }

    private var assetName: String {
        switch mood {
        case .waiting:
            return "LiuliuIdleArt"
        case .happy:
            return "LiuliuHappyArt"
        case .encourage:
            return "LiuliuEncourageArt"
        }
    }
}

private struct DudouDiamond: View {
    let coral: Color

    var body: some View {
        RoundedRectangle(cornerRadius: 18)
            .fill(
                LinearGradient(
                    colors: [
                        Color(red: 1.0, green: 0.45, blue: 0.38),
                        coral
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .rotationEffect(.degrees(45))
            .shadow(color: Color(red: 0.76, green: 0.16, blue: 0.10).opacity(0.18), radius: 8, y: 4)
            .overlay(
                Circle()
                    .fill(Color(red: 1.0, green: 0.78, blue: 0.50))
                    .frame(width: 17, height: 17)
            )
    }
}

private struct LiuliuSmileEye: View {
    let ink: Color

    var body: some View {
        Path { path in
            path.move(to: CGPoint(x: 2, y: 12))
            path.addQuadCurve(to: CGPoint(x: 24, y: 12), control: CGPoint(x: 13, y: 0))
        }
        .stroke(ink, style: StrokeStyle(lineWidth: 4.2, lineCap: .round))
        .frame(width: 26, height: 18)
    }
}

private struct SmileMouth: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX + rect.width * 0.10, y: rect.minY + rect.height * 0.34))
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX - rect.width * 0.10, y: rect.minY + rect.height * 0.34),
            control: CGPoint(x: rect.midX, y: rect.maxY)
        )
        return path
    }
}

private struct HappyMouth: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY + rect.height * 0.20))
        path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.minY + rect.height * 0.20), control: CGPoint(x: rect.midX, y: rect.minY - rect.height * 0.14))
        path.addQuadCurve(to: CGPoint(x: rect.minX, y: rect.minY + rect.height * 0.20), control: CGPoint(x: rect.midX, y: rect.maxY * 1.18))
        path.closeSubpath()
        return path
    }
}

private struct BeanFace: View {
    let isHappy: Bool

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 44)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 1.0, green: 0.86, blue: 0.42),
                            Color(red: 1.0, green: 0.64, blue: 0.28)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 44)
                        .stroke(.white.opacity(0.78), lineWidth: 4)
                )

            HStack(spacing: 28) {
                EyeView(isHappy: isHappy)
                EyeView(isHappy: isHappy)
            }
            .offset(y: -8)

            MouthView(isHappy: isHappy)
                .stroke(Color(red: 0.25, green: 0.16, blue: 0.12).opacity(0.74), style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .frame(width: 34, height: 20)
                .offset(y: 22)

            HStack(spacing: 60) {
                BlushView()
                BlushView()
            }
            .offset(y: 14)

            HairTuft()
                .stroke(Color(red: 0.30, green: 0.16, blue: 0.10), style: StrokeStyle(lineWidth: 4.5, lineCap: .round, lineJoin: .round))
                .frame(width: 38, height: 28)
                .offset(y: -64)
        }
    }
}

struct LiuliuAppIconConcept: View {
    var body: some View {
        Image("LiuliuLogoIcon")
            .resizable()
            .scaledToFit()
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .aspectRatio(1, contentMode: .fit)
    }
}

private struct EarView: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color(red: 1.0, green: 0.83, blue: 0.58))
                .frame(width: 44, height: 44)
                .overlay(
                    Circle()
                        .stroke(.white.opacity(0.65), lineWidth: 2)
                )

            Circle()
                .fill(Color(red: 1.0, green: 0.70, blue: 0.55).opacity(0.72))
                .frame(width: 22, height: 22)
        }
    }
}

private struct BodyView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 64)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 1.0, green: 0.84, blue: 0.58),
                            Color(red: 0.98, green: 0.73, blue: 0.40)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: 142, height: 156)
                .overlay(
                    RoundedRectangle(cornerRadius: 64)
                        .stroke(.white.opacity(0.38), lineWidth: 3)
                )
        }
    }
}

private struct ArmView: View {
    var body: some View {
        Capsule()
            .fill(Color(red: 1.0, green: 0.80, blue: 0.52))
            .frame(width: 30, height: 86)
            .overlay(
                Circle()
                    .fill(Color(red: 1.0, green: 0.75, blue: 0.58))
                    .frame(width: 32, height: 32)
                    .offset(y: 30)
            )
    }
}

private struct FootView: View {
    var body: some View {
        Capsule()
            .fill(Color(red: 1.0, green: 0.78, blue: 0.52))
            .frame(width: 44, height: 24)
    }
}

private struct BlushView: View {
    var body: some View {
        Ellipse()
            .fill(Color(red: 1.0, green: 0.58, blue: 0.50).opacity(0.55))
            .frame(width: 24, height: 18)
    }
}

private struct EyeView: View {
    let isHappy: Bool

    var body: some View {
        let ink = Color(red: 0.34, green: 0.25, blue: 0.18)

        if isHappy {
            Path { path in
                path.move(to: CGPoint(x: 1, y: 12))
                path.addQuadCurve(to: CGPoint(x: 23, y: 12), control: CGPoint(x: 12, y: 1))
            }
            .stroke(ink.opacity(0.82), style: StrokeStyle(lineWidth: 4, lineCap: .round))
            .frame(width: 24, height: 22)
        } else {
            Circle()
                .fill(ink.opacity(0.86))
                .frame(width: 13, height: 13)
                .overlay(
                    Circle()
                        .fill(.white.opacity(0.9))
                        .frame(width: 4, height: 4)
                        .offset(x: -3, y: -3)
                )
        }
    }
}

private struct DudouView: View {
    var body: some View {
        ZStack {
            DudouShape()
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 1.0, green: 0.24, blue: 0.22),
                            Color(red: 0.88, green: 0.08, blue: 0.08)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: 88, height: 108)
                .shadow(color: Color(red: 0.80, green: 0.05, blue: 0.04).opacity(0.2), radius: 8, y: 4)

            Circle()
                .stroke(.white.opacity(0.86), lineWidth: 4)
                .frame(width: 34, height: 34)
                .offset(y: 8)

            HStack(spacing: 70) {
                Path { path in
                    path.move(to: CGPoint(x: 0, y: 0))
                    path.addLine(to: CGPoint(x: 28, y: 40))
                }
                .stroke(Color(red: 0.78, green: 0.05, blue: 0.05), style: StrokeStyle(lineWidth: 7, lineCap: .round))

                Path { path in
                    path.move(to: CGPoint(x: 28, y: 0))
                    path.addLine(to: CGPoint(x: 0, y: 40))
                }
                .stroke(Color(red: 0.78, green: 0.05, blue: 0.05), style: StrokeStyle(lineWidth: 7, lineCap: .round))
            }
            .frame(width: 116, height: 42)
            .offset(y: -55)
        }
    }
}

private struct DudouShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addQuadCurve(to: CGPoint(x: rect.maxX - 12, y: rect.minY + 22), control: CGPoint(x: rect.maxX - 6, y: rect.minY + 2))
        path.addLine(to: CGPoint(x: rect.maxX - 5, y: rect.maxY - 18))
        path.addQuadCurve(to: CGPoint(x: rect.midX, y: rect.maxY), control: CGPoint(x: rect.maxX - 18, y: rect.maxY + 4))
        path.addQuadCurve(to: CGPoint(x: rect.minX + 5, y: rect.maxY - 18), control: CGPoint(x: rect.minX + 18, y: rect.maxY + 4))
        path.addLine(to: CGPoint(x: rect.minX + 12, y: rect.minY + 22))
        path.addQuadCurve(to: CGPoint(x: rect.midX, y: rect.minY), control: CGPoint(x: rect.minX + 6, y: rect.minY + 2))
        path.closeSubpath()
        return path
    }
}

private struct MouthView: Shape {
    let isHappy: Bool

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: isHappy ? rect.minY : rect.midY))
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX, y: isHappy ? rect.minY : rect.midY),
            control: CGPoint(x: rect.midX, y: isHappy ? rect.maxY : rect.maxY * 0.76)
        )
        return path
    }
}

private struct HairTuft: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX + 4, y: rect.maxY))
        path.addQuadCurve(to: CGPoint(x: rect.midX, y: rect.minY + 2), control: CGPoint(x: rect.minX + 8, y: rect.minY + 4))
        path.addQuadCurve(to: CGPoint(x: rect.maxX - 4, y: rect.maxY), control: CGPoint(x: rect.maxX - 6, y: rect.minY + 2))
        return path
    }
}

private struct PendantCord: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX + 8, y: rect.maxY))
        path.addQuadCurve(to: CGPoint(x: rect.maxX - 8, y: rect.maxY), control: CGPoint(x: rect.midX, y: rect.minY))
        return path
    }
}

struct ColorFriendTarget: View {
    let color: Color

    var body: some View {
        ZStack {
            BlobShape()
                .fill(
                    RadialGradient(
                        colors: [.white.opacity(0.55), color],
                        center: .topLeading,
                        startRadius: 8,
                        endRadius: 92
                    )
                )
                .shadow(color: color.opacity(0.22), radius: 14, y: 8)

            Circle()
                .fill(.white.opacity(0.26))
                .frame(width: 28, height: 28)
                .offset(x: -28, y: -30)
        }
    }
}

struct ColorLearningObjectView: View {
    let kind: FriendKind
    let color: Color

    var body: some View {
        ZStack {
            switch kind {
            case .balloon:
                VStack(spacing: -2) {
                    ColorFriendTarget(color: color)
                        .frame(width: 108, height: 108)
                    Triangle()
                        .fill(color)
                        .frame(width: 26, height: 22)
                        .rotationEffect(.degrees(180))
                        .opacity(0.9)
                }
            case .ball:
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [.white.opacity(0.58), color],
                                center: .topLeading,
                                startRadius: 8,
                                endRadius: 84
                            )
                        )
                    Circle()
                        .stroke(.white.opacity(0.72), lineWidth: 7)
                        .padding(18)
                    Path { path in
                        path.move(to: CGPoint(x: 26, y: 72))
                        path.addQuadCurve(to: CGPoint(x: 112, y: 46), control: CGPoint(x: 66, y: 26))
                    }
                    .stroke(.white.opacity(0.72), style: StrokeStyle(lineWidth: 7, lineCap: .round))
                }
                .frame(width: 128, height: 128)
            case .book:
                ZStack {
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [.white.opacity(0.42), color],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(.white.opacity(0.68), lineWidth: 6)
                        .padding(12)
                    Rectangle()
                        .fill(.white.opacity(0.44))
                        .frame(width: 6)
                }
                .frame(width: 126, height: 104)
            case .cup:
                ZStack {
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [.white.opacity(0.52), color],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 92, height: 106)
                    Circle()
                        .stroke(color.opacity(0.82), lineWidth: 12)
                        .frame(width: 46, height: 46)
                        .offset(x: 48, y: -4)
                    Capsule()
                        .fill(.white.opacity(0.34))
                        .frame(width: 56, height: 12)
                        .offset(y: -28)
                }
                .frame(width: 132, height: 124)
            case .flower:
                ZStack {
                    ForEach(0..<6, id: \.self) { petalIndex in
                        Capsule()
                            .fill(color)
                            .frame(width: 38, height: 66)
                            .offset(y: -34)
                            .rotationEffect(.degrees(Double(petalIndex) * 60))
                    }
                    Circle()
                        .fill(Color(red: 1.0, green: 0.82, blue: 0.25))
                        .frame(width: 48, height: 48)
                    Circle()
                        .fill(.white.opacity(0.32))
                        .frame(width: 18, height: 18)
                        .offset(x: -10, y: -10)
                }
                .frame(width: 132, height: 132)
            case .umbrella:
                ZStack {
                    SemiCircle()
                        .fill(
                            LinearGradient(
                                colors: [.white.opacity(0.44), color],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 132, height: 76)
                        .offset(y: -18)
                    Capsule()
                        .fill(Color(red: 0.58, green: 0.42, blue: 0.30))
                        .frame(width: 8, height: 76)
                        .offset(y: 24)
                    Circle()
                        .trim(from: 0.52, to: 0.95)
                        .stroke(Color(red: 0.58, green: 0.42, blue: 0.30), style: StrokeStyle(lineWidth: 8, lineCap: .round))
                        .frame(width: 42, height: 42)
                        .offset(x: 17, y: 58)
                }
                .frame(width: 144, height: 132)
            default:
                ColorFriendTarget(color: color)
            }
        }
        .shadow(color: color.opacity(0.18), radius: 12, y: 7)
    }
}

struct SoundBubble: View {
    let text: String

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 42)
                .fill(
                    LinearGradient(
                        colors: [.white, Color(red: 0.91, green: 0.96, blue: 1.0)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 42)
                        .stroke(Color(red: 0.75, green: 0.88, blue: 0.98), lineWidth: 4)
                )
                .shadow(color: Color(red: 0.22, green: 0.65, blue: 0.94).opacity(0.18), radius: 18, y: 10)

            VStack(spacing: 10) {
                SpeakerGlyph()
                    .stroke(Color(red: 0.17, green: 0.48, blue: 0.74), style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                    .frame(width: 46, height: 34)
                Text(text)
                    .font(.system(size: 34, weight: .heavy, design: .rounded))
            }
            .foregroundStyle(Color(red: 0.1, green: 0.34, blue: 0.58))
        }
    }
}

private struct BlobShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY + rect.height * 0.06))
        path.addCurve(
            to: CGPoint(x: rect.maxX - rect.width * 0.06, y: rect.midY),
            control1: CGPoint(x: rect.maxX - rect.width * 0.14, y: rect.minY - rect.height * 0.02),
            control2: CGPoint(x: rect.maxX, y: rect.minY + rect.height * 0.24)
        )
        path.addCurve(
            to: CGPoint(x: rect.midX, y: rect.maxY - rect.height * 0.05),
            control1: CGPoint(x: rect.maxX - rect.width * 0.02, y: rect.maxY - rect.height * 0.22),
            control2: CGPoint(x: rect.maxX - rect.width * 0.20, y: rect.maxY)
        )
        path.addCurve(
            to: CGPoint(x: rect.minX + rect.width * 0.06, y: rect.midY),
            control1: CGPoint(x: rect.minX + rect.width * 0.20, y: rect.maxY),
            control2: CGPoint(x: rect.minX - rect.width * 0.02, y: rect.maxY - rect.height * 0.22)
        )
        path.addCurve(
            to: CGPoint(x: rect.midX, y: rect.minY + rect.height * 0.06),
            control1: CGPoint(x: rect.minX, y: rect.minY + rect.height * 0.24),
            control2: CGPoint(x: rect.minX + rect.width * 0.14, y: rect.minY - rect.height * 0.02)
        )
        path.closeSubpath()
        return path
    }
}

private struct SpeakerGlyph: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX + rect.width * 0.05, y: rect.midY - rect.height * 0.18))
        path.addLine(to: CGPoint(x: rect.minX + rect.width * 0.28, y: rect.midY - rect.height * 0.18))
        path.addLine(to: CGPoint(x: rect.minX + rect.width * 0.50, y: rect.minY + rect.height * 0.10))
        path.addLine(to: CGPoint(x: rect.minX + rect.width * 0.50, y: rect.maxY - rect.height * 0.10))
        path.addLine(to: CGPoint(x: rect.minX + rect.width * 0.28, y: rect.midY + rect.height * 0.18))
        path.addLine(to: CGPoint(x: rect.minX + rect.width * 0.05, y: rect.midY + rect.height * 0.18))
        path.closeSubpath()
        path.move(to: CGPoint(x: rect.minX + rect.width * 0.64, y: rect.midY - rect.height * 0.22))
        path.addQuadCurve(to: CGPoint(x: rect.minX + rect.width * 0.64, y: rect.midY + rect.height * 0.22), control: CGPoint(x: rect.minX + rect.width * 0.78, y: rect.midY))
        path.move(to: CGPoint(x: rect.minX + rect.width * 0.78, y: rect.midY - rect.height * 0.34))
        path.addQuadCurve(to: CGPoint(x: rect.minX + rect.width * 0.78, y: rect.midY + rect.height * 0.34), control: CGPoint(x: rect.maxX, y: rect.midY))
        return path
    }
}

struct FriendShape: View {
    let kind: FriendKind
    let color: Color
    let isShadow: Bool

    var body: some View {
        ZStack {
            if let imageAssetName = kind.imageAssetName {
                Image(imageAssetName)
                    .resizable()
                    .renderingMode(isShadow ? .template : .original)
                    .scaledToFit()
                    .foregroundStyle(color)
            } else {
                switch kind {
            case .balloon:
                if isShadow {
                    BalloonShape(color: color, isShadow: true)
                } else {
                    Image("ObjectBalloonArt")
                        .resizable()
                        .scaledToFit()
                }
            case .cat:
                if isShadow {
                    AnimalFace(color: color, ear: .triangle, isShadow: true)
                } else {
                    Image("AnimalCatArt")
                        .resizable()
                        .scaledToFit()
                }
            case .dog:
                if isShadow {
                    AnimalFace(color: color, ear: .floppy, isShadow: true)
                } else {
                    Image("AnimalDogArt")
                        .resizable()
                        .scaledToFit()
                }
            case .duck:
                if isShadow {
                    DuckShape(color: color, isShadow: true)
                } else {
                    Image("AnimalDuckArt")
                        .resizable()
                        .scaledToFit()
                }
            case .bear:
                if isShadow {
                    AnimalFace(color: color, ear: .round, isShadow: true)
                } else {
                    Image("AnimalBearArt")
                        .resizable()
                        .scaledToFit()
                }
            case .rabbit:
                if isShadow {
                    AnimalFace(color: color, ear: .long, isShadow: true)
                } else {
                    Image("AnimalRabbitArt")
                        .resizable()
                        .scaledToFit()
                }
            case .frog:
                if isShadow {
                    FrogFace(color: color, isShadow: true)
                } else {
                    Image("AnimalFrogArt")
                        .resizable()
                        .scaledToFit()
                }
            case .apple:
                if isShadow {
                    AppleShape(color: color, isShadow: true)
                } else {
                    Image("ObjectAppleArt")
                        .resizable()
                        .scaledToFit()
                }
            case .fish:
                if isShadow {
                    FishShape(color: color, isShadow: true)
                } else {
                    Image("AnimalFishArt")
                        .resizable()
                        .scaledToFit()
                }
            case .circle:
                ShapeSymbol(kind: .circle, color: color, isShadow: isShadow)
            case .square:
                ShapeSymbol(kind: .square, color: color, isShadow: isShadow)
            case .triangle:
                ShapeSymbol(kind: .triangle, color: color, isShadow: isShadow)
            case .star:
                StarShape(color: color, isShadow: isShadow)
            case .heart:
                ShapeSymbol(kind: .heart, color: color, isShadow: isShadow)
            case .rectangle:
                ShapeSymbol(kind: .rectangle, color: color, isShadow: isShadow)
            case .oval:
                ShapeSymbol(kind: .oval, color: color, isShadow: isShadow)
            case .diamond:
                ShapeSymbol(kind: .diamond, color: color, isShadow: isShadow)
            case .moon:
                SymbolFriendShape(kind: kind, color: color, isShadow: isShadow)
            default:
                SymbolFriendShape(kind: kind, color: color, isShadow: isShadow)
                }
            }
        }
        .saturation(isShadow ? 0 : 1)
    }
}

private struct BalloonShape: View {
    let color: Color
    let isShadow: Bool

    var body: some View {
        ZStack {
            Circle()
                .fill(color)
                .frame(width: 110, height: 110)

            Triangle()
                .fill(color)
                .frame(width: 26, height: 22)
                .offset(y: 64)

            if !isShadow {
                Circle()
                    .fill(.white.opacity(0.45))
                    .frame(width: 24, height: 24)
                    .offset(x: -26, y: -24)
            }
        }
    }
}

private enum EarStyle {
    case triangle
    case floppy
    case round
    case long
}

private struct AnimalFace: View {
    let color: Color
    let ear: EarStyle
    let isShadow: Bool

    var body: some View {
        ZStack {
            ears
                .offset(y: -44)

            Circle()
                .fill(color)
                .frame(width: 124, height: 112)

            if !isShadow {
                HStack(spacing: 30) {
                    SoftAnimalEye(size: 10)
                    SoftAnimalEye(size: 10)
                }
                .offset(y: -14)

                Circle()
                    .fill(.white.opacity(0.85))
                    .frame(width: 42, height: 32)
                    .offset(y: 18)

                Circle()
                    .fill(Color(red: 0.34, green: 0.25, blue: 0.18).opacity(0.62))
                    .frame(width: 8, height: 6)
                    .offset(y: 10)
            }
        }
    }

    @ViewBuilder
    private var ears: some View {
        switch ear {
        case .triangle:
            HStack(spacing: 48) {
                Triangle().fill(color).frame(width: 44, height: 42)
                Triangle().fill(color).frame(width: 44, height: 42)
            }
        case .floppy:
            HStack(spacing: 60) {
                Capsule().fill(color).frame(width: 34, height: 70).rotationEffect(.degrees(26))
                Capsule().fill(color).frame(width: 34, height: 70).rotationEffect(.degrees(-26))
            }
        case .round:
            HStack(spacing: 56) {
                Circle().fill(color).frame(width: 48, height: 48)
                Circle().fill(color).frame(width: 48, height: 48)
            }
        case .long:
            HStack(spacing: 38) {
                Capsule().fill(color).frame(width: 28, height: 86).rotationEffect(.degrees(-8))
                Capsule().fill(color).frame(width: 28, height: 86).rotationEffect(.degrees(8))
            }
        }
    }
}

private struct FrogFace: View {
    let color: Color
    let isShadow: Bool

    var body: some View {
        ZStack {
            HStack(spacing: 32) {
                Circle().fill(color).frame(width: 54, height: 54)
                Circle().fill(color).frame(width: 54, height: 54)
            }
            .offset(y: -48)

            Circle()
                .fill(color)
                .frame(width: 126, height: 112)

            if !isShadow {
                HStack(spacing: 40) {
                    Circle().fill(.white.opacity(0.92)).frame(width: 24, height: 24).overlay(SoftAnimalEye(size: 8))
                    Circle().fill(.white.opacity(0.92)).frame(width: 24, height: 24).overlay(SoftAnimalEye(size: 8))
                }
                .offset(y: -48)

                MouthView(isHappy: false)
                    .stroke(Color(red: 0.34, green: 0.25, blue: 0.18).opacity(0.66), style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .frame(width: 54, height: 26)
                    .offset(y: 18)
            }
        }
    }
}

private struct DuckShape: View {
    let color: Color
    let isShadow: Bool

    var body: some View {
        ZStack {
            Ellipse()
                .fill(color)
                .frame(width: 128, height: 92)
                .offset(y: 18)

            Circle()
                .fill(color)
                .frame(width: 76, height: 76)
                .offset(x: -36, y: -34)

            if !isShadow {
                SoftAnimalEye(size: 8).offset(x: -48, y: -44)
                Capsule().fill(.orange).frame(width: 42, height: 18).offset(x: -82, y: -26)
            }
        }
    }
}

private struct AppleShape: View {
    let color: Color
    let isShadow: Bool

    var body: some View {
        ZStack {
            Circle()
                .fill(color)
                .frame(width: 116, height: 110)

            Circle()
                .fill(color)
                .frame(width: 86, height: 92)
                .offset(x: -26, y: 8)

            Circle()
                .fill(color)
                .frame(width: 86, height: 92)
                .offset(x: 26, y: 8)

            Capsule()
                .fill(isShadow ? color : .brown)
                .frame(width: 14, height: 42)
                .rotationEffect(.degrees(16))
                .offset(y: -64)
        }
    }
}

private struct FishShape: View {
    let color: Color
    let isShadow: Bool

    var body: some View {
        ZStack {
            Ellipse()
                .fill(color)
                .frame(width: 122, height: 78)

            Triangle()
                .fill(color)
                .frame(width: 52, height: 58)
                .rotationEffect(.degrees(90))
                .offset(x: 72)

            if !isShadow {
                SoftAnimalEye(size: 8)
                    .offset(x: -36, y: -10)
            }
        }
    }
}

private struct SoftAnimalEye: View {
    let size: CGFloat

    var body: some View {
        Circle()
            .fill(Color(red: 0.34, green: 0.25, blue: 0.18).opacity(0.82))
            .frame(width: size, height: size)
            .overlay(
                Circle()
                    .fill(.white.opacity(0.86))
                    .frame(width: size * 0.34, height: size * 0.34)
                    .offset(x: -size * 0.18, y: -size * 0.18)
            )
    }
}

private struct StarShape: View {
    let color: Color
    let isShadow: Bool

    var body: some View {
        GeometryReader { proxy in
            let length = min(proxy.size.width, proxy.size.height)

            Image(systemName: "star.fill")
                .font(.system(size: length * 0.78, weight: .heavy))
                .foregroundStyle(color)
                .shadow(color: isShadow ? .clear : .yellow.opacity(0.2), radius: length * 0.07)
                .frame(width: proxy.size.width, height: proxy.size.height)
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

private enum ShapeSymbolKind {
    case circle
    case square
    case triangle
    case heart
    case rectangle
    case oval
    case diamond
}

private struct ShapeSymbol: View {
    let kind: ShapeSymbolKind
    let color: Color
    let isShadow: Bool

    var body: some View {
        GeometryReader { proxy in
            let length = min(proxy.size.width, proxy.size.height)

            Group {
                switch kind {
                case .circle:
                    Circle()
                case .square:
                    RoundedRectangle(cornerRadius: length * 0.22)
                case .triangle:
                    Triangle()
                case .heart:
                    Image(systemName: "heart.fill")
                        .font(.system(size: length * 0.86, weight: .heavy))
                case .rectangle:
                    RoundedRectangle(cornerRadius: length * 0.15)
                        .frame(width: length * 0.96, height: length * 0.62)
                case .oval:
                    Ellipse()
                        .frame(width: length * 0.98, height: length * 0.70)
                case .diamond:
                    Rectangle()
                        .rotationEffect(.degrees(45))
                        .frame(width: length * 0.62, height: length * 0.62)
                }
            }
            .foregroundStyle(color)
            .frame(width: proxy.size.width, height: proxy.size.height)
            .shadow(color: isShadow ? .clear : color.opacity(0.18), radius: length * 0.07, y: length * 0.04)
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

private struct SymbolFriendShape: View {
    let kind: FriendKind
    let color: Color
    let isShadow: Bool

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 34)
                .fill(color.opacity(isShadow ? 1 : 0.16))
                .frame(width: 132, height: 132)

            Image(systemName: kind.symbolName)
                .font(.system(size: symbolSize, weight: .heavy, design: .rounded))
                .foregroundStyle(color)
                .symbolRenderingMode(.hierarchical)
                .scaleEffect(x: kind == .airplane ? -1 : 1, y: 1)

            if !isShadow {
                Text(kind.name)
                    .font(.system(size: 18, weight: .heavy, design: .rounded))
                    .foregroundStyle(Color(red: 0.35, green: 0.27, blue: 0.20).opacity(0.82))
                    .lineLimit(1)
                    .minimumScaleFactor(0.72)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(.white.opacity(0.70), in: Capsule())
                    .offset(y: 50)

                Circle()
                    .fill(.white.opacity(0.45))
                    .frame(width: 24, height: 24)
                    .offset(x: -38, y: -38)
            }
        }
        .shadow(color: isShadow ? .clear : color.opacity(0.18), radius: 12, y: 6)
    }

    private var symbolSize: CGFloat {
        switch kind.category {
        case .vehicle:
            return 74
        case .fruit, .clothing, .vegetable, .tableware, .object:
            return 78
        case .animal:
            return 76
        case .shape, .body:
            return 86
        }
    }
}

private struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

private struct SemiCircle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.maxY), control: CGPoint(x: rect.midX, y: rect.minY))
        path.closeSubpath()
        return path
    }
}

struct SparkleBurst: View {
    var body: some View {
        ZStack {
            ForEach(0..<6) { index in
                Image(systemName: "sparkle")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(.yellow)
                    .offset(
                        x: CGFloat(cos(Double(index) * .pi / 3) * 58),
                        y: CGFloat(sin(Double(index) * .pi / 3) * 58)
                    )
            }
        }
    }
}

#Preview("六六角色") {
    HStack(spacing: 32) {
        LiuliuMascot(mood: .waiting)
            .frame(width: 220, height: 260)
        LiuliuMascot(mood: .happy)
            .frame(width: 220, height: 260)
    }
    .padding()
    .background(BackgroundView())
}

#Preview("图标概念") {
    LiuliuAppIconConcept()
        .frame(width: 240, height: 240)
        .padding()
        .background(Color.white)
}
