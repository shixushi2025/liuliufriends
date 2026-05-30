import Foundation
import SwiftUI

enum AppScreen: Equatable {
    case play
    case parent
    case settings
}

enum GameMode: String, CaseIterable {
    case animal
    case sound
    case color
    case shape
    case size
    case shadow

    var title: String {
        switch self {
        case .animal:
            return "动物朋友"
        case .sound:
            return "声音朋友"
        case .color:
            return "颜色朋友"
        case .shape:
            return "形状朋友"
        case .size:
            return "大小朋友"
        case .shadow:
            return "影子朋友"
        }
    }

    var prompt: String {
        switch self {
        case .animal:
            return "帮六六找动物朋友"
        case .sound:
            return "听声音找朋友"
        case .color:
            return "帮六六找一样的颜色"
        case .shape:
            return "帮六六找一样的形状"
        case .size:
            return "帮六六找一样大的朋友"
        case .shadow:
            return "帮六六找这个影子"
        }
    }

    var ageLabel: String {
        switch self {
        case .animal, .sound:
            return "18m+"
        case .color, .shape:
            return "24m+"
        case .size, .shadow:
            return "30m+"
        }
    }

    var usesNeutralBackground: Bool {
        switch self {
        case .color, .shape, .size, .shadow:
            return true
        case .animal, .sound:
            return false
        }
    }

    var accentColor: Color {
        switch self {
        case .animal:
            return Color(red: 1.0, green: 0.42, blue: 0.34)
        case .sound:
            return Color(red: 0.22, green: 0.65, blue: 0.94)
        case .color:
            return Color(red: 1.0, green: 0.42, blue: 0.37)
        case .shape:
            return Color(red: 0.24, green: 0.65, blue: 0.94)
        case .size:
            return Color(red: 0.61, green: 0.45, blue: 0.91)
        case .shadow:
            return Color(red: 0.31, green: 0.27, blue: 0.23)
        }
    }
}

enum FriendKind: String, CaseIterable, Identifiable {
    case balloon
    case cat
    case dog
    case duck
    case bear
    case rabbit
    case frog
    case apple
    case fish
    case circle
    case square
    case triangle
    case star
    case heart

    var id: String { rawValue }

    var name: String {
        switch self {
        case .balloon:
            return "气球"
        case .cat:
            return "小猫"
        case .dog:
            return "小狗"
        case .duck:
            return "小鸭"
        case .bear:
            return "小熊"
        case .rabbit:
            return "小兔"
        case .frog:
            return "小蛙"
        case .apple:
            return "苹果"
        case .fish:
            return "小鱼"
        case .circle:
            return "圆形"
        case .square:
            return "方形"
        case .triangle:
            return "三角形"
        case .star:
            return "星星"
        case .heart:
            return "爱心"
        }
    }

    var soundText: String {
        switch self {
        case .cat:
            return "喵喵"
        case .dog:
            return "汪汪"
        case .duck:
            return "嘎嘎"
        case .bear:
            return "抱抱"
        case .rabbit:
            return "跳跳"
        case .frog:
            return "呱呱"
        case .balloon:
            return "啵啵"
        case .apple:
            return "咚咚"
        case .fish:
            return "咕噜"
        case .circle:
            return "圆圆"
        case .square:
            return "方方"
        case .triangle:
            return "尖尖"
        case .star:
            return "亮亮"
        case .heart:
            return "爱心"
        }
    }

    var isAnimal: Bool {
        switch self {
        case .cat, .dog, .duck, .bear, .rabbit, .frog:
            return true
        default:
            return false
        }
    }

    var isShapeSymbol: Bool {
        switch self {
        case .circle, .square, .triangle, .star, .heart:
            return true
        default:
            return false
        }
    }
}

struct FriendCandidate: Identifiable {
    let id: UUID
    let kind: FriendKind
    let color: Color
    let isCorrect: Bool
    let sizeScale: CGFloat

    init(id: UUID = UUID(), kind: FriendKind, color: Color, isCorrect: Bool, sizeScale: CGFloat = 1) {
        self.id = id
        self.kind = kind
        self.color = color
        self.isCorrect = isCorrect
        self.sizeScale = sizeScale
    }
}

struct GameRound: Identifiable {
    let id: UUID
    let mode: GameMode
    let targetKind: FriendKind
    let targetColor: Color
    let targetSizeScale: CGFloat
    let candidates: [FriendCandidate]

    init(
        id: UUID = UUID(),
        mode: GameMode,
        targetKind: FriendKind,
        targetColor: Color,
        targetSizeScale: CGFloat = 1,
        candidates: [FriendCandidate]
    ) {
        self.id = id
        self.mode = mode
        self.targetKind = targetKind
        self.targetColor = targetColor
        self.targetSizeScale = targetSizeScale
        self.candidates = candidates
    }
}

struct GameSettings: Equatable {
    var soundEnabled: Bool = true
    var voicePromptEnabled: Bool = true
    var autoAdvanceEnabled: Bool = true
    var reducedMotion: Bool = false
}

enum SelectionResult: Equatable {
    case correct
    case retry
    case ignored
}
