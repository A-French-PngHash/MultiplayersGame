//
//  SnakeGame.swift
//  Multiplayers Game
//
//  Created by Titouan Blossier on 14/05/2020.
//  Copyright © 2020 Titouan Blossier. All rights reserved.
//

import Foundation

class SnakeGame {
    var snakes : Array<Snake>! //Contain all the Snakes in the game.
    var snakeHeadOrientation : Array<Float>! //The scene change this value so that the model can know where is oriented the next tile
    var timer : Timer! //The timer that tick each - tickInterval -
    let tickInterval = 0.10 //Define (in seconds) the time between th game advance
    
    init(numberOfPlayer : Int, teams : Array<Teams>) { //We need The parameter teams to create right snake color
        snakes = []
        for i in 0...numberOfPlayer - 1{
            let snakeBody = [SnakeTile(orientation: 90, posX: 80, posY: 80 + i * 80)]
            let snake = Snake(team: teams[i], body: snakeBody)
            snakes.append(snake)
        }
        snakeHeadOrientation = []
        for _ in 0...numberOfPlayer - 1 {
            snakeHeadOrientation.append(90)
        }
    }
    
    func startGameTick() {
        timer = Timer.scheduledTimer(withTimeInterval: tickInterval, repeats: true, block: { (timer) in
            self.tick()
        })
    }
    
    private func updateExistingSnake() {
        for i in snakes {
            
        }
    }
    
    func tick() {
        sendTickNotification()
    }
    
    private func sendTickNotification() { //This notification is received by the SKScene which update the display
        let tickNotification = Notification(name: Notification.Name(rawValue: "snakeTick"))
        NotificationCenter.default.post(tickNotification)
    }
}
