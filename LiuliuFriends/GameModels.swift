import Foundation
import SwiftUI

enum GameMode: String, CaseIterable {
    case color
    case shadow
    case sound

    var title: String {
        switch self {
        case .color:
            return "颜色朋友"
        case .shadow:
            return "影子朋友"
        case .sound:
            return "声音朋友"
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
        }
    }
}

struct FriendCandidate: Identifiable {
    let id = UUID()
    let kind: FriendKind
    let color: Color
    let isCorrect: Bool
}

struct GameRound: Identifiable {
    let id = UUID()
    let mode: GameMode
    let targetKind: FriendKind
    let targetColor: Color
    let candidates: [FriendCandidate]
}
