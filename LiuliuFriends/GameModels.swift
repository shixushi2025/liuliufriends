import Foundation
import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

enum AppScreen: Equatable {
    case play
    case settings
}

enum LearningAgeBand: String, CaseIterable, Codable {
    case starter18Months
    case explorer24Months
    case matcher30Months
    case preschool36Months

    var order: Int {
        switch self {
        case .starter18Months:
            return 0
        case .explorer24Months:
            return 1
        case .matcher30Months:
            return 2
        case .preschool36Months:
            return 3
        }
    }

    func isIncluded(in maximumAgeBand: LearningAgeBand) -> Bool {
        order <= maximumAgeBand.order
    }

    var label: String {
        switch self {
        case .starter18Months:
            return "18m+"
        case .explorer24Months:
            return "24m+"
        case .matcher30Months:
            return "30m+"
        case .preschool36Months:
            return "36m+"
        }
    }

    var focus: String {
        switch self {
        case .starter18Months:
            return "看图识物、听声音、点选反馈"
        case .explorer24Months:
            return "颜色、形状、常见分类"
        case .matcher30Months:
            return "大小、影子、相似项辨别"
        case .preschool36Months:
            return "数字、节奏、儿歌、顺序认知"
        }
    }
}

enum FutureLearningModule: String, CaseIterable {
    case numbers
    case nurseryRhymes

    var recommendedAgeBand: LearningAgeBand {
        switch self {
        case .numbers, .nurseryRhymes:
            return .preschool36Months
        }
    }
}

enum GameMode: String, CaseIterable, Codable {
    case animal
    case sound
    case color
    case shape
    case body
    case clothing
    case vegetable
    case tableware
    case hygiene
    case home
    case stationery
    case size
    case shadow
    case count
    case quantityCompare
    case category
    case position
    case purpose
    case scene
    case weather
    case routine
    case emotion
    case action
    case texture
    case taste
    case pairing
    case opposite
    case rhythm
    case sequence
    case pattern
    case difference

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
        case .body:
            return "身体朋友"
        case .clothing:
            return "衣物朋友"
        case .vegetable:
            return "蔬菜朋友"
        case .tableware:
            return "餐具朋友"
        case .hygiene:
            return "卫生朋友"
        case .home:
            return "家居朋友"
        case .stationery:
            return "文具朋友"
        case .size:
            return "大小朋友"
        case .shadow:
            return "影子朋友"
        case .count:
            return "数量朋友"
        case .quantityCompare:
            return "多少朋友"
        case .category:
            return "分类朋友"
        case .position:
            return "位置朋友"
        case .purpose:
            return "用途朋友"
        case .scene:
            return "场景朋友"
        case .weather:
            return "天气朋友"
        case .routine:
            return "作息朋友"
        case .emotion:
            return "情绪朋友"
        case .action:
            return "动作朋友"
        case .texture:
            return "触感朋友"
        case .taste:
            return "味道朋友"
        case .pairing:
            return "搭配朋友"
        case .opposite:
            return "相反朋友"
        case .rhythm:
            return "节奏朋友"
        case .sequence:
            return "顺序朋友"
        case .pattern:
            return "规律朋友"
        case .difference:
            return "不同朋友"
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
        case .body:
            return "帮六六找身体部位"
        case .clothing:
            return "帮六六找穿戴的朋友"
        case .vegetable:
            return "帮六六找蔬菜朋友"
        case .tableware:
            return "帮六六找吃饭用的朋友"
        case .hygiene:
            return "帮六六找干净朋友"
        case .home:
            return "帮六六找家里的朋友"
        case .stationery:
            return "帮六六找学习用的朋友"
        case .size:
            return "帮六六找一样大的朋友"
        case .shadow:
            return "帮六六找这个影子"
        case .count:
            return "帮六六找一样多的朋友"
        case .quantityCompare:
            return "帮六六找多和少"
        case .category:
            return "帮六六找同一类朋友"
        case .position:
            return "帮六六找上下左右"
        case .purpose:
            return "帮六六找有用的朋友"
        case .scene:
            return "帮六六找在哪儿"
        case .weather:
            return "帮六六找天气朋友"
        case .routine:
            return "帮六六找每天做的事"
        case .emotion:
            return "帮六六找表情"
        case .action:
            return "帮六六找会怎么动"
        case .texture:
            return "帮六六找摸起来的感觉"
        case .taste:
            return "帮六六找尝起来的味道"
        case .pairing:
            return "帮六六找好搭档"
        case .opposite:
            return "帮六六找相反的朋友"
        case .rhythm:
            return "帮六六找节奏动作"
        case .sequence:
            return "帮六六找前后顺序"
        case .pattern:
            return "帮六六找下一个"
        case .difference:
            return "帮六六找不一样"
        }
    }

    var ageBand: LearningAgeBand {
        switch self {
        case .animal, .sound:
            return .starter18Months
        case .color, .shape, .body, .clothing, .vegetable, .tableware, .hygiene, .home, .stationery, .category, .position, .routine, .emotion:
            return .explorer24Months
        case .size, .shadow, .purpose, .scene, .weather, .action, .texture, .taste, .pairing, .opposite, .difference:
            return .matcher30Months
        case .count, .quantityCompare, .rhythm, .sequence, .pattern:
            return .preschool36Months
        }
    }

    var ageLabel: String {
        ageBand.label
    }

    var settingsGroupTitle: String {
        switch self {
        case .animal, .sound, .color, .shape, .body, .clothing, .vegetable, .tableware, .hygiene, .home, .stationery:
            return "基础识物"
        case .category, .routine, .emotion, .purpose, .scene, .weather, .action, .texture, .taste, .pairing, .opposite:
            return "生活关系"
        case .size, .shadow, .position, .difference:
            return "观察匹配"
        case .count, .quantityCompare, .rhythm, .sequence, .pattern:
            return "进阶思维"
        }
    }

    static let settingsGroupOrder = [
        "基础识物",
        "生活关系",
        "观察匹配",
        "进阶思维"
    ]

    var usesNeutralBackground: Bool {
        switch self {
        case .color, .shape, .body, .clothing, .vegetable, .tableware, .hygiene, .home, .stationery, .size, .shadow, .count, .quantityCompare, .category, .position, .purpose, .scene, .weather, .routine, .emotion, .action, .texture, .taste, .pairing, .opposite, .rhythm, .sequence, .pattern, .difference:
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
        case .body:
            return Color(red: 0.96, green: 0.46, blue: 0.54)
        case .clothing:
            return Color(red: 0.36, green: 0.55, blue: 0.90)
        case .vegetable:
            return Color(red: 0.28, green: 0.70, blue: 0.38)
        case .tableware:
            return Color(red: 0.26, green: 0.62, blue: 0.80)
        case .hygiene:
            return Color(red: 0.28, green: 0.68, blue: 0.76)
        case .home:
            return Color(red: 0.76, green: 0.52, blue: 0.34)
        case .stationery:
            return Color(red: 0.52, green: 0.47, blue: 0.88)
        case .size:
            return Color(red: 0.61, green: 0.45, blue: 0.91)
        case .shadow:
            return Color(red: 0.31, green: 0.27, blue: 0.23)
        case .count:
            return Color(red: 0.98, green: 0.54, blue: 0.16)
        case .quantityCompare:
            return Color(red: 0.92, green: 0.50, blue: 0.20)
        case .category:
            return Color(red: 0.14, green: 0.66, blue: 0.54)
        case .position:
            return Color(red: 0.36, green: 0.55, blue: 0.95)
        case .purpose:
            return Color(red: 0.96, green: 0.48, blue: 0.20)
        case .scene:
            return Color(red: 0.18, green: 0.63, blue: 0.74)
        case .weather:
            return Color(red: 0.27, green: 0.58, blue: 0.92)
        case .routine:
            return Color(red: 0.88, green: 0.52, blue: 0.24)
        case .emotion:
            return Color(red: 0.94, green: 0.42, blue: 0.58)
        case .action:
            return Color(red: 0.45, green: 0.48, blue: 0.92)
        case .texture:
            return Color(red: 0.74, green: 0.50, blue: 0.34)
        case .taste:
            return Color(red: 0.93, green: 0.42, blue: 0.38)
        case .pairing:
            return Color(red: 0.22, green: 0.64, blue: 0.58)
        case .opposite:
            return Color(red: 0.96, green: 0.46, blue: 0.30)
        case .rhythm:
            return Color(red: 0.90, green: 0.42, blue: 0.74)
        case .sequence:
            return Color(red: 0.40, green: 0.62, blue: 0.92)
        case .pattern:
            return Color(red: 0.54, green: 0.50, blue: 0.88)
        case .difference:
            return Color(red: 0.18, green: 0.60, blue: 0.58)
        }
    }
}

enum SpatialPosition: String, CaseIterable {
    case top
    case bottom
    case left
    case right

    var name: String {
        switch self {
        case .top:
            return "上面"
        case .bottom:
            return "下面"
        case .left:
            return "左边"
        case .right:
            return "右边"
        }
    }
}

enum FriendPurpose: String, CaseIterable {
    case drink
    case read
    case rain
    case fly
    case ride
    case eat
    case play
    case plant

    var promptTitle: String {
        switch self {
        case .drink:
            return "喝水"
        case .read:
            return "看书"
        case .rain:
            return "遮雨"
        case .fly:
            return "飞上天"
        case .ride:
            return "坐车"
        case .eat:
            return "吃水果"
        case .play:
            return "玩一玩"
        case .plant:
            return "种在土里"
        }
    }

    var speechTitle: String {
        switch self {
        case .drink:
            return "可以喝水的"
        case .read:
            return "可以看书的"
        case .rain:
            return "可以遮雨的"
        case .fly:
            return "会飞上天的"
        case .ride:
            return "可以坐的车"
        case .eat:
            return "可以吃的水果"
        case .play:
            return "可以玩的"
        case .plant:
            return "种在土里的"
        }
    }

    var iconName: String {
        switch self {
        case .drink:
            return "drop.fill"
        case .read:
            return "book.fill"
        case .rain:
            return "umbrella.fill"
        case .fly:
            return "airplane"
        case .ride:
            return "bus.fill"
        case .eat:
            return "fork.knife"
        case .play:
            return "gamecontroller.fill"
        case .plant:
            return "leaf.fill"
        }
    }
}

enum FriendScene: String, CaseIterable {
    case sea
    case sky
    case road
    case home
    case garden
    case rainyDay

    var promptTitle: String {
        switch self {
        case .sea:
            return "海里"
        case .sky:
            return "天空"
        case .road:
            return "路上"
        case .home:
            return "家里"
        case .garden:
            return "花园"
        case .rainyDay:
            return "雨天"
        }
    }

    var speechTitle: String {
        switch self {
        case .sea:
            return "在海里的"
        case .sky:
            return "在天空的"
        case .road:
            return "在路上的"
        case .home:
            return "在家里的"
        case .garden:
            return "在花园里的"
        case .rainyDay:
            return "雨天用的"
        }
    }

    var iconName: String {
        switch self {
        case .sea:
            return "drop.fill"
        case .sky:
            return "cloud.sun.fill"
        case .road:
            return "car.fill"
        case .home:
            return "house.fill"
        case .garden:
            return "leaf.fill"
        case .rainyDay:
            return "cloud.rain.fill"
        }
    }
}

enum FriendWeather: String, CaseIterable {
    case sunny
    case rainy
    case cloudy
    case windy

    var promptTitle: String {
        switch self {
        case .sunny:
            return "晴天"
        case .rainy:
            return "雨天"
        case .cloudy:
            return "多云"
        case .windy:
            return "有风"
        }
    }

    var speechTitle: String {
        switch self {
        case .sunny:
            return "晴天的"
        case .rainy:
            return "雨天用的"
        case .cloudy:
            return "云朵多的"
        case .windy:
            return "会被风吹的"
        }
    }

    var iconName: String {
        switch self {
        case .sunny:
            return "sun.max.fill"
        case .rainy:
            return "cloud.rain.fill"
        case .cloudy:
            return "cloud.fill"
        case .windy:
            return "wind"
        }
    }
}

enum FriendRoutine: String, CaseIterable {
    case morning
    case drinkWater
    case reading
    case playing
    case goingOut
    case bedtime

    var promptTitle: String {
        switch self {
        case .morning:
            return "早上"
        case .drinkWater:
            return "喝水"
        case .reading:
            return "看书"
        case .playing:
            return "玩耍"
        case .goingOut:
            return "出门"
        case .bedtime:
            return "睡觉"
        }
    }

    var speechTitle: String {
        switch self {
        case .morning:
            return "早上看到的"
        case .drinkWater:
            return "喝水用的"
        case .reading:
            return "看书用的"
        case .playing:
            return "玩的时候用的"
        case .goingOut:
            return "出门坐的"
        case .bedtime:
            return "睡觉前看到的"
        }
    }

    var iconName: String {
        switch self {
        case .morning:
            return "sunrise.fill"
        case .drinkWater:
            return "drop.fill"
        case .reading:
            return "book.fill"
        case .playing:
            return "figure.play"
        case .goingOut:
            return "car.fill"
        case .bedtime:
            return "moon.fill"
        }
    }
}

enum FriendEmotion: String, CaseIterable {
    case happy
    case calm
    case encouraged

    var promptTitle: String {
        switch self {
        case .happy:
            return "开心"
        case .calm:
            return "安静"
        case .encouraged:
            return "加油"
        }
    }

    var speechTitle: String {
        switch self {
        case .happy:
            return "开心的表情"
        case .calm:
            return "安静的表情"
        case .encouraged:
            return "加油的表情"
        }
    }

    var iconName: String {
        switch self {
        case .happy:
            return "face.smiling.fill"
        case .calm:
            return "moon.stars.fill"
        case .encouraged:
            return "hands.sparkles.fill"
        }
    }
}

enum FriendAction: String, CaseIterable {
    case fly
    case swim
    case roll
    case jump
    case drive
    case grow

    var promptTitle: String {
        switch self {
        case .fly:
            return "会飞"
        case .swim:
            return "会游"
        case .roll:
            return "会滚"
        case .jump:
            return "会跳"
        case .drive:
            return "会开走"
        case .grow:
            return "会长大"
        }
    }

    var speechTitle: String {
        switch self {
        case .fly:
            return "会飞的"
        case .swim:
            return "会游的"
        case .roll:
            return "会滚的"
        case .jump:
            return "会跳的"
        case .drive:
            return "会开走的"
        case .grow:
            return "会长大的"
        }
    }

    var iconName: String {
        switch self {
        case .fly:
            return "bird.fill"
        case .swim:
            return "water.waves"
        case .roll:
            return "circle.dashed"
        case .jump:
            return "figure.jump"
        case .drive:
            return "car.fill"
        case .grow:
            return "leaf.fill"
        }
    }
}

enum FriendQuantityCompare: String, CaseIterable {
    case more
    case fewer

    var promptTitle: String {
        switch self {
        case .more:
            return "多的"
        case .fewer:
            return "少的"
        }
    }

    var speechTitle: String {
        promptTitle
    }

    var iconName: String {
        switch self {
        case .more:
            return "plus.circle.fill"
        case .fewer:
            return "minus.circle.fill"
        }
    }
}

enum FriendTexture: String, CaseIterable {
    case soft
    case hard
    case smooth
    case rough

    var promptTitle: String {
        switch self {
        case .soft:
            return "软软的"
        case .hard:
            return "硬硬的"
        case .smooth:
            return "滑滑的"
        case .rough:
            return "粗粗的"
        }
    }

    var speechTitle: String {
        promptTitle
    }

    var iconName: String {
        switch self {
        case .soft:
            return "circle.fill"
        case .hard:
            return "cube.fill"
        case .smooth:
            return "sparkles"
        case .rough:
            return "circle.grid.cross.fill"
        }
    }
}

enum FriendTaste: String, CaseIterable {
    case sweet
    case sour
    case juicy
    case bland

    var promptTitle: String {
        switch self {
        case .sweet:
            return "甜甜的"
        case .sour:
            return "酸酸的"
        case .juicy:
            return "多汁的"
        case .bland:
            return "淡淡的"
        }
    }

    var speechTitle: String {
        promptTitle
    }

    var iconName: String {
        switch self {
        case .sweet:
            return "heart.fill"
        case .sour:
            return "sparkles"
        case .juicy:
            return "drop.fill"
        case .bland:
            return "circle.dotted"
        }
    }
}

enum FriendPairing: String, CaseIterable {
    case beeFlower
    case butterflyFlower
    case monkeyBanana
    case umbrellaCloud
    case fishBoat
    case cupBook

    var cueKind: FriendKind {
        switch self {
        case .beeFlower:
            return .bee
        case .butterflyFlower:
            return .butterfly
        case .monkeyBanana:
            return .monkey
        case .umbrellaCloud:
            return .umbrella
        case .fishBoat:
            return .fish
        case .cupBook:
            return .cup
        }
    }

    var answerKind: FriendKind {
        switch self {
        case .beeFlower, .butterflyFlower:
            return .flower
        case .monkeyBanana:
            return .banana
        case .umbrellaCloud:
            return .cloud
        case .fishBoat:
            return .boat
        case .cupBook:
            return .book
        }
    }

    var distractorKind: FriendKind {
        switch self {
        case .beeFlower:
            return .truck
        case .butterflyFlower:
            return .cup
        case .monkeyBanana:
            return .umbrella
        case .umbrellaCloud:
            return .apple
        case .fishBoat:
            return .car
        case .cupBook:
            return .ball
        }
    }

    var promptTitle: String {
        "\(cueKind.name)的好搭档"
    }

    var speechTitle: String {
        "\(cueKind.name)的好搭档"
    }
}

enum FriendOpposite: String, CaseIterable {
    case dayNight
    case upDown
    case hotCold
    case fullEmpty
    case openClosed
    case fastSlow

    var promptTitle: String {
        switch self {
        case .dayNight:
            return "白天和夜晚"
        case .upDown:
            return "上面和下面"
        case .hotCold:
            return "热和冷"
        case .fullEmpty:
            return "满满和空空"
        case .openClosed:
            return "打开和关上"
        case .fastSlow:
            return "快和慢"
        }
    }

    var speechTitle: String {
        switch self {
        case .dayNight:
            return "夜晚的朋友"
        case .upDown:
            return "下面的朋友"
        case .hotCold:
            return "凉凉的朋友"
        case .fullEmpty:
            return "空空的朋友"
        case .openClosed:
            return "关上的朋友"
        case .fastSlow:
            return "慢慢的朋友"
        }
    }

    var cueTitle: String {
        switch self {
        case .dayNight:
            return "白天"
        case .upDown:
            return "上面"
        case .hotCold:
            return "热热"
        case .fullEmpty:
            return "满满"
        case .openClosed:
            return "打开"
        case .fastSlow:
            return "快快"
        }
    }

    var answerTitle: String {
        switch self {
        case .dayNight:
            return "夜晚"
        case .upDown:
            return "下面"
        case .hotCold:
            return "凉凉"
        case .fullEmpty:
            return "空空"
        case .openClosed:
            return "关上"
        case .fastSlow:
            return "慢慢"
        }
    }

    var cueIconName: String {
        switch self {
        case .dayNight:
            return "sun.max.fill"
        case .upDown:
            return "arrow.up.circle.fill"
        case .hotCold:
            return "flame.fill"
        case .fullEmpty:
            return "circle.fill"
        case .openClosed:
            return "lock.open.fill"
        case .fastSlow:
            return "hare.fill"
        }
    }

    var answerIconName: String {
        switch self {
        case .dayNight:
            return "moon.stars.fill"
        case .upDown:
            return "arrow.down.circle.fill"
        case .hotCold:
            return "snowflake"
        case .fullEmpty:
            return "circle"
        case .openClosed:
            return "lock.fill"
        case .fastSlow:
            return "tortoise.fill"
        }
    }
}

enum FriendRhythm: String, CaseIterable {
    case clap
    case step
    case shake
    case tap

    var promptTitle: String {
        switch self {
        case .clap:
            return "拍拍手"
        case .step:
            return "踏踏脚"
        case .shake:
            return "摇一摇"
        case .tap:
            return "敲一敲"
        }
    }

    var speechTitle: String {
        switch self {
        case .clap:
            return "拍拍手"
        case .step:
            return "踏踏脚"
        case .shake:
            return "摇一摇"
        case .tap:
            return "敲一敲"
        }
    }

    var iconName: String {
        switch self {
        case .clap:
            return "hand.raised.fill"
        case .step:
            return "figure.walk"
        case .shake:
            return "speaker.wave.2.fill"
        case .tap:
            return "music.note"
        }
    }
}

enum FriendSequence: String, CaseIterable {
    case first
    case second
    case last

    var promptTitle: String {
        switch self {
        case .first:
            return "第一个"
        case .second:
            return "第二个"
        case .last:
            return "最后一个"
        }
    }

    var speechTitle: String {
        switch self {
        case .first:
            return "第一个"
        case .second:
            return "第二个"
        case .last:
            return "最后一个"
        }
    }

    var iconName: String {
        switch self {
        case .first:
            return "1.circle.fill"
        case .second:
            return "2.circle.fill"
        case .last:
            return "3.circle.fill"
        }
    }

    var highlightedIndex: Int {
        switch self {
        case .first:
            return 0
        case .second:
            return 1
        case .last:
            return 2
        }
    }
}

enum FriendPattern: String, CaseIterable {
    case catDog
    case appleBanana
    case carBus
    case sunMoon
    case circleTriangle
    case flowerTree

    var promptTitle: String {
        "下一个"
    }

    var speechTitle: String {
        "下一个"
    }

    var sequencePrefix: [FriendKind] {
        switch self {
        case .catDog:
            return [.cat, .dog, .cat]
        case .appleBanana:
            return [.apple, .banana, .apple]
        case .carBus:
            return [.car, .bus, .car]
        case .sunMoon:
            return [.sun, .moon, .sun]
        case .circleTriangle:
            return [.circle, .triangle, .circle]
        case .flowerTree:
            return [.flower, .tree, .flower]
        }
    }

    var correctKind: FriendKind {
        switch self {
        case .catDog:
            return .dog
        case .appleBanana:
            return .banana
        case .carBus:
            return .bus
        case .sunMoon:
            return .moon
        case .circleTriangle:
            return .triangle
        case .flowerTree:
            return .tree
        }
    }

    var distractorKind: FriendKind {
        switch self {
        case .catDog:
            return .rabbit
        case .appleBanana:
            return .strawberry
        case .carBus:
            return .train
        case .sunMoon:
            return .cloud
        case .circleTriangle:
            return .square
        case .flowerTree:
            return .balloon
        }
    }
}

enum FriendCategory: String, CaseIterable {
    case animal
    case vehicle
    case fruit
    case shape
    case body
    case clothing
    case vegetable
    case tableware
    case hygiene
    case home
    case stationery
    case object

    var title: String {
        switch self {
        case .animal:
            return "动物"
        case .vehicle:
            return "车辆"
        case .fruit:
            return "水果"
        case .shape:
            return "形状"
        case .body:
            return "身体"
        case .clothing:
            return "衣物"
        case .vegetable:
            return "蔬菜"
        case .tableware:
            return "餐具"
        case .hygiene:
            return "卫生"
        case .home:
            return "家居"
        case .stationery:
            return "文具"
        case .object:
            return "生活"
        }
    }

    var childPromptTitle: String {
        switch self {
        case .animal:
            return "动物朋友"
        case .vehicle:
            return "车车朋友"
        case .fruit:
            return "水果朋友"
        case .shape:
            return "形状朋友"
        case .body:
            return "身体朋友"
        case .clothing:
            return "衣物朋友"
        case .vegetable:
            return "蔬菜朋友"
        case .tableware:
            return "餐具朋友"
        case .hygiene:
            return "卫生朋友"
        case .home:
            return "家居朋友"
        case .stationery:
            return "文具朋友"
        case .object:
            return "生活朋友"
        }
    }
}

enum VoicePromptGroup: String, CaseIterable {
    case color
    case animal
    case vehicle
    case fruit
    case shape
    case body
    case clothing
    case vegetable
    case tableware
    case hygiene
    case home
    case stationery
    case object

    var title: String {
        switch self {
        case .color:
            return "颜色"
        case .animal:
            return "动物"
        case .vehicle:
            return "车辆"
        case .fruit:
            return "水果"
        case .shape:
            return "形状"
        case .body:
            return "身体"
        case .clothing:
            return "衣物"
        case .vegetable:
            return "蔬菜"
        case .tableware:
            return "餐具"
        case .hygiene:
            return "卫生"
        case .home:
            return "家居"
        case .stationery:
            return "文具"
        case .object:
            return "生活"
        }
    }
}

struct VoicePromptTarget: Identifiable, Equatable {
    let id: String
    let name: String
    let group: VoicePromptGroup
    let kind: FriendKind?
    let color: Color?

    static func == (lhs: VoicePromptTarget, rhs: VoicePromptTarget) -> Bool {
        lhs.id == rhs.id
    }

    static var all: [VoicePromptTarget] {
        colorTargets + FriendKind.allCases.map { kind in
            VoicePromptTarget(
                id: kind.rawValue,
                name: kind.name,
                group: kind.voicePromptGroup,
                kind: kind,
                color: nil
            )
        }
    }

    static let defaultTarget = VoicePromptTarget(kind: .cat)

    init(kind: FriendKind) {
        id = kind.rawValue
        name = kind.name
        group = kind.voicePromptGroup
        self.kind = kind
        color = nil
    }

    private init(id: String, name: String, group: VoicePromptGroup, kind: FriendKind?, color: Color?) {
        self.id = id
        self.name = name
        self.group = group
        self.kind = kind
        self.color = color
    }

    static func target(for id: String) -> VoicePromptTarget {
        all.first { $0.id == id } ?? defaultTarget
    }

    static func targets(in group: VoicePromptGroup) -> [VoicePromptTarget] {
        all.filter { $0.group == group }
    }

    static func firstTarget(in group: VoicePromptGroup) -> VoicePromptTarget? {
        targets(in: group).first
    }

    static func target(for color: Color) -> VoicePromptTarget {
        let targetComponents = color.rgbaComponents
        return colorTargets.min { first, second in
            colorDistance(targetComponents, first.color?.rgbaComponents ?? (0, 0, 0, 1)) < colorDistance(targetComponents, second.color?.rgbaComponents ?? (0, 0, 0, 1))
        } ?? colorTargets[0]
    }

    static var colorTargets: [VoicePromptTarget] {
        [
            VoicePromptTarget(id: "color.red", name: "红色", group: .color, kind: nil, color: Color(red: 1.0, green: 0.42, blue: 0.37)),
            VoicePromptTarget(id: "color.blue", name: "蓝色", group: .color, kind: nil, color: Color(red: 0.22, green: 0.65, blue: 0.94)),
            VoicePromptTarget(id: "color.green", name: "绿色", group: .color, kind: nil, color: Color(red: 0.14, green: 0.76, blue: 0.54)),
            VoicePromptTarget(id: "color.yellow", name: "黄色", group: .color, kind: nil, color: Color(red: 1.0, green: 0.75, blue: 0.18)),
            VoicePromptTarget(id: "color.purple", name: "紫色", group: .color, kind: nil, color: Color(red: 0.61, green: 0.45, blue: 0.91)),
            VoicePromptTarget(id: "color.pink", name: "粉色", group: .color, kind: nil, color: Color(red: 1.0, green: 0.55, blue: 0.70)),
            VoicePromptTarget(id: "color.orange", name: "橙色", group: .color, kind: nil, color: Color(red: 1.0, green: 0.60, blue: 0.02)),
            VoicePromptTarget(id: "color.brown", name: "棕色", group: .color, kind: nil, color: Color(red: 0.70, green: 0.48, blue: 0.30)),
            VoicePromptTarget(id: "color.aqua", name: "蓝绿色", group: .color, kind: nil, color: Color(red: 0.20, green: 0.72, blue: 0.78)),
            VoicePromptTarget(id: "color.gray", name: "灰色", group: .color, kind: nil, color: Color(red: 0.72, green: 0.75, blue: 0.78))
        ]
    }
}

enum LearningPromptTextCatalog {
    static func soundPrompt(for kind: FriendKind) -> String {
        recognizedSoundPrompts[kind] ?? kind.name
    }

    static func usesRecognizedSoundPrompt(_ kind: FriendKind) -> Bool {
        recognizedSoundPrompts[kind] != nil
    }

    static let configurablePromptGroups: [VoicePromptGroup] = VoicePromptGroup.allCases

    private static let recognizedSoundPrompts: [FriendKind: String] = [
        .cat: "喵喵",
        .dog: "汪汪",
        .duck: "嘎嘎",
        .frog: "呱呱",
        .bird: "啾啾",
        .cow: "哞哞",
        .sheep: "咩咩",
        .pig: "哼哼",
        .monkey: "吱吱",
        .tiger: "嗷呜",
        .lion: "吼吼",
        .bee: "嗡嗡",
        .car: "嘀嘀",
        .train: "呜呜",
        .truck: "轰轰",
        .bicycle: "叮叮",
        .fireTruck: "呜啦",
        .ambulance: "滴嘟",
        .tractor: "突突"
    ]
}

final class PromptAliasStore: ObservableObject {
    static let shared = PromptAliasStore()

    @Published private(set) var aliases: [String: String]

    private let defaults: UserDefaults
    private let aliasesKey = "liuliufriends.promptAliases"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        aliases = defaults.dictionary(forKey: aliasesKey) as? [String: String] ?? [:]
    }

    func displayName(for target: VoicePromptTarget) -> String {
        customName(for: target.id) ?? target.name
    }

    func displayName(for kind: FriendKind) -> String {
        customName(for: kind.rawValue) ?? kind.name
    }

    func soundPrompt(for kind: FriendKind) -> String {
        customName(for: kind.rawValue) ?? LearningPromptTextCatalog.soundPrompt(for: kind)
    }

    func customName(for id: String) -> String? {
        guard let value = aliases[id], !value.isEmpty else { return nil }
        return value
    }

    func setCustomName(_ name: String, for id: String) {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            aliases.removeValue(forKey: id)
        } else {
            aliases[id] = trimmed
        }
        defaults.set(aliases, forKey: aliasesKey)
    }

    func resetCustomName(for id: String) {
        aliases.removeValue(forKey: id)
        defaults.set(aliases, forKey: aliasesKey)
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
    case bird
    case cow
    case sheep
    case horse
    case pig
    case monkey
    case panda
    case tiger
    case lion
    case elephant
    case turtle
    case bee
    case butterfly
    case car
    case bus
    case train
    case truck
    case airplane
    case boat
    case bicycle
    case fireTruck
    case ambulance
    case tractor
    case rocket
    case banana
    case orange
    case pear
    case strawberry
    case watermelon
    case grape
    case peach
    case pineapple
    case cherry
    case lemon
    case rectangle
    case oval
    case diamond
    case moon
    case eye
    case ear
    case mouth
    case hand
    case foot
    case nose
    case hat
    case shirt
    case pants
    case shoes
    case socks
    case coat
    case carrot
    case corn
    case tomato
    case cucumber
    case mushroom
    case broccoli
    case bowl
    case spoon
    case plate
    case fork
    case chopsticks
    case bottle
    case toothbrush
    case toothpaste
    case towel
    case soap
    case bathtub
    case comb
    case chair
    case table
    case bed
    case sofa
    case lamp
    case clock
    case pencil
    case crayon
    case eraser
    case ruler
    case notebook
    case schoolbag
    case flower
    case tree
    case sun
    case cloud
    case umbrella
    case ball
    case book
    case cup

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
        case .bird:
            return "小鸟"
        case .cow:
            return "奶牛"
        case .sheep:
            return "绵羊"
        case .horse:
            return "小马"
        case .pig:
            return "小猪"
        case .monkey:
            return "猴子"
        case .panda:
            return "熊猫"
        case .tiger:
            return "老虎"
        case .lion:
            return "狮子"
        case .elephant:
            return "大象"
        case .turtle:
            return "乌龟"
        case .bee:
            return "蜜蜂"
        case .butterfly:
            return "蝴蝶"
        case .car:
            return "小车"
        case .bus:
            return "巴士"
        case .train:
            return "火车"
        case .truck:
            return "卡车"
        case .airplane:
            return "飞机"
        case .boat:
            return "小船"
        case .bicycle:
            return "自行车"
        case .fireTruck:
            return "消防车"
        case .ambulance:
            return "救护车"
        case .tractor:
            return "拖拉机"
        case .rocket:
            return "火箭"
        case .banana:
            return "香蕉"
        case .orange:
            return "橙子"
        case .pear:
            return "梨子"
        case .strawberry:
            return "草莓"
        case .watermelon:
            return "西瓜"
        case .grape:
            return "葡萄"
        case .peach:
            return "桃子"
        case .pineapple:
            return "菠萝"
        case .cherry:
            return "樱桃"
        case .lemon:
            return "柠檬"
        case .rectangle:
            return "长方形"
        case .oval:
            return "椭圆形"
        case .diamond:
            return "菱形"
        case .moon:
            return "月亮"
        case .eye:
            return "眼睛"
        case .ear:
            return "耳朵"
        case .mouth:
            return "嘴巴"
        case .hand:
            return "小手"
        case .foot:
            return "小脚"
        case .nose:
            return "鼻子"
        case .hat:
            return "帽子"
        case .shirt:
            return "衣服"
        case .pants:
            return "裤子"
        case .shoes:
            return "鞋子"
        case .socks:
            return "袜子"
        case .coat:
            return "外套"
        case .carrot:
            return "胡萝卜"
        case .corn:
            return "玉米"
        case .tomato:
            return "番茄"
        case .cucumber:
            return "黄瓜"
        case .mushroom:
            return "蘑菇"
        case .broccoli:
            return "西兰花"
        case .bowl:
            return "小碗"
        case .spoon:
            return "勺子"
        case .plate:
            return "盘子"
        case .fork:
            return "叉子"
        case .chopsticks:
            return "筷子"
        case .bottle:
            return "奶瓶"
        case .toothbrush:
            return "牙刷"
        case .toothpaste:
            return "牙膏"
        case .towel:
            return "毛巾"
        case .soap:
            return "香皂"
        case .bathtub:
            return "澡盆"
        case .comb:
            return "梳子"
        case .chair:
            return "椅子"
        case .table:
            return "桌子"
        case .bed:
            return "小床"
        case .sofa:
            return "沙发"
        case .lamp:
            return "台灯"
        case .clock:
            return "时钟"
        case .pencil:
            return "铅笔"
        case .crayon:
            return "蜡笔"
        case .eraser:
            return "橡皮"
        case .ruler:
            return "尺子"
        case .notebook:
            return "本子"
        case .schoolbag:
            return "书包"
        case .flower:
            return "花朵"
        case .tree:
            return "小树"
        case .sun:
            return "太阳"
        case .cloud:
            return "云朵"
        case .umbrella:
            return "雨伞"
        case .ball:
            return "皮球"
        case .book:
            return "图书"
        case .cup:
            return "杯子"
        }
    }

    var soundText: String {
        LearningPromptTextCatalog.soundPrompt(for: self)
    }

    var category: FriendCategory {
        switch self {
        case .cat, .dog, .duck, .bear, .rabbit, .frog, .fish, .bird, .cow, .sheep, .horse, .pig, .monkey, .panda, .tiger, .lion, .elephant, .turtle, .bee, .butterfly:
            return .animal
        case .car, .bus, .train, .truck, .airplane, .boat, .bicycle, .fireTruck, .ambulance, .tractor, .rocket:
            return .vehicle
        case .apple, .banana, .orange, .pear, .strawberry, .watermelon, .grape, .peach, .pineapple, .cherry, .lemon:
            return .fruit
        case .circle, .square, .triangle, .star, .heart, .rectangle, .oval, .diamond:
            return .shape
        case .eye, .ear, .mouth, .hand, .foot, .nose:
            return .body
        case .hat, .shirt, .pants, .shoes, .socks, .coat:
            return .clothing
        case .carrot, .corn, .tomato, .cucumber, .mushroom, .broccoli:
            return .vegetable
        case .bowl, .spoon, .plate, .fork, .chopsticks, .bottle:
            return .tableware
        case .toothbrush, .toothpaste, .towel, .soap, .bathtub, .comb:
            return .hygiene
        case .chair, .table, .bed, .sofa, .lamp, .clock:
            return .home
        case .pencil, .crayon, .eraser, .ruler, .notebook, .schoolbag:
            return .stationery
        case .balloon, .moon, .flower, .tree, .sun, .cloud, .umbrella, .ball, .book, .cup:
            return .object
        }
    }

    var voicePromptGroup: VoicePromptGroup {
        switch category {
        case .animal:
            return .animal
        case .vehicle:
            return .vehicle
        case .fruit:
            return .fruit
        case .shape:
            return .shape
        case .body:
            return .body
        case .clothing:
            return .clothing
        case .vegetable:
            return .vegetable
        case .tableware:
            return .tableware
        case .hygiene:
            return .hygiene
        case .home:
            return .home
        case .stationery:
            return .stationery
        case .object:
            return .object
        }
    }

    var symbolName: String {
        switch self {
        case .bird:
            return "bird.fill"
        case .cow:
            return "cow.fill"
        case .sheep:
            return "cloud.fill"
        case .horse:
            return "hare.fill"
        case .pig:
            return "circle.fill"
        case .monkey:
            return "figure.play"
        case .panda:
            return "circle.grid.cross.fill"
        case .tiger:
            return "pawprint.fill"
        case .lion:
            return "sun.max.fill"
        case .elephant:
            return "tortoise.fill"
        case .turtle:
            return "tortoise.fill"
        case .bee:
            return "ladybug.fill"
        case .butterfly:
            return "camera.macro"
        case .car:
            return "car.fill"
        case .bus:
            return "bus.fill"
        case .train:
            return "tram.fill"
        case .truck:
            return "truck.box.fill"
        case .airplane:
            return "airplane"
        case .boat:
            return "sailboat.fill"
        case .bicycle:
            return "bicycle"
        case .fireTruck:
            return "firetruck.fill"
        case .ambulance:
            return "cross.case.fill"
        case .tractor:
            return "tractor.fill"
        case .rocket:
            return "rocket.fill"
        case .banana:
            return "moon.fill"
        case .orange:
            return "circle.fill"
        case .pear:
            return "drop.fill"
        case .strawberry:
            return "heart.fill"
        case .watermelon:
            return "circle.lefthalf.filled"
        case .grape:
            return "circle.grid.3x3.fill"
        case .peach:
            return "heart.circle.fill"
        case .pineapple:
            return "oval.portrait.fill"
        case .cherry:
            return "circle.grid.2x2.fill"
        case .lemon:
            return "oval.fill"
        case .rectangle:
            return "rectangle.fill"
        case .oval:
            return "oval.fill"
        case .diamond:
            return "diamond.fill"
        case .moon:
            return "moon.fill"
        case .eye:
            return "eye.fill"
        case .ear:
            return "ear.fill"
        case .mouth:
            return "mouth.fill"
        case .hand:
            return "hand.raised.fill"
        case .foot:
            return "shoeprints.fill"
        case .nose:
            return "triangle.fill"
        case .hat:
            return "graduationcap.fill"
        case .shirt:
            return "tshirt.fill"
        case .pants:
            return "rectangle.split.2x1.fill"
        case .shoes:
            return "shoe.2.fill"
        case .socks:
            return "rectangle.roundedtop.fill"
        case .coat:
            return "person.crop.square.filled.and.at.rectangle.fill"
        case .carrot:
            return "carrot.fill"
        case .corn:
            return "leaf.fill"
        case .tomato:
            return "circle.fill"
        case .cucumber:
            return "capsule.fill"
        case .mushroom:
            return "circle.bottomhalf.filled"
        case .broccoli:
            return "tree.fill"
        case .bowl:
            return "circle.bottomhalf.filled"
        case .spoon:
            return "capsule.fill"
        case .plate:
            return "circle.fill"
        case .fork:
            return "fork.knife.circle.fill"
        case .chopsticks:
            return "line.3.horizontal"
        case .bottle:
            return "capsule.portrait.fill"
        case .toothbrush:
            return "rectangle.fill"
        case .toothpaste:
            return "capsule.fill"
        case .towel:
            return "rectangle.fill"
        case .soap:
            return "capsule.fill"
        case .bathtub:
            return "rectangle.fill"
        case .comb:
            return "line.3.horizontal"
        case .chair:
            return "chair.fill"
        case .table:
            return "table.furniture.fill"
        case .bed:
            return "bed.double.fill"
        case .sofa:
            return "sofa.fill"
        case .lamp:
            return "lamp.desk.fill"
        case .clock:
            return "clock.fill"
        case .pencil:
            return "pencil"
        case .crayon:
            return "pencil.tip"
        case .eraser:
            return "capsule.fill"
        case .ruler:
            return "ruler.fill"
        case .notebook:
            return "book.closed.fill"
        case .schoolbag:
            return "bag.fill"
        case .flower:
            return "camera.macro"
        case .tree:
            return "tree.fill"
        case .sun:
            return "sun.max.fill"
        case .cloud:
            return "cloud.fill"
        case .umbrella:
            return "umbrella.fill"
        case .ball:
            return "circle.grid.cross.fill"
        case .book:
            return "book.fill"
        case .cup:
            return "cup.and.saucer.fill"
        default:
            return "circle.fill"
        }
    }

    var imageAssetName: String? {
        switch self {
        case .balloon:
            return "ObjectBalloonArt"
        case .cat:
            return "AnimalCatArt"
        case .dog:
            return "AnimalDogArt"
        case .duck:
            return "AnimalDuckArt"
        case .bear:
            return "AnimalBearArt"
        case .rabbit:
            return "AnimalRabbitArt"
        case .frog:
            return "AnimalFrogArt"
        case .apple:
            return "ObjectAppleArt"
        case .fish:
            return "AnimalFishArt"
        case .circle, .square, .triangle, .star, .heart, .rectangle, .oval, .diamond, .eye, .ear, .mouth, .hand, .foot, .nose, .hat, .shirt, .pants, .shoes, .socks, .coat, .carrot, .corn, .tomato, .cucumber, .mushroom, .broccoli, .bowl, .spoon, .plate, .fork, .chopsticks, .bottle, .toothbrush, .toothpaste, .towel, .soap, .bathtub, .comb, .chair, .table, .bed, .sofa, .lamp, .clock, .pencil, .crayon, .eraser, .ruler, .notebook, .schoolbag:
            return nil
        case .bird:
            return "AnimalBirdArt"
        case .cow:
            return "AnimalCowArt"
        case .sheep:
            return "AnimalSheepArt"
        case .horse:
            return "AnimalHorseArt"
        case .pig:
            return "AnimalPigArt"
        case .monkey:
            return "AnimalMonkeyArt"
        case .panda:
            return "AnimalPandaArt"
        case .tiger:
            return "AnimalTigerArt"
        case .lion:
            return "AnimalLionArt"
        case .elephant:
            return "AnimalElephantArt"
        case .turtle:
            return "AnimalTurtleArt"
        case .bee:
            return "AnimalBeeArt"
        case .butterfly:
            return "AnimalButterflyArt"
        case .car:
            return "VehicleCarArt"
        case .bus:
            return "VehicleBusArt"
        case .train:
            return "VehicleTrainArt"
        case .truck:
            return "VehicleTruckArt"
        case .airplane:
            return "VehicleAirplaneArt"
        case .boat:
            return "VehicleBoatArt"
        case .bicycle:
            return "VehicleBicycleArt"
        case .fireTruck:
            return "VehicleFireTruckArt"
        case .ambulance:
            return "VehicleAmbulanceArt"
        case .tractor:
            return "VehicleTractorArt"
        case .rocket:
            return "VehicleRocketArt"
        case .banana:
            return "FruitBananaArt"
        case .orange:
            return "FruitOrangeArt"
        case .pear:
            return "FruitPearArt"
        case .strawberry:
            return "FruitStrawberryArt"
        case .watermelon:
            return "FruitWatermelonArt"
        case .grape:
            return "FruitGrapeArt"
        case .peach:
            return "FruitPeachArt"
        case .pineapple:
            return "FruitPineappleArt"
        case .cherry:
            return "FruitCherryArt"
        case .lemon:
            return "FruitLemonArt"
        case .moon:
            return "ShapeMoonArt"
        case .flower:
            return "ObjectFlowerArt"
        case .tree:
            return "ObjectTreeArt"
        case .sun:
            return "ObjectSunArt"
        case .cloud:
            return "ObjectCloudArt"
        case .umbrella:
            return "ObjectUmbrellaArt"
        case .ball:
            return "ObjectBallArt"
        case .book:
            return "ObjectBookArt"
        case .cup:
            return "ObjectCupArt"
        }
    }

    var isAnimal: Bool {
        category == .animal
    }

    var isShapeSymbol: Bool {
        category == .shape
    }
}

struct FriendCandidate: Identifiable {
    let id: UUID
    let kind: FriendKind
    let color: Color
    let isCorrect: Bool
    let sizeScale: CGFloat
    let count: Int
    let position: SpatialPosition
    let emotion: FriendEmotion?
    let opposite: FriendOpposite?
    let rhythm: FriendRhythm?
    let sequence: FriendSequence?

    init(id: UUID = UUID(), kind: FriendKind, color: Color, isCorrect: Bool, sizeScale: CGFloat = 1, count: Int = 1, position: SpatialPosition = .top, emotion: FriendEmotion? = nil, opposite: FriendOpposite? = nil, rhythm: FriendRhythm? = nil, sequence: FriendSequence? = nil) {
        self.id = id
        self.kind = kind
        self.color = color
        self.isCorrect = isCorrect
        self.sizeScale = sizeScale
        self.count = count
        self.position = position
        self.emotion = emotion
        self.opposite = opposite
        self.rhythm = rhythm
        self.sequence = sequence
    }
}

struct GameRound: Identifiable {
    let id: UUID
    let mode: GameMode
    let targetKind: FriendKind
    let targetColor: Color
    let targetSizeScale: CGFloat
    let targetCount: Int
    let targetQuantityCompare: FriendQuantityCompare?
    let targetCategory: FriendCategory?
    let targetPosition: SpatialPosition
    let targetPurpose: FriendPurpose?
    let targetScene: FriendScene?
    let targetWeather: FriendWeather?
    let targetRoutine: FriendRoutine?
    let targetEmotion: FriendEmotion?
    let targetAction: FriendAction?
    let targetTexture: FriendTexture?
    let targetTaste: FriendTaste?
    let targetPairing: FriendPairing?
    let targetOpposite: FriendOpposite?
    let targetRhythm: FriendRhythm?
    let targetSequence: FriendSequence?
    let targetPattern: FriendPattern?
    let candidates: [FriendCandidate]

    init(
        id: UUID = UUID(),
        mode: GameMode,
        targetKind: FriendKind,
        targetColor: Color,
        targetSizeScale: CGFloat = 1,
        targetCount: Int = 1,
        targetQuantityCompare: FriendQuantityCompare? = nil,
        targetCategory: FriendCategory? = nil,
        targetPosition: SpatialPosition = .top,
        targetPurpose: FriendPurpose? = nil,
        targetScene: FriendScene? = nil,
        targetWeather: FriendWeather? = nil,
        targetRoutine: FriendRoutine? = nil,
        targetEmotion: FriendEmotion? = nil,
        targetAction: FriendAction? = nil,
        targetTexture: FriendTexture? = nil,
        targetTaste: FriendTaste? = nil,
        targetPairing: FriendPairing? = nil,
        targetOpposite: FriendOpposite? = nil,
        targetRhythm: FriendRhythm? = nil,
        targetSequence: FriendSequence? = nil,
        targetPattern: FriendPattern? = nil,
        candidates: [FriendCandidate]
    ) {
        self.id = id
        self.mode = mode
        self.targetKind = targetKind
        self.targetColor = targetColor
        self.targetSizeScale = targetSizeScale
        self.targetCount = targetCount
        self.targetQuantityCompare = targetQuantityCompare
        self.targetCategory = targetCategory
        self.targetPosition = targetPosition
        self.targetPurpose = targetPurpose
        self.targetScene = targetScene
        self.targetWeather = targetWeather
        self.targetRoutine = targetRoutine
        self.targetEmotion = targetEmotion
        self.targetAction = targetAction
        self.targetTexture = targetTexture
        self.targetTaste = targetTaste
        self.targetPairing = targetPairing
        self.targetOpposite = targetOpposite
        self.targetRhythm = targetRhythm
        self.targetSequence = targetSequence
        self.targetPattern = targetPattern
        self.candidates = candidates
    }

    var promptSpeechText: String {
        switch mode {
        case .animal:
            return "找\(targetKind.name)"
        case .sound:
            return "找\(targetKind.soundText)"
        case .color:
            return "找\(targetColor.speechName)"
        case .shape:
            return "找\(targetKind.name)"
        case .body:
            return "找\(targetKind.name)"
        case .clothing:
            return "找\(targetKind.name)"
        case .vegetable:
            return "找\(targetKind.name)"
        case .tableware:
            return "找\(targetKind.name)"
        case .hygiene:
            return "找\(targetKind.name)"
        case .home:
            return "找\(targetKind.name)"
        case .stationery:
            return "找\(targetKind.name)"
        case .size:
            return "找一样大的\(targetKind.name)"
        case .shadow:
            return "找\(targetKind.name)的影子"
        case .count:
            return "找\(targetCount.cnNumberName)个\(targetKind.name)"
        case .quantityCompare:
            return "找\(targetQuantityCompare?.speechTitle ?? "多的")"
        case .category:
            return "找\(targetCategory?.childPromptTitle ?? targetKind.category.childPromptTitle)"
        case .position:
            return "找在\(targetPosition.name)的\(targetKind.name)"
        case .purpose:
            return "找\(targetPurpose?.speechTitle ?? targetKind.name)"
        case .scene:
            return "找\(targetScene?.speechTitle ?? targetKind.name)"
        case .weather:
            return "找\(targetWeather?.speechTitle ?? targetKind.name)"
        case .routine:
            return "找\(targetRoutine?.speechTitle ?? targetKind.name)"
        case .emotion:
            return "找\(targetEmotion?.speechTitle ?? targetKind.name)"
        case .action:
            return "找\(targetAction?.speechTitle ?? targetKind.name)"
        case .texture:
            return "找\(targetTexture?.speechTitle ?? targetKind.name)"
        case .taste:
            return "找\(targetTaste?.speechTitle ?? targetKind.name)"
        case .pairing:
            return "找\(targetPairing?.speechTitle ?? targetKind.name)"
        case .opposite:
            return "找\(targetOpposite?.speechTitle ?? targetKind.name)"
        case .rhythm:
            return "找\(targetRhythm?.speechTitle ?? targetKind.name)"
        case .sequence:
            return "找\(targetSequence?.speechTitle ?? targetKind.name)"
        case .pattern:
            return "找\(targetPattern?.speechTitle ?? targetKind.name)"
        case .difference:
            return "找不一样的"
        }
    }

    var successSpeechText: String {
        switch mode {
        case .color:
            return "\(targetColor.speechName)，找到了"
        case .body:
            return "\(targetKind.name)，找到了"
        case .clothing:
            return "\(targetKind.name)，找到了"
        case .vegetable:
            return "\(targetKind.name)，找到了"
        case .tableware:
            return "\(targetKind.name)，找到了"
        case .hygiene:
            return "\(targetKind.name)，找到了"
        case .home:
            return "\(targetKind.name)，找到了"
        case .stationery:
            return "\(targetKind.name)，找到了"
        case .count:
            return "\(targetCount.cnNumberName)个\(targetKind.name)，找到了"
        case .quantityCompare:
            return "\(targetQuantityCompare?.promptTitle ?? "多的")，找到了"
        case .category:
            return "\(targetKind.name)，是\(targetKind.category.childPromptTitle)"
        case .position:
            return "\(targetKind.name)在\(targetPosition.name)，找到了"
        case .purpose:
            return "\(targetKind.name)，\(targetPurpose?.speechTitle ?? "找到了")"
        case .scene:
            return "\(targetKind.name)，找到了"
        case .weather:
            return "\(targetKind.name)，找到了"
        case .routine:
            return "\(targetKind.name)，找到了"
        case .emotion:
            return "\(targetEmotion?.promptTitle ?? targetKind.name)，找到了"
        case .action:
            return "\(targetKind.name)，找到了"
        case .texture:
            return "\(targetKind.name)，摸起来\(targetTexture?.promptTitle ?? "找到了")"
        case .taste:
            return "\(targetKind.name)，尝起来\(targetTaste?.promptTitle ?? "找到了")"
        case .pairing:
            return "\(targetKind.name)，是好搭档"
        case .opposite:
            return "\(targetOpposite?.answerTitle ?? targetKind.name)，找到了"
        case .rhythm:
            return "\(targetRhythm?.promptTitle ?? targetKind.name)，找到了"
        case .sequence:
            return "\(targetSequence?.promptTitle ?? targetKind.name)，找到了"
        case .pattern:
            return "\(targetKind.name)，找到了"
        case .difference:
            return "\(targetKind.name)，不一样"
        default:
            return "\(targetKind.name)，找到了"
        }
    }

    var voicePromptID: String {
        switch mode {
        case .color:
            return VoicePromptTarget.target(for: targetColor).id
        default:
            return targetKind.rawValue
        }
    }
}

struct GameSettings: Equatable, Codable {
    var soundEnabled: Bool = true
    var voicePromptEnabled: Bool = true
    var customVoiceEnabled: Bool = false
    var customPromptAliasEnabled: Bool = false
    var autoAdvanceEnabled: Bool = true
    var restReminderEnabled: Bool = true
    var eyeComfortEnabled: Bool = true
    var reducedMotion: Bool = false
    var maximumAgeBand: LearningAgeBand = .preschool36Months
    var enabledGameModes: Set<GameMode> = Set(GameMode.allCases)
}

struct ReviewRound: Equatable {
    let roundID: UUID
    let availableAfterCompletedRounds: Int
}

enum SelectionResult: Equatable {
    case correct
    case retry
    case ignored
}

enum BreakReminder: Equatable {
    case sessionLimit
    case dailyLimit

    var title: String {
        switch self {
        case .sessionLimit:
            return "休息一下"
        case .dailyLimit:
            return "今天先到这里"
        }
    }

    var message: String {
        switch self {
        case .sessionLimit:
            return "已经连续玩了一会儿，看看远处、喝口水，再继续。"
        case .dailyLimit:
            return "今天的启蒙时间已经不少了，建议换成亲子阅读或户外活动。"
        }
    }
}

extension Color {
    var speechName: String {
        VoicePromptTarget.target(for: self).name
    }

    var rgbaComponents: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        #if canImport(UIKit)
        let uiColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (red, green, blue, alpha)
        #else
        return (0, 0, 0, 1)
        #endif
    }

}

func colorDistance(
    _ first: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat),
    _ second: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)
) -> CGFloat {
    abs(first.red - second.red) + abs(first.green - second.green) + abs(first.blue - second.blue)
}

extension Int {
    var cnNumberName: String {
        switch self {
        case 1:
            return "一"
        case 2:
            return "二"
        case 3:
            return "三"
        case 4:
            return "四"
        case 5:
            return "五"
        case 6:
            return "六"
        case 7:
            return "七"
        case 8:
            return "八"
        case 9:
            return "九"
        default:
            return "\(self)"
        }
    }
}
