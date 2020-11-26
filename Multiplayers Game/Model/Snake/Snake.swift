//
//  Snake.swift
//  Multiplayers Game
//
//  Created by Titouan Blossier on 14/05/2020.
//  Copyright © 2020 Titouan Blossier. All rights reserved.
//

import Foundation

class Snake {
    var team : Teams
    var body : Array<SnakeTile>

    init(team : Teams, body : Array<SnakeTile>) {
        self.team = team
        self.body = body
    }
    
}
