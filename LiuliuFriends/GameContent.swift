import SwiftUI

enum GameContent {
    static let rounds: [GameRound] = makeRounds()
    static var sessionRoundTotalLimit: Int { GameMode.allCases.count }
    private static let warmupModes: [GameMode] = [.animal, .vehicle, .fruit, .sound, .color, .shape]

    static func sessionRounds() -> [GameRound] {
        warmupFirst(balancedShuffled(limitedForSession(rounds)))
    }

    static func sessionRoundLimit(for mode: GameMode) -> Int {
        switch mode.ageBand {
        case .starter18Months:
            return 10
        case .explorer24Months:
            return 7
        case .matcher30Months:
            return 5
        case .preschool36Months:
            return 4
        }
    }

    private static let palette: [Color] = [
        .coral,
        .skyBlue,
        .mintGreen,
        .sunYellow,
        .purple,
        .rosePink,
        .leafGreen,
        .orange,
        .milkBrown,
        .berryRed,
        .aqua,
        .softGray
    ]

    private static let colorPracticeKinds: [FriendKind] = [
        .balloon,
        .ball,
        .book,
        .cup,
        .flower,
        .umbrella
    ]
    private static let colorLearningPalette = VoicePromptTarget.colorTargets.compactMap(\.color)

    private static let shapePracticeColor = Color(red: 0.24, green: 0.65, blue: 0.94)
    private static let colorShapePracticeKinds: [FriendKind] = [
        .circle,
        .square,
        .triangle,
        .star,
        .heart,
        .rectangle,
        .oval,
        .diamond
    ]

    private static let baseColors: [FriendKind: Color] = [
        .balloon: .coral,
        .cat: .catOrange,
        .dog: .dogTan,
        .duck: .duckYellow,
        .bear: .bearBrown,
        .rabbit: .rabbitCream,
        .frog: .frogGreen,
        .apple: .berryRed,
        .fish: .skyBlue,
        .circle: .purple,
        .square: .mintGreen,
        .triangle: .coral,
        .star: .sunYellow,
        .heart: .rosePink,
        .bird: .skyBlue,
        .cow: .softGray,
        .sheep: .rabbitCream,
        .horse: .milkBrown,
        .pig: .rosePink,
        .monkey: .milkBrown,
        .panda: .softGray,
        .tiger: .orange,
        .lion: .sunYellow,
        .elephant: .softGray,
        .turtle: .leafGreen,
        .bee: .sunYellow,
        .butterfly: .purple,
        .car: .coral,
        .bus: .sunYellow,
        .train: .skyBlue,
        .truck: .mintGreen,
        .airplane: .aqua,
        .boat: .skyBlue,
        .bicycle: .orange,
        .fireTruck: .berryRed,
        .ambulance: .softGray,
        .tractor: .leafGreen,
        .rocket: .purple,
        .banana: .sunYellow,
        .orange: .orange,
        .pear: .leafGreen,
        .strawberry: .berryRed,
        .watermelon: .leafGreen,
        .grape: .purple,
        .peach: .rosePink,
        .pineapple: .sunYellow,
        .cherry: .berryRed,
        .lemon: .sunYellow,
        .rice: .softGray,
        .noodles: .sunYellow,
        .bread: .milkBrown,
        .egg: .softGray,
        .milk: .aqua,
        .cookie: .milkBrown,
        .rectangle: .skyBlue,
        .oval: .mintGreen,
        .diamond: .purple,
        .moon: .sunYellow,
        .eye: .skyBlue,
        .ear: .rosePink,
        .mouth: .coral,
        .hand: .sunYellow,
        .foot: .mintGreen,
        .nose: .orange,
        .hat: .purple,
        .shirt: .skyBlue,
        .pants: .mintGreen,
        .shoes: .milkBrown,
        .socks: .rosePink,
        .coat: .orange,
        .carrot: .orange,
        .corn: .sunYellow,
        .tomato: .berryRed,
        .cucumber: .leafGreen,
        .mushroom: .milkBrown,
        .broccoli: .leafGreen,
        .bowl: .skyBlue,
        .spoon: .softGray,
        .plate: .mintGreen,
        .fork: .softGray,
        .chopsticks: .milkBrown,
        .bottle: .rosePink,
        .toothbrush: .skyBlue,
        .toothpaste: .mintGreen,
        .towel: .aqua,
        .soap: .rosePink,
        .bathtub: .softGray,
        .comb: .milkBrown,
        .chair: .milkBrown,
        .table: .milkBrown,
        .bed: .skyBlue,
        .sofa: .rosePink,
        .lamp: .sunYellow,
        .clock: .softGray,
        .pencil: .sunYellow,
        .crayon: .coral,
        .eraser: .rosePink,
        .ruler: .mintGreen,
        .notebook: .skyBlue,
        .schoolbag: .purple,
        .drum: .coral,
        .piano: .softGray,
        .guitar: .milkBrown,
        .trumpet: .sunYellow,
        .bell: .sunYellow,
        .microphone: .purple,
        .blocks: .orange,
        .doll: .rosePink,
        .kite: .skyBlue,
        .puzzle: .mintGreen,
        .rattle: .sunYellow,
        .bucket: .coral,
        .flower: .rosePink,
        .tree: .leafGreen,
        .sun: .sunYellow,
        .cloud: .softGray,
        .rainbow: .skyBlue,
        .house: .coral,
        .school: .skyBlue,
        .park: .leafGreen,
        .beach: .aqua,
        .store: .orange,
        .playground: .purple,
        .doctor: .aqua,
        .teacher: .skyBlue,
        .policeOfficer: .purple,
        .firefighter: .coral,
        .chef: .softGray,
        .farmer: .leafGreen,
        .umbrella: .purple,
        .ball: .coral,
        .book: .skyBlue,
        .cup: .aqua,
        .knife: .softGray,
        .kettle: .berryRed,
        .scissors: .orange,
        .socket: .purple
    ]

    private static var animals: [FriendKind] {
        FriendKind.allCases.filter { $0.category == .animal }
    }

    private static var shapes: [FriendKind] {
        FriendKind.allCases.filter { $0.category == .shape }
    }

    private static var bodyParts: [FriendKind] {
        FriendKind.allCases.filter { $0.category == .body }
    }

    private static var clothingItems: [FriendKind] {
        FriendKind.allCases.filter { $0.category == .clothing }
    }

    private static var vegetables: [FriendKind] {
        FriendKind.allCases.filter { $0.category == .vegetable }
    }

    private static var foodItems: [FriendKind] {
        FriendKind.allCases.filter { $0.category == .food }
    }

    private static var tablewareItems: [FriendKind] {
        FriendKind.allCases.filter { $0.category == .tableware }
    }

    private static var hygieneItems: [FriendKind] {
        FriendKind.allCases.filter { $0.category == .hygiene }
    }

    private static var homeItems: [FriendKind] {
        FriendKind.allCases.filter { $0.category == .home }
    }

    private static var stationeryItems: [FriendKind] {
        FriendKind.allCases.filter { $0.category == .stationery }
    }

    private static var instrumentItems: [FriendKind] {
        FriendKind.allCases.filter { $0.category == .instrument }
    }

    private static var toyItems: [FriendKind] {
        FriendKind.allCases.filter { $0.category == .toy }
    }

    private static var natureItems: [FriendKind] {
        FriendKind.allCases.filter { $0.category == .nature }
    }

    private static var placeItems: [FriendKind] {
        FriendKind.allCases.filter { $0.category == .place }
    }

    private static var professionItems: [FriendKind] {
        FriendKind.allCases.filter { $0.category == .profession }
    }

    private static var vehicleItems: [FriendKind] {
        FriendKind.allCases.filter { $0.category == .vehicle }
    }

    private static var fruitItems: [FriendKind] {
        FriendKind.allCases.filter { $0.category == .fruit }
    }

    private static var visibleKinds: [FriendKind] {
        FriendKind.allCases
    }

    private static let countPracticeKinds: [FriendKind] = [
        .cat,
        .dog,
        .fish,
        .apple,
        .banana,
        .ball,
        .book,
        .car
    ]
    private static let numberPracticeCounts = Array(1...10)
    private static let lengthPracticeKinds: [FriendKind] = [
        .pencil,
        .ruler,
        .crayon,
        .banana,
        .toothbrush,
        .comb
    ]
    private static let heightPracticeKinds: [FriendKind] = [
        .tree,
        .lamp,
        .bottle,
        .rocket,
        .microphone,
        .flower
    ]

    private static let quantityComparePracticePairs: [(kind: FriendKind, target: FriendQuantityCompare, correctCount: Int, wrongCount: Int)] = [
        (.apple, .more, 4, 2),
        (.banana, .fewer, 1, 3),
        (.fish, .more, 3, 1),
        (.ball, .fewer, 2, 4),
        (.flower, .more, 4, 1),
        (.book, .fewer, 1, 4),
        (.car, .more, 3, 2),
        (.cup, .fewer, 2, 3)
    ]

    private static let categoryPracticeGroups: [FriendCategory: [FriendKind]] = [
        .animal: [.cat, .dog, .duck, .rabbit, .fish, .bird],
        .vehicle: [.car, .bus, .train, .truck, .airplane, .boat],
        .fruit: [.apple, .banana, .orange, .pear, .strawberry, .watermelon],
        .body: [.eye, .ear, .mouth, .hand, .foot, .nose],
        .clothing: [.hat, .shirt, .pants, .shoes, .socks, .coat],
        .vegetable: [.carrot, .corn, .tomato, .cucumber, .mushroom, .broccoli],
        .food: [.rice, .noodles, .bread, .egg, .milk, .cookie],
        .tableware: [.bowl, .spoon, .plate, .fork, .chopsticks, .bottle],
        .hygiene: [.toothbrush, .toothpaste, .towel, .soap, .bathtub, .comb],
        .home: [.chair, .table, .bed, .sofa, .lamp, .clock],
        .stationery: [.pencil, .crayon, .eraser, .ruler, .notebook, .schoolbag],
        .instrument: [.drum, .piano, .guitar, .trumpet, .bell, .microphone],
        .toy: [.blocks, .doll, .kite, .puzzle, .rattle, .bucket],
        .nature: [.sun, .cloud, .moon, .flower, .tree, .rainbow],
        .place: [.house, .school, .park, .beach, .store, .playground],
        .profession: [.doctor, .teacher, .policeOfficer, .firefighter, .chef, .farmer],
        .object: [.balloon, .umbrella, .ball, .book, .cup]
    ]

    private static let differencePracticePairs: [(category: FriendCategory, same: FriendKind, different: FriendKind)] = [
        (.animal, .cat, .car),
        (.animal, .dog, .apple),
        (.vehicle, .bus, .banana),
        (.vehicle, .train, .fish),
        (.fruit, .apple, .book),
        (.fruit, .watermelon, .car),
        (.vegetable, .carrot, .cat),
        (.vegetable, .tomato, .bus),
        (.food, .rice, .dog),
        (.food, .bread, .car),
        (.tableware, .bowl, .rabbit),
        (.tableware, .spoon, .banana),
        (.hygiene, .toothbrush, .apple),
        (.hygiene, .towel, .car),
        (.home, .chair, .fish),
        (.home, .bed, .banana),
        (.stationery, .pencil, .dog),
        (.stationery, .notebook, .car),
        (.instrument, .drum, .apple),
        (.instrument, .bell, .truck),
        (.toy, .blocks, .fish),
        (.toy, .kite, .tomato),
        (.nature, .sun, .cup),
        (.nature, .tree, .bus),
        (.place, .house, .fish),
        (.place, .park, .spoon),
        (.profession, .doctor, .banana),
        (.profession, .chef, .car),
        (.object, .book, .rabbit),
        (.object, .umbrella, .banana)
    ]

    private static let positionPracticeKinds: [FriendKind] = [
        .cat,
        .dog,
        .fish,
        .ball,
        .car,
        .apple
    ]
    private static let cardinalPositions: [SpatialPosition] = [.top, .bottom, .left, .right]
    private static let insideOutsidePracticeKinds: [FriendKind] = [
        .cat,
        .ball,
        .apple,
        .book,
        .duck,
        .blocks
    ]
    private static let frontBackPracticeKinds: [FriendKind] = [
        .dog,
        .car,
        .rabbit,
        .truck,
        .doll,
        .schoolbag
    ]
    private static let distancePracticeKinds: [FriendKind] = [
        .cat,
        .dog,
        .car,
        .ball,
        .tree,
        .house
    ]

    private static let purposePracticePairs: [(purpose: FriendPurpose, correct: FriendKind, wrong: FriendKind)] = [
        (.drink, .cup, .book),
        (.read, .book, .ball),
        (.rain, .umbrella, .flower),
        (.fly, .airplane, .truck),
        (.ride, .bus, .apple),
        (.eat, .banana, .car),
        (.play, .ball, .cup),
        (.plant, .tree, .train)
    ]

    private static let safetyPracticePairs: [(safety: FriendSafety, correct: FriendKind, wrong: FriendKind)] = [
        (.safeToTouch, .ball, .knife),
        (.safeToTouch, .book, .kettle),
        (.safeToTouch, .blocks, .scissors),
        (.safeToTouch, .doll, .socket),
        (.askGrownup, .knife, .ball),
        (.askGrownup, .kettle, .book),
        (.askGrownup, .scissors, .blocks),
        (.askGrownup, .socket, .doll)
    ]

    private static let habitPracticePairs: [(habit: FriendHabit, correct: FriendKind, wrong: FriendKind)] = [
        (.washHands, .soap, .ball),
        (.washHands, .towel, .kite),
        (.brushTeeth, .toothbrush, .cup),
        (.drinkWater, .cup, .socks),
        (.tidyToys, .blocks, .banana),
        (.readBook, .book, .car),
        (.wearHat, .hat, .spoon)
    ]

    private static let scenePracticePairs: [(scene: FriendScene, correct: FriendKind, wrong: FriendKind)] = [
        (.sea, .fish, .car),
        (.sky, .bird, .cup),
        (.road, .bus, .watermelon),
        (.home, .book, .airplane),
        (.garden, .flower, .truck),
        (.rainyDay, .umbrella, .sun)
    ]

    private static let weatherPracticePairs: [(weather: FriendWeather, correct: FriendKind, wrong: FriendKind)] = [
        (.sunny, .sun, .umbrella),
        (.sunny, .sun, .cloud),
        (.rainy, .umbrella, .sun),
        (.rainy, .cloud, .ball),
        (.cloudy, .cloud, .apple),
        (.cloudy, .cloud, .book),
        (.windy, .balloon, .cup),
        (.windy, .balloon, .tree)
    ]

    private static let seasonPracticePairs: [(season: FriendSeason, correct: FriendKind, wrong: FriendKind)] = [
        (.spring, .flower, .moon),
        (.spring, .tree, .airplane),
        (.summer, .sun, .coat),
        (.summer, .beach, .clock),
        (.autumn, .apple, .fish),
        (.autumn, .tree, .cup),
        (.winter, .coat, .sun),
        (.winter, .cloud, .flower)
    ]

    private static let routinePracticePairs: [(routine: FriendRoutine, correct: FriendKind, wrong: FriendKind)] = [
        (.morning, .sun, .moon),
        (.morning, .sun, .book),
        (.drinkWater, .cup, .ball),
        (.reading, .book, .banana),
        (.playing, .ball, .cup),
        (.goingOut, .car, .flower),
        (.bedtime, .moon, .sun),
        (.bedtime, .moon, .bus)
    ]

    private static let emotionPracticePairs: [(target: FriendEmotion, distractor: FriendEmotion)] = [
        (.happy, .calm),
        (.calm, .happy),
        (.encouraged, .calm),
        (.happy, .encouraged),
        (.calm, .encouraged),
        (.encouraged, .happy)
    ]

    private static let actionPracticePairs: [(action: FriendAction, correct: FriendKind, wrong: FriendKind)] = [
        (.fly, .bird, .fish),
        (.fly, .airplane, .cup),
        (.swim, .fish, .car),
        (.roll, .ball, .book),
        (.jump, .frog, .tree),
        (.drive, .bus, .banana),
        (.drive, .car, .flower),
        (.grow, .tree, .truck)
    ]

    private static let texturePracticePairs: [(texture: FriendTexture, correct: FriendKind, wrong: FriendKind)] = [
        (.soft, .sheep, .book),
        (.soft, .rabbit, .cup),
        (.hard, .turtle, .balloon),
        (.hard, .book, .sheep),
        (.smooth, .ball, .pineapple),
        (.smooth, .cup, .tree),
        (.rough, .pineapple, .ball),
        (.rough, .tree, .cup)
    ]

    private static let materialPracticePairs: [(material: FriendMaterial, correct: FriendKind, wrong: FriendKind)] = [
        (.wood, .chair, .spoon),
        (.wood, .table, .cup),
        (.metal, .spoon, .book),
        (.metal, .scissors, .shirt),
        (.paper, .book, .ball),
        (.paper, .notebook, .bottle),
        (.glass, .cup, .pencil),
        (.glass, .bottle, .socks),
        (.cloth, .shirt, .fork),
        (.cloth, .towel, .blocks),
        (.plastic, .ball, .bread),
        (.plastic, .blocks, .egg)
    ]

    private static let tastePracticePairs: [(taste: FriendTaste, correct: FriendKind, wrong: FriendKind)] = [
        (.sweet, .strawberry, .lemon),
        (.sweet, .cherry, .pear),
        (.sour, .lemon, .banana),
        (.sour, .orange, .watermelon),
        (.juicy, .watermelon, .book),
        (.juicy, .orange, .ball),
        (.bland, .pear, .pineapple),
        (.bland, .cup, .strawberry)
    ]

    private static let oppositePracticePairs: [(target: FriendOpposite, distractor: FriendOpposite, correct: FriendKind, wrong: FriendKind)] = [
        (.dayNight, .hotCold, .moon, .sun),
        (.upDown, .openClosed, .cloud, .book),
        (.hotCold, .dayNight, .umbrella, .sun),
        (.fullEmpty, .fastSlow, .cup, .bus),
        (.openClosed, .upDown, .book, .cloud),
        (.fastSlow, .fullEmpty, .turtle, .cup)
    ]

    private static let rhythmPracticePairs: [(target: FriendRhythm, distractor: FriendRhythm)] = [
        (.clap, .step),
        (.step, .shake),
        (.shake, .tap),
        (.tap, .clap),
        (.clap, .shake),
        (.step, .tap)
    ]

    private static let sequencePracticePairs: [(target: FriendSequence, distractor: FriendSequence)] = [
        (.first, .second),
        (.second, .last),
        (.last, .first),
        (.first, .last),
        (.second, .first),
        (.last, .second)
    ]

    private static func makeRounds() -> [GameRound] {
        var result: [GameRound] = []

        result += animals.enumerated().map { index, kind in
            matchingRound(.animal, kind, color(for: kind), distractor(for: kind, in: animals, offset: 5), color(for: distractor(for: kind, in: animals, offset: 5)), correctFirst: index.isMultiple(of: 2))
        }

        result += visibleKinds.enumerated().map { index, kind in
            matchingRound(.sound, kind, color(for: kind), distractor(for: kind, in: visibleKinds, offset: 9), color(for: distractor(for: kind, in: visibleKinds, offset: 9)), correctFirst: !index.isMultiple(of: 3))
        }

        result += colorLearningPalette.enumerated().map { colorIndex, targetColor in
            color(
                colorPracticeKinds[colorIndex % colorPracticeKinds.count],
                targetColor,
                colorLearningPalette[(colorIndex + 3) % colorLearningPalette.count],
                correctFirst: colorIndex.isMultiple(of: 2)
            )
        }

        result += shapes.enumerated().map { kindIndex, kind in
            shape(kind, shapePracticeColor, distractor(for: kind, in: shapes, offset: 1), correctFirst: kindIndex.isMultiple(of: 2))
        }

        result += colorShapePracticeKinds.enumerated().map { index, kind in
            colorShape(
                kind,
                colorLearningPalette[index % colorLearningPalette.count],
                wrongKind: colorShapePracticeKinds[(index + 3) % colorShapePracticeKinds.count],
                wrongColor: colorLearningPalette[(index + 4) % colorLearningPalette.count],
                changesColorOnly: index.isMultiple(of: 2),
                correctFirst: !index.isMultiple(of: 2)
            )
        }

        result += bodyParts.enumerated().map { index, kind in
            matchingRound(.body, kind, color(for: kind), distractor(for: kind, in: bodyParts, offset: 2), color(for: distractor(for: kind, in: bodyParts, offset: 2)), correctFirst: !index.isMultiple(of: 2))
        }

        result += clothingItems.enumerated().map { index, kind in
            matchingRound(.clothing, kind, color(for: kind), distractor(for: kind, in: clothingItems, offset: 2), color(for: distractor(for: kind, in: clothingItems, offset: 2)), correctFirst: index.isMultiple(of: 2))
        }

        result += vegetables.enumerated().map { index, kind in
            matchingRound(.vegetable, kind, color(for: kind), distractor(for: kind, in: vegetables, offset: 2), color(for: distractor(for: kind, in: vegetables, offset: 2)), correctFirst: !index.isMultiple(of: 2))
        }

        result += foodItems.enumerated().map { index, kind in
            matchingRound(.food, kind, color(for: kind), distractor(for: kind, in: foodItems, offset: 2), color(for: distractor(for: kind, in: foodItems, offset: 2)), correctFirst: index.isMultiple(of: 2))
        }

        result += tablewareItems.enumerated().map { index, kind in
            matchingRound(.tableware, kind, color(for: kind), distractor(for: kind, in: tablewareItems, offset: 2), color(for: distractor(for: kind, in: tablewareItems, offset: 2)), correctFirst: index.isMultiple(of: 2))
        }

        result += hygieneItems.enumerated().map { index, kind in
            matchingRound(.hygiene, kind, color(for: kind), distractor(for: kind, in: hygieneItems, offset: 2), color(for: distractor(for: kind, in: hygieneItems, offset: 2)), correctFirst: !index.isMultiple(of: 2))
        }

        result += homeItems.enumerated().map { index, kind in
            matchingRound(.home, kind, color(for: kind), distractor(for: kind, in: homeItems, offset: 2), color(for: distractor(for: kind, in: homeItems, offset: 2)), correctFirst: index.isMultiple(of: 2))
        }

        result += stationeryItems.enumerated().map { index, kind in
            matchingRound(.stationery, kind, color(for: kind), distractor(for: kind, in: stationeryItems, offset: 2), color(for: distractor(for: kind, in: stationeryItems, offset: 2)), correctFirst: !index.isMultiple(of: 2))
        }

        result += instrumentItems.enumerated().map { index, kind in
            matchingRound(.instrument, kind, color(for: kind), distractor(for: kind, in: instrumentItems, offset: 2), color(for: distractor(for: kind, in: instrumentItems, offset: 2)), correctFirst: index.isMultiple(of: 2))
        }

        result += toyItems.enumerated().map { index, kind in
            matchingRound(.toy, kind, color(for: kind), distractor(for: kind, in: toyItems, offset: 2), color(for: distractor(for: kind, in: toyItems, offset: 2)), correctFirst: !index.isMultiple(of: 2))
        }

        result += natureItems.enumerated().map { index, kind in
            matchingRound(.nature, kind, color(for: kind), distractor(for: kind, in: natureItems, offset: 2), color(for: distractor(for: kind, in: natureItems, offset: 2)), correctFirst: index.isMultiple(of: 2))
        }

        result += placeItems.enumerated().map { index, kind in
            matchingRound(.place, kind, color(for: kind), distractor(for: kind, in: placeItems, offset: 2), color(for: distractor(for: kind, in: placeItems, offset: 2)), correctFirst: !index.isMultiple(of: 2))
        }

        result += professionItems.enumerated().map { index, kind in
            matchingRound(.profession, kind, color(for: kind), distractor(for: kind, in: professionItems, offset: 2), color(for: distractor(for: kind, in: professionItems, offset: 2)), correctFirst: index.isMultiple(of: 2))
        }

        result += vehicleItems.enumerated().map { index, kind in
            matchingRound(.vehicle, kind, color(for: kind), distractor(for: kind, in: vehicleItems, offset: 2), color(for: distractor(for: kind, in: vehicleItems, offset: 2)), correctFirst: !index.isMultiple(of: 2))
        }

        result += fruitItems.enumerated().map { index, kind in
            matchingRound(.fruit, kind, color(for: kind), distractor(for: kind, in: fruitItems, offset: 2), color(for: distractor(for: kind, in: fruitItems, offset: 2)), correctFirst: index.isMultiple(of: 2))
        }

        result += visibleKinds.enumerated().flatMap { index, kind in
            [
                size(kind, color(for: kind), correctScale: 1.10, wrongScale: 0.66, correctFirst: index.isMultiple(of: 2)),
                size(kind, palette[(index + 4) % palette.count], correctScale: 0.68, wrongScale: 1.12, correctFirst: !index.isMultiple(of: 2))
            ]
        }

        result += lengthPracticeKinds.enumerated().flatMap { index, kind in
            [
                length(kind, color(for: kind), correctScale: 1.25, wrongScale: 0.62, correctFirst: index.isMultiple(of: 2)),
                length(kind, color(for: kind), correctScale: 0.62, wrongScale: 1.25, correctFirst: !index.isMultiple(of: 2))
            ]
        }

        result += heightPracticeKinds.enumerated().flatMap { index, kind in
            [
                height(kind, color(for: kind), correctScale: 1.25, wrongScale: 0.62, correctFirst: index.isMultiple(of: 2)),
                height(kind, color(for: kind), correctScale: 0.62, wrongScale: 1.25, correctFirst: !index.isMultiple(of: 2))
            ]
        }

        result += visibleKinds.enumerated().map { index, kind in
            matchingRound(.shadow, kind, color(for: kind), distractor(for: kind, in: visibleKinds, offset: 7), color(for: distractor(for: kind, in: visibleKinds, offset: 7)), correctFirst: !index.isMultiple(of: 2))
        }

        result += numberPracticeCounts.enumerated().map { index, targetCount in
            number(targetCount: targetCount, distractorCount: numberDistractor(for: targetCount), correctFirst: index.isMultiple(of: 2))
        }

        result += countPracticeKinds.enumerated().flatMap { index, kind in
            [
                count(kind, color(for: kind), targetCount: (index % 4) + 1, distractorCount: ((index + 1) % 4) + 1, correctFirst: index.isMultiple(of: 2)),
                count(kind, color(for: kind), targetCount: ((index + 2) % 4) + 1, distractorCount: ((index + 3) % 4) + 1, correctFirst: !index.isMultiple(of: 2))
            ]
        }

        result += quantityComparePracticePairs.enumerated().map { index, pair in
            quantityCompare(pair.kind, color(for: pair.kind), target: pair.target, correctCount: pair.correctCount, wrongCount: pair.wrongCount, correctFirst: index.isMultiple(of: 2))
        }

        let categoryRounds = categoryPracticeGroups.keys.sorted { $0.rawValue < $1.rawValue }.flatMap { category in
            categoryPracticeGroups[category, default: []].enumerated().map { index, kind in
                categoryRound(
                    category,
                    correctKind: kind,
                    wrongKind: categoryDistractor(for: category, offset: index + 2),
                    correctFirst: index.isMultiple(of: 2)
                )
            }
        }
        result += categoryRounds

        result += differencePracticePairs.enumerated().map { index, pair in
            difference(pair.category, sameKind: pair.same, differentKind: pair.different, correctFirst: !index.isMultiple(of: 2))
        }

        result += positionPracticeKinds.enumerated().flatMap { index, kind in
            let firstTarget = cardinalPositions[index % cardinalPositions.count]
            let secondTarget = cardinalPositions[(index + 2) % cardinalPositions.count]
            return [
                position(kind, color(for: kind), targetPosition: firstTarget, distractorPosition: distractorPosition(for: firstTarget), correctFirst: index.isMultiple(of: 2)),
                position(kind, color(for: kind), targetPosition: secondTarget, distractorPosition: distractorPosition(for: secondTarget), correctFirst: !index.isMultiple(of: 2))
            ]
        }

        result += insideOutsidePracticeKinds.enumerated().flatMap { index, kind in
            [
                insideOutside(kind, color(for: kind), targetPosition: .inside, correctFirst: index.isMultiple(of: 2)),
                insideOutside(kind, color(for: kind), targetPosition: .outside, correctFirst: !index.isMultiple(of: 2))
            ]
        }

        result += frontBackPracticeKinds.enumerated().flatMap { index, kind in
            [
                frontBack(kind, color(for: kind), targetPosition: .front, correctFirst: index.isMultiple(of: 2)),
                frontBack(kind, color(for: kind), targetPosition: .back, correctFirst: !index.isMultiple(of: 2))
            ]
        }

        result += distancePracticeKinds.enumerated().flatMap { index, kind in
            [
                distance(kind, color(for: kind), correctScale: 1.18, wrongScale: 0.70, correctFirst: index.isMultiple(of: 2)),
                distance(kind, color(for: kind), correctScale: 0.70, wrongScale: 1.18, correctFirst: !index.isMultiple(of: 2))
            ]
        }

        result += purposePracticePairs.enumerated().map { index, pair in
            purpose(pair.purpose, correctKind: pair.correct, wrongKind: pair.wrong, correctFirst: index.isMultiple(of: 2))
        }

        result += safetyPracticePairs.enumerated().map { index, pair in
            safety(pair.safety, correctKind: pair.correct, wrongKind: pair.wrong, correctFirst: !index.isMultiple(of: 2))
        }

        result += habitPracticePairs.enumerated().map { index, pair in
            habit(pair.habit, correctKind: pair.correct, wrongKind: pair.wrong, correctFirst: index.isMultiple(of: 2))
        }

        result += scenePracticePairs.enumerated().map { index, pair in
            scene(pair.scene, correctKind: pair.correct, wrongKind: pair.wrong, correctFirst: !index.isMultiple(of: 2))
        }

        result += weatherPracticePairs.enumerated().map { index, pair in
            weather(pair.weather, correctKind: pair.correct, wrongKind: pair.wrong, correctFirst: index.isMultiple(of: 2))
        }

        result += seasonPracticePairs.enumerated().map { index, pair in
            season(pair.season, correctKind: pair.correct, wrongKind: pair.wrong, correctFirst: !index.isMultiple(of: 2))
        }

        result += routinePracticePairs.enumerated().map { index, pair in
            routine(pair.routine, correctKind: pair.correct, wrongKind: pair.wrong, correctFirst: !index.isMultiple(of: 2))
        }

        result += emotionPracticePairs.enumerated().map { index, pair in
            emotion(pair.target, distractor: pair.distractor, correctFirst: index.isMultiple(of: 2))
        }

        result += actionPracticePairs.enumerated().map { index, pair in
            action(pair.action, correctKind: pair.correct, wrongKind: pair.wrong, correctFirst: !index.isMultiple(of: 2))
        }

        result += texturePracticePairs.enumerated().map { index, pair in
            texture(pair.texture, correctKind: pair.correct, wrongKind: pair.wrong, correctFirst: index.isMultiple(of: 2))
        }

        result += materialPracticePairs.enumerated().map { index, pair in
            material(pair.material, correctKind: pair.correct, wrongKind: pair.wrong, correctFirst: !index.isMultiple(of: 2))
        }

        result += tastePracticePairs.enumerated().map { index, pair in
            taste(pair.taste, correctKind: pair.correct, wrongKind: pair.wrong, correctFirst: !index.isMultiple(of: 2))
        }

        result += FriendPairing.allCases.enumerated().map { index, pairing in
            pairingRound(pairing, correctFirst: index.isMultiple(of: 2))
        }

        result += FriendAnimalHome.allCases.enumerated().map { index, animalHome in
            animalHomeRound(animalHome, correctFirst: !index.isMultiple(of: 2))
        }

        result += FriendAnimalBaby.allCases.enumerated().map { index, animalBaby in
            animalBabyRound(animalBaby, correctFirst: index.isMultiple(of: 2))
        }

        result += FriendAnimalFood.allCases.enumerated().map { index, animalFood in
            animalFoodRound(animalFood, correctFirst: !index.isMultiple(of: 2))
        }

        result += FriendItemHome.allCases.enumerated().map { index, itemHome in
            itemHomeRound(itemHome, correctFirst: index.isMultiple(of: 2))
        }

        result += FriendOrigin.allCases.enumerated().map { index, origin in
            originRound(origin, correctFirst: !index.isMultiple(of: 2))
        }

        result += oppositePracticePairs.enumerated().map { index, pair in
            opposite(pair.target, distractor: pair.distractor, correctKind: pair.correct, wrongKind: pair.wrong, correctFirst: index.isMultiple(of: 2))
        }

        result += rhythmPracticePairs.enumerated().map { index, pair in
            rhythm(pair.target, distractor: pair.distractor, correctFirst: index.isMultiple(of: 2))
        }

        result += sequencePracticePairs.enumerated().map { index, pair in
            sequence(pair.target, distractor: pair.distractor, correctFirst: !index.isMultiple(of: 2))
        }

        result += FriendPattern.allCases.enumerated().map { index, pattern in
            patternRound(pattern, correctFirst: index.isMultiple(of: 2))
        }

        return result
    }

    private static func color(
        _ kind: FriendKind,
        _ targetColor: Color,
        _ distractorColor: Color,
        correctFirst: Bool = true
    ) -> GameRound {
        let correct = FriendCandidate(kind: kind, color: targetColor, isCorrect: true)
        let wrong = FriendCandidate(kind: kind, color: distractorColor, isCorrect: false)
        return GameRound(
            mode: .color,
            targetKind: kind,
            targetColor: targetColor,
            candidates: ordered(correct: correct, wrong: wrong, correctFirst: correctFirst)
        )
    }

    private static func shape(
        _ target: FriendKind,
        _ color: Color,
        _ distractor: FriendKind,
        correctFirst: Bool = true
    ) -> GameRound {
        matchingRound(.shape, target, color, distractor, color, correctFirst: correctFirst)
    }

    private static func colorShape(
        _ target: FriendKind,
        _ targetColor: Color,
        wrongKind: FriendKind,
        wrongColor: Color,
        changesColorOnly: Bool,
        correctFirst: Bool
    ) -> GameRound {
        let wrong = changesColorOnly
            ? FriendCandidate(kind: target, color: wrongColor, isCorrect: false)
            : FriendCandidate(kind: wrongKind, color: targetColor, isCorrect: false)
        let correct = FriendCandidate(kind: target, color: targetColor, isCorrect: true)
        return GameRound(
            mode: .colorShape,
            targetKind: target,
            targetColor: targetColor,
            candidates: ordered(correct: correct, wrong: wrong, correctFirst: correctFirst)
        )
    }

    private static func size(
        _ kind: FriendKind,
        _ color: Color,
        correctScale: CGFloat,
        wrongScale: CGFloat,
        correctFirst: Bool = true
    ) -> GameRound {
        let correct = FriendCandidate(kind: kind, color: color, isCorrect: true, sizeScale: correctScale)
        let wrong = FriendCandidate(kind: kind, color: color, isCorrect: false, sizeScale: wrongScale)
        return GameRound(
            mode: .size,
            targetKind: kind,
            targetColor: color,
            targetSizeScale: correctScale,
            candidates: ordered(correct: correct, wrong: wrong, correctFirst: correctFirst)
        )
    }

    private static func count(
        _ kind: FriendKind,
        _ color: Color,
        targetCount: Int,
        distractorCount: Int,
        correctFirst: Bool = true
    ) -> GameRound {
        let correct = FriendCandidate(kind: kind, color: color, isCorrect: true, count: targetCount)
        let wrong = FriendCandidate(kind: kind, color: color, isCorrect: false, count: distractorCount)
        return GameRound(
            mode: .count,
            targetKind: kind,
            targetColor: color,
            targetCount: targetCount,
            candidates: ordered(correct: correct, wrong: wrong, correctFirst: correctFirst)
        )
    }

    private static func length(
        _ kind: FriendKind,
        _ color: Color,
        correctScale: CGFloat,
        wrongScale: CGFloat,
        correctFirst: Bool
    ) -> GameRound {
        let correct = FriendCandidate(kind: kind, color: color, isCorrect: true, sizeScale: correctScale)
        let wrong = FriendCandidate(kind: kind, color: color, isCorrect: false, sizeScale: wrongScale)
        return GameRound(
            mode: .length,
            targetKind: kind,
            targetColor: color,
            targetSizeScale: correctScale,
            candidates: ordered(correct: correct, wrong: wrong, correctFirst: correctFirst)
        )
    }

    private static func height(
        _ kind: FriendKind,
        _ color: Color,
        correctScale: CGFloat,
        wrongScale: CGFloat,
        correctFirst: Bool
    ) -> GameRound {
        let correct = FriendCandidate(kind: kind, color: color, isCorrect: true, sizeScale: correctScale)
        let wrong = FriendCandidate(kind: kind, color: color, isCorrect: false, sizeScale: wrongScale)
        return GameRound(
            mode: .height,
            targetKind: kind,
            targetColor: color,
            targetSizeScale: correctScale,
            candidates: ordered(correct: correct, wrong: wrong, correctFirst: correctFirst)
        )
    }

    private static func number(targetCount: Int, distractorCount: Int, correctFirst: Bool) -> GameRound {
        let correct = FriendCandidate(kind: .blocks, color: .skyBlue, isCorrect: true, count: targetCount)
        let wrong = FriendCandidate(kind: .blocks, color: .softGray, isCorrect: false, count: distractorCount)
        return GameRound(
            mode: .number,
            targetKind: .blocks,
            targetColor: .skyBlue,
            targetCount: targetCount,
            candidates: ordered(correct: correct, wrong: wrong, correctFirst: correctFirst)
        )
    }

    private static func quantityCompare(
        _ kind: FriendKind,
        _ color: Color,
        target: FriendQuantityCompare,
        correctCount: Int,
        wrongCount: Int,
        correctFirst: Bool
    ) -> GameRound {
        let correct = FriendCandidate(kind: kind, color: color, isCorrect: true, count: correctCount)
        let wrong = FriendCandidate(kind: kind, color: color, isCorrect: false, count: wrongCount)
        return GameRound(
            mode: .quantityCompare,
            targetKind: kind,
            targetColor: color,
            targetCount: correctCount,
            targetQuantityCompare: target,
            candidates: ordered(correct: correct, wrong: wrong, correctFirst: correctFirst)
        )
    }

    private static func categoryRound(
        _ category: FriendCategory,
        correctKind: FriendKind,
        wrongKind: FriendKind,
        correctFirst: Bool
    ) -> GameRound {
        let correct = FriendCandidate(kind: correctKind, color: color(for: correctKind), isCorrect: true)
        let wrong = FriendCandidate(kind: wrongKind, color: color(for: wrongKind), isCorrect: false)
        return GameRound(
            mode: .category,
            targetKind: correctKind,
            targetColor: color(for: correctKind),
            targetCategory: category,
            candidates: ordered(correct: correct, wrong: wrong, correctFirst: correctFirst)
        )
    }

    private static func difference(
        _ baseCategory: FriendCategory,
        sameKind: FriendKind,
        differentKind: FriendKind,
        correctFirst: Bool
    ) -> GameRound {
        let correct = FriendCandidate(kind: differentKind, color: color(for: differentKind), isCorrect: true)
        let wrong = FriendCandidate(kind: sameKind, color: color(for: sameKind), isCorrect: false)
        return GameRound(
            mode: .difference,
            targetKind: differentKind,
            targetColor: color(for: differentKind),
            targetCategory: baseCategory,
            candidates: ordered(correct: correct, wrong: wrong, correctFirst: correctFirst)
        )
    }

    private static func position(
        _ kind: FriendKind,
        _ color: Color,
        targetPosition: SpatialPosition,
        distractorPosition: SpatialPosition,
        correctFirst: Bool
    ) -> GameRound {
        let correct = FriendCandidate(kind: kind, color: color, isCorrect: true, position: targetPosition)
        let wrong = FriendCandidate(kind: kind, color: color, isCorrect: false, position: distractorPosition)
        return GameRound(
            mode: .position,
            targetKind: kind,
            targetColor: color,
            targetPosition: targetPosition,
            candidates: ordered(correct: correct, wrong: wrong, correctFirst: correctFirst)
        )
    }

    private static func insideOutside(
        _ kind: FriendKind,
        _ color: Color,
        targetPosition: SpatialPosition,
        correctFirst: Bool
    ) -> GameRound {
        let wrongPosition: SpatialPosition = targetPosition == .inside ? .outside : .inside
        let correct = FriendCandidate(kind: kind, color: color, isCorrect: true, position: targetPosition)
        let wrong = FriendCandidate(kind: kind, color: color, isCorrect: false, position: wrongPosition)
        return GameRound(
            mode: .insideOutside,
            targetKind: kind,
            targetColor: color,
            targetPosition: targetPosition,
            candidates: ordered(correct: correct, wrong: wrong, correctFirst: correctFirst)
        )
    }

    private static func frontBack(
        _ kind: FriendKind,
        _ color: Color,
        targetPosition: SpatialPosition,
        correctFirst: Bool
    ) -> GameRound {
        let wrongPosition: SpatialPosition = targetPosition == .front ? .back : .front
        let correct = FriendCandidate(kind: kind, color: color, isCorrect: true, position: targetPosition)
        let wrong = FriendCandidate(kind: kind, color: color, isCorrect: false, position: wrongPosition)
        return GameRound(
            mode: .frontBack,
            targetKind: kind,
            targetColor: color,
            targetPosition: targetPosition,
            candidates: ordered(correct: correct, wrong: wrong, correctFirst: correctFirst)
        )
    }

    private static func purpose(
        _ purpose: FriendPurpose,
        correctKind: FriendKind,
        wrongKind: FriendKind,
        correctFirst: Bool
    ) -> GameRound {
        let correct = FriendCandidate(kind: correctKind, color: color(for: correctKind), isCorrect: true)
        let wrong = FriendCandidate(kind: wrongKind, color: color(for: wrongKind), isCorrect: false)
        return GameRound(
            mode: .purpose,
            targetKind: correctKind,
            targetColor: color(for: correctKind),
            targetPurpose: purpose,
            candidates: ordered(correct: correct, wrong: wrong, correctFirst: correctFirst)
        )
    }

    private static func distance(
        _ kind: FriendKind,
        _ color: Color,
        correctScale: CGFloat,
        wrongScale: CGFloat,
        correctFirst: Bool
    ) -> GameRound {
        let correct = FriendCandidate(kind: kind, color: color, isCorrect: true, sizeScale: correctScale)
        let wrong = FriendCandidate(kind: kind, color: color, isCorrect: false, sizeScale: wrongScale)
        return GameRound(
            mode: .distance,
            targetKind: kind,
            targetColor: color,
            targetSizeScale: correctScale,
            candidates: ordered(correct: correct, wrong: wrong, correctFirst: correctFirst)
        )
    }

    private static func safety(
        _ safety: FriendSafety,
        correctKind: FriendKind,
        wrongKind: FriendKind,
        correctFirst: Bool
    ) -> GameRound {
        let correct = FriendCandidate(kind: correctKind, color: color(for: correctKind), isCorrect: true)
        let wrong = FriendCandidate(kind: wrongKind, color: color(for: wrongKind), isCorrect: false)
        return GameRound(
            mode: .safety,
            targetKind: correctKind,
            targetColor: color(for: correctKind),
            targetSafety: safety,
            candidates: ordered(correct: correct, wrong: wrong, correctFirst: correctFirst)
        )
    }

    private static func habit(
        _ habit: FriendHabit,
        correctKind: FriendKind,
        wrongKind: FriendKind,
        correctFirst: Bool
    ) -> GameRound {
        let correct = FriendCandidate(kind: correctKind, color: color(for: correctKind), isCorrect: true)
        let wrong = FriendCandidate(kind: wrongKind, color: color(for: wrongKind), isCorrect: false)
        return GameRound(
            mode: .habit,
            targetKind: correctKind,
            targetColor: color(for: correctKind),
            targetHabit: habit,
            candidates: ordered(correct: correct, wrong: wrong, correctFirst: correctFirst)
        )
    }

    private static func scene(
        _ scene: FriendScene,
        correctKind: FriendKind,
        wrongKind: FriendKind,
        correctFirst: Bool
    ) -> GameRound {
        let correct = FriendCandidate(kind: correctKind, color: color(for: correctKind), isCorrect: true)
        let wrong = FriendCandidate(kind: wrongKind, color: color(for: wrongKind), isCorrect: false)
        return GameRound(
            mode: .scene,
            targetKind: correctKind,
            targetColor: color(for: correctKind),
            targetScene: scene,
            candidates: ordered(correct: correct, wrong: wrong, correctFirst: correctFirst)
        )
    }

    private static func weather(
        _ weather: FriendWeather,
        correctKind: FriendKind,
        wrongKind: FriendKind,
        correctFirst: Bool
    ) -> GameRound {
        let correct = FriendCandidate(kind: correctKind, color: color(for: correctKind), isCorrect: true)
        let wrong = FriendCandidate(kind: wrongKind, color: color(for: wrongKind), isCorrect: false)
        return GameRound(
            mode: .weather,
            targetKind: correctKind,
            targetColor: color(for: correctKind),
            targetWeather: weather,
            candidates: ordered(correct: correct, wrong: wrong, correctFirst: correctFirst)
        )
    }

    private static func season(
        _ season: FriendSeason,
        correctKind: FriendKind,
        wrongKind: FriendKind,
        correctFirst: Bool
    ) -> GameRound {
        let correct = FriendCandidate(kind: correctKind, color: color(for: correctKind), isCorrect: true)
        let wrong = FriendCandidate(kind: wrongKind, color: color(for: wrongKind), isCorrect: false)
        return GameRound(
            mode: .season,
            targetKind: correctKind,
            targetColor: color(for: correctKind),
            targetSeason: season,
            candidates: ordered(correct: correct, wrong: wrong, correctFirst: correctFirst)
        )
    }

    private static func routine(
        _ routine: FriendRoutine,
        correctKind: FriendKind,
        wrongKind: FriendKind,
        correctFirst: Bool
    ) -> GameRound {
        let correct = FriendCandidate(kind: correctKind, color: color(for: correctKind), isCorrect: true)
        let wrong = FriendCandidate(kind: wrongKind, color: color(for: wrongKind), isCorrect: false)
        return GameRound(
            mode: .routine,
            targetKind: correctKind,
            targetColor: color(for: correctKind),
            targetRoutine: routine,
            candidates: ordered(correct: correct, wrong: wrong, correctFirst: correctFirst)
        )
    }

    private static func emotion(
        _ target: FriendEmotion,
        distractor: FriendEmotion,
        correctFirst: Bool
    ) -> GameRound {
        let correct = FriendCandidate(kind: .cat, color: .coral, isCorrect: true, emotion: target)
        let wrong = FriendCandidate(kind: .dog, color: .skyBlue, isCorrect: false, emotion: distractor)
        return GameRound(
            mode: .emotion,
            targetKind: .cat,
            targetColor: .coral,
            targetEmotion: target,
            candidates: ordered(correct: correct, wrong: wrong, correctFirst: correctFirst)
        )
    }

    private static func action(
        _ action: FriendAction,
        correctKind: FriendKind,
        wrongKind: FriendKind,
        correctFirst: Bool
    ) -> GameRound {
        let correct = FriendCandidate(kind: correctKind, color: color(for: correctKind), isCorrect: true)
        let wrong = FriendCandidate(kind: wrongKind, color: color(for: wrongKind), isCorrect: false)
        return GameRound(
            mode: .action,
            targetKind: correctKind,
            targetColor: color(for: correctKind),
            targetAction: action,
            candidates: ordered(correct: correct, wrong: wrong, correctFirst: correctFirst)
        )
    }

    private static func texture(
        _ texture: FriendTexture,
        correctKind: FriendKind,
        wrongKind: FriendKind,
        correctFirst: Bool
    ) -> GameRound {
        let correct = FriendCandidate(kind: correctKind, color: color(for: correctKind), isCorrect: true)
        let wrong = FriendCandidate(kind: wrongKind, color: color(for: wrongKind), isCorrect: false)
        return GameRound(
            mode: .texture,
            targetKind: correctKind,
            targetColor: color(for: correctKind),
            targetTexture: texture,
            candidates: ordered(correct: correct, wrong: wrong, correctFirst: correctFirst)
        )
    }

    private static func material(
        _ material: FriendMaterial,
        correctKind: FriendKind,
        wrongKind: FriendKind,
        correctFirst: Bool
    ) -> GameRound {
        let correct = FriendCandidate(kind: correctKind, color: color(for: correctKind), isCorrect: true)
        let wrong = FriendCandidate(kind: wrongKind, color: color(for: wrongKind), isCorrect: false)
        return GameRound(
            mode: .material,
            targetKind: correctKind,
            targetColor: color(for: correctKind),
            targetMaterial: material,
            candidates: ordered(correct: correct, wrong: wrong, correctFirst: correctFirst)
        )
    }

    private static func taste(
        _ taste: FriendTaste,
        correctKind: FriendKind,
        wrongKind: FriendKind,
        correctFirst: Bool
    ) -> GameRound {
        let correct = FriendCandidate(kind: correctKind, color: color(for: correctKind), isCorrect: true)
        let wrong = FriendCandidate(kind: wrongKind, color: color(for: wrongKind), isCorrect: false)
        return GameRound(
            mode: .taste,
            targetKind: correctKind,
            targetColor: color(for: correctKind),
            targetTaste: taste,
            candidates: ordered(correct: correct, wrong: wrong, correctFirst: correctFirst)
        )
    }

    private static func pairingRound(
        _ pairing: FriendPairing,
        correctFirst: Bool
    ) -> GameRound {
        let correct = FriendCandidate(kind: pairing.answerKind, color: color(for: pairing.answerKind), isCorrect: true)
        let wrong = FriendCandidate(kind: pairing.distractorKind, color: color(for: pairing.distractorKind), isCorrect: false)
        return GameRound(
            mode: .pairing,
            targetKind: pairing.answerKind,
            targetColor: color(for: pairing.answerKind),
            targetPairing: pairing,
            candidates: ordered(correct: correct, wrong: wrong, correctFirst: correctFirst)
        )
    }

    private static func animalHomeRound(
        _ animalHome: FriendAnimalHome,
        correctFirst: Bool
    ) -> GameRound {
        let correct = FriendCandidate(kind: animalHome.animalKind, color: color(for: animalHome.animalKind), isCorrect: true)
        let wrong = FriendCandidate(kind: animalHome.distractorKind, color: color(for: animalHome.distractorKind), isCorrect: false)
        return GameRound(
            mode: .animalHome,
            targetKind: animalHome.animalKind,
            targetColor: color(for: animalHome.animalKind),
            targetAnimalHome: animalHome,
            candidates: ordered(correct: correct, wrong: wrong, correctFirst: correctFirst)
        )
    }

    private static func animalBabyRound(
        _ animalBaby: FriendAnimalBaby,
        correctFirst: Bool
    ) -> GameRound {
        let correct = FriendCandidate(kind: animalBaby.babyKind, color: color(for: animalBaby.babyKind), isCorrect: true)
        let wrong = FriendCandidate(kind: animalBaby.distractorKind, color: color(for: animalBaby.distractorKind), isCorrect: false)
        return GameRound(
            mode: .animalBaby,
            targetKind: animalBaby.babyKind,
            targetColor: color(for: animalBaby.babyKind),
            targetAnimalBaby: animalBaby,
            candidates: ordered(correct: correct, wrong: wrong, correctFirst: correctFirst)
        )
    }

    private static func animalFoodRound(
        _ animalFood: FriendAnimalFood,
        correctFirst: Bool
    ) -> GameRound {
        let correct = FriendCandidate(kind: animalFood.foodKind, color: color(for: animalFood.foodKind), isCorrect: true)
        let wrong = FriendCandidate(kind: animalFood.distractorKind, color: color(for: animalFood.distractorKind), isCorrect: false)
        return GameRound(
            mode: .animalFood,
            targetKind: animalFood.foodKind,
            targetColor: color(for: animalFood.foodKind),
            targetAnimalFood: animalFood,
            candidates: ordered(correct: correct, wrong: wrong, correctFirst: correctFirst)
        )
    }

    private static func itemHomeRound(
        _ itemHome: FriendItemHome,
        correctFirst: Bool
    ) -> GameRound {
        let correct = FriendCandidate(kind: itemHome.itemKind, color: color(for: itemHome.itemKind), isCorrect: true)
        let wrong = FriendCandidate(kind: itemHome.distractorKind, color: color(for: itemHome.distractorKind), isCorrect: false)
        return GameRound(
            mode: .itemHome,
            targetKind: itemHome.itemKind,
            targetColor: color(for: itemHome.itemKind),
            targetItemHome: itemHome,
            candidates: ordered(correct: correct, wrong: wrong, correctFirst: correctFirst)
        )
    }

    private static func originRound(
        _ origin: FriendOrigin,
        correctFirst: Bool
    ) -> GameRound {
        let correct = FriendCandidate(kind: origin.sourceKind, color: color(for: origin.sourceKind), isCorrect: true)
        let wrong = FriendCandidate(kind: origin.distractorKind, color: color(for: origin.distractorKind), isCorrect: false)
        return GameRound(
            mode: .origin,
            targetKind: origin.sourceKind,
            targetColor: color(for: origin.sourceKind),
            targetOrigin: origin,
            candidates: ordered(correct: correct, wrong: wrong, correctFirst: correctFirst)
        )
    }

    private static func opposite(
        _ target: FriendOpposite,
        distractor: FriendOpposite,
        correctKind: FriendKind,
        wrongKind: FriendKind,
        correctFirst: Bool
    ) -> GameRound {
        let correct = FriendCandidate(kind: correctKind, color: color(for: correctKind), isCorrect: true, opposite: target)
        let wrong = FriendCandidate(kind: wrongKind, color: color(for: wrongKind), isCorrect: false, opposite: distractor)
        return GameRound(
            mode: .opposite,
            targetKind: correctKind,
            targetColor: color(for: correctKind),
            targetOpposite: target,
            candidates: ordered(correct: correct, wrong: wrong, correctFirst: correctFirst)
        )
    }

    private static func rhythm(
        _ target: FriendRhythm,
        distractor: FriendRhythm,
        correctFirst: Bool
    ) -> GameRound {
        let correct = FriendCandidate(kind: .ball, color: .rosePink, isCorrect: true, rhythm: target)
        let wrong = FriendCandidate(kind: .book, color: .skyBlue, isCorrect: false, rhythm: distractor)
        return GameRound(
            mode: .rhythm,
            targetKind: .ball,
            targetColor: .rosePink,
            targetRhythm: target,
            candidates: ordered(correct: correct, wrong: wrong, correctFirst: correctFirst)
        )
    }

    private static func sequence(
        _ target: FriendSequence,
        distractor: FriendSequence,
        correctFirst: Bool
    ) -> GameRound {
        let correct = FriendCandidate(kind: .star, color: .skyBlue, isCorrect: true, sequence: target)
        let wrong = FriendCandidate(kind: .star, color: .softGray, isCorrect: false, sequence: distractor)
        return GameRound(
            mode: .sequence,
            targetKind: .star,
            targetColor: .skyBlue,
            targetSequence: target,
            candidates: ordered(correct: correct, wrong: wrong, correctFirst: correctFirst)
        )
    }

    private static func patternRound(
        _ pattern: FriendPattern,
        correctFirst: Bool
    ) -> GameRound {
        let correct = FriendCandidate(kind: pattern.correctKind, color: color(for: pattern.correctKind), isCorrect: true)
        let wrong = FriendCandidate(kind: pattern.distractorKind, color: color(for: pattern.distractorKind), isCorrect: false)
        return GameRound(
            mode: .pattern,
            targetKind: pattern.correctKind,
            targetColor: color(for: pattern.correctKind),
            targetPattern: pattern,
            candidates: ordered(correct: correct, wrong: wrong, correctFirst: correctFirst)
        )
    }

    private static func matchingRound(
        _ mode: GameMode,
        _ target: FriendKind,
        _ targetColor: Color,
        _ distractor: FriendKind,
        _ distractorColor: Color,
        correctFirst: Bool
    ) -> GameRound {
        let correct = FriendCandidate(kind: target, color: targetColor, isCorrect: true)
        let wrong = FriendCandidate(kind: distractor, color: distractorColor, isCorrect: false)
        return GameRound(
            mode: mode,
            targetKind: target,
            targetColor: targetColor,
            candidates: ordered(correct: correct, wrong: wrong, correctFirst: correctFirst)
        )
    }

    private static func ordered(correct: FriendCandidate, wrong: FriendCandidate, correctFirst: Bool) -> [FriendCandidate] {
        correctFirst ? [correct, wrong] : [wrong, correct]
    }

    private static func color(for kind: FriendKind) -> Color {
        baseColors[kind] ?? .coral
    }

    private static func distractor(for kind: FriendKind, in kinds: [FriendKind], offset: Int) -> FriendKind {
        guard let index = kinds.firstIndex(of: kind), kinds.count > 1 else {
            return kind
        }
        return kinds[(index + offset) % kinds.count]
    }

    private static func numberDistractor(for targetCount: Int) -> Int {
        let wrappedIndex = targetCount % numberPracticeCounts.count
        return numberPracticeCounts[wrappedIndex]
    }

    private static func categoryDistractor(for category: FriendCategory, offset: Int) -> FriendKind {
        let otherKinds = categoryPracticeGroups
            .filter { $0.key != category }
            .flatMap(\.value)
        guard !otherKinds.isEmpty else {
            return visibleKinds.first { $0.category != category } ?? .cat
        }
        return otherKinds[offset % otherKinds.count]
    }

    private static func distractorPosition(for position: SpatialPosition) -> SpatialPosition {
        switch position {
        case .top:
            return .bottom
        case .bottom:
            return .top
        case .left:
            return .right
        case .right:
            return .left
        case .inside:
            return .outside
        case .outside:
            return .inside
        case .front:
            return .back
        case .back:
            return .front
        }
    }

    private static func balancedShuffled(_ sourceRounds: [GameRound]) -> [GameRound] {
        var buckets = Dictionary(grouping: sourceRounds, by: \.mode)
            .mapValues { $0.shuffled() }
        var result: [GameRound] = []

        while buckets.values.contains(where: { !$0.isEmpty }) {
            for mode in GameMode.allCases.shuffled() {
                guard var bucket = buckets[mode], !bucket.isEmpty else {
                    continue
                }
                result.append(bucket.removeLast())
                buckets[mode] = bucket
            }
        }

        return result
    }

    private static func limitedForSession(_ sourceRounds: [GameRound]) -> [GameRound] {
        var buckets = Dictionary(grouping: sourceRounds, by: \.mode)
            .mapValues { $0.shuffled() }
        var selectedRounds: [GameRound] = []
        var selectedCountsByMode: [GameMode: Int] = [:]

        for mode in GameMode.allCases {
            guard var bucket = buckets[mode], !bucket.isEmpty else {
                continue
            }
            selectedRounds.append(bucket.removeLast())
            selectedCountsByMode[mode, default: 0] += 1
            buckets[mode] = bucket
        }

        let weightedModes = GameMode.allCases.flatMap { mode in
            Array(repeating: mode, count: sessionRoundLimit(for: mode))
        }

        while selectedRounds.count < sessionRoundTotalLimit, buckets.values.contains(where: { !$0.isEmpty }) {
            var didAddRound = false

            for mode in weightedModes.shuffled() {
                guard selectedRounds.count < sessionRoundTotalLimit else {
                    break
                }
                guard selectedCountsByMode[mode, default: 0] < sessionRoundLimit(for: mode) else {
                    continue
                }
                guard var bucket = buckets[mode], !bucket.isEmpty else {
                    continue
                }

                selectedRounds.append(bucket.removeLast())
                selectedCountsByMode[mode, default: 0] += 1
                buckets[mode] = bucket
                didAddRound = true
            }

            guard didAddRound else {
                break
            }
        }

        return selectedRounds
    }

    private static func warmupFirst(_ sourceRounds: [GameRound]) -> [GameRound] {
        var remainingRounds = sourceRounds
        var warmupRounds: [GameRound] = []

        for mode in warmupModes {
            guard let index = remainingRounds.firstIndex(where: { $0.mode == mode }) else {
                continue
            }
            warmupRounds.append(remainingRounds.remove(at: index))
        }

        return warmupRounds + remainingRounds
    }
}

private extension Color {
    static let catOrange = Color(red: 0.94, green: 0.63, blue: 0.30)
    static let dogTan = Color(red: 0.84, green: 0.63, blue: 0.42)
    static let duckYellow = Color(red: 1.0, green: 0.79, blue: 0.24)
    static let bearBrown = Color(red: 0.73, green: 0.54, blue: 0.39)
    static let rabbitCream = Color(red: 0.95, green: 0.91, blue: 0.89)
    static let frogGreen = Color(red: 0.48, green: 0.78, blue: 0.42)
    static let skyBlue = Color(red: 0.22, green: 0.65, blue: 0.94)
    static let coral = Color(red: 1.0, green: 0.42, blue: 0.37)
    static let mintGreen = Color(red: 0.14, green: 0.76, blue: 0.54)
    static let sunYellow = Color(red: 1.0, green: 0.75, blue: 0.18)
    static let purple = Color(red: 0.61, green: 0.45, blue: 0.91)
    static let rosePink = Color(red: 1.0, green: 0.55, blue: 0.70)
    static let leafGreen = Color(red: 0.38, green: 0.68, blue: 0.32)
    static let orange = Color(red: 1.0, green: 0.60, blue: 0.02)
    static let milkBrown = Color(red: 0.70, green: 0.48, blue: 0.30)
    static let berryRed = Color(red: 0.92, green: 0.18, blue: 0.24)
    static let aqua = Color(red: 0.20, green: 0.72, blue: 0.78)
    static let softGray = Color(red: 0.72, green: 0.75, blue: 0.78)
}
