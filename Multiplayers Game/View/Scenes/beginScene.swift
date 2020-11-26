//
//  beginScene.swift
//  Multiplayers Game
//
//  Created by Titouan Blossier on 04/04/2020.
//  Copyright © 2020 Titouan Blossier. All rights reserved.
//
import SpriteKit
import Foundation

class BeginScene : SKScene { //This scene is here to disable the grey background at the start of the app
    override func didMove(to view: SKView) {
        self.backgroundColor = .white
    }
}
