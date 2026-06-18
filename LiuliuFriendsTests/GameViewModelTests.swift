import XCTest
import UIKit
import SwiftUI
@testable import LiuliuFriends

final class GameViewModelTests: XCTestCase {
    override func setUp() {
        super.setUp()
        UserDefaults.standard.removeObject(forKey: "liuliufriends.gameSettings.v1")
    }

    func testRoundsHaveExactlyOneCorrectCandidate() {
        for round in GameContent.rounds {
            let correctCount = round.candidates.filter { $0.isCorrect }.count
            XCTAssertEqual(correctCount, 1, "\(round.mode.title) should have exactly one correct candidate.")
            XCTAssertLessThanOrEqual(round.candidates.count, 2, "1.5-3 岁玩法每轮最多保留两个选项。")
        }
    }

    func testContentCoversAllDesignGameModes() {
        let modes = Set(GameContent.rounds.map(\.mode))
        XCTAssertEqual(modes, Set(GameMode.allCases))
    }

    func testEachGameModeHasEnoughRounds() {
        for mode in GameMode.allCases {
            let count = GameContent.rounds.filter { $0.mode == mode }.count
            XCTAssertGreaterThanOrEqual(count, 6, "\(mode.title) should have enough variety.")
        }
    }

    func testContentHasBroadRoundCoverage() {
        XCTAssertGreaterThanOrEqual(GameContent.rounds.count, 250)
    }

    func testColorRoundsUseEachSpokenColorOnce() {
        let colorRounds = GameContent.rounds.filter { $0.mode == .color }
        let colorPromptIDs = colorRounds.map(\.voicePromptID)

        XCTAssertEqual(colorRounds.count, VoicePromptTarget.colorTargets.count)
        XCTAssertEqual(Set(colorPromptIDs), Set(VoicePromptTarget.colorTargets.map(\.id)))
        XCTAssertEqual(Set(colorPromptIDs).count, colorPromptIDs.count)
    }

    func testBodyRoundsCoverCommonBodyParts() {
        let bodyRounds = GameContent.rounds.filter { $0.mode == .body }
        let bodyKinds = FriendKind.allCases.filter { $0.category == .body }

        XCTAssertEqual(bodyRounds.count, bodyKinds.count)
        XCTAssertEqual(Set(bodyRounds.map(\.targetKind)), Set(bodyKinds))
        for round in bodyRounds {
            XCTAssertTrue(round.promptSpeechText.hasPrefix("找"))
            XCTAssertTrue(round.candidates.allSatisfy { $0.kind.category == .body })
        }
    }

    func testVehicleRoundsCoverCommonVehicles() {
        let vehicleRounds = GameContent.rounds.filter { $0.mode == .vehicle }
        let vehicleKinds = FriendKind.allCases.filter { $0.category == .vehicle }

        XCTAssertEqual(vehicleRounds.count, vehicleKinds.count)
        XCTAssertEqual(Set(vehicleRounds.map(\.targetKind)), Set(vehicleKinds))
        for round in vehicleRounds {
            XCTAssertTrue(round.promptSpeechText.hasPrefix("找"))
            XCTAssertTrue(round.candidates.allSatisfy { $0.kind.category == .vehicle })
        }
    }

    func testFruitRoundsCoverCommonFruits() {
        let fruitRounds = GameContent.rounds.filter { $0.mode == .fruit }
        let fruitKinds = FriendKind.allCases.filter { $0.category == .fruit }

        XCTAssertEqual(fruitRounds.count, fruitKinds.count)
        XCTAssertEqual(Set(fruitRounds.map(\.targetKind)), Set(fruitKinds))
        for round in fruitRounds {
            XCTAssertTrue(round.promptSpeechText.hasPrefix("找"))
            XCTAssertTrue(round.candidates.allSatisfy { $0.kind.category == .fruit })
        }
    }

    func testClothingRoundsCoverCommonClothingItems() {
        let clothingRounds = GameContent.rounds.filter { $0.mode == .clothing }
        let clothingKinds = FriendKind.allCases.filter { $0.category == .clothing }

        XCTAssertEqual(clothingRounds.count, clothingKinds.count)
        XCTAssertEqual(Set(clothingRounds.map(\.targetKind)), Set(clothingKinds))
        for round in clothingRounds {
            XCTAssertTrue(round.promptSpeechText.hasPrefix("找"))
            XCTAssertTrue(round.candidates.allSatisfy { $0.kind.category == .clothing })
        }
    }

    func testVegetableRoundsCoverCommonVegetables() {
        let vegetableRounds = GameContent.rounds.filter { $0.mode == .vegetable }
        let vegetableKinds = FriendKind.allCases.filter { $0.category == .vegetable }

        XCTAssertEqual(vegetableRounds.count, vegetableKinds.count)
        XCTAssertEqual(Set(vegetableRounds.map(\.targetKind)), Set(vegetableKinds))
        for round in vegetableRounds {
            XCTAssertTrue(round.promptSpeechText.hasPrefix("找"))
            XCTAssertTrue(round.candidates.allSatisfy { $0.kind.category == .vegetable })
        }
    }

    func testFoodRoundsCoverCommonFoodItems() {
        let foodRounds = GameContent.rounds.filter { $0.mode == .food }
        let foodKinds = FriendKind.allCases.filter { $0.category == .food }

        XCTAssertEqual(foodRounds.count, foodKinds.count)
        XCTAssertEqual(Set(foodRounds.map(\.targetKind)), Set(foodKinds))
        for round in foodRounds {
            XCTAssertTrue(round.promptSpeechText.hasPrefix("找"))
            XCTAssertTrue(round.candidates.allSatisfy { $0.kind.category == .food })
        }
    }

    func testNumberRoundsCoverDigitsOneToTen() {
        let numberRounds = GameContent.rounds.filter { $0.mode == .number }

        XCTAssertEqual(numberRounds.count, 10)
        XCTAssertEqual(Set(numberRounds.map(\.targetCount)), Set(1...10))
        XCTAssertEqual(Set(numberRounds.map(\.voicePromptID)), Set((1...10).map { "number.\($0)" }))
        for round in numberRounds {
            XCTAssertTrue(round.promptSpeechText.hasPrefix("找数字"))
            XCTAssertEqual(round.targetKind, .blocks)
            XCTAssertEqual(Set(round.candidates.map(\.kind)), [.blocks])
            XCTAssertEqual(round.candidates.filter(\.isCorrect).first?.count, round.targetCount)
            XCTAssertTrue(round.candidates.allSatisfy { (1...10).contains($0.count) })
        }
    }

    func testChineseNumberNamesCoverOneToTen() {
        let names = (1...10).map(\.cnNumberName)

        XCTAssertEqual(names, ["一", "二", "三", "四", "五", "六", "七", "八", "九", "十"])
    }

    func testTablewareRoundsCoverCommonTablewareItems() {
        let tablewareRounds = GameContent.rounds.filter { $0.mode == .tableware }
        let tablewareKinds = FriendKind.allCases.filter { $0.category == .tableware }

        XCTAssertEqual(tablewareRounds.count, tablewareKinds.count)
        XCTAssertEqual(Set(tablewareRounds.map(\.targetKind)), Set(tablewareKinds))
        for round in tablewareRounds {
            XCTAssertTrue(round.promptSpeechText.hasPrefix("找"))
            XCTAssertTrue(round.candidates.allSatisfy { $0.kind.category == .tableware })
        }
    }

    func testHygieneRoundsCoverCommonHygieneItems() {
        let hygieneRounds = GameContent.rounds.filter { $0.mode == .hygiene }
        let hygieneKinds = FriendKind.allCases.filter { $0.category == .hygiene }

        XCTAssertEqual(hygieneRounds.count, hygieneKinds.count)
        XCTAssertEqual(Set(hygieneRounds.map(\.targetKind)), Set(hygieneKinds))
        for round in hygieneRounds {
            XCTAssertTrue(round.promptSpeechText.hasPrefix("找"))
            XCTAssertTrue(round.candidates.allSatisfy { $0.kind.category == .hygiene })
        }
    }

    func testHomeRoundsCoverCommonHomeItems() {
        let homeRounds = GameContent.rounds.filter { $0.mode == .home }
        let homeKinds = FriendKind.allCases.filter { $0.category == .home }

        XCTAssertEqual(homeRounds.count, homeKinds.count)
        XCTAssertEqual(Set(homeRounds.map(\.targetKind)), Set(homeKinds))
        for round in homeRounds {
            XCTAssertTrue(round.promptSpeechText.hasPrefix("找"))
            XCTAssertTrue(round.candidates.allSatisfy { $0.kind.category == .home })
        }
    }

    func testStationeryRoundsCoverCommonStationeryItems() {
        let stationeryRounds = GameContent.rounds.filter { $0.mode == .stationery }
        let stationeryKinds = FriendKind.allCases.filter { $0.category == .stationery }

        XCTAssertEqual(stationeryRounds.count, stationeryKinds.count)
        XCTAssertEqual(Set(stationeryRounds.map(\.targetKind)), Set(stationeryKinds))
        for round in stationeryRounds {
            XCTAssertTrue(round.promptSpeechText.hasPrefix("找"))
            XCTAssertTrue(round.candidates.allSatisfy { $0.kind.category == .stationery })
        }
    }

    func testInstrumentRoundsCoverCommonInstrumentItems() {
        let instrumentRounds = GameContent.rounds.filter { $0.mode == .instrument }
        let instrumentKinds = FriendKind.allCases.filter { $0.category == .instrument }

        XCTAssertEqual(instrumentRounds.count, instrumentKinds.count)
        XCTAssertEqual(Set(instrumentRounds.map(\.targetKind)), Set(instrumentKinds))
        for round in instrumentRounds {
            XCTAssertTrue(round.promptSpeechText.hasPrefix("找"))
            XCTAssertTrue(round.candidates.allSatisfy { $0.kind.category == .instrument })
        }
    }

    func testToyRoundsCoverCommonToyItems() {
        let toyRounds = GameContent.rounds.filter { $0.mode == .toy }
        let toyKinds = FriendKind.allCases.filter { $0.category == .toy }

        XCTAssertEqual(toyRounds.count, toyKinds.count)
        XCTAssertEqual(Set(toyRounds.map(\.targetKind)), Set(toyKinds))
        for round in toyRounds {
            XCTAssertTrue(round.promptSpeechText.hasPrefix("找"))
            XCTAssertTrue(round.candidates.allSatisfy { $0.kind.category == .toy })
        }
    }

    func testNatureRoundsCoverCommonNatureItems() {
        let natureRounds = GameContent.rounds.filter { $0.mode == .nature }
        let natureKinds = FriendKind.allCases.filter { $0.category == .nature }

        XCTAssertEqual(natureRounds.count, natureKinds.count)
        XCTAssertEqual(Set(natureRounds.map(\.targetKind)), Set(natureKinds))
        for round in natureRounds {
            XCTAssertTrue(round.promptSpeechText.hasPrefix("找"))
            XCTAssertTrue(round.candidates.allSatisfy { $0.kind.category == .nature })
        }
    }

    func testPlaceRoundsCoverCommonPlaceItems() {
        let placeRounds = GameContent.rounds.filter { $0.mode == .place }
        let placeKinds = FriendKind.allCases.filter { $0.category == .place }

        XCTAssertEqual(placeRounds.count, placeKinds.count)
        XCTAssertEqual(Set(placeRounds.map(\.targetKind)), Set(placeKinds))
        for round in placeRounds {
            XCTAssertTrue(round.promptSpeechText.hasPrefix("找"))
            XCTAssertTrue(round.candidates.allSatisfy { $0.kind.category == .place })
        }
    }

    func testProfessionRoundsCoverCommonProfessionItems() {
        let professionRounds = GameContent.rounds.filter { $0.mode == .profession }
        let professionKinds = FriendKind.allCases.filter { $0.category == .profession }

        XCTAssertEqual(professionRounds.count, professionKinds.count)
        XCTAssertEqual(Set(professionRounds.map(\.targetKind)), Set(professionKinds))
        for round in professionRounds {
            XCTAssertTrue(round.promptSpeechText.hasPrefix("找"))
            XCTAssertTrue(round.candidates.allSatisfy { $0.kind.category == .profession })
        }
    }

    func testContentCoversCoreFriendCategories() {
        let categories = Set(FriendKind.allCases.map(\.category))

        XCTAssertEqual(categories, [.animal, .vehicle, .fruit, .shape, .body, .clothing, .vegetable, .food, .tableware, .hygiene, .home, .stationery, .instrument, .toy, .nature, .place, .profession, .object])
    }

    func testGameModesUseStructuredAgeBands() {
        XCTAssertEqual(GameMode.animal.ageBand, .starter18Months)
        XCTAssertEqual(GameMode.sound.ageBand, .starter18Months)
        XCTAssertEqual(GameMode.vehicle.ageBand, .explorer24Months)
        XCTAssertEqual(GameMode.fruit.ageBand, .explorer24Months)
        XCTAssertEqual(GameMode.color.ageBand, .explorer24Months)
        XCTAssertEqual(GameMode.shape.ageBand, .explorer24Months)
        XCTAssertEqual(GameMode.colorShape.ageBand, .preschool36Months)
        XCTAssertEqual(GameMode.body.ageBand, .explorer24Months)
        XCTAssertEqual(GameMode.sense.ageBand, .explorer24Months)
        XCTAssertEqual(GameMode.clothing.ageBand, .explorer24Months)
        XCTAssertEqual(GameMode.vegetable.ageBand, .explorer24Months)
        XCTAssertEqual(GameMode.food.ageBand, .explorer24Months)
        XCTAssertEqual(GameMode.tableware.ageBand, .explorer24Months)
        XCTAssertEqual(GameMode.hygiene.ageBand, .explorer24Months)
        XCTAssertEqual(GameMode.home.ageBand, .explorer24Months)
        XCTAssertEqual(GameMode.stationery.ageBand, .explorer24Months)
        XCTAssertEqual(GameMode.instrument.ageBand, .explorer24Months)
        XCTAssertEqual(GameMode.toy.ageBand, .explorer24Months)
        XCTAssertEqual(GameMode.nature.ageBand, .explorer24Months)
        XCTAssertEqual(GameMode.place.ageBand, .explorer24Months)
        XCTAssertEqual(GameMode.profession.ageBand, .explorer24Months)
        XCTAssertEqual(GameMode.category.ageBand, .explorer24Months)
        XCTAssertEqual(GameMode.position.ageBand, .explorer24Months)
        XCTAssertEqual(GameMode.insideOutside.ageBand, .explorer24Months)
        XCTAssertEqual(GameMode.frontBack.ageBand, .explorer24Months)
        XCTAssertEqual(GameMode.routine.ageBand, .explorer24Months)
        XCTAssertEqual(GameMode.emotion.ageBand, .explorer24Months)
        XCTAssertEqual(GameMode.size.ageBand, .matcher30Months)
        XCTAssertEqual(GameMode.length.ageBand, .matcher30Months)
        XCTAssertEqual(GameMode.height.ageBand, .matcher30Months)
        XCTAssertEqual(GameMode.shadow.ageBand, .matcher30Months)
        XCTAssertEqual(GameMode.distance.ageBand, .matcher30Months)
        XCTAssertEqual(GameMode.purpose.ageBand, .matcher30Months)
        XCTAssertEqual(GameMode.safety.ageBand, .matcher30Months)
        XCTAssertEqual(GameMode.habit.ageBand, .matcher30Months)
        XCTAssertEqual(GameMode.scene.ageBand, .matcher30Months)
        XCTAssertEqual(GameMode.samePlace.ageBand, .matcher30Months)
        XCTAssertEqual(GameMode.weather.ageBand, .matcher30Months)
        XCTAssertEqual(GameMode.season.ageBand, .matcher30Months)
        XCTAssertEqual(GameMode.action.ageBand, .matcher30Months)
        XCTAssertEqual(GameMode.texture.ageBand, .matcher30Months)
        XCTAssertEqual(GameMode.temperature.ageBand, .matcher30Months)
        XCTAssertEqual(GameMode.brightness.ageBand, .matcher30Months)
        XCTAssertEqual(GameMode.weight.ageBand, .matcher30Months)
        XCTAssertEqual(GameMode.material.ageBand, .matcher30Months)
        XCTAssertEqual(GameMode.taste.ageBand, .matcher30Months)
        XCTAssertEqual(GameMode.pairing.ageBand, .matcher30Months)
        XCTAssertEqual(GameMode.animalHome.ageBand, .matcher30Months)
        XCTAssertEqual(GameMode.animalBaby.ageBand, .matcher30Months)
        XCTAssertEqual(GameMode.animalFood.ageBand, .matcher30Months)
        XCTAssertEqual(GameMode.itemHome.ageBand, .matcher30Months)
        XCTAssertEqual(GameMode.origin.ageBand, .matcher30Months)
        XCTAssertEqual(GameMode.opposite.ageBand, .matcher30Months)
        XCTAssertEqual(GameMode.difference.ageBand, .matcher30Months)
        XCTAssertEqual(GameMode.number.ageBand, .preschool36Months)
        XCTAssertEqual(GameMode.count.ageBand, .preschool36Months)
        XCTAssertEqual(GameMode.quantityCompare.ageBand, .preschool36Months)
        XCTAssertEqual(GameMode.rhythm.ageBand, .preschool36Months)
        XCTAssertEqual(GameMode.sequence.ageBand, .preschool36Months)
        XCTAssertEqual(GameMode.pattern.ageBand, .preschool36Months)
        XCTAssertEqual(FutureLearningModule.numbers.recommendedAgeBand, .preschool36Months)
        XCTAssertEqual(FutureLearningModule.nurseryRhymes.recommendedAgeBand, .preschool36Months)
    }

    func testLearningAgeBandsHaveStableProgressionOrder() {
        XCTAssertTrue(LearningAgeBand.starter18Months.isIncluded(in: .starter18Months))
        XCTAssertTrue(LearningAgeBand.starter18Months.isIncluded(in: .explorer24Months))
        XCTAssertTrue(LearningAgeBand.explorer24Months.isIncluded(in: .matcher30Months))
        XCTAssertTrue(LearningAgeBand.matcher30Months.isIncluded(in: .preschool36Months))
        XCTAssertFalse(LearningAgeBand.preschool36Months.isIncluded(in: .matcher30Months))
        XCTAssertFalse(LearningAgeBand.matcher30Months.isIncluded(in: .explorer24Months))
    }

    func testGameModesHaveStableSettingsGroups() {
        let groupedModes = Dictionary(grouping: GameMode.allCases, by: \.settingsGroupTitle)

        XCTAssertEqual(Set(groupedModes.keys), Set(GameMode.settingsGroupOrder))
        XCTAssertEqual(Set(groupedModes["基础识物", default: []]), [.animal, .vehicle, .fruit, .sound, .color, .shape, .body, .sense, .clothing, .vegetable, .food, .tableware, .hygiene, .home, .stationery, .instrument, .toy, .nature, .place, .profession])
        XCTAssertEqual(Set(groupedModes["生活关系", default: []]), [.category, .routine, .emotion, .purpose, .safety, .habit, .scene, .samePlace, .weather, .season, .action, .texture, .temperature, .brightness, .weight, .material, .taste, .pairing, .animalHome, .animalBaby, .animalFood, .itemHome, .origin, .opposite])
        XCTAssertEqual(Set(groupedModes["观察匹配", default: []]), [.size, .length, .height, .shadow, .position, .insideOutside, .frontBack, .distance, .difference])
        XCTAssertEqual(Set(groupedModes["进阶思维", default: []]), [.number, .count, .quantityCompare, .colorShape, .rhythm, .sequence, .pattern])
    }

    func testLengthRoundsCompareLongAndShort() {
        let lengthRounds = GameContent.rounds.filter { $0.mode == .length }

        XCTAssertGreaterThanOrEqual(lengthRounds.count, 12)
        XCTAssertEqual(Set(lengthRounds.map { $0.targetSizeScale > 1 }), [true, false])
        for round in lengthRounds {
            XCTAssertTrue(round.promptSpeechText == "找长长的" || round.promptSpeechText == "找短短的")
            XCTAssertEqual(round.candidates.count, 2)
            let correct = round.candidates.first { $0.isCorrect }
            let wrong = round.candidates.first { !$0.isCorrect }
            XCTAssertEqual(correct?.kind, round.targetKind)
            XCTAssertEqual(wrong?.kind, round.targetKind)
            XCTAssertEqual(correct?.sizeScale, round.targetSizeScale)
            XCTAssertNotEqual(correct?.sizeScale, wrong?.sizeScale)
        }
    }

    func testHeightRoundsCompareTallAndShort() {
        let heightRounds = GameContent.rounds.filter { $0.mode == .height }

        XCTAssertGreaterThanOrEqual(heightRounds.count, 12)
        XCTAssertEqual(Set(heightRounds.map { $0.targetSizeScale > 1 }), [true, false])
        for round in heightRounds {
            XCTAssertTrue(round.promptSpeechText == "找高高的" || round.promptSpeechText == "找矮矮的")
            XCTAssertEqual(round.candidates.count, 2)
            let correct = round.candidates.first { $0.isCorrect }
            let wrong = round.candidates.first { !$0.isCorrect }
            XCTAssertEqual(correct?.kind, round.targetKind)
            XCTAssertEqual(wrong?.kind, round.targetKind)
            XCTAssertEqual(correct?.sizeScale, round.targetSizeScale)
            XCTAssertNotEqual(correct?.sizeScale, wrong?.sizeScale)
        }
    }

    func testPositionRoundsStayCardinalOnly() {
        let positionRounds = GameContent.rounds.filter { $0.mode == .position }
        let cardinalPositions: Set<SpatialPosition> = [.top, .bottom, .left, .right]

        XCTAssertFalse(positionRounds.isEmpty)
        XCTAssertEqual(Set(positionRounds.map(\.targetPosition)), cardinalPositions)
        for round in positionRounds {
            XCTAssertTrue(cardinalPositions.contains(round.targetPosition))
            XCTAssertTrue(round.candidates.allSatisfy { cardinalPositions.contains($0.position) })
        }
    }

    func testInsideOutsideRoundsCoverBothRelations() {
        let relationRounds = GameContent.rounds.filter { $0.mode == .insideOutside }
        let relations: Set<SpatialPosition> = [.inside, .outside]

        XCTAssertGreaterThanOrEqual(relationRounds.count, 12)
        XCTAssertEqual(Set(relationRounds.map(\.targetPosition)), relations)
        for round in relationRounds {
            XCTAssertTrue(round.promptSpeechText == "找在里面的\(round.targetKind.name)" || round.promptSpeechText == "找在外面的\(round.targetKind.name)")
            XCTAssertEqual(round.candidates.count, 2)
            XCTAssertTrue(round.candidates.allSatisfy { $0.kind == round.targetKind })
            XCTAssertEqual(Set(round.candidates.map(\.position)), relations)
            XCTAssertEqual(round.candidates.first { $0.isCorrect }?.position, round.targetPosition)
        }
    }

    func testFrontBackRoundsCoverBothRelations() {
        let relationRounds = GameContent.rounds.filter { $0.mode == .frontBack }
        let relations: Set<SpatialPosition> = [.front, .back]

        XCTAssertGreaterThanOrEqual(relationRounds.count, 12)
        XCTAssertEqual(Set(relationRounds.map(\.targetPosition)), relations)
        for round in relationRounds {
            XCTAssertTrue(round.promptSpeechText == "找在前面的\(round.targetKind.name)" || round.promptSpeechText == "找在后面的\(round.targetKind.name)")
            XCTAssertEqual(round.candidates.count, 2)
            XCTAssertTrue(round.candidates.allSatisfy { $0.kind == round.targetKind })
            XCTAssertEqual(Set(round.candidates.map(\.position)), relations)
            XCTAssertEqual(round.candidates.first { $0.isCorrect }?.position, round.targetPosition)
        }
    }

    func testDistanceRoundsCompareNearAndFar() {
        let distanceRounds = GameContent.rounds.filter { $0.mode == .distance }

        XCTAssertGreaterThanOrEqual(distanceRounds.count, 12)
        XCTAssertTrue(distanceRounds.contains { $0.targetSizeScale > 1 })
        XCTAssertTrue(distanceRounds.contains { $0.targetSizeScale < 1 })
        for round in distanceRounds {
            XCTAssertTrue(round.promptSpeechText.hasPrefix(round.targetSizeScale > 1 ? "找近近的" : "找远远的"))
            XCTAssertEqual(round.candidates.count, 2)
            XCTAssertTrue(round.candidates.allSatisfy { $0.kind == round.targetKind })
            XCTAssertTrue(round.candidates.contains { $0.sizeScale > 1 })
            XCTAssertTrue(round.candidates.contains { $0.sizeScale < 1 })
            XCTAssertEqual(round.candidates.first { $0.isCorrect }?.sizeScale, round.targetSizeScale)
        }
    }

    func testFriendCategoryVisualSamplesStayInCategory() {
        for category in FriendCategory.allCases {
            let preferredKind = FriendKind.allCases.first { $0.category == category }!
            let categorySamples = category.categoryCardSampleKinds(preferred: preferredKind)
            let differenceSamples = category.differenceCardSampleKinds

            XCTAssertGreaterThanOrEqual(categorySamples.count, 3, "\(category.title) category card should have enough visual examples.")
            XCTAssertGreaterThanOrEqual(differenceSamples.count, 2, "\(category.title) difference card should have enough visual examples.")
            XCTAssertTrue(categorySamples.allSatisfy { $0.category == category })
            XCTAssertTrue(differenceSamples.allSatisfy { $0.category == category })
        }
    }

    func testPurposeRoundsHaveExplicitPurposeTargets() {
        let purposeRounds = GameContent.rounds.filter { $0.mode == .purpose }

        XCTAssertGreaterThanOrEqual(purposeRounds.count, FriendPurpose.allCases.count * 2)
        XCTAssertEqual(Set(purposeRounds.compactMap(\.targetPurpose)), Set(FriendPurpose.allCases))
        for purpose in FriendPurpose.allCases {
            XCTAssertGreaterThanOrEqual(purposeRounds.filter { $0.targetPurpose == purpose }.count, 2)
        }
        for round in purposeRounds {
            let correct = try! XCTUnwrap(round.candidates.first { $0.isCorrect })
            let wrong = try! XCTUnwrap(round.candidates.first { !$0.isCorrect })
            XCTAssertNotEqual(correct.kind, wrong.kind)
            XCTAssertNotNil(round.targetPurpose)
            XCTAssertTrue(round.promptSpeechText.hasPrefix("找"))
            XCTAssertTrue(round.promptSpeechText.contains(round.targetPurpose!.speechTitle))
            XCTAssertTrue(round.successSpeechText.contains("找到了") || round.successSpeechText.contains(round.targetPurpose!.speechTitle))
        }
    }

    func testSafetyRoundsHaveExplicitSafetyTargets() {
        let safetyRounds = GameContent.rounds.filter { $0.mode == .safety }

        XCTAssertFalse(safetyRounds.isEmpty)
        XCTAssertEqual(Set(safetyRounds.compactMap(\.targetSafety)), Set(FriendSafety.allCases))
        for round in safetyRounds {
            XCTAssertNotNil(round.targetSafety)
            XCTAssertTrue(round.promptSpeechText.hasPrefix("找"))
            XCTAssertTrue(round.promptSpeechText.contains(round.targetSafety!.speechTitle))
            XCTAssertTrue(round.successSpeechText.contains(round.targetSafety!.promptTitle))
        }
    }

    func testHabitRoundsHaveExplicitHabitTargets() {
        let habitRounds = GameContent.rounds.filter { $0.mode == .habit }

        XCTAssertGreaterThanOrEqual(habitRounds.count, FriendHabit.allCases.count * 2)
        XCTAssertEqual(Set(habitRounds.compactMap(\.targetHabit)), Set(FriendHabit.allCases))
        for habit in FriendHabit.allCases {
            XCTAssertGreaterThanOrEqual(habitRounds.filter { $0.targetHabit == habit }.count, 2)
        }
        for round in habitRounds {
            let correct = try! XCTUnwrap(round.candidates.first { $0.isCorrect })
            let wrong = try! XCTUnwrap(round.candidates.first { !$0.isCorrect })
            XCTAssertNotEqual(correct.kind, wrong.kind)
            XCTAssertNotNil(round.targetHabit)
            XCTAssertTrue(round.promptSpeechText.hasPrefix("找"))
            XCTAssertTrue(round.promptSpeechText.contains(round.targetHabit!.speechTitle))
            XCTAssertTrue(round.successSpeechText.contains(round.targetHabit!.promptTitle))
        }
    }

    func testSceneRoundsHaveExplicitSceneTargets() {
        let sceneRounds = GameContent.rounds.filter { $0.mode == .scene }

        XCTAssertGreaterThanOrEqual(sceneRounds.count, FriendScene.allCases.count * 2)
        XCTAssertEqual(Set(sceneRounds.compactMap(\.targetScene)), Set(FriendScene.allCases))
        for scene in FriendScene.allCases {
            XCTAssertGreaterThanOrEqual(sceneRounds.filter { $0.targetScene == scene }.count, 2)
        }
        for round in sceneRounds {
            let correct = try! XCTUnwrap(round.candidates.first { $0.isCorrect })
            let wrong = try! XCTUnwrap(round.candidates.first { !$0.isCorrect })
            XCTAssertNotEqual(correct.kind, wrong.kind)
            XCTAssertNotNil(round.targetScene)
            XCTAssertTrue(round.promptSpeechText.hasPrefix("找"))
            XCTAssertTrue(round.promptSpeechText.contains(round.targetScene!.speechTitle))
            XCTAssertTrue(round.successSpeechText.contains("找到了"))
        }
    }

    func testSamePlaceRoundsHaveExplicitSamePlaceTargets() {
        let samePlaceRounds = GameContent.rounds.filter { $0.mode == .samePlace }

        XCTAssertFalse(samePlaceRounds.isEmpty)
        XCTAssertEqual(Set(samePlaceRounds.compactMap(\.targetSamePlace)), Set(FriendSamePlace.allCases))
        for round in samePlaceRounds {
            let samePlace = try! XCTUnwrap(round.targetSamePlace)
            XCTAssertEqual(round.targetKind, samePlace.answerKind)
            XCTAssertEqual(round.candidates.first { $0.isCorrect }?.kind, samePlace.answerKind)
            XCTAssertTrue(round.candidates.contains { $0.kind == samePlace.distractorKind })
            XCTAssertTrue(round.promptSpeechText.hasPrefix("找"))
            XCTAssertTrue(round.promptSpeechText.contains(samePlace.speechTitle))
            XCTAssertTrue(round.successSpeechText.contains(samePlace.speechTitle))
        }
    }

    func testWeatherRoundsHaveExplicitWeatherTargets() {
        let weatherRounds = GameContent.rounds.filter { $0.mode == .weather }

        XCTAssertFalse(weatherRounds.isEmpty)
        XCTAssertEqual(Set(weatherRounds.compactMap(\.targetWeather)), Set(FriendWeather.allCases))
        for round in weatherRounds {
            XCTAssertNotNil(round.targetWeather)
            XCTAssertTrue(round.promptSpeechText.hasPrefix("找"))
            XCTAssertTrue(round.promptSpeechText.contains(round.targetWeather!.speechTitle))
            XCTAssertTrue(round.successSpeechText.contains("找到了"))
        }
    }

    func testSeasonRoundsHaveExplicitSeasonTargets() {
        let seasonRounds = GameContent.rounds.filter { $0.mode == .season }

        XCTAssertFalse(seasonRounds.isEmpty)
        XCTAssertEqual(Set(seasonRounds.compactMap(\.targetSeason)), Set(FriendSeason.allCases))
        for round in seasonRounds {
            XCTAssertNotNil(round.targetSeason)
            XCTAssertTrue(round.promptSpeechText.hasPrefix("找"))
            XCTAssertTrue(round.promptSpeechText.contains(round.targetSeason!.speechTitle))
            XCTAssertTrue(round.successSpeechText.contains(round.targetSeason!.promptTitle))
        }
    }

    func testRoutineRoundsHaveExplicitRoutineTargets() {
        let routineRounds = GameContent.rounds.filter { $0.mode == .routine }

        XCTAssertFalse(routineRounds.isEmpty)
        XCTAssertEqual(Set(routineRounds.compactMap(\.targetRoutine)), Set(FriendRoutine.allCases))
        for round in routineRounds {
            XCTAssertNotNil(round.targetRoutine)
            XCTAssertTrue(round.promptSpeechText.hasPrefix("找"))
            XCTAssertTrue(round.promptSpeechText.contains(round.targetRoutine!.speechTitle))
            XCTAssertTrue(round.successSpeechText.contains("找到了"))
        }
    }

    func testEmotionRoundsHaveExplicitEmotionTargets() {
        let emotionRounds = GameContent.rounds.filter { $0.mode == .emotion }

        XCTAssertFalse(emotionRounds.isEmpty)
        XCTAssertGreaterThanOrEqual(FriendEmotion.allCases.count, 6)
        XCTAssertEqual(Set(emotionRounds.compactMap(\.targetEmotion)), Set(FriendEmotion.allCases))
        for round in emotionRounds {
            XCTAssertNotNil(round.targetEmotion)
            XCTAssertTrue(round.candidates.allSatisfy { $0.emotion != nil })
            XCTAssertTrue(round.promptSpeechText.hasPrefix("找"))
            XCTAssertTrue(round.promptSpeechText.contains(round.targetEmotion!.speechTitle))
            XCTAssertTrue(round.successSpeechText.contains("找到了"))
        }
    }

    func testSenseRoundsHaveExplicitSenseTargets() {
        let senseRounds = GameContent.rounds.filter { $0.mode == .sense }

        XCTAssertFalse(senseRounds.isEmpty)
        XCTAssertEqual(Set(senseRounds.compactMap(\.targetSense)), Set(FriendSense.allCases))
        for round in senseRounds {
            let sense = try! XCTUnwrap(round.targetSense)
            XCTAssertEqual(round.candidates.first { $0.isCorrect }?.kind, round.targetKind)
            XCTAssertTrue(round.promptSpeechText.hasPrefix("找"))
            XCTAssertTrue(round.promptSpeechText.contains(sense.speechTitle))
            XCTAssertTrue(round.successSpeechText.contains(sense.promptTitle))
        }
    }

    func testActionRoundsHaveExplicitActionTargets() {
        let actionRounds = GameContent.rounds.filter { $0.mode == .action }

        XCTAssertGreaterThanOrEqual(actionRounds.count, FriendAction.allCases.count * 2)
        XCTAssertEqual(Set(actionRounds.compactMap(\.targetAction)), Set(FriendAction.allCases))
        for action in FriendAction.allCases {
            XCTAssertGreaterThanOrEqual(actionRounds.filter { $0.targetAction == action }.count, 2)
        }
        for round in actionRounds {
            let correct = try! XCTUnwrap(round.candidates.first { $0.isCorrect })
            let wrong = try! XCTUnwrap(round.candidates.first { !$0.isCorrect })
            XCTAssertNotEqual(correct.kind, wrong.kind)
            XCTAssertNotNil(round.targetAction)
            XCTAssertTrue(round.promptSpeechText.hasPrefix("找"))
            XCTAssertTrue(round.promptSpeechText.contains(round.targetAction!.speechTitle))
            XCTAssertTrue(round.successSpeechText.contains("找到了"))
        }
    }

    func testTextureRoundsHaveExplicitTextureTargets() {
        let textureRounds = GameContent.rounds.filter { $0.mode == .texture }

        XCTAssertFalse(textureRounds.isEmpty)
        XCTAssertEqual(Set(textureRounds.compactMap(\.targetTexture)), Set(FriendTexture.allCases))
        for round in textureRounds {
            XCTAssertNotNil(round.targetTexture)
            XCTAssertTrue(round.promptSpeechText.hasPrefix("找"))
            XCTAssertTrue(round.promptSpeechText.contains(round.targetTexture!.speechTitle))
            XCTAssertTrue(round.successSpeechText.contains("摸起来"))
        }
    }

    func testTemperatureRoundsHaveExplicitTemperatureTargets() {
        let temperatureRounds = GameContent.rounds.filter { $0.mode == .temperature }

        XCTAssertFalse(temperatureRounds.isEmpty)
        XCTAssertEqual(Set(temperatureRounds.compactMap(\.targetTemperature)), Set(FriendTemperature.allCases))
        for round in temperatureRounds {
            let temperature = try! XCTUnwrap(round.targetTemperature)
            XCTAssertNotEqual(round.candidates.first { $0.isCorrect }?.kind, round.candidates.first { !$0.isCorrect }?.kind)
            XCTAssertTrue(round.promptSpeechText.hasPrefix("找"))
            XCTAssertTrue(round.promptSpeechText.contains(temperature.speechTitle))
            XCTAssertTrue(round.successSpeechText.contains(temperature.promptTitle))
        }
    }

    func testBrightnessRoundsHaveExplicitBrightnessTargets() {
        let brightnessRounds = GameContent.rounds.filter { $0.mode == .brightness }

        XCTAssertFalse(brightnessRounds.isEmpty)
        XCTAssertEqual(Set(brightnessRounds.compactMap(\.targetBrightness)), Set(FriendBrightness.allCases))
        for round in brightnessRounds {
            let brightness = try! XCTUnwrap(round.targetBrightness)
            XCTAssertNotEqual(round.candidates.first { $0.isCorrect }?.kind, round.candidates.first { !$0.isCorrect }?.kind)
            XCTAssertTrue(round.promptSpeechText.hasPrefix("找"))
            XCTAssertTrue(round.promptSpeechText.contains(brightness.speechTitle))
            XCTAssertTrue(round.successSpeechText.contains(brightness.promptTitle))
        }
    }

    func testWeightRoundsHaveExplicitWeightTargets() {
        let weightRounds = GameContent.rounds.filter { $0.mode == .weight }

        XCTAssertFalse(weightRounds.isEmpty)
        XCTAssertEqual(Set(weightRounds.compactMap(\.targetWeight)), Set(FriendWeight.allCases))
        for round in weightRounds {
            let weight = try! XCTUnwrap(round.targetWeight)
            XCTAssertNotEqual(round.candidates.first { $0.isCorrect }?.kind, round.candidates.first { !$0.isCorrect }?.kind)
            XCTAssertTrue(round.promptSpeechText.hasPrefix("找"))
            XCTAssertTrue(round.promptSpeechText.contains(weight.speechTitle))
            XCTAssertTrue(round.successSpeechText.contains(weight.promptTitle))
        }
    }

    func testMaterialRoundsHaveExplicitMaterialTargets() {
        let materialRounds = GameContent.rounds.filter { $0.mode == .material }

        XCTAssertFalse(materialRounds.isEmpty)
        XCTAssertEqual(Set(materialRounds.compactMap(\.targetMaterial)), Set(FriendMaterial.allCases))
        for round in materialRounds {
            let material = try! XCTUnwrap(round.targetMaterial)
            XCTAssertNotEqual(round.candidates.first { $0.isCorrect }?.kind, round.candidates.first { !$0.isCorrect }?.kind)
            XCTAssertTrue(round.promptSpeechText.hasPrefix("找"))
            XCTAssertTrue(round.promptSpeechText.contains(material.speechTitle))
            XCTAssertTrue(round.successSpeechText.contains("是"))
            XCTAssertTrue(round.successSpeechText.contains(material.promptTitle))
        }
    }

    func testTasteRoundsHaveExplicitTasteTargets() {
        let tasteRounds = GameContent.rounds.filter { $0.mode == .taste }

        XCTAssertFalse(tasteRounds.isEmpty)
        XCTAssertEqual(Set(tasteRounds.compactMap(\.targetTaste)), Set(FriendTaste.allCases))
        for round in tasteRounds {
            XCTAssertNotNil(round.targetTaste)
            XCTAssertTrue(round.promptSpeechText.hasPrefix("找"))
            XCTAssertTrue(round.promptSpeechText.contains(round.targetTaste!.speechTitle))
            XCTAssertTrue(round.successSpeechText.contains("尝起来"))
        }
    }

    func testQuantityCompareRoundsCompareMoreAndFewer() {
        let compareRounds = GameContent.rounds.filter { $0.mode == .quantityCompare }

        XCTAssertGreaterThanOrEqual(compareRounds.count, 16)
        XCTAssertEqual(Set(compareRounds.compactMap(\.targetQuantityCompare)), Set(FriendQuantityCompare.allCases))
        for round in compareRounds {
            let target = try! XCTUnwrap(round.targetQuantityCompare)
            let correct = try! XCTUnwrap(round.candidates.first { $0.isCorrect })
            let wrong = try! XCTUnwrap(round.candidates.first { !$0.isCorrect })
            let correctCount = correct.count
            let wrongCount = wrong.count

            XCTAssertEqual(correct.kind, wrong.kind)
            XCTAssertTrue((1...4).contains(correctCount))
            XCTAssertTrue((1...4).contains(wrongCount))
            switch target {
            case .more:
                XCTAssertGreaterThan(correctCount, wrongCount)
            case .fewer:
                XCTAssertLessThan(correctCount, wrongCount)
            }
            XCTAssertTrue(round.promptSpeechText.hasPrefix("找"))
            XCTAssertTrue(round.promptSpeechText.contains(target.speechTitle))
            XCTAssertTrue(round.successSpeechText.contains("找到了"))
        }
    }

    func testShapeRoundsUseSingleNeutralPracticeColor() {
        let shapeRounds = GameContent.rounds.filter { $0.mode == .shape }

        XCTAssertGreaterThanOrEqual(shapeRounds.count, 8)
        XCTAssertEqual(Set(shapeRounds.map(\.targetKind.category)), [.shape])
        for round in shapeRounds {
            XCTAssertTrue(round.promptSpeechText.hasPrefix("找"))
            XCTAssertFalse(round.promptSpeechText.contains(round.targetColor.speechName))
            XCTAssertTrue(round.successSpeechText.contains("找到了"))
            for candidate in round.candidates {
                XCTAssertLessThan(colorDistance(candidate.color.rgbaComponents, round.targetColor.rgbaComponents), 0.01)
            }
        }
    }

    func testColorShapeRoundsCombineTwoAttributes() {
        let colorShapeRounds = GameContent.rounds.filter { $0.mode == .colorShape }

        XCTAssertGreaterThanOrEqual(colorShapeRounds.count, 8)
        XCTAssertEqual(Set(colorShapeRounds.map(\.targetKind.category)), [.shape])
        for round in colorShapeRounds {
            let correct = try! XCTUnwrap(round.candidates.first { $0.isCorrect })
            let wrong = try! XCTUnwrap(round.candidates.first { !$0.isCorrect })
            let correctMatchesTargetColor = colorDistance(correct.color.rgbaComponents, round.targetColor.rgbaComponents) < 0.01
            let wrongMatchesTargetColor = colorDistance(wrong.color.rgbaComponents, round.targetColor.rgbaComponents) < 0.01
            XCTAssertEqual(correct.kind, round.targetKind)
            XCTAssertTrue(correctMatchesTargetColor)
            XCTAssertTrue(wrong.kind != round.targetKind || !wrongMatchesTargetColor)
            XCTAssertTrue(wrong.kind == round.targetKind || wrongMatchesTargetColor)
            XCTAssertTrue(round.promptSpeechText.hasPrefix("找"))
            XCTAssertTrue(round.promptSpeechText.contains(round.targetColor.speechName))
            XCTAssertTrue(round.promptSpeechText.contains(round.targetKind.name))
            XCTAssertTrue(round.successSpeechText.contains("找到了"))
        }
    }

    func testPairingRoundsHaveExplicitPairingTargets() {
        let pairingRounds = GameContent.rounds.filter { $0.mode == .pairing }

        XCTAssertFalse(pairingRounds.isEmpty)
        XCTAssertEqual(Set(pairingRounds.compactMap(\.targetPairing)), Set(FriendPairing.allCases))
        for round in pairingRounds {
            let pairing = try! XCTUnwrap(round.targetPairing)
            XCTAssertEqual(round.targetKind, pairing.answerKind)
            XCTAssertEqual(round.candidates.first { $0.isCorrect }?.kind, pairing.answerKind)
            XCTAssertTrue(round.candidates.contains { $0.kind == pairing.distractorKind })
            XCTAssertTrue(round.promptSpeechText.hasPrefix("找"))
            XCTAssertTrue(round.promptSpeechText.contains(pairing.speechTitle))
            XCTAssertTrue(round.successSpeechText.contains("好搭档"))
        }
    }

    func testAnimalHomeRoundsHaveExplicitHomeTargets() {
        let animalHomeRounds = GameContent.rounds.filter { $0.mode == .animalHome }

        XCTAssertGreaterThanOrEqual(animalHomeRounds.count, 10)
        XCTAssertEqual(Set(animalHomeRounds.compactMap(\.targetAnimalHome)), Set(FriendAnimalHome.allCases))
        for round in animalHomeRounds {
            let animalHome = try! XCTUnwrap(round.targetAnimalHome)
            XCTAssertEqual(round.targetKind, animalHome.animalKind)
            XCTAssertEqual(round.candidates.first { $0.isCorrect }?.kind, animalHome.animalKind)
            XCTAssertTrue(round.candidates.contains { $0.kind == animalHome.distractorKind })
            XCTAssertTrue(round.candidates.allSatisfy { $0.kind.category == .animal })
            XCTAssertTrue(round.promptSpeechText.hasPrefix("找"))
            XCTAssertTrue(round.promptSpeechText.contains(animalHome.speechTitle))
            XCTAssertTrue(round.successSpeechText.contains(animalHome.speechTitle))
        }
    }

    func testAnimalBabyRoundsHaveExplicitBabyTargets() {
        let animalBabyRounds = GameContent.rounds.filter { $0.mode == .animalBaby }

        XCTAssertGreaterThanOrEqual(animalBabyRounds.count, 10)
        XCTAssertEqual(Set(animalBabyRounds.compactMap(\.targetAnimalBaby)), Set(FriendAnimalBaby.allCases))
        for round in animalBabyRounds {
            let animalBaby = try! XCTUnwrap(round.targetAnimalBaby)
            XCTAssertEqual(round.targetKind, animalBaby.babyKind)
            XCTAssertEqual(round.candidates.first { $0.isCorrect }?.kind, animalBaby.babyKind)
            XCTAssertTrue(round.candidates.contains { $0.kind == animalBaby.distractorKind })
            XCTAssertTrue(round.candidates.allSatisfy { $0.kind.category == .animal })
            XCTAssertTrue(round.promptSpeechText.hasPrefix("找"))
            XCTAssertTrue(round.promptSpeechText.contains(animalBaby.speechTitle))
            XCTAssertTrue(round.successSpeechText.contains(animalBaby.speechTitle))
        }
    }

    func testAnimalFoodRoundsHaveExplicitFoodTargets() {
        let animalFoodRounds = GameContent.rounds.filter { $0.mode == .animalFood }

        XCTAssertGreaterThanOrEqual(animalFoodRounds.count, 10)
        XCTAssertEqual(Set(animalFoodRounds.compactMap(\.targetAnimalFood)), Set(FriendAnimalFood.allCases))
        for round in animalFoodRounds {
            let animalFood = try! XCTUnwrap(round.targetAnimalFood)
            XCTAssertEqual(round.targetKind, animalFood.foodKind)
            XCTAssertEqual(round.candidates.first { $0.isCorrect }?.kind, animalFood.foodKind)
            XCTAssertTrue(round.candidates.contains { $0.kind == animalFood.distractorKind })
            XCTAssertNotEqual(animalFood.animalKind, animalFood.foodKind)
            XCTAssertNotEqual(animalFood.foodKind, animalFood.distractorKind)
            XCTAssertTrue(round.promptSpeechText.hasPrefix("找"))
            XCTAssertTrue(round.promptSpeechText.contains(animalFood.speechTitle))
            XCTAssertTrue(round.successSpeechText.contains(animalFood.speechTitle))
        }
    }

    func testItemHomeRoundsHaveExplicitHomeTargets() {
        let itemHomeRounds = GameContent.rounds.filter { $0.mode == .itemHome }

        XCTAssertGreaterThanOrEqual(itemHomeRounds.count, 10)
        XCTAssertEqual(Set(itemHomeRounds.compactMap(\.targetItemHome)), Set(FriendItemHome.allCases))
        for round in itemHomeRounds {
            let itemHome = try! XCTUnwrap(round.targetItemHome)
            XCTAssertEqual(round.targetKind, itemHome.itemKind)
            XCTAssertEqual(round.candidates.first { $0.isCorrect }?.kind, itemHome.itemKind)
            XCTAssertTrue(round.candidates.contains { $0.kind == itemHome.distractorKind })
            XCTAssertNotEqual(itemHome.itemKind, itemHome.distractorKind)
            XCTAssertTrue(round.promptSpeechText.hasPrefix("找"))
            XCTAssertTrue(round.promptSpeechText.contains(itemHome.speechTitle))
            XCTAssertTrue(round.successSpeechText.contains(itemHome.speechTitle))
        }
    }

    func testOriginRoundsHaveExplicitSourceTargets() {
        let originRounds = GameContent.rounds.filter { $0.mode == .origin }

        XCTAssertGreaterThanOrEqual(originRounds.count, 10)
        XCTAssertEqual(Set(originRounds.compactMap(\.targetOrigin)), Set(FriendOrigin.allCases))
        for round in originRounds {
            let origin = try! XCTUnwrap(round.targetOrigin)
            XCTAssertEqual(round.targetKind, origin.sourceKind)
            XCTAssertEqual(round.candidates.first { $0.isCorrect }?.kind, origin.sourceKind)
            XCTAssertTrue(round.candidates.contains { $0.kind == origin.distractorKind })
            XCTAssertNotEqual(origin.sourceKind, origin.distractorKind)
            XCTAssertNotEqual(origin.itemKind, origin.sourceKind)
            XCTAssertTrue(round.promptSpeechText.hasPrefix("找"))
            XCTAssertTrue(round.promptSpeechText.contains(origin.speechTitle))
            XCTAssertTrue(round.successSpeechText.contains(origin.speechTitle))
        }
    }

    func testPairingRoundsIncludeProfessionToolRelationships() {
        let professionPairings = FriendPairing.allCases.filter { $0.cueKind.category == .profession }
        let pairingRounds = GameContent.rounds.filter { $0.mode == .pairing && $0.targetPairing?.cueKind.category == .profession }

        XCTAssertEqual(professionPairings.count, 6)
        XCTAssertEqual(Set(pairingRounds.compactMap(\.targetPairing)), Set(professionPairings))
        for pairing in professionPairings {
            XCTAssertNotEqual(pairing.answerKind.category, .profession)
            XCTAssertNotEqual(pairing.distractorKind, pairing.answerKind)
            XCTAssertTrue(pairing.speechTitle.contains(pairing.cueKind.name))
        }
    }

    func testOppositeRoundsHaveExplicitOppositeTargets() {
        let oppositeRounds = GameContent.rounds.filter { $0.mode == .opposite }

        XCTAssertGreaterThanOrEqual(oppositeRounds.count, FriendOpposite.allCases.count * 2)
        XCTAssertEqual(Set(oppositeRounds.compactMap(\.targetOpposite)), Set(FriendOpposite.allCases))
        for opposite in FriendOpposite.allCases {
            XCTAssertGreaterThanOrEqual(oppositeRounds.filter { $0.targetOpposite == opposite }.count, 2)
        }
        for round in oppositeRounds {
            let target = try! XCTUnwrap(round.targetOpposite)
            let correct = try! XCTUnwrap(round.candidates.first { $0.isCorrect })
            let wrong = try! XCTUnwrap(round.candidates.first { !$0.isCorrect })
            XCTAssertEqual(correct.opposite, target)
            XCTAssertNotEqual(wrong.opposite, target)
            XCTAssertNotEqual(correct.kind, wrong.kind)
            XCTAssertTrue(round.candidates.allSatisfy { $0.opposite != nil })
            XCTAssertTrue(round.promptSpeechText.hasPrefix("找"))
            XCTAssertTrue(round.promptSpeechText.contains(target.speechTitle))
            XCTAssertTrue(round.successSpeechText.contains("找到了"))
        }
    }

    func testDifferenceRoundsUseDifferentCategoryTargets() {
        let differenceRounds = GameContent.rounds.filter { $0.mode == .difference }

        XCTAssertFalse(differenceRounds.isEmpty)
        for round in differenceRounds {
            let baseCategory = try! XCTUnwrap(round.targetCategory)
            let correctKind = try! XCTUnwrap(round.candidates.first { $0.isCorrect }?.kind)
            let wrongKind = try! XCTUnwrap(round.candidates.first { !$0.isCorrect }?.kind)

            XCTAssertNotEqual(correctKind.category, baseCategory)
            XCTAssertEqual(wrongKind.category, baseCategory)
            XCTAssertEqual(round.targetKind, correctKind)
            XCTAssertEqual(round.promptSpeechText, "找不一样的")
            XCTAssertTrue(round.successSpeechText.contains("不一样"))
        }
    }

    func testRhythmRoundsHaveExplicitRhythmTargets() {
        let rhythmRounds = GameContent.rounds.filter { $0.mode == .rhythm }

        XCTAssertGreaterThanOrEqual(rhythmRounds.count, FriendRhythm.allCases.count * 2)
        XCTAssertEqual(Set(rhythmRounds.compactMap(\.targetRhythm)), Set(FriendRhythm.allCases))
        for rhythm in FriendRhythm.allCases {
            XCTAssertGreaterThanOrEqual(rhythmRounds.filter { $0.targetRhythm == rhythm }.count, 2)
        }
        for round in rhythmRounds {
            let target = try! XCTUnwrap(round.targetRhythm)
            let correct = try! XCTUnwrap(round.candidates.first { $0.isCorrect })
            let wrong = try! XCTUnwrap(round.candidates.first { !$0.isCorrect })
            XCTAssertEqual(correct.rhythm, target)
            XCTAssertNotEqual(wrong.rhythm, target)
            XCTAssertTrue(round.candidates.allSatisfy { $0.rhythm != nil })
            XCTAssertTrue(round.promptSpeechText.hasPrefix("找"))
            XCTAssertTrue(round.promptSpeechText.contains(target.speechTitle))
            XCTAssertTrue(round.successSpeechText.contains("找到了"))
        }
    }

    func testSequenceRoundsHaveExplicitSequenceTargets() {
        let sequenceRounds = GameContent.rounds.filter { $0.mode == .sequence }

        XCTAssertGreaterThanOrEqual(sequenceRounds.count, FriendSequence.allCases.count * 2)
        XCTAssertEqual(Set(sequenceRounds.compactMap(\.targetSequence)), Set(FriendSequence.allCases))
        for sequence in FriendSequence.allCases {
            XCTAssertGreaterThanOrEqual(sequenceRounds.filter { $0.targetSequence == sequence }.count, 2)
        }
        for round in sequenceRounds {
            let target = try! XCTUnwrap(round.targetSequence)
            let correct = try! XCTUnwrap(round.candidates.first { $0.isCorrect })
            let wrong = try! XCTUnwrap(round.candidates.first { !$0.isCorrect })
            XCTAssertEqual(correct.sequence, target)
            XCTAssertNotEqual(wrong.sequence, target)
            XCTAssertTrue(round.candidates.allSatisfy { $0.sequence != nil })
            XCTAssertTrue(round.promptSpeechText.hasPrefix("找"))
            XCTAssertTrue(round.promptSpeechText.contains(target.speechTitle))
            XCTAssertTrue(round.successSpeechText.contains("找到了"))
        }
    }

    func testPatternRoundsHaveExplicitPatternTargets() {
        let patternRounds = GameContent.rounds.filter { $0.mode == .pattern }

        XCTAssertFalse(patternRounds.isEmpty)
        XCTAssertEqual(Set(patternRounds.compactMap(\.targetPattern)), Set(FriendPattern.allCases))
        for round in patternRounds {
            let pattern = try! XCTUnwrap(round.targetPattern)
            XCTAssertEqual(round.targetKind, pattern.correctKind)
            XCTAssertEqual(round.candidates.first { $0.isCorrect }?.kind, pattern.correctKind)
            XCTAssertTrue(round.candidates.contains { $0.kind == pattern.distractorKind })
            XCTAssertEqual(pattern.sequencePrefix.count, 3)
            XCTAssertTrue(round.promptSpeechText.hasPrefix("找"))
            XCTAssertTrue(round.promptSpeechText.contains(pattern.speechTitle))
            XCTAssertTrue(round.successSpeechText.contains("找到了"))
        }
    }

    func testSessionRoundsLimitLargeModesAndKeepAllModesVisible() {
        let sessionRounds = GameContent.sessionRounds()
        let countsByMode = Dictionary(grouping: sessionRounds, by: \.mode).mapValues(\.count)

        XCTAssertEqual(Set(countsByMode.keys), Set(GameMode.allCases))
        XCTAssertLessThanOrEqual(sessionRounds.count, GameContent.sessionRoundTotalLimit)
        XCTAssertGreaterThanOrEqual(GameContent.sessionRoundTotalLimit, GameMode.allCases.count)
        for mode in GameMode.allCases {
            XCTAssertLessThanOrEqual(countsByMode[mode, default: 0], GameContent.sessionRoundLimit(for: mode), "\(mode.title) should not dominate one session.")
        }
    }

    func testSessionRoundsStayShortEnoughForOneSitting() {
        let sessionRounds = GameContent.sessionRounds()

        XCTAssertEqual(sessionRounds.count, GameContent.sessionRoundTotalLimit)
    }

    func testSessionRoundLimitsGetShorterForHarderAgeBands() {
        XCTAssertEqual(GameContent.sessionRoundLimit(for: .animal), 10)
        XCTAssertEqual(GameContent.sessionRoundLimit(for: .routine), 7)
        XCTAssertEqual(GameContent.sessionRoundLimit(for: .action), 5)
        XCTAssertEqual(GameContent.sessionRoundLimit(for: .texture), 5)
        XCTAssertEqual(GameContent.sessionRoundLimit(for: .temperature), 5)
        XCTAssertEqual(GameContent.sessionRoundLimit(for: .material), 5)
        XCTAssertEqual(GameContent.sessionRoundLimit(for: .samePlace), 5)
        XCTAssertEqual(GameContent.sessionRoundLimit(for: .pairing), 5)
        XCTAssertEqual(GameContent.sessionRoundLimit(for: .opposite), 5)
        XCTAssertEqual(GameContent.sessionRoundLimit(for: .count), 4)
        XCTAssertEqual(GameContent.sessionRoundLimit(for: .quantityCompare), 4)
        XCTAssertEqual(GameContent.sessionRoundLimit(for: .colorShape), 4)
        XCTAssertEqual(GameContent.sessionRoundLimit(for: .rhythm), 4)
        XCTAssertEqual(GameContent.sessionRoundLimit(for: .sequence), 4)
        XCTAssertEqual(GameContent.sessionRoundLimit(for: .pattern), 4)
    }

    func testSessionStartsWithBasicWarmupModes() {
        let warmupModes = GameContent.sessionRounds().prefix(6).map(\.mode)

        XCTAssertEqual(Array(warmupModes), [.animal, .vehicle, .fruit, .sound, .color, .shape])
    }

    func testAdaptiveWarmupKeepsEarlyRoundsSimple() {
        let viewModel = GameViewModel(feedbackPlayer: TestFeedbackPlayer())
        let simpleAgeBands: Set<LearningAgeBand> = [.starter18Months, .explorer24Months]

        for _ in 0..<10 {
            XCTAssertTrue(simpleAgeBands.contains(viewModel.round.mode.ageBand), "\(viewModel.round.mode.title) should not appear during early warmup.")
            viewModel.nextRound()
        }
    }

    func testAdaptiveWarmupUnlocksHarderRoundsAfterProgress() {
        let hardRound = GameContent.rounds.first { $0.mode == .purpose }!
        let easyRound = GameContent.rounds.first { $0.mode == .animal }!
        let viewModel = GameViewModel(rounds: [hardRound, easyRound], feedbackPlayer: TestFeedbackPlayer())

        XCTAssertEqual(viewModel.round.mode, .animal)
        viewModel.nextRound()
        XCTAssertEqual(viewModel.round.mode, .animal)

        viewModel.completedRounds = 8
        viewModel.nextRound()

        XCTAssertEqual(viewModel.round.mode, .purpose)
    }

    func testMaximumAgeBandFiltersHarderRounds() {
        let viewModel = GameViewModel(feedbackPlayer: TestFeedbackPlayer())
        viewModel.setMaximumAgeBand(.explorer24Months)
        viewModel.completedRounds = 8

        for _ in 0..<30 {
            XCTAssertTrue(viewModel.round.mode.ageBand.isIncluded(in: .explorer24Months), "\(viewModel.round.mode.title) should be filtered by the selected learning stage.")
            viewModel.nextRound()
        }
    }

    func testChangingMaximumAgeBandMovesAwayFromHardCurrentRound() {
        let easyRound = GameContent.rounds.first { $0.mode == .animal }!
        let hardRound = GameContent.rounds.first { $0.mode == .purpose }!
        let viewModel = GameViewModel(rounds: [easyRound, hardRound], feedbackPlayer: TestFeedbackPlayer())
        viewModel.completedRounds = 8
        viewModel.nextRound()

        XCTAssertEqual(viewModel.round.mode, .purpose)
        viewModel.setMaximumAgeBand(.explorer24Months)

        XCTAssertEqual(viewModel.round.mode, .animal)
    }

    func testContentUsesAllFriendKinds() {
        let usedKinds = Set(GameContent.rounds.flatMap { round in
            [round.targetKind] + round.candidates.map(\.kind)
        })

        XCTAssertEqual(usedKinds, Set(FriendKind.allCases))
    }

    func testDeclaredImageAssetsCanLoad() {
        for kind in FriendKind.allCases {
            guard let imageAssetName = kind.imageAssetName else {
                continue
            }

            XCTAssertNotNil(UIImage(named: imageAssetName), "\(kind.name) image asset should load: \(imageAssetName)")
        }
    }

    func testCorrectSelectionCompletesRoundWithoutAutoAdvanceWhenDisabled() {
        let feedback = TestFeedbackPlayer()
        let viewModel = GameViewModel(feedbackPlayer: feedback)
        viewModel.settings.autoAdvanceEnabled = false

        let correct = viewModel.round.candidates.first { $0.isCorrect }!
        let result = viewModel.choose(correct)

        XCTAssertEqual(result, .correct)
        XCTAssertEqual(viewModel.completedCandidateID, correct.id)
        XCTAssertEqual(viewModel.completedRounds, 1)
        XCTAssertEqual(viewModel.celebrationSeed, 1)
        XCTAssertEqual(feedback.correctCount, 1)
        XCTAssertEqual(feedback.correctRecordingID, viewModel.round.voicePromptID)
        XCTAssertTrue(viewModel.showsManualNextRoundControl)
        XCTAssertNotNil(viewModel.completionMessage)
    }

    func testManualNextControlAdvancesWhenAutoAdvanceDisabled() {
        let feedback = TestFeedbackPlayer()
        let viewModel = GameViewModel(feedbackPlayer: feedback, initialPromptDelay: 60)
        viewModel.settings.autoAdvanceEnabled = false
        let firstRoundID = viewModel.round.id

        let correct = viewModel.round.candidates.first { $0.isCorrect }!
        XCTAssertEqual(viewModel.choose(correct), .correct)
        XCTAssertTrue(viewModel.showsManualNextRoundControl)

        viewModel.nextRound()

        XCTAssertNotEqual(viewModel.round.id, firstRoundID)
        XCTAssertNil(viewModel.completedCandidateID)
        XCTAssertNil(viewModel.completionMessage)
        XCTAssertFalse(viewModel.showsManualNextRoundControl)
    }

    func testManualNextControlHiddenWhenAutoAdvanceEnabled() {
        let viewModel = GameViewModel(feedbackPlayer: TestFeedbackPlayer(), autoAdvanceDelay: 60)

        let correct = viewModel.round.candidates.first { $0.isCorrect }!
        XCTAssertEqual(viewModel.choose(correct), .correct)

        XCTAssertFalse(viewModel.showsManualNextRoundControl)
    }

    func testConsecutiveCorrectRoundsShowGentleEncouragement() {
        let viewModel = GameViewModel(feedbackPlayer: TestFeedbackPlayer())
        viewModel.settings.autoAdvanceEnabled = false

        for expectedCount in 1...2 {
            let correct = viewModel.round.candidates.first { $0.isCorrect }!
            XCTAssertEqual(viewModel.choose(correct), .correct)
            XCTAssertEqual(viewModel.consecutiveCorrectRounds, expectedCount)
            XCTAssertNil(viewModel.encouragementMessage)
            viewModel.nextRound()
        }

        var correct = viewModel.round.candidates.first { $0.isCorrect }!
        XCTAssertEqual(viewModel.choose(correct), .correct)
        XCTAssertEqual(viewModel.consecutiveCorrectRounds, 3)
        XCTAssertEqual(viewModel.encouragementMessage, "连续找到 3 个")
        viewModel.nextRound()

        correct = viewModel.round.candidates.first { $0.isCorrect }!
        XCTAssertEqual(viewModel.choose(correct), .correct)
        XCTAssertEqual(viewModel.consecutiveCorrectRounds, 4)
        XCTAssertEqual(viewModel.encouragementMessage, "连续找到 4 个")
    }

    func testWrongSelectionMarksRetryAndDoesNotAdvanceProgress() {
        let feedback = TestFeedbackPlayer()
        let viewModel = GameViewModel(feedbackPlayer: feedback)

        let wrong = viewModel.round.candidates.first { !$0.isCorrect }!
        let result = viewModel.choose(wrong)

        XCTAssertEqual(result, .retry)
        XCTAssertEqual(viewModel.wrongCandidateID, wrong.id)
        XCTAssertEqual(viewModel.completedRounds, 0)
        XCTAssertEqual(viewModel.consecutiveCorrectRounds, 0)
        XCTAssertEqual(feedback.retryCount, 1)
    }

    func testRoundFeedbackBannerReflectsRetryHintAndSuccess() async throws {
        let viewModel = GameViewModel(feedbackPlayer: TestFeedbackPlayer())
        let wrong = viewModel.round.candidates.first { !$0.isCorrect }!
        let correct = viewModel.round.candidates.first { $0.isCorrect }!

        XCTAssertNil(viewModel.roundFeedbackBanner)

        XCTAssertEqual(viewModel.choose(wrong), .retry)
        XCTAssertEqual(viewModel.roundFeedbackBanner?.kind, .retry)
        XCTAssertEqual(viewModel.roundFeedbackBanner?.title, "再试试")

        try await Task.sleep(nanoseconds: 520_000_000)
        XCTAssertEqual(viewModel.roundFeedbackBanner?.kind, .hint)
        XCTAssertEqual(viewModel.roundFeedbackBanner?.title, "看这里")

        try await Task.sleep(nanoseconds: 360_000_000)
        XCTAssertEqual(viewModel.choose(correct), .correct)
        XCTAssertEqual(viewModel.roundFeedbackBanner?.kind, .success)
        XCTAssertEqual(viewModel.roundFeedbackBanner?.title, "找到了")
    }

    func testSelectionIsIgnoredWhileWrongFeedbackIsVisible() {
        let viewModel = GameViewModel(feedbackPlayer: TestFeedbackPlayer())
        let wrong = viewModel.round.candidates.first { !$0.isCorrect }!
        let correct = viewModel.round.candidates.first { $0.isCorrect }!

        XCTAssertEqual(viewModel.choose(wrong), .retry)
        XCTAssertEqual(viewModel.choose(correct), .ignored)
        XCTAssertNil(viewModel.completedCandidateID)
        XCTAssertEqual(viewModel.completedRounds, 0)
    }

    func testWrongSelectionShowsCorrectHint() async throws {
        let viewModel = GameViewModel(feedbackPlayer: TestFeedbackPlayer())
        let wrong = viewModel.round.candidates.first { !$0.isCorrect }!
        let correct = viewModel.round.candidates.first { $0.isCorrect }!

        viewModel.choose(wrong)
        try await Task.sleep(nanoseconds: 520_000_000)

        XCTAssertEqual(viewModel.hintCandidateID, correct.id)
    }

    func testWrongThenCorrectRoundReturnsForGentleReview() async throws {
        let rounds = makeAnimalReviewRounds()
        let viewModel = GameViewModel(rounds: rounds, feedbackPlayer: TestFeedbackPlayer(), autoAdvanceDelay: 60)
        let firstRoundID = viewModel.round.id

        viewModel.choose(viewModel.round.candidates.first { !$0.isCorrect }!)
        try await Task.sleep(nanoseconds: 900_000_000)
        viewModel.choose(viewModel.round.candidates.first { $0.isCorrect }!)

        viewModel.nextRound()
        XCTAssertNotEqual(viewModel.round.id, firstRoundID)
        viewModel.choose(viewModel.round.candidates.first { $0.isCorrect }!)

        viewModel.nextRound()
        XCTAssertNotEqual(viewModel.round.id, firstRoundID)
        viewModel.choose(viewModel.round.candidates.first { $0.isCorrect }!)

        viewModel.nextRound()
        XCTAssertNotEqual(viewModel.round.id, firstRoundID)
        viewModel.choose(viewModel.round.candidates.first { $0.isCorrect }!)

        viewModel.nextRound()

        XCTAssertEqual(viewModel.round.id, firstRoundID)
    }

    func testQueuedReviewRoundsAreSeparatedByNormalPlay() async throws {
        let rounds = makeAnimalReviewRounds()
        let viewModel = GameViewModel(rounds: rounds, feedbackPlayer: TestFeedbackPlayer(), autoAdvanceDelay: 60)
        let firstRoundID = viewModel.round.id

        viewModel.choose(viewModel.round.candidates.first { !$0.isCorrect }!)
        try await Task.sleep(nanoseconds: 900_000_000)
        viewModel.choose(viewModel.round.candidates.first { $0.isCorrect }!)

        viewModel.nextRound()
        let secondRoundID = viewModel.round.id
        viewModel.choose(viewModel.round.candidates.first { $0.isCorrect }!)

        viewModel.nextRound()
        let thirdRoundID = viewModel.round.id
        viewModel.choose(viewModel.round.candidates.first { !$0.isCorrect }!)
        try await Task.sleep(nanoseconds: 900_000_000)
        viewModel.choose(viewModel.round.candidates.first { $0.isCorrect }!)

        viewModel.nextRound()
        viewModel.choose(viewModel.round.candidates.first { $0.isCorrect }!)

        viewModel.nextRound()
        XCTAssertEqual(viewModel.round.id, firstRoundID)
        viewModel.choose(viewModel.round.candidates.first { $0.isCorrect }!)

        viewModel.nextRound()
        XCTAssertEqual(viewModel.round.id, secondRoundID, "A normal round should separate queued review rounds.")
        viewModel.choose(viewModel.round.candidates.first { $0.isCorrect }!)

        viewModel.nextRound()
        XCTAssertEqual(viewModel.round.id, thirdRoundID)
    }

    func testResetProgressClearsQueuedReview() async throws {
        let rounds = makeAnimalReviewRounds()
        let viewModel = GameViewModel(rounds: rounds, feedbackPlayer: TestFeedbackPlayer(), autoAdvanceDelay: 60)

        viewModel.nextRound()
        let reviewedRoundID = viewModel.round.id
        viewModel.choose(viewModel.round.candidates.first { !$0.isCorrect }!)
        try await Task.sleep(nanoseconds: 900_000_000)
        viewModel.choose(viewModel.round.candidates.first { $0.isCorrect }!)
        viewModel.resetProgress()

        for _ in 0..<4 {
            viewModel.nextRound()
            viewModel.choose(viewModel.round.candidates.first { $0.isCorrect }!)
        }

        viewModel.nextRound()

        XCTAssertNotEqual(viewModel.round.id, reviewedRoundID, "Reset should clear pending review rounds instead of jumping back to the reviewed round.")
    }

    func testNextRoundCyclesThroughContent() {
        let viewModel = GameViewModel(feedbackPlayer: TestFeedbackPlayer())
        let firstRoundID = viewModel.round.id

        viewModel.nextRound()

        XCTAssertNotEqual(viewModel.round.id, firstRoundID)
    }

    func testDisabledGameModeIsSkippedWhenAdvancing() {
        let rounds = [
            GameRound(
                mode: .animal,
                targetKind: .cat,
                targetColor: .red,
                candidates: [
                    FriendCandidate(kind: .cat, color: .red, isCorrect: true),
                    FriendCandidate(kind: .dog, color: .red, isCorrect: false)
                ]
            ),
            GameRound(
                mode: .shadow,
                targetKind: .truck,
                targetColor: .gray,
                candidates: [
                    FriendCandidate(kind: .truck, color: .gray, isCorrect: true),
                    FriendCandidate(kind: .bus, color: .gray, isCorrect: false)
                ]
            )
        ]
        let viewModel = GameViewModel(rounds: rounds, feedbackPlayer: TestFeedbackPlayer())

        viewModel.setGameMode(.shadow, enabled: false)
        viewModel.nextRound()

        XCTAssertEqual(viewModel.round.mode, .animal)
    }

    func testDisablingCurrentModeMovesToEnabledRound() {
        let rounds = [
            GameRound(
                mode: .animal,
                targetKind: .cat,
                targetColor: .red,
                candidates: [
                    FriendCandidate(kind: .cat, color: .red, isCorrect: true),
                    FriendCandidate(kind: .dog, color: .red, isCorrect: false)
                ]
            ),
            GameRound(
                mode: .shadow,
                targetKind: .truck,
                targetColor: .gray,
                candidates: [
                    FriendCandidate(kind: .truck, color: .gray, isCorrect: true),
                    FriendCandidate(kind: .bus, color: .gray, isCorrect: false)
                ]
            )
        ]
        let viewModel = GameViewModel(rounds: rounds, feedbackPlayer: TestFeedbackPlayer())
        viewModel.completedRounds = 8
        viewModel.nextRound()

        XCTAssertEqual(viewModel.round.mode, .shadow)
        viewModel.setGameMode(.shadow, enabled: false)

        XCTAssertEqual(viewModel.round.mode, .animal)
    }

    func testCannotDisableLastEnabledGameMode() {
        let viewModel = GameViewModel(feedbackPlayer: TestFeedbackPlayer())

        for mode in GameMode.allCases where mode != .animal {
            viewModel.setGameMode(mode, enabled: false)
        }
        viewModel.setGameMode(.animal, enabled: false)

        XCTAssertEqual(viewModel.settings.enabledGameModes, [.animal])
    }

    func testInitialPromptPlaysOnlyOnce() {
        let feedback = TestFeedbackPlayer()
        let viewModel = GameViewModel(feedbackPlayer: feedback, initialPromptDelay: 0)

        viewModel.playInitialPromptIfNeeded()
        viewModel.playInitialPromptIfNeeded()

        XCTAssertEqual(feedback.promptCount, 1)
    }

    func testStartPlayingTriggersFirstPromptOnce() {
        let feedback = TestFeedbackPlayer()
        let viewModel = GameViewModel(feedbackPlayer: feedback, initialPromptDelay: 0)

        XCTAssertFalse(viewModel.hasStartedPlaying)
        XCTAssertEqual(feedback.promptCount, 0)

        viewModel.startPlaying()
        viewModel.startPlaying()

        XCTAssertTrue(viewModel.hasStartedPlaying)
        XCTAssertEqual(feedback.promptCount, 1)
    }

    func testRoundSpeechTextCoversPromptAndSuccess() {
        let colorRound = GameContent.rounds.first { $0.mode == .color }!
        let soundRound = GameContent.rounds.first { $0.mode == .sound }!

        XCTAssertTrue(colorRound.promptSpeechText.hasPrefix("找"))
        XCTAssertTrue(colorRound.successSpeechText.contains("找到了"))
        XCTAssertTrue(colorRound.voicePromptID.hasPrefix("color."))
        XCTAssertEqual(soundRound.promptSpeechText, "找\(soundRound.targetKind.soundText)")
        XCTAssertEqual(soundRound.voicePromptID, soundRound.targetKind.rawValue)
    }


    func testSoundRoundPromptsAlwaysUseFindPrefix() {
        let viewModel = GameViewModel(feedbackPlayer: TestFeedbackPlayer())

        XCTAssertEqual(viewModel.soundRoundPrompt(for: .cat), "找喵喵")
        XCTAssertEqual(viewModel.soundRoundPrompt(for: .peach), "找桃子")
    }

    func testSoundPromptsUseOnlyRecognizedSoundsOrCanonicalNames() {
        XCTAssertEqual(FriendKind.sheep.soundText, "咩咩")
        XCTAssertEqual(FriendKind.cat.soundText, "喵喵")
        XCTAssertEqual(FriendKind.dog.soundText, "汪汪")
        XCTAssertEqual(FriendKind.horse.soundText, "咴咴")
        XCTAssertEqual(FriendKind.drum.soundText, "咚咚")
        XCTAssertEqual(FriendKind.bell.soundText, "叮铃")
        XCTAssertEqual(FriendKind.rattle.soundText, "沙沙")
        XCTAssertEqual(FriendKind.grape.soundText, "葡萄")
        XCTAssertEqual(FriendKind.circle.soundText, "圆形")
        XCTAssertEqual(FriendKind.watermelon.soundText, "西瓜")
        XCTAssertEqual(FriendKind.butterfly.soundText, "蝴蝶")
    }

    func testRecognizedSoundPromptCatalogOnlyOverridesKnownSoundMakers() {
        let knownSoundMakers: Set<FriendKind> = [
            .cat, .dog, .duck, .frog, .bird, .cow, .sheep, .horse, .pig, .monkey, .tiger, .lion, .bee,
            .car, .train, .truck, .bicycle, .fireTruck, .ambulance, .tractor,
            .drum, .bell, .rattle
        ]

        for kind in FriendKind.allCases where !knownSoundMakers.contains(kind) {
            XCTAssertFalse(LearningPromptTextCatalog.usesRecognizedSoundPrompt(kind), "\(kind.name) should default to canonical name unless it has a widely recognized sound.")
            XCTAssertEqual(kind.soundText, kind.name)
        }
    }

    func testCustomPromptAliasOverridesSpokenPromptWithoutChangingDefaultName() {
        let defaults = UserDefaults(suiteName: "liuliufriends.tests.alias")!
        defaults.removePersistentDomain(forName: "liuliufriends.tests.alias")
        let aliasStore = PromptAliasStore(defaults: defaults)
        let feedback = TestFeedbackPlayer()
        let rounds = [
            GameRound(
                mode: .sound,
                targetKind: .grape,
                targetColor: .red,
                candidates: [
                    FriendCandidate(kind: .grape, color: .red, isCorrect: true),
                    FriendCandidate(kind: .apple, color: .red, isCorrect: false)
                ]
            )
        ]
        let viewModel = GameViewModel(rounds: rounds, promptAliasStore: aliasStore, feedbackPlayer: feedback, initialPromptDelay: 0)

        XCTAssertEqual(viewModel.soundPrompt(for: .grape), "葡萄")
        XCTAssertEqual(viewModel.soundRoundPrompt(for: .grape), "找葡萄")

        viewModel.setCustomPromptName("串串", for: VoicePromptTarget(kind: .grape))
        XCTAssertEqual(viewModel.soundPrompt(for: .grape), "葡萄")

        viewModel.settings.customPromptAliasEnabled = true

        XCTAssertEqual(FriendKind.grape.name, "葡萄")
        XCTAssertEqual(viewModel.soundPrompt(for: .grape), "串串")
        XCTAssertEqual(viewModel.soundRoundPrompt(for: .grape), "找串串")
        viewModel.playInitialPromptIfNeeded()
        XCTAssertEqual(feedback.promptText, "找串串")
    }

    func testEyeComfortDefaultsToEnabled() {
        XCTAssertTrue(GameSettings().eyeComfortEnabled)
    }

    func testGameSettingsPersistAcrossViewModelInstances() {
        let defaults = UserDefaults(suiteName: "liuliufriends.tests.settings")!
        defaults.removePersistentDomain(forName: "liuliufriends.tests.settings")

        let firstViewModel = GameViewModel(feedbackPlayer: TestFeedbackPlayer(), defaults: defaults)
        firstViewModel.settings.eyeComfortEnabled = false
        firstViewModel.settings.voicePromptEnabled = false
        firstViewModel.setMaximumAgeBand(.explorer24Months)
        firstViewModel.setGameMode(.animal, enabled: false)

        let secondViewModel = GameViewModel(feedbackPlayer: TestFeedbackPlayer(), defaults: defaults)

        XCTAssertFalse(secondViewModel.settings.eyeComfortEnabled)
        XCTAssertFalse(secondViewModel.settings.voicePromptEnabled)
        XCTAssertEqual(secondViewModel.settings.maximumAgeBand, .explorer24Months)
        XCTAssertFalse(secondViewModel.settings.enabledGameModes.contains(.animal))
    }

    func testPlayableSummaryFollowsStageAndEnabledModes() {
        let defaults = UserDefaults(suiteName: "liuliufriends.tests.playable.summary")!
        defaults.removePersistentDomain(forName: "liuliufriends.tests.playable.summary")
        let rounds = [
            GameRound(
                mode: .animal,
                targetKind: .cat,
                targetColor: .red,
                candidates: [
                    FriendCandidate(kind: .cat, color: .red, isCorrect: true),
                    FriendCandidate(kind: .dog, color: .red, isCorrect: false)
                ]
            ),
            GameRound(
                mode: .sound,
                targetKind: .dog,
                targetColor: .blue,
                candidates: [
                    FriendCandidate(kind: .dog, color: .blue, isCorrect: true),
                    FriendCandidate(kind: .cat, color: .blue, isCorrect: false)
                ]
            ),
            GameRound(
                mode: .color,
                targetKind: .ball,
                targetColor: .yellow,
                candidates: [
                    FriendCandidate(kind: .ball, color: .yellow, isCorrect: true),
                    FriendCandidate(kind: .ball, color: .blue, isCorrect: false)
                ]
            )
        ]
        let viewModel = GameViewModel(rounds: rounds, feedbackPlayer: TestFeedbackPlayer(), defaults: defaults)

        viewModel.setMaximumAgeBand(.starter18Months)
        XCTAssertEqual(Set(viewModel.stageGameModes), [.animal, .sound])
        XCTAssertEqual(Set(viewModel.playableGameModes), [.animal, .sound])
        XCTAssertEqual(viewModel.playableRoundCount, 2)

        viewModel.setGameMode(.sound, enabled: false)
        XCTAssertEqual(viewModel.playableGameModes, [.animal])
        XCTAssertEqual(viewModel.playableRoundCount, 1)
    }

    func testCorruptSavedGameSettingsFallsBackToDefaults() {
        let defaults = UserDefaults(suiteName: "liuliufriends.tests.settings.corrupt")!
        defaults.removePersistentDomain(forName: "liuliufriends.tests.settings.corrupt")
        defaults.set(Data("not-json".utf8), forKey: "liuliufriends.gameSettings.v1")

        let viewModel = GameViewModel(feedbackPlayer: TestFeedbackPlayer(), defaults: defaults)

        XCTAssertEqual(viewModel.settings, GameSettings())
    }

    func testUsageTickShowsSessionBreakReminder() {
        let defaults = UserDefaults(suiteName: "liuliufriends.tests.session")!
        defaults.removePersistentDomain(forName: "liuliufriends.tests.session")
        let viewModel = GameViewModel(feedbackPlayer: TestFeedbackPlayer(), initialPromptDelay: 60, sessionLimit: 2, dailyLimit: 60, defaults: defaults)

        viewModel.recordActiveUsageTick()
        XCTAssertNil(viewModel.breakReminder)

        viewModel.startPlaying()
        viewModel.recordActiveUsageTick()
        XCTAssertNil(viewModel.breakReminder)

        viewModel.recordActiveUsageTick()
        XCTAssertEqual(viewModel.breakReminder, .sessionLimit)
    }

    func testBreakReminderBlocksSelectionUntilParentContinues() {
        let defaults = UserDefaults(suiteName: "liuliufriends.tests.break")!
        defaults.removePersistentDomain(forName: "liuliufriends.tests.break")
        let feedback = TestFeedbackPlayer()
        let viewModel = GameViewModel(feedbackPlayer: feedback, initialPromptDelay: 60, sessionLimit: 1, dailyLimit: 60, defaults: defaults)
        viewModel.startPlaying()
        viewModel.recordActiveUsageTick()
        let correct = viewModel.round.candidates.first { $0.isCorrect }!

        XCTAssertEqual(viewModel.choose(correct), .ignored)

        viewModel.continueAfterBreak()

        XCTAssertNil(viewModel.breakReminder)
        XCTAssertEqual(viewModel.choose(correct), .correct)
        XCTAssertEqual(feedback.promptCount, 1)
    }

    func testDailyBreakCanBeDismissedForCurrentDay() {
        let defaults = UserDefaults(suiteName: "liuliufriends.tests.daily")!
        defaults.removePersistentDomain(forName: "liuliufriends.tests.daily")
        let viewModel = GameViewModel(feedbackPlayer: TestFeedbackPlayer(), initialPromptDelay: 60, sessionLimit: 60, dailyLimit: 2, defaults: defaults)

        viewModel.startPlaying()
        viewModel.recordActiveUsageTick()
        viewModel.recordActiveUsageTick()
        XCTAssertEqual(viewModel.breakReminder, .dailyLimit)

        viewModel.continueAfterBreak()
        viewModel.recordActiveUsageTick()

        XCTAssertNil(viewModel.breakReminder)
    }

    func testResetProgressReturnsToFirstRound() {
        let viewModel = GameViewModel(feedbackPlayer: TestFeedbackPlayer())
        let firstRoundID = viewModel.round.id
        viewModel.nextRound()

        viewModel.resetProgress()

        XCTAssertEqual(viewModel.round.id, firstRoundID)
        XCTAssertEqual(viewModel.completedRounds, 0)
        XCTAssertEqual(viewModel.consecutiveCorrectRounds, 0)
        XCTAssertNil(viewModel.completedCandidateID)
        XCTAssertNil(viewModel.wrongCandidateID)
    }

    func testResetProgressCancelsPendingAutoAdvance() async throws {
        let viewModel = GameViewModel(feedbackPlayer: TestFeedbackPlayer(), autoAdvanceDelay: 0.05)
        let firstRoundID = viewModel.round.id
        let correct = viewModel.round.candidates.first { $0.isCorrect }!

        viewModel.choose(correct)
        viewModel.resetProgress()

        try await Task.sleep(nanoseconds: 120_000_000)

        XCTAssertEqual(viewModel.round.id, firstRoundID)
        XCTAssertEqual(viewModel.completedRounds, 0)
        XCTAssertNil(viewModel.completedCandidateID)
        XCTAssertNil(viewModel.hintCandidateID)
    }

    func testAutoAdvanceDelaysNextPrompt() async throws {
        let feedback = TestFeedbackPlayer()
        let viewModel = GameViewModel(feedbackPlayer: feedback, autoAdvanceDelay: 0.05, nextPromptDelayAfterAutoAdvance: 0.2)
        let firstRoundID = viewModel.round.id
        let correct = viewModel.round.candidates.first { $0.isCorrect }!

        viewModel.choose(correct)
        try await Task.sleep(nanoseconds: 90_000_000)

        XCTAssertNotEqual(viewModel.round.id, firstRoundID)
        XCTAssertEqual(feedback.promptCount, 0)

        try await Task.sleep(nanoseconds: 180_000_000)

        XCTAssertEqual(feedback.promptCount, 1)
    }

    func testCorrectSelectionClearsPendingWrongFeedbackAfterRetryDelay() async throws {
        let viewModel = GameViewModel(feedbackPlayer: TestFeedbackPlayer())
        let wrong = viewModel.round.candidates.first { !$0.isCorrect }!
        let correct = viewModel.round.candidates.first { $0.isCorrect }!

        viewModel.choose(wrong)
        try await Task.sleep(nanoseconds: 900_000_000)
        viewModel.choose(correct)

        XCTAssertNil(viewModel.wrongCandidateID)
        XCTAssertEqual(viewModel.completedCandidateID, correct.id)
    }

    private func makeAnimalReviewRounds() -> [GameRound] {
        [
            GameRound(
                mode: .animal,
                targetKind: .cat,
                targetColor: .orange,
                candidates: [
                    FriendCandidate(kind: .cat, color: .orange, isCorrect: true),
                    FriendCandidate(kind: .dog, color: .brown, isCorrect: false)
                ]
            ),
            GameRound(
                mode: .animal,
                targetKind: .dog,
                targetColor: .brown,
                candidates: [
                    FriendCandidate(kind: .dog, color: .brown, isCorrect: true),
                    FriendCandidate(kind: .duck, color: .yellow, isCorrect: false)
                ]
            ),
            GameRound(
                mode: .animal,
                targetKind: .duck,
                targetColor: .yellow,
                candidates: [
                    FriendCandidate(kind: .duck, color: .yellow, isCorrect: true),
                    FriendCandidate(kind: .rabbit, color: .white, isCorrect: false)
                ]
            ),
            GameRound(
                mode: .animal,
                targetKind: .rabbit,
                targetColor: .white,
                candidates: [
                    FriendCandidate(kind: .rabbit, color: .white, isCorrect: true),
                    FriendCandidate(kind: .cat, color: .orange, isCorrect: false)
                ]
            ),
            GameRound(
                mode: .animal,
                targetKind: .fish,
                targetColor: .blue,
                candidates: [
                    FriendCandidate(kind: .fish, color: .blue, isCorrect: true),
                    FriendCandidate(kind: .cat, color: .orange, isCorrect: false)
                ]
            )
        ]
    }
}

private final class TestFeedbackPlayer: FeedbackPlaying {
    private(set) var correctCount = 0
    private(set) var retryCount = 0
    private(set) var promptCount = 0
    private(set) var correctRecordingID: String?
    private(set) var promptText: String?

    func playCorrect(text: String, recordingID: String, settings: GameSettings) {
        correctCount += 1
        correctRecordingID = recordingID
    }

    func playRetry(settings: GameSettings) {
        retryCount += 1
    }

    func playPrompt(text: String, recordingID: String, settings: GameSettings) {
        promptCount += 1
        promptText = text
    }
}
