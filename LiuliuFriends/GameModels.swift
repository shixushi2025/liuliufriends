import Foundation
import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

enum AppScreen: Equatable {
    case play
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

enum FriendCategory: String {
    case animal
    case vehicle
    case fruit
    case shape
    case object
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
        case .bird:
            return "啾啾"
        case .cow:
            return "哞哞"
        case .sheep:
            return "咩咩"
        case .horse:
            return "哒哒"
        case .pig:
            return "哼哼"
        case .monkey:
            return "吱吱"
        case .panda:
            return "慢慢"
        case .tiger:
            return "嗷呜"
        case .lion:
            return "吼吼"
        case .elephant:
            return "嘟嘟"
        case .turtle:
            return "爬爬"
        case .bee:
            return "嗡嗡"
        case .butterfly:
            return "飞飞"
        case .car:
            return "嘀嘀"
        case .bus:
            return "巴巴"
        case .train:
            return "呜呜"
        case .truck:
            return "轰轰"
        case .airplane:
            return "呼呼"
        case .boat:
            return "哗哗"
        case .bicycle:
            return "叮叮"
        case .fireTruck:
            return "呜啦"
        case .ambulance:
            return "滴嘟"
        case .tractor:
            return "突突"
        case .rocket:
            return "咻咻"
        case .banana:
            return "弯弯"
        case .orange:
            return "圆圆"
        case .pear:
            return "甜甜"
        case .strawberry:
            return "红红"
        case .watermelon:
            return "大大"
        case .grape:
            return "串串"
        case .peach:
            return "软软"
        case .pineapple:
            return "刺刺"
        case .cherry:
            return "小小"
        case .lemon:
            return "酸酸"
        case .rectangle:
            return "长长"
        case .oval:
            return "扁扁"
        case .diamond:
            return "闪闪"
        case .moon:
            return "弯月"
        case .flower:
            return "花花"
        case .tree:
            return "树树"
        case .sun:
            return "暖暖"
        case .cloud:
            return "飘飘"
        case .umbrella:
            return "哒哒"
        case .ball:
            return "拍拍"
        case .book:
            return "翻翻"
        case .cup:
            return "喝水"
        }
    }

    var category: FriendCategory {
        switch self {
        case .cat, .dog, .duck, .bear, .rabbit, .frog, .fish, .bird, .cow, .sheep, .horse, .pig, .monkey, .panda, .tiger, .lion, .elephant, .turtle, .bee, .butterfly:
            return .animal
        case .car, .bus, .train, .truck, .airplane, .boat, .bicycle, .fireTruck, .ambulance, .tractor, .rocket:
            return .vehicle
        case .apple, .banana, .orange, .pear, .strawberry, .watermelon, .grape, .peach, .pineapple, .cherry, .lemon:
            return .fruit
        case .circle, .square, .triangle, .star, .heart, .rectangle, .oval, .diamond, .moon:
            return .shape
        case .balloon, .flower, .tree, .sun, .cloud, .umbrella, .ball, .book, .cup:
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
        case .circle, .square, .triangle, .star, .heart:
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
        case .rectangle:
            return "ShapeRectangleArt"
        case .oval:
            return "ShapeOvalArt"
        case .diamond:
            return "ShapeDiamondArt"
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

    var promptSpeechText: String {
        switch mode {
        case .animal:
            return "找\(targetKind.name)"
        case .sound:
            return targetKind.soundText
        case .color:
            return "找\(targetColor.speechName)"
        case .shape:
            return "找\(targetKind.name)"
        case .size:
            return "找一样大的\(targetKind.name)"
        case .shadow:
            return "找\(targetKind.name)的影子"
        }
    }

    var successSpeechText: String {
        switch mode {
        case .color:
            return "\(targetColor.speechName)，找到了"
        default:
            return "\(targetKind.name)，找到了"
        }
    }
}

struct GameSettings: Equatable {
    var soundEnabled: Bool = true
    var voicePromptEnabled: Bool = true
    var customVoiceEnabled: Bool = true
    var autoAdvanceEnabled: Bool = true
    var restReminderEnabled: Bool = true
    var eyeComfortEnabled: Bool = false
    var reducedMotion: Bool = false
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

private extension Color {
    var speechName: String {
        let knownColors: [(Color, String)] = [
            (Color(red: 1.0, green: 0.42, blue: 0.37), "红色"),
            (Color(red: 0.22, green: 0.65, blue: 0.94), "蓝色"),
            (Color(red: 0.14, green: 0.76, blue: 0.54), "绿色"),
            (Color(red: 1.0, green: 0.75, blue: 0.18), "黄色"),
            (Color(red: 0.61, green: 0.45, blue: 0.91), "紫色"),
            (Color(red: 1.0, green: 0.55, blue: 0.70), "粉色"),
            (Color(red: 0.38, green: 0.68, blue: 0.32), "绿色"),
            (Color(red: 0.98, green: 0.50, blue: 0.18), "橙色"),
            (Color(red: 0.70, green: 0.48, blue: 0.30), "棕色"),
            (Color(red: 0.92, green: 0.18, blue: 0.24), "红色"),
            (Color(red: 0.20, green: 0.72, blue: 0.78), "蓝绿色"),
            (Color(red: 0.72, green: 0.75, blue: 0.78), "灰色")
        ]

        let target = rgbaComponents
        return knownColors.min { first, second in
            colorDistance(target, first.0.rgbaComponents) < colorDistance(target, second.0.rgbaComponents)
        }?.1 ?? "这个颜色"
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

    func colorDistance(
        _ first: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat),
        _ second: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)
    ) -> CGFloat {
        abs(first.red - second.red) + abs(first.green - second.green) + abs(first.blue - second.blue)
    }
}
