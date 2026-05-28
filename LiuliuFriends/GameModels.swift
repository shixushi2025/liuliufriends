import Foundation
import SwiftUI

enum AppScreen: Equatable {
    case play
    case parent
    case settings
}

enum GameMode: String, CaseIterable {
    case color
    case shadow
    case sound
    case size

    var title: String {
        switch self {
        case .color:
            return "颜色朋友"
        case .shadow:
            return "影子朋友"
        case .sound:
            return "声音朋友"
        case .size:
            return "大小朋友"
        }
    }

    var prompt: String {
        switch self {
        case .color:
            return "帮六六找一样的颜色"
        case .shadow:
            return "帮小伙伴找影子"
        case .sound:
            return "听一听，找朋友"
        case .size:
            return "帮小伙伴找合适的家"
        }
    }
}

enum FriendKind: String, CaseIterable, Identifiable {
    case balloon
    case cat
    case dog
    case duck
    case bear
    case apple
    case fish
    case star

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
        case .apple:
            return "苹果"
        case .fish:
            return "小鱼"
        case .star:
            return "星星"
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
        case .balloon:
            return "啵啵"
        case .apple:
            return "咚咚"
        case .fish:
            return "咕噜"
        case .star:
            return "亮亮"
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
