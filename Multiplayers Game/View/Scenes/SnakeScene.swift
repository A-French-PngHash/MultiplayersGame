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
    var playersTeam : Array<Teams>!
    var buttonSprites : Array<SKSpriteNode>!
    
    override func didMove(to view: SKView) {
        buttonSprites = []
        self.backgroundColor = .white
        displayButtons()
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
