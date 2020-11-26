//
//  GameCollectionViewCell.swift
//  Multiplayers Game
//
//  Created by Titouan Blossier on 12/05/2020.
//  Copyright © 2020 Titouan Blossier. All rights reserved.
//

import UIKit

class GameCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var gameImageButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var gameNameLabel: UILabel!
    var delegate : UICollectionViewGameCellDelegate!
    var segueName : String!
    
    @IBAction func startGameButtonPressed(_ sender: Any) {
        delegate.gameButtonPressed(for: self.gameNameLabel.text!)
    }
    @IBAction func infoButtonPressed(_ sender: Any) {
        delegate.infoButtonPressed(for: self.segueName)
    }
    
}
