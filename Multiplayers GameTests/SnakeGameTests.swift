//
//  SnakeGameTests.swift
//  Multiplayers GameTests
//
//  Created by Titouan Blossier on 17/05/2020.
//  Copyright © 2020 Titouan Blossier. All rights reserved.
//
import XCTest
@testable import Multiplayers_Game

class SnakeGameTeste : XCTestCase {
    var game : SnakeGame!
    
    override func setUp() {
        game = SnakeGame(numberOfPlayer: 3, teams: [.blue, .green, .yellow])
    }
    
    func testGivenThereIsNoGameWhenCreatingGameForThreePlayerThenHeadOrientationAndSnakesAreThreeLength() {
        XCTAssertEqual(game.snakes.count, 3)
        XCTAssertEqual(game.snakeHeadOrientation.count, 3)
    }
    
    func testGivenGameCreatedWhenStartingGameThenShouldTickEverySecond() {
        game.startGameTick()
        
        //Each tick, a notification is send
        let notificationExpectation = expectation(forNotification: NSNotification.Name(rawValue: "snakeTick"), object: nil, handler: nil)
        waitForExpectations(timeout: 1, handler: nil)
    }
}
