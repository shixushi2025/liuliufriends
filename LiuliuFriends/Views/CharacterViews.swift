import Foundation
import SwiftUI

struct BackgroundView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 1.0, green: 0.91, blue: 0.66),
                    Color(red: 0.78, green: 0.94, blue: 1.0),
                    Color(red: 0.93, green: 0.84, blue: 1.0)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            Circle()
                .fill(Color(red: 1.0, green: 0.34, blue: 0.25).opacity(0.18))
                .frame(width: 420, height: 420)
                .blur(radius: 42)
                .offset(x: -180, y: -260)

            Circle()
                .fill(Color(red: 0.18, green: 0.50, blue: 1.0).opacity(0.16))
                .frame(width: 520, height: 520)
                .blur(radius: 54)
                .offset(x: 210, y: 260)
        }
        .ignoresSafeArea()
    }
}

enum LiuliuMood {
    case waiting
    case happy
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
        ZStack {
            PendantCord()
                .stroke(Color(red: 0.24, green: 0.17, blue: 0.12), style: StrokeStyle(lineWidth: 5, lineCap: .round))
                .frame(width: 56, height: 46)
                .offset(y: -82)

            RoundedRectangle(cornerRadius: 34)
                .fill(.white.opacity(0.72))
                .frame(width: 132, height: 156)
                .rotationEffect(.degrees(-4))
                .shadow(color: Color(red: 0.62, green: 0.25, blue: 0.08).opacity(0.18), radius: 22, y: 12)

            BeanFace(isHappy: mood == .happy)
                .frame(width: 118, height: 118)
                .offset(y: -18)

            DudouView()
                .scaleEffect(0.54)
                .offset(y: 55)

            Text("六六")
                .font(.system(size: 18, weight: .black, design: .rounded))
                .foregroundStyle(.white)
                .offset(y: 66)
        }
        .frame(width: 150, height: 190)
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
        ZStack {
            RoundedRectangle(cornerRadius: 44)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 1.0, green: 0.70, blue: 0.23),
                            Color(red: 0.98, green: 0.20, blue: 0.20),
                            Color(red: 0.20, green: 0.53, blue: 1.0)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            Circle()
                .fill(.white.opacity(0.34))
                .frame(width: 178, height: 178)

            LiuliuPendant(mood: .happy)
                .frame(width: 170, height: 210)
                .offset(y: 10)
        }
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
        if isHappy {
            Path { path in
                path.move(to: CGPoint(x: 0, y: 10))
                path.addQuadCurve(to: CGPoint(x: 24, y: 10), control: CGPoint(x: 12, y: 22))
            }
            .stroke(Color(red: 0.18, green: 0.15, blue: 0.12).opacity(0.8), style: StrokeStyle(lineWidth: 4.5, lineCap: .round))
            .frame(width: 24, height: 22)
        } else {
            Circle()
                .fill(Color(red: 0.18, green: 0.15, blue: 0.12).opacity(0.86))
                .frame(width: 17, height: 17)
                .overlay(
                    Circle()
                        .fill(.white.opacity(0.9))
                        .frame(width: 5, height: 5)
                        .offset(x: -4, y: -4)
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
            Circle()
                .fill(color.opacity(0.25))
                .overlay(Circle().stroke(color, lineWidth: 8))

            Image(systemName: "heart.fill")
                .font(.system(size: 46, weight: .bold))
                .foregroundStyle(color)
        }
    }
}

struct SoundBubble: View {
    let text: String

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(red: 0.78, green: 0.93, blue: 1.0))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.white, lineWidth: 4)
                )

            VStack(spacing: 10) {
                Image(systemName: "speaker.wave.2.fill")
                    .font(.system(size: 40, weight: .bold))
                Text(text)
                    .font(.system(size: 34, weight: .heavy, design: .rounded))
            }
            .foregroundStyle(Color(red: 0.1, green: 0.34, blue: 0.58))
        }
    }
}

struct FriendShape: View {
    let kind: FriendKind
    let color: Color
    let isShadow: Bool

    var body: some View {
        ZStack {
            switch kind {
            case .balloon:
                BalloonShape(color: color, isShadow: isShadow)
            case .cat:
                AnimalFace(color: color, ear: .triangle, isShadow: isShadow)
            case .dog:
                AnimalFace(color: color, ear: .floppy, isShadow: isShadow)
            case .duck:
                DuckShape(color: color, isShadow: isShadow)
            case .bear:
                AnimalFace(color: color, ear: .round, isShadow: isShadow)
            case .apple:
                AppleShape(color: color, isShadow: isShadow)
            case .fish:
                FishShape(color: color, isShadow: isShadow)
            case .star:
                StarShape(color: color, isShadow: isShadow)
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
                    Circle().fill(.black.opacity(0.75)).frame(width: 12, height: 12)
                    Circle().fill(.black.opacity(0.75)).frame(width: 12, height: 12)
                }
                .offset(y: -14)

                Circle()
                    .fill(.white.opacity(0.85))
                    .frame(width: 42, height: 32)
                    .offset(y: 18)

                Circle()
                    .fill(.black.opacity(0.65))
                    .frame(width: 10, height: 8)
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
                Circle().fill(.black.opacity(0.75)).frame(width: 10, height: 10).offset(x: -48, y: -44)
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
                Circle()
                    .fill(.black.opacity(0.75))
                    .frame(width: 10, height: 10)
                    .offset(x: -36, y: -10)
            }
        }
    }
}

private struct StarShape: View {
    let color: Color
    let isShadow: Bool

    var body: some View {
        Image(systemName: "star.fill")
            .font(.system(size: 118, weight: .heavy))
            .foregroundStyle(color)
            .shadow(color: isShadow ? .clear : .yellow.opacity(0.2), radius: 8)
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
