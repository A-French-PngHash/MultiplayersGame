//
//  GameScene.swift
//  castle
//
//  Created by Titouan Blossier on 03/02/2020.
//  Copyright © 2020 Titouan Blossier. All rights reserved.
//
import UIKit
import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var numberOfPlayer : Int!
    private var game : Game!
    private var ways : Array<Way> {
        get {
            return MapData.shared.ways
        }
    }
    private var bases : Array<Base> {
        get {
            return MapData.shared.bases
        }
    }
    private var basesSprite : Array<SKSpriteNode>!
    private var waysSprite : Array<SKShapeNode>!
    private var unitSprites : Array<Unit>!
    var timer : Timer!
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self as SKPhysicsContactDelegate
        self.backgroundColor = UIColor(red: 1, green: 231/255, blue: 200/255, alpha: 1)
        game = Game()
        waysSprite = []
        basesSprite = []
        unitSprites = []
        loadMap()
        startGame()
    }
    
    
    //MARk: - Load map
    
    func loadMap() {
        LoadManager.shared.loadMapFor(player: self.numberOfPlayer, size: self.size)
        setupWays()
        setupBases()
    }
    
    private func setupBases() {
        for base in basesSprite {
            base.removeFromParent()
        }
        for base in bases {
            
            let baseShape = SKSpriteNode(imageNamed: "hexagone\(base.team!)")
            //let baseShape = SKShapeNode(rectOf: CGSize(width: base.poid * 2, height: base.poid * 2))
            baseShape.position = base.position
            baseShape.zPosition = Layer.base
            baseShape.size = CGSize(width: CGFloat(5 * Float(base.poid + 2)), height: CGFloat(4.5 * CGFloat(base.poid + 2)))
            //baseShape.fillColor = getColorFor(team: base.team)
            
            self.addChild(baseShape)
            
            basesSprite.append(baseShape)
        }
    }
    
    private func setupWays() {
        for way in ways {
            let xb = way.beginPoint.x
            let xe = way.endPoint.x
            let yb = way.beginPoint.y
            let ye = way.endPoint.y
            
            let a = (xb - xe) * (xb - xe)
            let b = (yb - ye) * (yb - ye)
            let sum = a + b
            let radius = sqrt(Float(sum))
            
            let firstPointX = Float(xb)
            let firstPointY = Float(yb) + radius
            
            let center = CGPoint(x : (xb + xe) / 2, y : (ye + yb) / 2)
            
            
            let angle = atan2(Float(firstPointY) - Float(ye), firstPointX - Float(xe)) * 2
            
            let distanceBetweenPoint = sqrt((xe-xb) * (xe - xb) + (ye - yb) * (ye - yb))
            //print(distanceBetweenPoint)
            
            let shapePath = UIBezierPath(rect: CGRect(
                origin: CGPoint(x: xb, y: yb),
                size: CGSize(width: 35, height: distanceBetweenPoint)))
            
            let wayShape = SKShapeNode(path: shapePath.cgPath, centered: true)
            wayShape.position = center//Définis le centre
            wayShape.fillColor = getColorFor(team: way.wayTeam)
            wayShape.alpha = 0.5
            wayShape.lineWidth = 0
            wayShape.zPosition = Layer.normalWay
            if way.wayTeam == .neutral {
                wayShape.zPosition = Layer.neutralWay
            }
            let rotate = SKAction.rotate(toAngle: CGFloat(angle), duration: 0)
            wayShape.run(rotate)
            wayShape.name = String(waysSprite.count)
            self.addChild(wayShape)
            
            waysSprite.append(wayShape)
        }
    }
    
    //MARK: - Start map
    private func startGame() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            self.game.second()
            self.reloadGraphical()
        })
    }
    
    private func reloadWaysColor() {
        for i in 0...ways.count - 1 {
            waysSprite[i].fillColor = getColorFor(team: ways[i].wayTeam)
        }
    }
    
    private func reloadGraphical() {
        for i in basesSprite {
            i.removeFromParent()
        }
        basesSprite = []
        setupBases()
        reloadWaysColor()
    }
    
    private func getAnimationDuration(way : Way) -> CGFloat{
        let xb = way.beginPoint.x
        let xe = way.endPoint.x
        let yb = way.beginPoint.y
        let ye = way.endPoint.y
        let animationDuration = sqrt((xe-xb) * (xe - xb) + (ye - yb) * (ye - yb)) / 75
        return animationDuration
    }
    
    private func getColorFor(team : Teams) -> UIColor{
        if team == .yellow {
            return UIColor(red: 252/255, green: 194/255, blue: 0, alpha: 1)
        } else if team == .green {
            return UIColor(red: 43/255, green: 208/255, blue: 0, alpha: 1)
        } else if team == .orange {
            return UIColor(red: 1, green: 124/255, blue: 0, alpha: 1)
        } else if team == .blue {
            return UIColor(red: 0, green: 153/255, blue: 1, alpha: 1)
        } else{ //neutral
            return UIColor(red: 224/255, green: 144/255, blue: 41/255, alpha: 0.5)
        }
    }
    
    //MARK: - End of game
    private func win(team : Teams) {
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "win")))
    }
    
}

extension GameScene {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            //print("gamescene : ", touch.location(in: self))
            
            //TODO: Mettre en place le nouveau système avec les begin id
            
            for i in nodes(at: touch.location(in: self)){
                if let name = i.name {
                    let way = ways[Int(name)!]
                    let beginId = way.beginId
                    let result = game.sendUnit(beginId : beginId, way : way)
                    if result.0 {
                        reloadGraphical()
                        let size = CGFloat(result.1) * 6.5
                        let unit = Unit(ellipseOf: CGSize(width: size, height: size))
                        unit.poid = result.1
                        
                        //print(result.2.y)
                        //print(self.scene?.frame.height)
                        
                        unit.destinationPoint = CGPoint(x: result.2.x, y: result.2.y + 43)
                        unit.position = game.base(id: beginId).position
                        unit.zPosition = Layer.unit
                        unit.fillColor = getColorFor(team: way.wayTeam)
                        unit.team = way.wayTeam
                        unit.alpha = 0.6
                        let borderBody = SKPhysicsBody(circleOfRadius: CGFloat(unit.poid))
                        unit.physicsBody = borderBody
                        
                        unit.physicsBody?.contactTestBitMask = BitMask.unitCategory //Whith wich category do he send a notification
                        unit.physicsBody?.categoryBitMask = BitMask.unitCategory //which category do he belong to
                        unit.physicsBody?.collisionBitMask = 0
                        
                        
                        let animationDuration = getAnimationDuration(way: way)
                        //print(unit.destinationPoint as Any)
                        let moveAnimation = SKAction.move(to: unit.destinationPoint, duration: TimeInterval(animationDuration))
                        self.addChild(unit)
                        
                        let endAnimation = SKAction.run {
                            let result =  self.game.unitArrived(beginId: beginId, unit: unit, destinationId: way.destinationId)

                            if result.0 { //Quelqun a gagné
                                self.win(team: result.1)
                            }
                            
                            unit.removeFromParent()
                            self.reloadGraphical()
                        }
                        unit.run(SKAction.sequence([moveAnimation, endAnimation]))
                    }
                    break
                }
            
            }
        }
    }
}

extension GameScene : SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        if let first = contact.bodyA.node as? Unit{
            if let second = contact.bodyB.node as? Unit {
                if second.team != first.team {
                    if first.poid > second.poid {
                        var newScale = Float(first.poid!)
                        first.poid -= second.poid
                        newScale = Float(first.poid!) / newScale
                        first.run(SKAction.scale(to: CGFloat(newScale), duration: 0))
                        second.removeFromParent()
                    } else if second.poid > first.poid{
                        var newScale = Float(first.poid!)
                        second.poid -= first.poid
                        newScale = Float(first.poid!) / newScale
                        first.run(SKAction.scale(to: CGFloat(newScale), duration: 0))
                        first.removeFromParent()
                    } else {
                        first.removeFromParent()
                        second.removeFromParent()
                    }
                }
            }
        }
    }
}


