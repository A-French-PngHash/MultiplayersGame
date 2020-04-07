//
//  Multiplayers_GameTests.swift
//  Multiplayers GameTests
//
//  Created by Titouan Blossier on 06/04/2020.
//  Copyright © 2020 Titouan Blossier. All rights reserved.
//

import XCTest
@testable import Multiplayers_Game

class ChateauGameTests: XCTestCase {
    
    var game : Game!
    override func setUp() {
        game = Game()
        setupBasicMap()
    }
    
    func setupBasicMap() {
        MapData.shared.ways = [
            Way(beginPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 50, y: 0), destinationPoint: CGPoint(x: 100, y: 0), destinationId: 1, beginId: 0, wayTeam: Teams.yellow, angle: 0),
            Way(beginPoint: CGPoint(x: 100, y: 0), endPoint: CGPoint(x: 50, y: 0), destinationPoint: CGPoint(x: 0, y: 0), destinationId: 0, beginId: 1, wayTeam: Teams.green, angle: 0),
            Way(beginPoint: CGPoint(x: 0, y: 100), endPoint: CGPoint(x: 0, y: 50), destinationPoint: CGPoint(x: 0, y: 0), destinationId: 0, beginId: 2, wayTeam: Teams.green, angle: 0),
            Way(beginPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 0, y: 50), destinationPoint: CGPoint(x: 0, y: 100), destinationId: 2, beginId: 0, wayTeam: Teams.green, angle: 0)
        ]
        let firstBase = Base()
        let secondBase = Base()
        let thirdBase = Base()
        firstBase.id = 0
        secondBase.id = 1
        thirdBase.id = 2
        firstBase.team = .yellow
        secondBase.team = .green
        thirdBase.team = .yellow
        
        MapData.shared.bases = [firstBase, secondBase]
        /*
         Map :
         Y(2)
         |
         |
         |
         Y(0) ------ G(1)
 
 
 */
        
    }
    
    func createUnit(team : Teams, poid : Int) -> Multiplayers_Game.Unit{
        let unit = Unit()
        unit.team = team
        unit.poid = poid
        return unit
    }
    
    func testGivenBaseWeightIsFourWhenUnitSendThenBaseWeightShouldBeLessThanFour() {
        MapData.shared.bases[0].poid = 4
        
        _ = game.sendUnit(beginId: 0, way: MapData.shared.ways[0])
        
        XCTAssertLessThan(MapData.shared.bases[0].poid, 40)
    }
    
    func testGivenBaseWeightIsOneWhenUnitSendThenBaseWeightShouldBeOneAndNoUnitSend() {
        MapData.shared.bases[0].poid = 1
        
        let result = game.sendUnit(beginId: 0, way: MapData.shared.ways[0])
        
        XCTAssert(MapData.shared.bases[0].poid == 1 && !result.0)
    }
    
    func testGivenBaseIsNotMaxWhenTimePassThenBaseWeightShouldBeBiggerThanBefore() {
        let weight = Int.random(in: 1...ChateauSize.maxSize)
        MapData.shared.bases[0].poid = weight
        
        game.second()
        
        XCTAssertGreaterThan(MapData.shared.bases[0].poid, weight)
    }

    func testGivenBaseIsMaxWhenTimePassThenBaseWeightShouldBeSameAsBefore() {
        let weight = ChateauSize.maxSize
        MapData.shared.bases[0].poid = weight
        
        game.second()
        
        XCTAssertEqual(MapData.shared.bases[0].poid, weight)
    }
    
    func testGivenSendedUnitOfNotMaxSizeAndBaseSizeGreaterThanUnitSizeWhenUnitArriveToStrangerBaseThenBaseWeightShouldCorrespond() {
        let weight = Int.random(in: 1...5)
        MapData.shared.bases[1].poid = Int.random(in: weight...ChateauSize.maxSize)
        let unit = createUnit(team: .yellow, poid: weight)
        let final = MapData.shared.bases[1].poid - weight
        
        _ = game.unitArrived(beginId: 0, unit: unit, destinationId: 1)
        
        XCTAssertEqual(MapData.shared.bases[1].poid, final)
    }
    
    func testGivenSendUnitYellowAndBaseNotMaxWhenUnitArriveToYellowThenBaseGreaterThanBefore() {
        let weight = Int.random(in: 1...ChateauSize.maxSize - 1)
        game.base(id: 0).poid = weight
        let unit = createUnit(team: .yellow, poid: 3)
        
        _ = game.unitArrived(beginId: 2, unit: unit, destinationId: 0)
        
        XCTAssertGreaterThan(game.base(id: 0).poid, weight)
    }
    
    func testGivenSendUnitThatCanCaptureBaseWhenUnitArriveThenBaseNewTeamAndNewWeight() {
        let weight = Int.random(in: 1...5)
        let unit = createUnit(team: .yellow, poid: weight)
        game.base(id: 1).poid = 1
        
        game.unitArrived(beginId: 0, unit: unit, destinationId: 1)
        
        let rightTeam = game.base(id: 1).team == .yellow
        let rightWeight = game.base(id: 1).poid == weight
        XCTAssert(rightTeam && rightWeight)
    }

}
