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
    
    var scene : SKScene!
    var numberOfPlayer : Int!
    
    var menuButton : Array<UIButton> {
        get {
            return menuPlayerButton + otherMenuButton
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backButton.isHidden = true
        self.replayButton.isHidden = true
        self.numberOfPlayer = 2
        
        showMenu()
        updateButton()
        NotificationCenter.default.addObserver(self, selector: #selector(chateauWin), name: NSNotification.Name(rawValue: "chateauWin"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(raceWin), name: NSNotification.Name("raceWin"), object: nil)
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBOutlet weak var replayButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet var menuPlayerButton: [UIButton]!
    @IBOutlet var otherMenuButton: [UIButton]!
    @IBOutlet var menuLabel: [UILabel]!
    
    @IBAction func race(_ sender: Any) {
        displayRaceScene()
    }
    
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
    @IBAction func fivePlayer(_ sender: Any) {
        numberOfPlayer = 5
        updateButton()
    }
    @IBAction func sixPlayer(_ sender: Any) {
        numberOfPlayer = 6
        updateButton()
    }
    
    @IBAction func replayButtonPressed(_ sender: Any) {
        removeScene()
        if let _ = scene as? ChateauScene {
            displayChateauScene()
        } else if let _ = scene as? RaceScene {
            displayRaceScene()
        }
    }
    
    @IBAction func backbuttonPressed(_ sender: Any) {
        removeScene()
    }
    
    @IBAction func startChateau(_ sender: Any) {
        displayChateauScene()
    }
    
    @objc func chateauWin() {
        replayButton.isHidden = false
        replayButton.frame.origin.y = self.view.frame.height - 60
        replayButton.frame.origin.x = self.view.frame.width - 65
    }
    
    @objc func raceWin() {
        replayButton.isHidden = false
        replayButton.frame.origin.y = 5
        replayButton.frame.origin.x = self.view.frame.width - 65
    }
    
    private func displayRaceScene() {
        hideMenu()
        backButton.isHidden = false
        backButton.frame.origin = CGPoint(x: 5, y: 5)
        // Configure the view.
        let skView = self.view as! SKView
        skView.ignoresSiblingOrder = true
        // Create and configure the scene.
        scene = RaceScene(size: CGSize(width: self.view.frame.width, height: self.view.frame.height))
        let scene = self.scene as! RaceScene
        scene.numberOfPlayer = self.numberOfPlayer
        scene.scaleMode = .aspectFill
        
        // Present the scene.
        skView.presentScene(scene)
        
        let timerStartCountdown = Timer(timeInterval: 0.05, repeats: false) { _ in
            let scene = self.scene as! RaceScene
            scene.startCountdown()
        }
        timerStartCountdown.fire()
        
    }

    private func displayChateauScene() {
        hideMenu()
        backButton.isHidden = false
        backButton.frame.origin.y = self.view.frame.height - 65
        backButton.frame.origin.x = 5
        // Configure the view.
        let skView = self.view as! SKView
        skView.ignoresSiblingOrder = true
        // Create and configure the scene.
        scene = ChateauScene(size: CGSize(width: self.view.frame.width, height: self.view.frame.height))
        let scene = self.scene as! ChateauScene
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
        scene.backgroundColor = .white
        showMenu()
        backButton.isHidden = true
        replayButton.isHidden = true
        if let scene = self.scene as? ChateauScene {
            scene.timer.invalidate()
        }
    }
    
    private func updateButton() {
        for i in 0...4 { //The first players button
            if i + 2 == numberOfPlayer {
                menuPlayerButton[i].imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            }
        }
    }
}
