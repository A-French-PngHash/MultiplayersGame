//
//  GameViewController.swift
//  castle
//
//  Created by Titouan Blossier on 03/02/2020.
//  Copyright © 2020 Titouan Blossier. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    var scene : GameScene!
    var numberOfPlayer : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backButton.isHidden = true
        self.replayButton.isHidden = true
        showPlayerButton()
        NotificationCenter.default.addObserver(self, selector: #selector(win), name: NSNotification.Name(rawValue: "win"), object: nil)
    }
    
    @IBOutlet weak var replayButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet var button: [UIButton]!
    
    @IBAction func twoPlayer(_ sender: Any) {
        numberOfPlayer = 2
        displayScene()
    }
    @IBAction func threePlayer(_ sender: Any) {
        numberOfPlayer = 3
        displayScene()
        
    }
    @IBAction func Player(_ sender: Any) {
        numberOfPlayer = 4
        displayScene()
    }
    
    @IBAction func replayButtonPressed(_ sender: Any) {
        removeScene()
        displayScene()
    }
    
    @IBAction func backbuttonPressed(_ sender: Any) {
        removeScene()
    }
    
    @objc func win() {
        replayButton.isHidden = false
    }

    private func displayScene() {
        for i in button {
            i.isHidden = true
        }
        backButton.isHidden = false
        label.isHidden = true
        // Configure the view.
        let skView = self.view as! SKView
        skView.ignoresSiblingOrder = true

        // Create and configure the scene.
        scene = GameScene(size: CGSize(width: 375, height: 667))
        scene.numberOfPlayer = self.numberOfPlayer
        scene.scaleMode = .aspectFill
        
        // Present the scene.
        skView.presentScene(scene)
    }
    
    private func showPlayerButton() {
        for i in button {
            i.isHidden = false
        }
    }
    
    private func removeScene() {
        scene.removeFromParent()
        scene.removeAllChildren()
        scene.timer.invalidate()
        scene.backgroundColor = .white
        showPlayerButton()
        backButton.isHidden = true
        replayButton.isHidden = true
        label.isHidden = false
    }
}

//MARK: - Tap Detection for testing

extension GameViewController : UIGestureRecognizerDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            //print("point : \(touch.location(in: self.view))")
            print("x : \(touch.location(in: self.view).x / self.view.frame.width)")
            print("y : \(touch.location(in: self.view).y / self.view.frame.height)")
        }
    }
}
