//
//  constants.swift
//  castle
//
//  Created by Titouan Blossier on 22/02/2020.
//  Copyright © 2020 Titouan Blossier. All rights reserved.
//

import UIKit


enum Layer {
    static let neutralWay : CGFloat = 0
    static let normalWay : CGFloat = 1
    static let unit : CGFloat = 2
    static let base : CGFloat = 3
    static let labelWin : CGFloat = 4
}

enum BitMask {
    static let unitCategory : UInt32 = 0x1 << 1
}

enum Size {
    static let maxSize : Int = 13
}
