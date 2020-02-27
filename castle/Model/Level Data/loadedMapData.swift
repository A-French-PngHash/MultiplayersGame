//
//  loadedMapData.swift
//  castle
//
//  Created by Titouan Blossier on 22/02/2020.
//  Copyright © 2020 Titouan Blossier. All rights reserved.
//

import Foundation

class MapData {
    static let shared = MapData()
    private init() { }
    
    var ways : Array<Way>!
    var bases : Array<Base>!
}
