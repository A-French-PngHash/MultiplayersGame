//
//  RaceScene.swift
//  Multiplayers Game
//
//  Created by Titouan Blossier on 01/03/2020.
//  Copyright © 2020 Titouan Blossier. All rights reserved.
//

import Foundation
import SpriteKit

class RaceScene : SKScene {
    
    var numberOfPlayer : Int!
    var buttonsSprite : Array<SKSpriteNode>!
    var carsSprite : Array<RaceCar>!
    var intervalle : Double!
    var endLine : SKShapeNode!
    let teams : Array<Teams> = [.green, .yellow, .orange, .blue, .pink, .purple]
    var infoLabel : SKLabelNode!
    var gameStarted = false
    
    override func didMove(to view: SKView) {
        print(14 / self.frame.height)
        self.physicsWorld.contactDelegate = self as SKPhysicsContactDelegate
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.backgroundColor = UIColor(red: 1, green: 231/255, blue: 200/255, alpha: 1)
        
        intervalle = 0.800 / Double(numberOfPlayer + 1)
        
        buttonsSprite = []
        carsSprite = []
        displayButtons()
        drawRoads()
        loadCars()
        drawEnd()
    }
    
    private func drawEnd() {
        let line = SKShapeNode()
        let pathToDraw = CGMutablePath()
        let y = 0.950 * self.size.height
        pathToDraw.move(to: CGPoint(x: CGFloat(0.100 + (Double(1) * intervalle)) * self.size.width - 30, y: y))
        pathToDraw.addLine(to: CGPoint(x: CGFloat(0.100 + (Double(numberOfPlayer) * intervalle)) * self.size.width + 30, y: y))
        line.lineWidth = 10
        line.path = pathToDraw
        line.strokeColor = SKColor.gray
        
        line.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 0.800 * self.frame.width, height: 10), center: CGPoint(x: 0.500 * self.size.width, y: y))
        line.physicsBody?.categoryBitMask = RaceBitMask.endBitMask
        line.physicsBody?.contactTestBitMask = RaceBitMask.carBitMask
        line.physicsBody?.collisionBitMask = 0
        
        endLine = line
        self.addChild(line)
    }
    
    private func displayButtons() {
        let buttonPosition = [[0.900, 0.100], [0.100, 0.100], [0.100, 0.850], [0.900, 0.850], [0.100, 0.500,], [0.100, 0.500]]
        for i in 0...numberOfPlayer - 1{
            let button = RaceButton(imageNamed: "\(teams[i])Arrow")
            button.team = teams[i]
            button.position = CGPoint(x: CGFloat(buttonPosition[i][0]) * self.size.width, y: CGFloat(buttonPosition[i][1]) * self.size.height)
            if numberOfPlayer == 6 {
                button.size = CGSize(width: 50, height: 50)
            } else {
                button.size = CGSize(width: 60, height: 60)
            }
            button.name = String(i)
            buttonsSprite.append(button)
            self.addChild(button)
        }
    }
    
    private func drawRoads() {
        for i in 0...numberOfPlayer - 1 {
            let x = CGFloat(0.100 + (Double(i + 1) * intervalle)) * self.frame.size.width
            
            let yourline = SKShapeNode()
            let pathToDraw = CGMutablePath()
            pathToDraw.move(to: CGPoint(x: x, y: 0.100 * self.frame.size.height))
            pathToDraw.addLine(to: CGPoint(x: x, y: 0.950 * self.frame.size.height))
            yourline.path = pathToDraw
            yourline.strokeColor = SKColor.black
            yourline.lineWidth = 5
            addChild(yourline)
        }
    }
    
    private func loadCars() {
        for i in 0...numberOfPlayer - 1 {
            let car = RaceCar(imageNamed: "\(teams[i])Car")
            car.team = teams[i]
            let x = CGFloat(0.100 + (Double(i + 1) * intervalle)) * self.frame.size.width
            car.position = CGPoint(x: x, y: 0.100 * self.frame.size.height)
            car.size = CGSize(width: 50, height: 50)
            
            car.physicsBody = SKPhysicsBody(circleOfRadius: 25)
            car.physicsBody?.categoryBitMask = RaceBitMask.carBitMask
            car.physicsBody?.contactTestBitMask = RaceBitMask.endBitMask
            car.physicsBody?.collisionBitMask = 0
            
            self.addChild(car)
            carsSprite.append(car)
        }
    }
    
    func startCountdown() {
        infoLabel = SKLabelNode()
        infoLabel.fontName = "copperplate"
        infoLabel.fontSize = 70
        infoLabel.fontColor = .black
        infoLabel.text = "3"
        infoLabel.position = CGPoint(x: self.view!.frame.midX, y: self.view!.frame.midY)
        self.addChild(infoLabel)
        
        let changeNumber = SKAction.run {
            if let text = self.infoLabel.text{
                if text == "1"{
                    self.infoLabel.text = "GO !"
                    self.infoLabel.fontColor = .red
                    self.infoLabel.fontSize = 90
                    self.gameStarted = true
                } else if text != "GO !"{
                    self.infoLabel.text = String(Int(text)! - 1)
                }
            }
        }
        let waitChangeNumber = SKAction.sequence([SKAction.wait(forDuration: 0.05),
                                                  SKAction.fadeIn(withDuration: 0.1),
                                                  SKAction.wait(forDuration: 0.75),
                                                  SKAction.fadeOut(withDuration: 0.1),
                                                  changeNumber])
       
        
        let clignote = SKAction.sequence([SKAction.hide(),
                                          SKAction.wait(forDuration: 0.05),
                                           SKAction.unhide(),
                                           SKAction.wait(forDuration: 0.05)])
        let clignotementSerie = SKAction.sequence([clignote, clignote, clignote, clignote, clignote, clignote, clignote, clignote, clignote, clignote, clignote, clignote,clignote, clignote, clignote])
        
        let showGo = SKAction.sequence([SKAction.wait(forDuration: 0.05),
                                        SKAction.fadeIn(withDuration: 0)])
        
        infoLabel.run(SKAction.sequence([waitChangeNumber,
                                              waitChangeNumber,
                                              waitChangeNumber,
                                              showGo,
                                              clignotementSerie,
                                              SKAction.removeFromParent()]))
    }
    
    private func stopGame() {
        for i in buttonsSprite {
            i.isHidden = true
            i.isUserInteractionEnabled = false
        }
        for i in carsSprite {
            i.removeAllActions()
        }
    }
    
    private func win(team : Teams) {
        infoLabel.fontColor = Function.getColorFor(team: team)
        infoLabel.fontSize = 40
        infoLabel.text = "\(team) team won"
        self.addChild(infoLabel)
        NotificationCenter.default.post(Notification(name: Notification.Name("raceWin")))
        
        let hide = SKAction.hide()
        let show = SKAction.unhide()
        let wait = SKAction.wait(forDuration: 0.4)
        let sequence = SKAction.sequence([hide, wait, show, wait])
        let fullSequence = SKAction.sequence([sequence, sequence, sequence, sequence, sequence, sequence])
        infoLabel.run(fullSequence)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameStarted {
            if let touch = touches.first {
                let nodes = self.nodes(at: touch.location(in: self))
                if nodes.count > 0 {
                    if let button = nodes[0] as? RaceButton {
                        let sprite = carsSprite![Int(button.name!)!]
                        if sprite.actualDestinationPoint == nil {
                            sprite.actualDestinationPoint = sprite.position
                        }
                        let destination = CGPoint(x: sprite.actualDestinationPoint.x,
                                                  y: (sprite.actualDestinationPoint.y / self.frame.height + 0.015) * self.frame.height)
                        sprite.actualDestinationPoint = destination
                        sprite.removeAllActions()
                        sprite.run(SKAction.move(to: destination, duration: 0.5))
                    }
                }
            }
        }
    }
}

extension RaceScene : SKPhysicsContactDelegate{
    func didBegin(_ contact: SKPhysicsContact) {
        var node = contact.bodyA.node as? RaceCar
        if node == nil {
            node = contact.bodyB.node as? RaceCar
        }
        stopGame()
        let hide = SKAction.hide()
        let show = SKAction.unhide()
        let wait = SKAction.wait(forDuration: 0.4)
        node?.removeAllActions()
        node!.run(SKAction.move(to: CGPoint(x: node!.position.x, y: (0.900 * self.frame.height) + (0.022 * self.frame.height)), duration: 0))

        let win = SKAction.run {
            self.win(team : node!.team)
        }
        let sequence = SKAction.sequence([hide, wait, show, wait])
        let fullSequence = SKAction.sequence([win, sequence, sequence, sequence, sequence, sequence, sequence])
        node?.run(fullSequence)
    }
}
