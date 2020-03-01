//
//  constants.swift
//  castle
//
//  Created by Titouan Blossier on 22/02/2020.
//  Copyright © 2020 Titouan Blossier. All rights reserved.
//

import UIKit


enum Layer {
    static let arrow : CGFloat = 0
    static let neutralWay : CGFloat = 1
    static let normalWay : CGFloat = 2
    static let unit : CGFloat = 3
    static let base : CGFloat = 4
    static let labelWin : CGFloat = 5
}

enum BitMask {
    static let unitCategory : UInt32 = 0x1 << 1
}

enum Size {
    static let maxSize : Int = 13
}
