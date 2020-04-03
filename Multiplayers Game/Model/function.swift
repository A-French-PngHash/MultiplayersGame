//
//  function.swift
//  Multiplayers Game
//
//  Created by Titouan Blossier on 23/03/2020.
//  Copyright © 2020 Titouan Blossier. All rights reserved.
//
import UIKit

class Function {
    public static func getColorFor(team : Teams) -> UIColor{
        if team == .yellow {
            return UIColor(red: 252/255, green: 194/255, blue: 0, alpha: 1)
        } else if team == .green {
            return UIColor(red: 43/255, green: 208/255, blue: 0, alpha: 1)
        } else if team == .orange {
            return UIColor(red: 1, green: 124/255, blue: 0, alpha: 1)
        } else if team == .blue {
            return UIColor(red: 0, green: 153/255, blue: 1, alpha: 1)
        } else if team == .purple {
            return UIColor(red: 185/255, green: 1/255, blue: 1, alpha: 1)
        } else if team == .pink {
            return UIColor(red: 1, green: 0, blue: 1, alpha: 1)
        } else{ //neutral
            return UIColor(red: 224/255, green: 144/255, blue: 41/255, alpha: 0.5)
        }
    }
}
