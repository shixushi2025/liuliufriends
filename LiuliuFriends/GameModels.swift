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
    case vehicle
    case fruit
    case sound
    case color
    case shape
    case colorShape
    case body
    case sense
    case clothing
    case vegetable
    case food
    case tableware
    case hygiene
    case home
    case stationery
    case instrument
    case toy
    case nature
    case place
    case profession
    case size
    case length
    case height
    case shadow
    case number
    case count
    case quantityCompare
    case category
    case position
    case insideOutside
    case frontBack
    case distance
    case purpose
    case safety
    case habit
    case scene
    case samePlace
    case weather
    case season
    case routine
    case emotion
    case action
    case texture
    case temperature
    case brightness
    case weight
    case material
    case taste
    case pairing
    case animalHome
    case animalBaby
    case animalFood
    case itemHome
    case origin
    case opposite
    case rhythm
    case sequence
    case pattern
    case difference

    var title: String {
        switch self {
        case .animal:
            return "动物朋友"
        case .vehicle:
            return "交通朋友"
        case .fruit:
            return "水果朋友"
        case .sound:
            return "声音朋友"
        case .color:
            return "颜色朋友"
        case .shape:
            return "形状朋友"
        case .colorShape:
            return "颜色形状"
        case .body:
            return "身体朋友"
        case .sense:
            return "感官朋友"
        case .clothing:
            return "衣物朋友"
        case .vegetable:
            return "蔬菜朋友"
        case .food:
            return "食物朋友"
        case .tableware:
            return "餐具朋友"
        case .hygiene:
            return "卫生朋友"
        case .home:
            return "家居朋友"
        case .stationery:
            return "文具朋友"
        case .instrument:
            return "乐器朋友"
        case .toy:
            return "玩具朋友"
        case .nature:
            return "自然朋友"
        case .place:
            return "地点朋友"
        case .profession:
            return "职业朋友"
        case .size:
            return "大小朋友"
        case .length:
            return "长短朋友"
        case .height:
            return "高矮朋友"
        case .shadow:
            return "影子朋友"
        case .number:
            return "数字朋友"
        case .count:
            return "数量朋友"
        case .quantityCompare:
            return "多少朋友"
        case .category:
            return "分类朋友"
        case .position:
            return "位置朋友"
        case .insideOutside:
            return "里外朋友"
        case .frontBack:
            return "前后朋友"
        case .distance:
            return "远近朋友"
        case .purpose:
            return "用途朋友"
        case .safety:
            return "安全朋友"
        case .habit:
            return "好习惯朋友"
        case .scene:
            return "场景朋友"
        case .samePlace:
            return "同处朋友"
        case .weather:
            return "天气朋友"
        case .season:
            return "四季朋友"
        case .routine:
            return "作息朋友"
        case .emotion:
            return "情绪朋友"
        case .action:
            return "动作朋友"
        case .texture:
            return "触感朋友"
        case .temperature:
            return "温度朋友"
        case .brightness:
            return "明暗朋友"
        case .weight:
            return "轻重朋友"
        case .material:
            return "材料朋友"
        case .taste:
            return "味道朋友"
        case .pairing:
            return "搭配朋友"
        case .animalHome:
            return "动物家朋友"
        case .animalBaby:
            return "动物宝宝"
        case .animalFood:
            return "动物食物"
        case .itemHome:
            return "物品回家"
        case .origin:
            return "来源朋友"
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
        case .vehicle:
            return "帮六六找交通工具"
        case .fruit:
            return "帮六六找水果朋友"
        case .sound:
            return "听声音找朋友"
        case .color:
            return "帮六六找一样的颜色"
        case .shape:
            return "帮六六找一样的形状"
        case .colorShape:
            return "帮六六找颜色和形状"
        case .body:
            return "帮六六找身体部位"
        case .sense:
            return "帮六六找感官朋友"
        case .clothing:
            return "帮六六找穿戴的朋友"
        case .vegetable:
            return "帮六六找蔬菜朋友"
        case .food:
            return "帮六六找吃的朋友"
        case .tableware:
            return "帮六六找吃饭用的朋友"
        case .hygiene:
            return "帮六六找干净朋友"
        case .home:
            return "帮六六找家里的朋友"
        case .stationery:
            return "帮六六找学习用的朋友"
        case .instrument:
            return "帮六六找会唱歌的朋友"
        case .toy:
            return "帮六六找玩具朋友"
        case .nature:
            return "帮六六找自然朋友"
        case .place:
            return "帮六六找去哪里"
        case .profession:
            return "帮六六找谁在工作"
        case .size:
            return "帮六六找一样大的朋友"
        case .length:
            return "帮六六找长和短"
        case .height:
            return "帮六六找高和矮"
        case .shadow:
            return "帮六六找这个影子"
        case .number:
            return "帮六六找数字"
        case .count:
            return "帮六六找一样多的朋友"
        case .quantityCompare:
            return "帮六六找多和少"
        case .category:
            return "帮六六找同一类朋友"
        case .position:
            return "帮六六找上下左右"
        case .insideOutside:
            return "帮六六找里面外面"
        case .frontBack:
            return "帮六六找前面后面"
        case .distance:
            return "帮六六找远和近"
        case .purpose:
            return "帮六六找有用的朋友"
        case .safety:
            return "帮六六找可以碰的朋友"
        case .habit:
            return "帮六六找好习惯"
        case .scene:
            return "帮六六找在哪儿"
        case .samePlace:
            return "帮六六找常在一起的朋友"
        case .weather:
            return "帮六六找天气朋友"
        case .season:
            return "帮六六找四季朋友"
        case .routine:
            return "帮六六找每天做的事"
        case .emotion:
            return "帮六六找表情"
        case .action:
            return "帮六六找会怎么动"
        case .texture:
            return "帮六六找摸起来的感觉"
        case .temperature:
            return "帮六六找冷暖朋友"
        case .brightness:
            return "帮六六找亮暗朋友"
        case .weight:
            return "帮六六找轻重朋友"
        case .material:
            return "帮六六找什么做的"
        case .taste:
            return "帮六六找尝起来的味道"
        case .pairing:
            return "帮六六找好搭档"
        case .animalHome:
            return "帮六六找动物住哪里"
        case .animalBaby:
            return "帮六六找动物宝宝"
        case .animalFood:
            return "帮六六找动物吃什么"
        case .itemHome:
            return "帮六六找物品放哪里"
        case .origin:
            return "帮六六找从哪里来"
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
        case .vehicle, .fruit, .color, .shape, .body, .sense, .clothing, .vegetable, .food, .tableware, .hygiene, .home, .stationery, .instrument, .toy, .nature, .place, .profession, .category, .position, .insideOutside, .frontBack, .routine, .emotion:
            return .explorer24Months
        case .size, .length, .height, .shadow, .distance, .purpose, .safety, .habit, .scene, .samePlace, .weather, .season, .action, .texture, .temperature, .brightness, .weight, .material, .taste, .pairing, .animalHome, .animalBaby, .animalFood, .itemHome, .origin, .opposite, .difference:
            return .matcher30Months
        case .number, .count, .quantityCompare, .colorShape, .rhythm, .sequence, .pattern:
            return .preschool36Months
        }
    }

    var ageLabel: String {
        ageBand.label
    }

    var settingsGroupTitle: String {
        switch self {
        case .animal, .vehicle, .fruit, .sound, .color, .shape, .body, .sense, .clothing, .vegetable, .food, .tableware, .hygiene, .home, .stationery, .instrument, .toy, .nature, .place, .profession:
            return "基础识物"
        case .category, .routine, .emotion, .purpose, .safety, .habit, .scene, .samePlace, .weather, .season, .action, .texture, .temperature, .brightness, .weight, .material, .taste, .pairing, .animalHome, .animalBaby, .animalFood, .itemHome, .origin, .opposite:
            return "生活关系"
        case .size, .length, .height, .shadow, .position, .insideOutside, .frontBack, .distance, .difference:
            return "观察匹配"
        case .number, .count, .quantityCompare, .colorShape, .rhythm, .sequence, .pattern:
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
        case .vehicle, .fruit, .color, .shape, .colorShape, .body, .sense, .clothing, .vegetable, .food, .tableware, .hygiene, .home, .stationery, .instrument, .toy, .nature, .place, .profession, .size, .length, .height, .shadow, .number, .count, .quantityCompare, .category, .position, .insideOutside, .frontBack, .distance, .purpose, .safety, .habit, .scene, .samePlace, .weather, .season, .routine, .emotion, .action, .texture, .temperature, .brightness, .weight, .material, .taste, .pairing, .animalHome, .animalBaby, .animalFood, .itemHome, .origin, .opposite, .rhythm, .sequence, .pattern, .difference:
            return true
        case .animal, .sound:
            return false
        }
    }

    var accentColor: Color {
        switch self {
        case .animal:
            return Color(red: 1.0, green: 0.42, blue: 0.34)
        case .vehicle:
            return Color(red: 0.26, green: 0.58, blue: 0.90)
        case .fruit:
            return Color(red: 0.95, green: 0.48, blue: 0.34)
        case .sound:
            return Color(red: 0.22, green: 0.65, blue: 0.94)
        case .color:
            return Color(red: 1.0, green: 0.42, blue: 0.37)
        case .shape:
            return Color(red: 0.24, green: 0.65, blue: 0.94)
        case .colorShape:
            return Color(red: 0.54, green: 0.46, blue: 0.92)
        case .body:
            return Color(red: 0.96, green: 0.46, blue: 0.54)
        case .sense:
            return Color(red: 0.44, green: 0.56, blue: 0.92)
        case .clothing:
            return Color(red: 0.36, green: 0.55, blue: 0.90)
        case .vegetable:
            return Color(red: 0.28, green: 0.70, blue: 0.38)
        case .food:
            return Color(red: 0.95, green: 0.58, blue: 0.28)
        case .tableware:
            return Color(red: 0.26, green: 0.62, blue: 0.80)
        case .hygiene:
            return Color(red: 0.28, green: 0.68, blue: 0.76)
        case .home:
            return Color(red: 0.76, green: 0.52, blue: 0.34)
        case .stationery:
            return Color(red: 0.52, green: 0.47, blue: 0.88)
        case .instrument:
            return Color(red: 0.88, green: 0.46, blue: 0.68)
        case .toy:
            return Color(red: 0.94, green: 0.54, blue: 0.22)
        case .nature:
            return Color(red: 0.26, green: 0.68, blue: 0.44)
        case .place:
            return Color(red: 0.30, green: 0.58, blue: 0.88)
        case .profession:
            return Color(red: 0.64, green: 0.46, blue: 0.86)
        case .size:
            return Color(red: 0.61, green: 0.45, blue: 0.91)
        case .length:
            return Color(red: 0.30, green: 0.62, blue: 0.86)
        case .height:
            return Color(red: 0.42, green: 0.66, blue: 0.38)
        case .shadow:
            return Color(red: 0.31, green: 0.27, blue: 0.23)
        case .number:
            return Color(red: 0.38, green: 0.58, blue: 0.95)
        case .count:
            return Color(red: 0.98, green: 0.54, blue: 0.16)
        case .quantityCompare:
            return Color(red: 0.92, green: 0.50, blue: 0.20)
        case .category:
            return Color(red: 0.14, green: 0.66, blue: 0.54)
        case .position:
            return Color(red: 0.36, green: 0.55, blue: 0.95)
        case .insideOutside:
            return Color(red: 0.28, green: 0.68, blue: 0.72)
        case .frontBack:
            return Color(red: 0.48, green: 0.54, blue: 0.86)
        case .distance:
            return Color(red: 0.35, green: 0.58, blue: 0.90)
        case .purpose:
            return Color(red: 0.96, green: 0.48, blue: 0.20)
        case .safety:
            return Color(red: 0.94, green: 0.36, blue: 0.28)
        case .habit:
            return Color(red: 0.22, green: 0.68, blue: 0.54)
        case .scene:
            return Color(red: 0.18, green: 0.63, blue: 0.74)
        case .samePlace:
            return Color(red: 0.24, green: 0.62, blue: 0.58)
        case .weather:
            return Color(red: 0.27, green: 0.58, blue: 0.92)
        case .season:
            return Color(red: 0.32, green: 0.66, blue: 0.36)
        case .routine:
            return Color(red: 0.88, green: 0.52, blue: 0.24)
        case .emotion:
            return Color(red: 0.94, green: 0.42, blue: 0.58)
        case .action:
            return Color(red: 0.45, green: 0.48, blue: 0.92)
        case .texture:
            return Color(red: 0.74, green: 0.50, blue: 0.34)
        case .temperature:
            return Color(red: 0.90, green: 0.44, blue: 0.30)
        case .brightness:
            return Color(red: 0.94, green: 0.62, blue: 0.22)
        case .weight:
            return Color(red: 0.58, green: 0.52, blue: 0.86)
        case .material:
            return Color(red: 0.52, green: 0.56, blue: 0.46)
        case .taste:
            return Color(red: 0.93, green: 0.42, blue: 0.38)
        case .pairing:
            return Color(red: 0.22, green: 0.64, blue: 0.58)
        case .animalHome:
            return Color(red: 0.42, green: 0.62, blue: 0.36)
        case .animalBaby:
            return Color(red: 0.95, green: 0.46, blue: 0.52)
        case .animalFood:
            return Color(red: 0.88, green: 0.56, blue: 0.24)
        case .itemHome:
            return Color(red: 0.48, green: 0.58, blue: 0.86)
        case .origin:
            return Color(red: 0.34, green: 0.62, blue: 0.38)
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
    case inside
    case outside
    case front
    case back

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
        case .inside:
            return "里面"
        case .outside:
            return "外面"
        case .front:
            return "前面"
        case .back:
            return "后面"
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

enum FriendSafety: String, CaseIterable {
    case safeToTouch
    case askGrownup
    case helper
    case protectBody

    var promptTitle: String {
        switch self {
        case .safeToTouch:
            return "可以碰"
        case .askGrownup:
            return "找大人"
        case .helper:
            return "会帮忙"
        case .protectBody:
            return "保护身体"
        }
    }

    var speechTitle: String {
        switch self {
        case .safeToTouch:
            return "可以碰的"
        case .askGrownup:
            return "要找大人的"
        case .helper:
            return "会帮忙的"
        case .protectBody:
            return "保护身体的"
        }
    }

    var iconName: String {
        switch self {
        case .safeToTouch:
            return "hand.tap.fill"
        case .askGrownup:
            return "exclamationmark.triangle.fill"
        case .helper:
            return "person.2.fill"
        case .protectBody:
            return "shield.fill"
        }
    }
}

enum FriendHabit: String, CaseIterable {
    case washHands
    case brushTeeth
    case drinkWater
    case tidyToys
    case readBook
    case wearHat

    var promptTitle: String {
        switch self {
        case .washHands:
            return "洗手"
        case .brushTeeth:
            return "刷牙"
        case .drinkWater:
            return "喝水"
        case .tidyToys:
            return "收玩具"
        case .readBook:
            return "看书"
        case .wearHat:
            return "戴帽子"
        }
    }

    var speechTitle: String {
        switch self {
        case .washHands:
            return "洗手用的"
        case .brushTeeth:
            return "刷牙用的"
        case .drinkWater:
            return "喝水用的"
        case .tidyToys:
            return "收玩具用的"
        case .readBook:
            return "看书用的"
        case .wearHat:
            return "戴在头上的"
        }
    }

    var iconName: String {
        switch self {
        case .washHands:
            return "sparkles"
        case .brushTeeth:
            return "sparkles"
        case .drinkWater:
            return "drop.fill"
        case .tidyToys:
            return "shippingbox.fill"
        case .readBook:
            return "book.fill"
        case .wearHat:
            return "sun.max.fill"
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

enum FriendSamePlace: String, CaseIterable {
    case fishBoat
    case beachBucket
    case tableBowl
    case schoolPencil
    case bathroomToothbrush
    case gardenButterfly
    case roadBus
    case bedroomBook
    case parkBall
    case doctorAmbulance
    case farmerTractor
    case chefBowl

    var cueKind: FriendKind {
        switch self {
        case .fishBoat:
            return .fish
        case .beachBucket:
            return .beach
        case .tableBowl:
            return .table
        case .schoolPencil:
            return .school
        case .bathroomToothbrush:
            return .toothbrush
        case .gardenButterfly:
            return .flower
        case .roadBus:
            return .car
        case .bedroomBook:
            return .bed
        case .parkBall:
            return .park
        case .doctorAmbulance:
            return .doctor
        case .farmerTractor:
            return .farmer
        case .chefBowl:
            return .chef
        }
    }

    var answerKind: FriendKind {
        switch self {
        case .fishBoat:
            return .boat
        case .beachBucket:
            return .bucket
        case .tableBowl:
            return .bowl
        case .schoolPencil:
            return .pencil
        case .bathroomToothbrush:
            return .soap
        case .gardenButterfly:
            return .butterfly
        case .roadBus:
            return .bus
        case .bedroomBook:
            return .book
        case .parkBall:
            return .ball
        case .doctorAmbulance:
            return .ambulance
        case .farmerTractor:
            return .tractor
        case .chefBowl:
            return .bowl
        }
    }

    var distractorKind: FriendKind {
        switch self {
        case .fishBoat:
            return .chair
        case .beachBucket:
            return .piano
        case .tableBowl:
            return .airplane
        case .schoolPencil:
            return .fish
        case .bathroomToothbrush:
            return .truck
        case .gardenButterfly:
            return .fork
        case .roadBus:
            return .banana
        case .bedroomBook:
            return .tractor
        case .parkBall:
            return .fork
        case .doctorAmbulance:
            return .cherry
        case .farmerTractor:
            return .piano
        case .chefBowl:
            return .rocket
        }
    }

    var promptTitle: String {
        "\(cueKind.name)旁边"
    }

    var speechTitle: String {
        "和\(cueKind.name)常在一起的"
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

enum FriendSeason: String, CaseIterable {
    case spring
    case summer
    case autumn
    case winter

    var promptTitle: String {
        switch self {
        case .spring:
            return "春天"
        case .summer:
            return "夏天"
        case .autumn:
            return "秋天"
        case .winter:
            return "冬天"
        }
    }

    var speechTitle: String {
        switch self {
        case .spring:
            return "春天的"
        case .summer:
            return "夏天的"
        case .autumn:
            return "秋天的"
        case .winter:
            return "冬天的"
        }
    }

    var iconName: String {
        switch self {
        case .spring:
            return "leaf.fill"
        case .summer:
            return "sun.max.fill"
        case .autumn:
            return "tree.fill"
        case .winter:
            return "snowflake"
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
    case sleepy
    case curious
    case surprised

    var promptTitle: String {
        switch self {
        case .happy:
            return "开心"
        case .calm:
            return "安静"
        case .encouraged:
            return "加油"
        case .sleepy:
            return "困困"
        case .curious:
            return "好奇"
        case .surprised:
            return "惊喜"
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
        case .sleepy:
            return "困困的表情"
        case .curious:
            return "好奇的表情"
        case .surprised:
            return "惊喜的表情"
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
        case .sleepy:
            return "bed.double.fill"
        case .curious:
            return "magnifyingglass.circle.fill"
        case .surprised:
            return "sparkles"
        }
    }
}

enum FriendSense: String, CaseIterable {
    case see
    case hear
    case smell
    case taste
    case touch

    var promptTitle: String {
        switch self {
        case .see:
            return "用眼睛看"
        case .hear:
            return "用耳朵听"
        case .smell:
            return "用鼻子闻"
        case .taste:
            return "用嘴巴尝"
        case .touch:
            return "用小手摸"
        }
    }

    var speechTitle: String {
        promptTitle
    }

    var iconName: String {
        switch self {
        case .see:
            return "eye.fill"
        case .hear:
            return "ear.fill"
        case .smell:
            return "nose.fill"
        case .taste:
            return "mouth.fill"
        case .touch:
            return "hand.raised.fill"
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

enum FriendTemperature: String, CaseIterable {
    case hot
    case warm
    case cool
    case cold

    var promptTitle: String {
        switch self {
        case .hot:
            return "热热的"
        case .warm:
            return "暖暖的"
        case .cool:
            return "凉凉的"
        case .cold:
            return "冷冷的"
        }
    }

    var speechTitle: String {
        promptTitle
    }

    var iconName: String {
        switch self {
        case .hot:
            return "sun.max.fill"
        case .warm:
            return "tshirt.fill"
        case .cool:
            return "wind"
        case .cold:
            return "snowflake"
        }
    }
}

enum FriendBrightness: String, CaseIterable {
    case bright
    case dark
    case shiny
    case dim

    var promptTitle: String {
        switch self {
        case .bright:
            return "亮亮的"
        case .dark:
            return "暗暗的"
        case .shiny:
            return "闪闪的"
        case .dim:
            return "微微亮的"
        }
    }

    var speechTitle: String {
        promptTitle
    }

    var iconName: String {
        switch self {
        case .bright:
            return "sun.max.fill"
        case .dark:
            return "moon.fill"
        case .shiny:
            return "sparkles"
        case .dim:
            return "lightbulb.fill"
        }
    }
}

enum FriendWeight: String, CaseIterable {
    case heavy
    case light

    var promptTitle: String {
        switch self {
        case .heavy:
            return "重重的"
        case .light:
            return "轻轻的"
        }
    }

    var speechTitle: String {
        promptTitle
    }

    var iconName: String {
        switch self {
        case .heavy:
            return "scalemass.fill"
        case .light:
            return "balloon.fill"
        }
    }
}

enum FriendMaterial: String, CaseIterable {
    case wood
    case metal
    case paper
    case glass
    case cloth
    case plastic

    var promptTitle: String {
        switch self {
        case .wood:
            return "木头做的"
        case .metal:
            return "金属做的"
        case .paper:
            return "纸做的"
        case .glass:
            return "玻璃做的"
        case .cloth:
            return "布做的"
        case .plastic:
            return "塑料做的"
        }
    }

    var speechTitle: String {
        promptTitle
    }

    var iconName: String {
        switch self {
        case .wood:
            return "tree.fill"
        case .metal:
            return "wrench.and.screwdriver.fill"
        case .paper:
            return "doc.fill"
        case .glass:
            return "diamond.fill"
        case .cloth:
            return "tshirt.fill"
        case .plastic:
            return "cube.fill"
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
    case doctorToothbrush
    case teacherBook
    case policeCar
    case firefighterFireTruck
    case chefBowl
    case farmerTractor
    case pencilNotebook
    case toothbrushToothpaste
    case bucketBeach
    case guitarMicrophone

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
        case .doctorToothbrush:
            return .doctor
        case .teacherBook:
            return .teacher
        case .policeCar:
            return .policeOfficer
        case .firefighterFireTruck:
            return .firefighter
        case .chefBowl:
            return .chef
        case .farmerTractor:
            return .farmer
        case .pencilNotebook:
            return .pencil
        case .toothbrushToothpaste:
            return .toothbrush
        case .bucketBeach:
            return .bucket
        case .guitarMicrophone:
            return .guitar
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
        case .doctorToothbrush:
            return .toothbrush
        case .teacherBook:
            return .book
        case .policeCar:
            return .car
        case .firefighterFireTruck:
            return .fireTruck
        case .chefBowl:
            return .bowl
        case .farmerTractor:
            return .tractor
        case .pencilNotebook:
            return .notebook
        case .toothbrushToothpaste:
            return .toothpaste
        case .bucketBeach:
            return .beach
        case .guitarMicrophone:
            return .microphone
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
        case .doctorToothbrush:
            return .kite
        case .teacherBook:
            return .banana
        case .policeCar:
            return .flower
        case .firefighterFireTruck:
            return .pear
        case .chefBowl:
            return .train
        case .farmerTractor:
            return .soap
        case .pencilNotebook:
            return .ball
        case .toothbrushToothpaste:
            return .banana
        case .bucketBeach:
            return .book
        case .guitarMicrophone:
            return .carrot
        }
    }

    var promptTitle: String {
        "\(cueKind.name)的好搭档"
    }

    var speechTitle: String {
        "\(cueKind.name)的好搭档"
    }
}

enum FriendAnimalHome: String, CaseIterable {
    case fishSea
    case birdNest
    case beeHive
    case rabbitBurrow
    case cowFarm
    case frogPond
    case turtleBeach
    case duckPond
    case lionGrassland
    case monkeyTree

    var animalKind: FriendKind {
        switch self {
        case .fishSea:
            return .fish
        case .birdNest:
            return .bird
        case .beeHive:
            return .bee
        case .rabbitBurrow:
            return .rabbit
        case .cowFarm:
            return .cow
        case .frogPond:
            return .frog
        case .turtleBeach:
            return .turtle
        case .duckPond:
            return .duck
        case .lionGrassland:
            return .lion
        case .monkeyTree:
            return .monkey
        }
    }

    var distractorKind: FriendKind {
        switch self {
        case .fishSea:
            return .rabbit
        case .birdNest:
            return .fish
        case .beeHive:
            return .cow
        case .rabbitBurrow:
            return .bird
        case .cowFarm:
            return .bee
        case .frogPond:
            return .cow
        case .turtleBeach:
            return .bird
        case .duckPond:
            return .rabbit
        case .lionGrassland:
            return .fish
        case .monkeyTree:
            return .turtle
        }
    }

    var promptTitle: String {
        switch self {
        case .fishSea:
            return "海里"
        case .birdNest:
            return "鸟窝"
        case .beeHive:
            return "蜂窝"
        case .rabbitBurrow:
            return "洞洞"
        case .cowFarm:
            return "农场"
        case .frogPond:
            return "池塘"
        case .turtleBeach:
            return "沙滩"
        case .duckPond:
            return "池塘"
        case .lionGrassland:
            return "草原"
        case .monkeyTree:
            return "树上"
        }
    }

    var speechTitle: String {
        "住在\(promptTitle)"
    }

    var iconName: String {
        switch self {
        case .fishSea:
            return "drop.fill"
        case .birdNest:
            return "leaf.fill"
        case .beeHive:
            return "hexagon.fill"
        case .rabbitBurrow:
            return "circle.fill"
        case .cowFarm:
            return "house.fill"
        case .frogPond:
            return "water.waves"
        case .turtleBeach:
            return "beach.umbrella.fill"
        case .duckPond:
            return "water.waves"
        case .lionGrassland:
            return "leaf.fill"
        case .monkeyTree:
            return "tree.fill"
        }
    }
}

enum FriendAnimalBaby: String, CaseIterable {
    case catKitten
    case dogPuppy
    case duckDuckling
    case cowCalf
    case sheepLamb
    case horseFoal
    case rabbitKit
    case pigPiglet
    case frogTadpole
    case elephantCalf

    var babyKind: FriendKind {
        switch self {
        case .catKitten:
            return .cat
        case .dogPuppy:
            return .dog
        case .duckDuckling:
            return .duck
        case .cowCalf:
            return .cow
        case .sheepLamb:
            return .sheep
        case .horseFoal:
            return .horse
        case .rabbitKit:
            return .rabbit
        case .pigPiglet:
            return .pig
        case .frogTadpole:
            return .frog
        case .elephantCalf:
            return .elephant
        }
    }

    var distractorKind: FriendKind {
        switch self {
        case .catKitten:
            return .duck
        case .dogPuppy:
            return .cat
        case .duckDuckling:
            return .sheep
        case .cowCalf:
            return .horse
        case .sheepLamb:
            return .dog
        case .horseFoal:
            return .cow
        case .rabbitKit:
            return .frog
        case .pigPiglet:
            return .rabbit
        case .frogTadpole:
            return .pig
        case .elephantCalf:
            return .horse
        }
    }

    var promptTitle: String {
        switch self {
        case .catKitten:
            return "猫妈妈"
        case .dogPuppy:
            return "狗妈妈"
        case .duckDuckling:
            return "鸭妈妈"
        case .cowCalf:
            return "牛妈妈"
        case .sheepLamb:
            return "羊妈妈"
        case .horseFoal:
            return "马妈妈"
        case .rabbitKit:
            return "兔妈妈"
        case .pigPiglet:
            return "猪妈妈"
        case .frogTadpole:
            return "青蛙妈妈"
        case .elephantCalf:
            return "象妈妈"
        }
    }

    var speechTitle: String {
        "\(promptTitle)的宝宝"
    }

    var iconName: String {
        "pawprint.fill"
    }
}

enum FriendAnimalFood: String, CaseIterable {
    case rabbitCarrot
    case monkeyBanana
    case catMilk
    case duckCorn
    case beeFlower
    case horseCarrot
    case cowCorn
    case pigTomato
    case birdCorn
    case elephantApple

    var animalKind: FriendKind {
        switch self {
        case .rabbitCarrot:
            return .rabbit
        case .monkeyBanana:
            return .monkey
        case .catMilk:
            return .cat
        case .duckCorn:
            return .duck
        case .beeFlower:
            return .bee
        case .horseCarrot:
            return .horse
        case .cowCorn:
            return .cow
        case .pigTomato:
            return .pig
        case .birdCorn:
            return .bird
        case .elephantApple:
            return .elephant
        }
    }

    var foodKind: FriendKind {
        switch self {
        case .rabbitCarrot, .horseCarrot:
            return .carrot
        case .monkeyBanana:
            return .banana
        case .catMilk:
            return .milk
        case .duckCorn:
            return .corn
        case .beeFlower:
            return .flower
        case .cowCorn:
            return .corn
        case .pigTomato:
            return .tomato
        case .birdCorn:
            return .corn
        case .elephantApple:
            return .apple
        }
    }

    var distractorKind: FriendKind {
        switch self {
        case .rabbitCarrot:
            return .fish
        case .monkeyBanana:
            return .corn
        case .catMilk:
            return .carrot
        case .duckCorn:
            return .banana
        case .beeFlower:
            return .bread
        case .horseCarrot:
            return .cookie
        case .cowCorn:
            return .banana
        case .pigTomato:
            return .milk
        case .birdCorn:
            return .lemon
        case .elephantApple:
            return .bread
        }
    }

    var promptTitle: String {
        "\(animalKind.name)吃什么"
    }

    var speechTitle: String {
        "\(animalKind.name)爱吃的"
    }
}

enum FriendItemHome: String, CaseIterable {
    case pencilSchoolbag
    case bookShelf
    case toothbrushCup
    case shoesDoor
    case blocksToyBox
    case spoonTable
    case towelBathroom
    case coatCloset
    case notebookSchoolbag
    case cupTable

    var itemKind: FriendKind {
        switch self {
        case .pencilSchoolbag:
            return .pencil
        case .bookShelf:
            return .book
        case .toothbrushCup:
            return .toothbrush
        case .shoesDoor:
            return .shoes
        case .blocksToyBox:
            return .blocks
        case .spoonTable:
            return .spoon
        case .towelBathroom:
            return .towel
        case .coatCloset:
            return .coat
        case .notebookSchoolbag:
            return .notebook
        case .cupTable:
            return .cup
        }
    }

    var distractorKind: FriendKind {
        switch self {
        case .pencilSchoolbag:
            return .spoon
        case .bookShelf:
            return .shoes
        case .toothbrushCup:
            return .blocks
        case .shoesDoor:
            return .pencil
        case .blocksToyBox:
            return .toothbrush
        case .spoonTable:
            return .book
        case .towelBathroom:
            return .pencil
        case .coatCloset:
            return .spoon
        case .notebookSchoolbag:
            return .cup
        case .cupTable:
            return .shoes
        }
    }

    var promptTitle: String {
        switch self {
        case .pencilSchoolbag:
            return "书包里"
        case .bookShelf:
            return "书架上"
        case .toothbrushCup:
            return "刷牙杯里"
        case .shoesDoor:
            return "门口"
        case .blocksToyBox:
            return "玩具盒里"
        case .spoonTable:
            return "餐桌上"
        case .towelBathroom:
            return "浴室里"
        case .coatCloset:
            return "衣柜里"
        case .notebookSchoolbag:
            return "书包里"
        case .cupTable:
            return "餐桌上"
        }
    }

    var speechTitle: String {
        "放在\(promptTitle)的"
    }

    var iconName: String {
        switch self {
        case .pencilSchoolbag:
            return "backpack.fill"
        case .bookShelf:
            return "book.closed.fill"
        case .toothbrushCup:
            return "cup.and.saucer.fill"
        case .shoesDoor:
            return "house.fill"
        case .blocksToyBox:
            return "shippingbox.fill"
        case .spoonTable:
            return "fork.knife"
        case .towelBathroom:
            return "bathtub.fill"
        case .coatCloset:
            return "hanger"
        case .notebookSchoolbag:
            return "backpack.fill"
        case .cupTable:
            return "cup.and.saucer.fill"
        }
    }
}

enum FriendOrigin: String, CaseIterable {
    case milkCow
    case eggDuck
    case appleTree
    case breadChef
    case carrotFarmer
    case honeyBee
    case pearTree
    case cookieChef
    case cornFarmer
    case tomatoFarmer

    var itemKind: FriendKind {
        switch self {
        case .milkCow:
            return .milk
        case .eggDuck:
            return .egg
        case .appleTree:
            return .apple
        case .breadChef:
            return .bread
        case .carrotFarmer:
            return .carrot
        case .honeyBee:
            return .flower
        case .pearTree:
            return .pear
        case .cookieChef:
            return .cookie
        case .cornFarmer:
            return .corn
        case .tomatoFarmer:
            return .tomato
        }
    }

    var sourceKind: FriendKind {
        switch self {
        case .milkCow:
            return .cow
        case .eggDuck:
            return .duck
        case .appleTree:
            return .tree
        case .breadChef:
            return .chef
        case .carrotFarmer:
            return .farmer
        case .honeyBee:
            return .bee
        case .pearTree:
            return .tree
        case .cookieChef:
            return .chef
        case .cornFarmer, .tomatoFarmer:
            return .farmer
        }
    }

    var distractorKind: FriendKind {
        switch self {
        case .milkCow:
            return .car
        case .eggDuck:
            return .sofa
        case .appleTree:
            return .bus
        case .breadChef:
            return .fish
        case .carrotFarmer:
            return .book
        case .honeyBee:
            return .truck
        case .pearTree:
            return .bus
        case .cookieChef:
            return .fish
        case .cornFarmer:
            return .sofa
        case .tomatoFarmer:
            return .car
        }
    }

    var promptTitle: String {
        switch self {
        case .milkCow:
            return "牛奶从哪里来"
        case .eggDuck:
            return "鸭蛋从哪里来"
        case .appleTree:
            return "苹果从哪里来"
        case .breadChef:
            return "面包是谁做的"
        case .carrotFarmer:
            return "胡萝卜是谁种的"
        case .honeyBee:
            return "花蜜找谁帮忙"
        case .pearTree:
            return "梨从哪里来"
        case .cookieChef:
            return "饼干是谁做的"
        case .cornFarmer:
            return "玉米是谁种的"
        case .tomatoFarmer:
            return "番茄是谁种的"
        }
    }

    var speechTitle: String {
        switch self {
        case .milkCow:
            return "牛奶的来源"
        case .eggDuck:
            return "鸭蛋的来源"
        case .appleTree:
            return "苹果的来源"
        case .breadChef:
            return "做面包的"
        case .carrotFarmer:
            return "种胡萝卜的"
        case .honeyBee:
            return "花蜜的朋友"
        case .pearTree:
            return "梨的来源"
        case .cookieChef:
            return "做饼干的"
        case .cornFarmer:
            return "种玉米的"
        case .tomatoFarmer:
            return "种番茄的"
        }
    }

    var iconName: String {
        switch self {
        case .milkCow:
            return "drop.fill"
        case .eggDuck:
            return "oval.fill"
        case .appleTree:
            return "leaf.fill"
        case .breadChef:
            return "fork.knife"
        case .carrotFarmer:
            return "leaf.fill"
        case .honeyBee:
            return "sparkles"
        case .pearTree:
            return "leaf.fill"
        case .cookieChef:
            return "fork.knife"
        case .cornFarmer, .tomatoFarmer:
            return "leaf.fill"
        }
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
    case food
    case tableware
    case hygiene
    case home
    case stationery
    case instrument
    case toy
    case nature
    case place
    case profession
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
        case .food:
            return "食物"
        case .tableware:
            return "餐具"
        case .hygiene:
            return "卫生"
        case .home:
            return "家居"
        case .stationery:
            return "文具"
        case .instrument:
            return "乐器"
        case .toy:
            return "玩具"
        case .nature:
            return "自然"
        case .place:
            return "地点"
        case .profession:
            return "职业"
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
        case .food:
            return "食物朋友"
        case .tableware:
            return "餐具朋友"
        case .hygiene:
            return "卫生朋友"
        case .home:
            return "家居朋友"
        case .stationery:
            return "文具朋友"
        case .instrument:
            return "乐器朋友"
        case .toy:
            return "玩具朋友"
        case .nature:
            return "自然朋友"
        case .place:
            return "地点朋友"
        case .profession:
            return "职业朋友"
        case .object:
            return "生活朋友"
        }
    }

    var accentColor: Color {
        switch self {
        case .animal:
            return Color(red: 1.0, green: 0.62, blue: 0.30)
        case .vehicle:
            return Color(red: 0.22, green: 0.65, blue: 0.94)
        case .fruit:
            return Color(red: 0.96, green: 0.32, blue: 0.34)
        case .shape:
            return Color(red: 0.61, green: 0.45, blue: 0.91)
        case .body:
            return Color(red: 0.96, green: 0.46, blue: 0.54)
        case .clothing:
            return Color(red: 0.36, green: 0.55, blue: 0.90)
        case .vegetable:
            return Color(red: 0.28, green: 0.70, blue: 0.38)
        case .food:
            return Color(red: 0.95, green: 0.58, blue: 0.28)
        case .tableware:
            return Color(red: 0.26, green: 0.62, blue: 0.80)
        case .hygiene:
            return Color(red: 0.28, green: 0.68, blue: 0.76)
        case .home:
            return Color(red: 0.76, green: 0.52, blue: 0.34)
        case .stationery:
            return Color(red: 0.52, green: 0.47, blue: 0.88)
        case .instrument:
            return Color(red: 0.88, green: 0.46, blue: 0.68)
        case .toy:
            return Color(red: 0.94, green: 0.54, blue: 0.22)
        case .nature:
            return Color(red: 0.26, green: 0.68, blue: 0.44)
        case .place:
            return Color(red: 0.30, green: 0.58, blue: 0.88)
        case .profession:
            return Color(red: 0.64, green: 0.46, blue: 0.86)
        case .object:
            return Color(red: 0.14, green: 0.66, blue: 0.54)
        }
    }

    func categoryCardSampleKinds(preferred preferredKind: FriendKind) -> [FriendKind] {
        var result: [FriendKind] = []
        for kind in [preferredKind] + defaultCategoryCardSampleKinds where !result.contains(kind) {
            result.append(kind)
        }
        return result
    }

    var differenceCardSampleKinds: [FriendKind] {
        switch self {
        case .animal:
            return [.cat, .dog]
        case .vehicle:
            return [.car, .bus]
        case .fruit:
            return [.apple, .banana]
        case .shape:
            return [.circle, .triangle]
        case .body:
            return [.eye, .hand]
        case .clothing:
            return [.hat, .shirt]
        case .vegetable:
            return [.carrot, .tomato]
        case .food:
            return [.rice, .bread]
        case .tableware:
            return [.bowl, .spoon]
        case .hygiene:
            return [.toothbrush, .towel]
        case .home:
            return [.chair, .bed]
        case .stationery:
            return [.pencil, .notebook]
        case .instrument:
            return [.drum, .bell]
        case .toy:
            return [.blocks, .kite]
        case .nature:
            return [.sun, .tree]
        case .place:
            return [.house, .park]
        case .profession:
            return [.doctor, .chef]
        case .object:
            return [.book, .umbrella]
        }
    }

    private var defaultCategoryCardSampleKinds: [FriendKind] {
        switch self {
        case .animal:
            return [.cat, .dog, .fish]
        case .vehicle:
            return [.car, .bus, .train]
        case .fruit:
            return [.apple, .banana, .watermelon]
        case .shape:
            return [.circle, .star, .triangle]
        case .body:
            return [.eye, .ear, .hand]
        case .clothing:
            return [.hat, .shirt, .shoes]
        case .vegetable:
            return [.carrot, .tomato, .corn]
        case .food:
            return [.rice, .noodles, .bread]
        case .tableware:
            return [.bowl, .spoon, .plate]
        case .hygiene:
            return [.toothbrush, .towel, .soap]
        case .home:
            return [.chair, .bed, .lamp]
        case .stationery:
            return [.pencil, .notebook, .schoolbag]
        case .instrument:
            return [.drum, .guitar, .bell]
        case .toy:
            return [.blocks, .doll, .kite]
        case .nature:
            return [.sun, .cloud, .tree]
        case .place:
            return [.house, .school, .park]
        case .profession:
            return [.doctor, .teacher, .chef]
        case .object:
            return [.balloon, .book, .umbrella]
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
    case food
    case tableware
    case hygiene
    case home
    case stationery
    case instrument
    case toy
    case nature
    case place
    case profession
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
        case .food:
            return "食物"
        case .tableware:
            return "餐具"
        case .hygiene:
            return "卫生"
        case .home:
            return "家居"
        case .stationery:
            return "文具"
        case .instrument:
            return "乐器"
        case .toy:
            return "玩具"
        case .nature:
            return "自然"
        case .place:
            return "地点"
        case .profession:
            return "职业"
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
        .horse: "咴咴",
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
        .tractor: "突突",
        .drum: "咚咚",
        .bell: "叮铃",
        .rattle: "沙沙"
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
    case rice
    case noodles
    case bread
    case egg
    case milk
    case cookie
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
    case drum
    case piano
    case guitar
    case trumpet
    case bell
    case microphone
    case blocks
    case doll
    case kite
    case puzzle
    case rattle
    case bucket
    case flower
    case tree
    case sun
    case cloud
    case rainbow
    case house
    case school
    case park
    case beach
    case store
    case playground
    case doctor
    case teacher
    case policeOfficer
    case firefighter
    case chef
    case farmer
    case umbrella
    case ball
    case book
    case cup
    case knife
    case kettle
    case scissors
    case socket

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
        case .rice:
            return "米饭"
        case .noodles:
            return "面条"
        case .bread:
            return "面包"
        case .egg:
            return "鸡蛋"
        case .milk:
            return "牛奶"
        case .cookie:
            return "饼干"
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
        case .drum:
            return "小鼓"
        case .piano:
            return "钢琴"
        case .guitar:
            return "吉他"
        case .trumpet:
            return "喇叭"
        case .bell:
            return "铃铛"
        case .microphone:
            return "麦克风"
        case .blocks:
            return "积木"
        case .doll:
            return "玩偶"
        case .kite:
            return "风筝"
        case .puzzle:
            return "拼图"
        case .rattle:
            return "摇铃"
        case .bucket:
            return "小桶"
        case .flower:
            return "花朵"
        case .tree:
            return "小树"
        case .sun:
            return "太阳"
        case .cloud:
            return "云朵"
        case .rainbow:
            return "彩虹"
        case .house:
            return "家"
        case .school:
            return "学校"
        case .park:
            return "公园"
        case .beach:
            return "海边"
        case .store:
            return "商店"
        case .playground:
            return "游乐场"
        case .doctor:
            return "医生"
        case .teacher:
            return "老师"
        case .policeOfficer:
            return "警察"
        case .firefighter:
            return "消防员"
        case .chef:
            return "厨师"
        case .farmer:
            return "农民"
        case .umbrella:
            return "雨伞"
        case .ball:
            return "皮球"
        case .book:
            return "图书"
        case .cup:
            return "杯子"
        case .knife:
            return "小刀"
        case .kettle:
            return "热水壶"
        case .scissors:
            return "剪刀"
        case .socket:
            return "插座"
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
        case .rice, .noodles, .bread, .egg, .milk, .cookie:
            return .food
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
        case .drum, .piano, .guitar, .trumpet, .bell, .microphone:
            return .instrument
        case .blocks, .doll, .kite, .puzzle, .rattle, .bucket:
            return .toy
        case .moon, .flower, .tree, .sun, .cloud, .rainbow:
            return .nature
        case .house, .school, .park, .beach, .store, .playground:
            return .place
        case .doctor, .teacher, .policeOfficer, .firefighter, .chef, .farmer:
            return .profession
        case .balloon, .umbrella, .ball, .book, .cup, .knife, .kettle, .scissors, .socket:
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
        case .food:
            return .food
        case .tableware:
            return .tableware
        case .hygiene:
            return .hygiene
        case .home:
            return .home
        case .stationery:
            return .stationery
        case .instrument:
            return .instrument
        case .toy:
            return .toy
        case .nature:
            return .nature
        case .place:
            return .place
        case .profession:
            return .profession
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
        case .rice:
            return "bowl.fill"
        case .noodles:
            return "fork.knife.circle.fill"
        case .bread:
            return "rectangle.fill"
        case .egg:
            return "oval.fill"
        case .milk:
            return "drop.fill"
        case .cookie:
            return "circle.fill"
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
        case .drum:
            return "circle.fill"
        case .piano:
            return "rectangle.fill"
        case .guitar:
            return "music.note"
        case .trumpet:
            return "speaker.wave.2.fill"
        case .bell:
            return "bell.fill"
        case .microphone:
            return "mic.fill"
        case .blocks:
            return "cube.fill"
        case .doll:
            return "figure.child"
        case .kite:
            return "diamond.fill"
        case .puzzle:
            return "square.grid.2x2.fill"
        case .rattle:
            return "bell.fill"
        case .bucket:
            return "shippingbox.fill"
        case .flower:
            return "camera.macro"
        case .tree:
            return "tree.fill"
        case .sun:
            return "sun.max.fill"
        case .cloud:
            return "cloud.fill"
        case .rainbow:
            return "cloud.sun.fill"
        case .house:
            return "house.fill"
        case .school:
            return "book.fill"
        case .park:
            return "tree.fill"
        case .beach:
            return "drop.fill"
        case .store:
            return "cart.fill"
        case .playground:
            return "figure.play"
        case .doctor:
            return "cross.case.fill"
        case .teacher:
            return "book.closed.fill"
        case .policeOfficer:
            return "shield.fill"
        case .firefighter:
            return "flame.fill"
        case .chef:
            return "fork.knife"
        case .farmer:
            return "leaf.fill"
        case .umbrella:
            return "umbrella.fill"
        case .ball:
            return "circle.grid.cross.fill"
        case .book:
            return "book.fill"
        case .cup:
            return "cup.and.saucer.fill"
        case .knife:
            return "fork.knife"
        case .kettle:
            return "flame.fill"
        case .scissors:
            return "scissors"
        case .socket:
            return "bolt.fill"
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
        case .circle, .square, .triangle, .star, .heart, .rectangle, .oval, .diamond, .rice, .noodles, .bread, .egg, .milk, .cookie, .eye, .ear, .mouth, .hand, .foot, .nose, .hat, .shirt, .pants, .shoes, .socks, .coat, .carrot, .corn, .tomato, .cucumber, .mushroom, .broccoli, .bowl, .spoon, .plate, .fork, .chopsticks, .bottle, .toothbrush, .toothpaste, .towel, .soap, .bathtub, .comb, .chair, .table, .bed, .sofa, .lamp, .clock, .pencil, .crayon, .eraser, .ruler, .notebook, .schoolbag, .drum, .piano, .guitar, .trumpet, .bell, .microphone, .blocks, .doll, .kite, .puzzle, .rattle, .bucket, .rainbow, .house, .school, .park, .beach, .store, .playground, .doctor, .teacher, .policeOfficer, .firefighter, .chef, .farmer, .knife, .kettle, .scissors, .socket:
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
    let targetSafety: FriendSafety?
    let targetHabit: FriendHabit?
    let targetScene: FriendScene?
    let targetSamePlace: FriendSamePlace?
    let targetWeather: FriendWeather?
    let targetSeason: FriendSeason?
    let targetRoutine: FriendRoutine?
    let targetEmotion: FriendEmotion?
    let targetSense: FriendSense?
    let targetAction: FriendAction?
    let targetTexture: FriendTexture?
    let targetTemperature: FriendTemperature?
    let targetBrightness: FriendBrightness?
    let targetWeight: FriendWeight?
    let targetMaterial: FriendMaterial?
    let targetTaste: FriendTaste?
    let targetPairing: FriendPairing?
    let targetAnimalHome: FriendAnimalHome?
    let targetAnimalBaby: FriendAnimalBaby?
    let targetAnimalFood: FriendAnimalFood?
    let targetItemHome: FriendItemHome?
    let targetOrigin: FriendOrigin?
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
        targetSafety: FriendSafety? = nil,
        targetHabit: FriendHabit? = nil,
        targetScene: FriendScene? = nil,
        targetSamePlace: FriendSamePlace? = nil,
        targetWeather: FriendWeather? = nil,
        targetSeason: FriendSeason? = nil,
        targetRoutine: FriendRoutine? = nil,
        targetEmotion: FriendEmotion? = nil,
        targetSense: FriendSense? = nil,
        targetAction: FriendAction? = nil,
        targetTexture: FriendTexture? = nil,
        targetTemperature: FriendTemperature? = nil,
        targetBrightness: FriendBrightness? = nil,
        targetWeight: FriendWeight? = nil,
        targetMaterial: FriendMaterial? = nil,
        targetTaste: FriendTaste? = nil,
        targetPairing: FriendPairing? = nil,
        targetAnimalHome: FriendAnimalHome? = nil,
        targetAnimalBaby: FriendAnimalBaby? = nil,
        targetAnimalFood: FriendAnimalFood? = nil,
        targetItemHome: FriendItemHome? = nil,
        targetOrigin: FriendOrigin? = nil,
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
        self.targetSafety = targetSafety
        self.targetHabit = targetHabit
        self.targetScene = targetScene
        self.targetSamePlace = targetSamePlace
        self.targetWeather = targetWeather
        self.targetSeason = targetSeason
        self.targetRoutine = targetRoutine
        self.targetEmotion = targetEmotion
        self.targetSense = targetSense
        self.targetAction = targetAction
        self.targetTexture = targetTexture
        self.targetTemperature = targetTemperature
        self.targetBrightness = targetBrightness
        self.targetWeight = targetWeight
        self.targetMaterial = targetMaterial
        self.targetTaste = targetTaste
        self.targetPairing = targetPairing
        self.targetAnimalHome = targetAnimalHome
        self.targetAnimalBaby = targetAnimalBaby
        self.targetAnimalFood = targetAnimalFood
        self.targetItemHome = targetItemHome
        self.targetOrigin = targetOrigin
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
        case .vehicle:
            return "找\(targetKind.name)"
        case .fruit:
            return "找\(targetKind.name)"
        case .sound:
            return "找\(targetKind.soundText)"
        case .color:
            return "找\(targetColor.speechName)"
        case .shape:
            return "找\(targetKind.name)"
        case .colorShape:
            return "找\(targetColor.speechName)\(targetKind.name)"
        case .body:
            return "找\(targetKind.name)"
        case .clothing:
            return "找\(targetKind.name)"
        case .vegetable:
            return "找\(targetKind.name)"
        case .food:
            return "找\(targetKind.name)"
        case .tableware:
            return "找\(targetKind.name)"
        case .hygiene:
            return "找\(targetKind.name)"
        case .home:
            return "找\(targetKind.name)"
        case .stationery:
            return "找\(targetKind.name)"
        case .instrument:
            return "找\(targetKind.name)"
        case .toy:
            return "找\(targetKind.name)"
        case .nature:
            return "找\(targetKind.name)"
        case .place:
            return "找\(targetKind.name)"
        case .profession:
            return "找\(targetKind.name)"
        case .size:
            return "找一样大的\(targetKind.name)"
        case .length:
            return targetSizeScale > 1 ? "找长长的" : "找短短的"
        case .height:
            return targetSizeScale > 1 ? "找高高的" : "找矮矮的"
        case .shadow:
            return "找\(targetKind.name)的影子"
        case .number:
            return "找数字\(targetCount.cnNumberName)"
        case .count:
            return "找\(targetCount.cnNumberName)个\(targetKind.name)"
        case .quantityCompare:
            return "找\(targetQuantityCompare?.speechTitle ?? "多的")"
        case .category:
            return "找\(targetCategory?.childPromptTitle ?? targetKind.category.childPromptTitle)"
        case .position:
            return "找在\(targetPosition.name)的\(targetKind.name)"
        case .insideOutside:
            return "找在\(targetPosition.name)的\(targetKind.name)"
        case .frontBack:
            return "找在\(targetPosition.name)的\(targetKind.name)"
        case .distance:
            return targetSizeScale > 1 ? "找近近的\(targetKind.name)" : "找远远的\(targetKind.name)"
        case .purpose:
            return "找\(targetPurpose?.speechTitle ?? targetKind.name)"
        case .safety:
            return "找\(targetSafety?.speechTitle ?? targetKind.name)"
        case .habit:
            return "找\(targetHabit?.speechTitle ?? targetKind.name)"
        case .scene:
            return "找\(targetScene?.speechTitle ?? targetKind.name)"
        case .samePlace:
            return "找\(targetSamePlace?.speechTitle ?? targetKind.name)"
        case .weather:
            return "找\(targetWeather?.speechTitle ?? targetKind.name)"
        case .season:
            return "找\(targetSeason?.speechTitle ?? targetKind.name)"
        case .routine:
            return "找\(targetRoutine?.speechTitle ?? targetKind.name)"
        case .emotion:
            return "找\(targetEmotion?.speechTitle ?? targetKind.name)"
        case .sense:
            return "找\(targetSense?.speechTitle ?? targetKind.name)"
        case .action:
            return "找\(targetAction?.speechTitle ?? targetKind.name)"
        case .texture:
            return "找\(targetTexture?.speechTitle ?? targetKind.name)"
        case .temperature:
            return "找\(targetTemperature?.speechTitle ?? targetKind.name)"
        case .brightness:
            return "找\(targetBrightness?.speechTitle ?? targetKind.name)"
        case .weight:
            return "找\(targetWeight?.speechTitle ?? targetKind.name)"
        case .material:
            return "找\(targetMaterial?.speechTitle ?? targetKind.name)"
        case .taste:
            return "找\(targetTaste?.speechTitle ?? targetKind.name)"
        case .pairing:
            return "找\(targetPairing?.speechTitle ?? targetKind.name)"
        case .animalHome:
            return "找\(targetAnimalHome?.speechTitle ?? targetKind.name)的\(targetKind.name)"
        case .animalBaby:
            return "找\(targetAnimalBaby?.speechTitle ?? targetKind.name)"
        case .animalFood:
            return "找\(targetAnimalFood?.speechTitle ?? targetKind.name)"
        case .itemHome:
            return "找\(targetItemHome?.speechTitle ?? targetKind.name)"
        case .origin:
            return "找\(targetOrigin?.speechTitle ?? targetKind.name)"
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
        case .vehicle:
            return "\(targetKind.name)，找到了"
        case .fruit:
            return "\(targetKind.name)，找到了"
        case .color:
            return "\(targetColor.speechName)，找到了"
        case .colorShape:
            return "\(targetColor.speechName)\(targetKind.name)，找到了"
        case .body:
            return "\(targetKind.name)，找到了"
        case .clothing:
            return "\(targetKind.name)，找到了"
        case .vegetable:
            return "\(targetKind.name)，找到了"
        case .food:
            return "\(targetKind.name)，找到了"
        case .tableware:
            return "\(targetKind.name)，找到了"
        case .hygiene:
            return "\(targetKind.name)，找到了"
        case .home:
            return "\(targetKind.name)，找到了"
        case .stationery:
            return "\(targetKind.name)，找到了"
        case .instrument:
            return "\(targetKind.name)，找到了"
        case .toy:
            return "\(targetKind.name)，找到了"
        case .nature:
            return "\(targetKind.name)，找到了"
        case .place:
            return "\(targetKind.name)，找到了"
        case .profession:
            return "\(targetKind.name)，找到了"
        case .length:
            return targetSizeScale > 1 ? "长长的，找到了" : "短短的，找到了"
        case .height:
            return targetSizeScale > 1 ? "高高的，找到了" : "矮矮的，找到了"
        case .number:
            return "数字\(targetCount.cnNumberName)，找到了"
        case .count:
            return "\(targetCount.cnNumberName)个\(targetKind.name)，找到了"
        case .quantityCompare:
            return "\(targetQuantityCompare?.promptTitle ?? "多的")，找到了"
        case .category:
            return "\(targetKind.name)，是\(targetKind.category.childPromptTitle)"
        case .position:
            return "\(targetKind.name)在\(targetPosition.name)，找到了"
        case .insideOutside:
            return "\(targetKind.name)在\(targetPosition.name)，找到了"
        case .frontBack:
            return "\(targetKind.name)在\(targetPosition.name)，找到了"
        case .distance:
            return targetSizeScale > 1 ? "\(targetKind.name)，近近的" : "\(targetKind.name)，远远的"
        case .purpose:
            return "\(targetKind.name)，\(targetPurpose?.speechTitle ?? "找到了")"
        case .safety:
            return "\(targetKind.name)，\(targetSafety?.promptTitle ?? "找到了")"
        case .habit:
            return "\(targetKind.name)，\(targetHabit?.promptTitle ?? "找到了")"
        case .scene:
            return "\(targetKind.name)，找到了"
        case .samePlace:
            return "\(targetKind.name)，\(targetSamePlace?.speechTitle ?? "找到了")"
        case .weather:
            return "\(targetKind.name)，找到了"
        case .season:
            return "\(targetKind.name)，\(targetSeason?.promptTitle ?? "找到了")"
        case .routine:
            return "\(targetKind.name)，找到了"
        case .emotion:
            return "\(targetEmotion?.promptTitle ?? targetKind.name)，找到了"
        case .sense:
            return "\(targetKind.name)，\(targetSense?.promptTitle ?? "找到了")"
        case .action:
            return "\(targetKind.name)，找到了"
        case .texture:
            return "\(targetKind.name)，摸起来\(targetTexture?.promptTitle ?? "找到了")"
        case .temperature:
            return "\(targetKind.name)，\(targetTemperature?.promptTitle ?? "找到了")"
        case .brightness:
            return "\(targetKind.name)，\(targetBrightness?.promptTitle ?? "找到了")"
        case .weight:
            return "\(targetKind.name)，\(targetWeight?.promptTitle ?? "找到了")"
        case .material:
            return "\(targetKind.name)，是\(targetMaterial?.promptTitle ?? "找到了")"
        case .taste:
            return "\(targetKind.name)，尝起来\(targetTaste?.promptTitle ?? "找到了")"
        case .pairing:
            return "\(targetKind.name)，是好搭档"
        case .animalHome:
            return "\(targetKind.name)\(targetAnimalHome?.speechTitle ?? "找到了")，找到了"
        case .animalBaby:
            return "\(targetKind.name)，是\(targetAnimalBaby?.speechTitle ?? "宝宝")"
        case .animalFood:
            return "\(targetKind.name)，是\(targetAnimalFood?.speechTitle ?? "爱吃的")"
        case .itemHome:
            return "\(targetKind.name)，是\(targetItemHome?.speechTitle ?? "放好的")"
        case .origin:
            return "\(targetKind.name)，是\(targetOrigin?.speechTitle ?? "来源")"
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
        case .number:
            return "number.\(targetCount)"
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

struct RoundFeedbackBanner: Equatable {
    enum Kind: Equatable {
        case success
        case hint
        case retry
    }

    let kind: Kind
    let title: String
    let message: String
    let systemName: String
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
        case 10:
            return "十"
        default:
            return "\(self)"
        }
    }
}
