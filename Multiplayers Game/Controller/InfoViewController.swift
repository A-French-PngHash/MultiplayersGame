//
//  InfoViewController.swift
//  Multiplayers Game
//
//  Created by Titouan Blossier on 04/04/2020.
//  Copyright © 2020 Titouan Blossier. All rights reserved.
//

import UIKit

class InfoViewController : UIViewController {
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func finished(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
