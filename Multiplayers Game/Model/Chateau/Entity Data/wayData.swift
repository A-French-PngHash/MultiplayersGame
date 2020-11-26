//
//  wayData.swift
//  castle
//
//  Created by Titouan Blossier on 06/02/2020.
//  Copyright © 2020 Titouan Blossier. All rights reserved.
//
import UIKit
import Foundation

struct Way{
    let beginPoint : CGPoint
    let endPoint : CGPoint //Where the segment end
    let destinationPoint : CGPoint //The segment is separeated in two therefore the true final destination point is not where the segment stop but further
    let destinationId : Int //To identify the target
    let beginId : Int
    var wayTeam : Teams //To put a color
    var angle : CGFloat!
}
