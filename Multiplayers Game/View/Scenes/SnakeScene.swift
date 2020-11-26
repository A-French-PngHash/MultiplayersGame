//
//  SnakeScene.swift
//  Multiplayers Game
//
//  Created by Titouan Blossier on 11/04/2020.
//  Copyright © 2020 Titouan Blossier. All rights reserved.
//

import SpriteKit
import Foundation

class SnakeScene : SKScene {
    var numberOfPlayer : Int!
    var playersTeam : Array<Teams>! //Contain the teams selected on the main menu.
    var buttonSprites : Array<SKSpriteNode>! //The buttons displayed on the screen so that the player interact with their snake are stored here.
    var snakes : Array<Snake> {
        get {
            return game.snakes
        }
    }
    var snakesTiles : Array<Array<SKSpriteNode>>! //In all the SKSpriteNode Array contained in this array, the first element correspond to the last in the cnake body. It's a queue : last in, last out
    var game : SnakeGame!
    
    override func didMove(to view: SKView) {
        game = SnakeGame(numberOfPlayer: numberOfPlayer, teams: playersTeam)
        
        buttonSprites = []
        self.backgroundColor = .white
        displayButtons()
        
        NotificationCenter.default.addObserver(self, selector: #selector(tick), name: NSNotification.Name(rawValue: "snakeTick"), object: nil)
    
        self.initialSnakeDraw()
        game.startGameTick()
        
    }
    
    func displayButtons() {
        let buttonPosition = [[0.900, 0.050], [0.100, 0.900], [0.100, 0.050], [0.900, 0.900], [0.100, 0.500,], [0.900, 0.500]]
        for i in 0...numberOfPlayer - 1 {
            let team = playersTeam[i]
            let button = SnakeButton(imageNamed: "\(playersTeam[i])Button")
            button.team = team
            button.size = CGSize(width: 50, height: 50)
            button.position = Function.posFor(x: CGFloat(buttonPosition[i][0]) , y: CGFloat(buttonPosition[i][1]), size: self.size)
            buttonSprites.append(button)
            self.addChild(button)
        }
    }
    
    @objc func tick() {
        //updateSnakePosition()
    }
    
    func initialSnakeDraw() { // This function draw all the snake one by one at teh start of the game
        snakesTiles = []
        for i in 0...numberOfPlayer - 1 {
            snakesTiles.append([])
        }
        for (index, snake) in snakes.enumerated() {
            for i in snake.body {
                let snakeTile = createTileFor(snakeTile: i, team: snake.team)
                snakesTiles[index].append(snakeTile) //The tile are in this array so that they can be deleted when the snake move.
                self.addChild(snakeTile)
            }
        }
    }
    
    private func redrawSnakePosition() { //Rather than moving all the tile one by one (which would consume a lot of performance), it's deleting the last one and adding a new one at the top of the snake. This function do it
        for (index, snake) in snakes.enumerated() {
            //We first delete the last one
            snakesTiles[index].remove(at: 0)
            //TODO: verify if the size need to be increased
            
            //TODO: Create a face for the snake
            let tileObject = snakes[index].body.last!
            let newTileNode = createTileFor(snakeTile: tileObject, team: snake.team)
            snakesTiles[index].append(newTileNode)//We add the new tile
            self.addChild(newTileNode)
        }
    }
    
    private func createTileFor(snakeTile : SnakeTile, team : Teams) -> SKSpriteNode {
        let tileImageName = "\(team)Tile"
        let newTileNode = SKSpriteNode(imageNamed: tileImageName)
        newTileNode.size = CGSize(width: 25, height: 14)
        let posX = snakeTile.posX
        let posY = snakeTile.posY
        newTileNode.position = CGPoint(x: posX, y: posY)
        return newTileNode
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let nodes = self.nodes(at: touch.location(in: self))
            if nodes.count > 0 {
                for node in nodes {
                    if let button = node as? SnakeButton {
                        
                        break
                    }
                }
            }
        }
    }
}
