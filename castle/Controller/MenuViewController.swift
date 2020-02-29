//
//  MenuViewController.swift
//  castle
//
//  Created by Titouan Blossier on 03/02/2020.
//  Copyright © 2020 Titouan Blossier. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class MenuViewController: UIViewController {
    
    var scene : ChateauScene!
    var numberOfPlayer : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backButton.isHidden = true
        self.replayButton.isHidden = true
        self.numberOfPlayer = 2
        
        showMenu()
        updateButton()
        NotificationCenter.default.addObserver(self, selector: #selector(win), name: NSNotification.Name(rawValue: "win"), object: nil)
    }
    
    @IBOutlet weak var replayButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet var menuButton: [UIButton]!
    @IBOutlet var menuLabel: [UILabel]!
    
    @IBAction func twoPlayer(_ sender: Any) {
        numberOfPlayer = 2
        updateButton()
    }
    @IBAction func threePlayer(_ sender: Any) {
        numberOfPlayer = 3
        updateButton()
    }
    @IBAction func Player(_ sender: Any) {
        numberOfPlayer = 4
        updateButton()
    }
    
    @IBAction func replayButtonPressed(_ sender: Any) {
        removeScene()
        displayChateauScene()
    }
    
    @IBAction func backbuttonPressed(_ sender: Any) {
        removeScene()
    }
    
    @IBAction func startChateau(_ sender: Any) {
        displayChateauScene()
    }
    
    @objc func win() {
        replayButton.isHidden = false
    }

    private func displayChateauScene() {
        hideMenu()
        backButton.isHidden = false
        // Configure the view.
        let skView = self.view as! SKView
        skView.ignoresSiblingOrder = true
        // Create and configure the scene.
        scene = ChateauScene(size: CGSize(width: self.view.frame.width, height: self.view.frame.height))
        scene.numberOfPlayer = self.numberOfPlayer
        scene.scaleMode = .aspectFill
        
        // Present the scene.
        skView.presentScene(scene)
    }
    
    private func showMenu() {
        for i in menuButton {
            i.isHidden = false
        }
        for i in menuLabel {
            i.isHidden = false
        }
    }
    
    private func hideMenu() {
        for i in menuButton {
            i.isHidden = true
        }
        for i in menuLabel {
            i.isHidden = true
        }
    }
    
    private func removeScene() {
        scene.removeFromParent()
        scene.removeAllChildren()
        scene.timer.invalidate()
        scene.backgroundColor = .white
        showMenu()
        backButton.isHidden = true
        replayButton.isHidden = true
    }
    
    private func updateButton() {
        for i in 0...2 { //The first players button
            if i + 2 == numberOfPlayer {
                menuButton[i].imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                
            } else {
                menuButton[i].imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
            }
        }
    }
}
