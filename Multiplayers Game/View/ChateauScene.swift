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

class ChateauScene: SKScene {
    
    var numberOfPlayer : Int!
    private var game : Game!
    private var ways : Array<Way> {
        get {
            return MapData.shared.ways
        }
        set {
            MapData.shared.ways = newValue
        }
    }
    private var bases : Array<Base> {
        get {
            return MapData.shared.bases
        }
    }
    private var basesSprite : Array<SKSpriteNode>!
    private var waysSprite : Array<SKShapeNode>!
    private var arrowSprite : Array<SKSpriteNode>!
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
    
    private func loadMap() {
        LoadManager.shared.loadMapFor(player: self.numberOfPlayer, size: self.size)
        setupWays()
        setupBases()
        setupArrows()
    }
    
    private func setupBases() {
        for base in basesSprite {
            base.removeFromParent()
        }
        for base in bases {
            
            let baseShape = SKSpriteNode(imageNamed: "hexagone\(base.team!)")
            baseShape.position = base.position
            baseShape.zPosition = ChateauLayer.base
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
            wayShape.zPosition = ChateauLayer.normalWay
            if way.wayTeam == .neutral {
                wayShape.zPosition = ChateauLayer.neutralWay
            }
            ways[waysSprite.count].angle = CGFloat(angle)
            let rotate = SKAction.rotate(toAngle: CGFloat(angle), duration: 0)
            wayShape.run(rotate)
            wayShape.name = String(waysSprite.count)
            //wayShape.zRotation = CGFloat(angle)
            self.addChild(wayShape)
            
            waysSprite.append(wayShape)
        }
    }
    
    private func setupArrows() {
        arrowSprite = []
        for way in waysSprite {
            let arrow = SKSpriteNode(imageNamed: "arrow")
            arrow.position = way.position
            arrow.zPosition = ChateauLayer.arrow
            arrow.size = CGSize(width: 50, height: 20)
            arrow.run(SKAction.rotate(toAngle: ways[Int(way.name!)!].angle! + CGFloat(Float.pi / 2), duration: 0))
            arrowSprite.append(arrow)
            self.addChild(arrow)
        }
        showArrows()
    }
    
    private func showArrows() {
        for arrow in arrowSprite { //Hiding arrow
            let sprites = self.nodes(at: arrow.position)
            for sprite in sprites {
                if let name = sprite.name {
                    if let number = Int(name){
                        if ways[number].wayTeam == .neutral {
                            arrow.isHidden = true
                        } else {
                            arrow.isHidden = false
                        }
                        break
                    }
                }
            }
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
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "chateauWin")))
    }
    
}

extension ChateauScene {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            print(touch.location(in: self).x / self.size.width)
            print(touch.location(in: self).y / self.size.height)
            for i in nodes(at: touch.location(in: self)){
                if let name = i.name {
                    let way = ways[Int(name)!]
                    let beginId = way.beginId
                    let result = game.sendUnit(beginId : beginId, way : way)
                    if result.0 {
                        
                        showArrows()
                        reloadGraphical()
                        
                        let unit = Unit(imageNamed: "unit")
                        unit.poid = result.1
                        
                        let size = CGFloat(result.1) * 6.5
                        unit.size = CGSize(width: size, height: size)
                        print(CGFloat(23) / (self.view?.frame.height)!)
                        unit.destinationPoint = CGPoint(x: result.2.x, y: result.2.y + 32)
                        unit.position = game.base(id: beginId).position
                        unit.zPosition = ChateauLayer.unit
                        unit.color = getColorFor(team: way.wayTeam)
                        unit.colorBlendFactor = 1.0
                        unit.team = way.wayTeam
                        unit.alpha = 0.8
                        let borderBody = SKPhysicsBody(circleOfRadius: CGFloat(unit.poid))
                        unit.physicsBody = borderBody
                        
                        unit.physicsBody?.contactTestBitMask = ChateauBitMask.unitCategory //Whith wich category do he send a notification
                        unit.physicsBody?.categoryBitMask = ChateauBitMask.unitCategory //which category do he belong to
                        unit.physicsBody?.collisionBitMask = 0
                        
                        
                        let animationDuration = getAnimationDuration(way: way)
                        
                        let path = UIBezierPath()
                        path.move(to: unit.position)
                        path.addLine(to: unit.destinationPoint)
                        let moveAnimation = SKAction.follow(path.cgPath, asOffset: false, orientToPath: false, duration: TimeInterval(animationDuration))
                        //let moveAnimation = SKAction.follow(path.cgPath, duration: TimeInterval(animationDuration))
                        print(path)
                        
                        //let moveAnimation = SKAction.move(to: unit.destinationPoint, duration: TimeInterval(animationDuration))
                        //print("destination : \(unit.destinationPoint)")
                        self.addChild(unit)
                        
                        let endAnimation = SKAction.run {
                            print(unit.position)
                            let result =  self.game.unitArrived(beginId: beginId, unit: unit, destinationId: way.destinationId)

                            if result.0 {
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

extension ChateauScene : SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        if let first = contact.bodyA.node as? Unit{
            if let second = contact.bodyB.node as? Unit {
                if second.team != first.team {
                    if first.poid > second.poid {
                        first.poid -= second.poid
                        let size = CGFloat(first.poid) * 6.5
                        first.size = CGSize(width: size, height: size)
                        second.removeFromParent()
                    } else if second.poid > first.poid{
                        second.poid -= first.poid
                        let size = CGFloat(second.poid) * 6.5
                        second.size = CGSize(width: size, height: size)
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


