//
//  basesData.swift
//  castle
//
//  Created by Titouan Blossier on 06/02/2020.
//  Copyright © 2020 Titouan Blossier. All rights reserved.
//
import UIKit
import SpriteKit

class Base : SKSpriteNode{
    var team : Teams!
    var id : Int! //So other entity can identify this base
    var poid : Int! = 6
}
