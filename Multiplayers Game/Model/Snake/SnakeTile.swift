//
//  SnakeTile.swift
//  Multiplayers Game
//
//  Created by Titouan Blossier on 14/05/2020.
//  Copyright © 2020 Titouan Blossier. All rights reserved.
//
import Foundation

class SnakeTile{
    var orientation : Float //In degree
    var posX : Int
    var posY : Int
    //var body : Int!
    
    init(orientation : Float, posX : Int, posY : Int) {
        self.orientation = orientation
        self.posY = posY
        self.posX = posX
    }
}
