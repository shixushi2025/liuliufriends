import Foundation
import SwiftUI

struct BackgroundView: View {
    var body: some View {
        LinearGradient(
            colors: [
                Color(red: 1.0, green: 0.96, blue: 0.88),
                Color(red: 0.88, green: 0.96, blue: 1.0)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
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
        ZStack {
            Ellipse()
                .fill(.black.opacity(0.08))
                .frame(width: 160, height: 28)
                .offset(y: 122)

            HStack(spacing: 96) {
                Capsule()
                    .fill(Color(red: 1.0, green: 0.82, blue: 0.54))
                    .frame(width: 36, height: 86)
                    .rotationEffect(.degrees(mood == .happy ? -34 : -20))
                Capsule()
                    .fill(Color(red: 1.0, green: 0.82, blue: 0.54))
                    .frame(width: 36, height: 86)
                    .rotationEffect(.degrees(mood == .happy ? 34 : 20))
            }
            .offset(y: 28)

            Ellipse()
                .fill(Color(red: 1.0, green: 0.82, blue: 0.54))
                .frame(width: 170, height: 190)
                .offset(y: 22)

            Circle()
                .fill(Color(red: 1.0, green: 0.88, blue: 0.68))
                .frame(width: 150, height: 150)
                .offset(y: -42)

            HStack(spacing: 54) {
                EarView()
                EarView()
            }
            .frame(width: 180, height: 46)
            .offset(y: -78)

            HairTuft()
                .stroke(Color(red: 0.35, green: 0.22, blue: 0.14), style: StrokeStyle(lineWidth: 5, lineCap: .round))
                .frame(width: 44, height: 28)
                .offset(y: -120)

            HStack(spacing: 30) {
                EyeView(isHappy: mood == .happy)
                EyeView(isHappy: mood == .happy)
            }
            .offset(y: -48)

            DudouView()
                .offset(y: 46)

            MouthView(isHappy: mood == .happy)
                .stroke(.black.opacity(0.55), style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .frame(width: 40, height: 22)
                .offset(y: -18)

            HStack(spacing: 112) {
                Circle()
                    .fill(Color(red: 1.0, green: 0.74, blue: 0.62))
                    .frame(width: 18, height: 18)
                Circle()
                    .fill(Color(red: 1.0, green: 0.74, blue: 0.62))
                    .frame(width: 18, height: 18)
            }
            .offset(y: -28)
        }
    }
}

struct LiuliuAppIconConcept: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 1.0, green: 0.93, blue: 0.78),
                            Color(red: 0.76, green: 0.91, blue: 1.0)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            Circle()
                .fill(.white.opacity(0.58))
                .frame(width: 156, height: 156)
                .offset(y: 2)

            LiuliuMascot(mood: .happy)
                .frame(width: 156, height: 184)
                .offset(y: 20)
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

private struct EarView: View {
    var body: some View {
        Circle()
            .fill(Color(red: 1.0, green: 0.88, blue: 0.68))
            .frame(width: 46, height: 46)
            .overlay(
                Circle()
                    .fill(Color(red: 1.0, green: 0.77, blue: 0.58))
                    .frame(width: 25, height: 25)
            )
    }
}

private struct EyeView: View {
    let isHappy: Bool

    var body: some View {
        if isHappy {
            Path { path in
                path.move(to: CGPoint(x: 0, y: 8))
                path.addQuadCurve(to: CGPoint(x: 20, y: 8), control: CGPoint(x: 10, y: 20))
            }
            .stroke(.black.opacity(0.75), style: StrokeStyle(lineWidth: 4, lineCap: .round))
            .frame(width: 20, height: 20)
        } else {
            Circle()
                .fill(.black.opacity(0.75))
                .frame(width: 14, height: 14)
                .overlay(
                    Circle()
                        .fill(.white.opacity(0.8))
                        .frame(width: 4, height: 4)
                        .offset(x: -3, y: -3)
                )
        }
    }
}

private struct DudouView: View {
    var body: some View {
        ZStack {
            Capsule()
                .fill(Color(red: 0.95, green: 0.26, blue: 0.24))
                .frame(width: 86, height: 112)

            Circle()
                .stroke(.white.opacity(0.86), lineWidth: 4)
                .frame(width: 34, height: 34)
                .offset(y: 14)

            HStack(spacing: 70) {
                Path { path in
                    path.move(to: CGPoint(x: 0, y: 0))
                    path.addLine(to: CGPoint(x: 28, y: 40))
                }
                .stroke(Color(red: 0.85, green: 0.16, blue: 0.16), style: StrokeStyle(lineWidth: 7, lineCap: .round))

                Path { path in
                    path.move(to: CGPoint(x: 28, y: 0))
                    path.addLine(to: CGPoint(x: 0, y: 40))
                }
                .stroke(Color(red: 0.85, green: 0.16, blue: 0.16), style: StrokeStyle(lineWidth: 7, lineCap: .round))
            }
            .frame(width: 116, height: 42)
            .offset(y: -58)
        }
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
