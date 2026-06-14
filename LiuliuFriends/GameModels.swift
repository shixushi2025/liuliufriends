import Foundation
import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

enum AppScreen: Equatable {
    case play
    case settings
}

enum LearningAgeBand: String, CaseIterable {
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

enum GameMode: String, CaseIterable {
    case animal
    case sound
    case color
    case shape
    case size
    case shadow
    case count
    case category
    case position
    case purpose
    case scene
    case weather
    case routine
    case emotion
    case action

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
        case .count:
            return "数量朋友"
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
        case .count:
            return "帮六六找一样多的朋友"
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
        }
    }

    var ageBand: LearningAgeBand {
        switch self {
        case .animal, .sound:
            return .starter18Months
        case .color, .shape, .category, .position, .routine, .emotion:
            return .explorer24Months
        case .size, .shadow, .purpose, .scene, .weather, .action:
            return .matcher30Months
        case .count:
            return .preschool36Months
        }
    }

    var ageLabel: String {
        ageBand.label
    }

    var usesNeutralBackground: Bool {
        switch self {
        case .color, .shape, .size, .shadow, .count, .category, .position, .purpose, .scene, .weather, .routine, .emotion, .action:
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
        case .count:
            return Color(red: 0.98, green: 0.54, blue: 0.16)
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

enum FriendCategory: String, CaseIterable {
    case animal
    case vehicle
    case fruit
    case shape
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
        case .circle, .square, .triangle, .star, .heart, .rectangle, .oval, .diamond:
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

    init(id: UUID = UUID(), kind: FriendKind, color: Color, isCorrect: Bool, sizeScale: CGFloat = 1, count: Int = 1, position: SpatialPosition = .top, emotion: FriendEmotion? = nil) {
        self.id = id
        self.kind = kind
        self.color = color
        self.isCorrect = isCorrect
        self.sizeScale = sizeScale
        self.count = count
        self.position = position
        self.emotion = emotion
    }
}

struct GameRound: Identifiable {
    let id: UUID
    let mode: GameMode
    let targetKind: FriendKind
    let targetColor: Color
    let targetSizeScale: CGFloat
    let targetCount: Int
    let targetCategory: FriendCategory?
    let targetPosition: SpatialPosition
    let targetPurpose: FriendPurpose?
    let targetScene: FriendScene?
    let targetWeather: FriendWeather?
    let targetRoutine: FriendRoutine?
    let targetEmotion: FriendEmotion?
    let targetAction: FriendAction?
    let candidates: [FriendCandidate]

    init(
        id: UUID = UUID(),
        mode: GameMode,
        targetKind: FriendKind,
        targetColor: Color,
        targetSizeScale: CGFloat = 1,
        targetCount: Int = 1,
        targetCategory: FriendCategory? = nil,
        targetPosition: SpatialPosition = .top,
        targetPurpose: FriendPurpose? = nil,
        targetScene: FriendScene? = nil,
        targetWeather: FriendWeather? = nil,
        targetRoutine: FriendRoutine? = nil,
        targetEmotion: FriendEmotion? = nil,
        targetAction: FriendAction? = nil,
        candidates: [FriendCandidate]
    ) {
        self.id = id
        self.mode = mode
        self.targetKind = targetKind
        self.targetColor = targetColor
        self.targetSizeScale = targetSizeScale
        self.targetCount = targetCount
        self.targetCategory = targetCategory
        self.targetPosition = targetPosition
        self.targetPurpose = targetPurpose
        self.targetScene = targetScene
        self.targetWeather = targetWeather
        self.targetRoutine = targetRoutine
        self.targetEmotion = targetEmotion
        self.targetAction = targetAction
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
        case .size:
            return "找一样大的\(targetKind.name)"
        case .shadow:
            return "找\(targetKind.name)的影子"
        case .count:
            return "找\(targetCount.cnNumberName)个\(targetKind.name)"
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
        }
    }

    var successSpeechText: String {
        switch mode {
        case .color:
            return "\(targetColor.speechName)，找到了"
        case .count:
            return "\(targetCount.cnNumberName)个\(targetKind.name)，找到了"
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

struct GameSettings: Equatable {
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
