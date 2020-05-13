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
    var numberOfPlayer : Int {
        get {
            return selectedPlayer.count
        }
    }
    var selectedPlayer : Array<Teams>!
    let teams : Array<Teams> = [.green, .yellow, .orange, .blue, .pink, .purple]
    var collectionViewGameCellContent : Array<Dictionary<String, Any>> = [
        ["GameName" : "Chateau", "GameImageName" : "castleIcon", "InfoController" : UIViewController()],
        ["GameName" : "Race", "GameImageName" : "raceIcon", "InfoController" : UIViewController()]
    ]
    /*Contain in each element all the carasteristics of a table view cell :
        - GameName (String) -> Name of the game
        - GameImageName (String) -> Name of the image which represent the game (images can be found in the asset file)
        - InfoController (ViewController) -> Controller to present when the info button is pressed
 */
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.backButton.isHidden = true //Hide game button
        self.replayButton.isHidden = true //Hide game button
        
        self.selectedPlayer = [.green, .yellow] //Selecting at the start the yellow and green players
        
        self.warningLabel.alpha = 0 //Hiding the warning about the number of player require to play a game
        
        self.view.backgroundColor = .white
        let skView = self.view as! SKView
        skView.backgroundColor = .white
        let scene = BeginScene()
        skView.presentScene(scene)
        
        scene.backgroundColor = .white
        scene.removeFromParent()
        
        
        //showMenu()
        updateButton()
        NotificationCenter.default.addObserver(self, selector: #selector(chateauWin), name: NSNotification.Name(rawValue: "chateauWin"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(raceWin), name: NSNotification.Name("raceWin"), object: nil)
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //MARK: - Outlets
    
    @IBOutlet weak var replayButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet var menuPlayerButton: [UIButton]!
    @IBOutlet var menuLabel: [UILabel]! //To hide them when a mini game start
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var gamesCollectionView: UICollectionView!
    
    //MARK: - @IBAction
    
    @IBAction func race(_ sender: Any) {
        displayRaceScene()
    }
    
    @IBAction func greenPlayer(_ sender: Any) {
        if selectedPlayer.contains(.green){
            selectedPlayer.remove(at: selectedPlayer.firstIndex(of: .green)!)
        } else {
            selectedPlayer.append(.green)
        }
        updateButton()
    }
    
    @IBAction func yellowPlayer(_ sender: Any) {
        if selectedPlayer.contains(.yellow){
            selectedPlayer.remove(at: selectedPlayer.firstIndex(of: .yellow)!)
        } else {
            selectedPlayer.append(.yellow)
        }
        updateButton()
    }
    
    @IBAction func orangePlayer(_ sender: Any) {
        if selectedPlayer.contains(.orange){
            selectedPlayer.remove(at: selectedPlayer.firstIndex(of: .orange)!)
        } else {
            selectedPlayer.append(.orange)
        }
        updateButton()
    }
    
    @IBAction func bluePlayer(_ sender: Any) {
        if selectedPlayer.contains(.blue){
            selectedPlayer.remove(at: selectedPlayer.firstIndex(of: .blue)!)
        } else {
            selectedPlayer.append(.blue)
        }
        updateButton()
    }
    
    @IBAction func pinkPlayer(_ sender: Any) {
        if selectedPlayer.contains(.pink){
            selectedPlayer.remove(at: selectedPlayer.firstIndex(of: .pink)!)
        } else {
            selectedPlayer.append(.pink)
        }
        updateButton()
    }
    
    @IBAction func purplePlayer(_ sender: Any) {
        if selectedPlayer.contains(.purple){
            selectedPlayer.remove(at: selectedPlayer.firstIndex(of: .purple)!)
        } else {
            selectedPlayer.append(.purple)
        }
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
    
    //MARK: - @objc functions
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

    //MARK: - Display functions
    private func displayRaceScene() {
        if selectedPlayer.count < 1 {
            displayWarningMessage(min: 1, max: 6)
        } else {
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
            scene.teams = selectedPlayer
            // Present the scene.
            skView.presentScene(scene)
            
            let timerStartCountdown = Timer(timeInterval: 0.05, repeats: false) { _ in
                let scene = self.scene as! RaceScene
                scene.startCountdown()
                scene.setupTimerLabel()
            }
            timerStartCountdown.fire()
        }
    }

    private func displayChateauScene() {
        if selectedPlayer!.count > 4 || selectedPlayer!.count < 2 {
            displayWarningMessage(min: 2, max: 4)
        } else {
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
            scene.playersTeam = self.selectedPlayer
            
            // Present the scene.
            skView.presentScene(scene)
        }
    }
    
    private func displaySnakeScene() {
        if selectedPlayer!.count > 6 || selectedPlayer!.count < 2 {
            displayWarningMessage(min: 2, max: 6)
        } else {
            hideMenu()
            backButton.frame.origin.y = self.view.frame.height - 65
            backButton.frame.origin.x = 5
            
            // Configure the view.
            let skView = self.view as! SKView
            skView.ignoresSiblingOrder = true
            
            // Create and configure the scene.
            scene = SnakeScene(size: CGSize(width: self.view.frame.width, height: self.view.frame.height))
            let scene = self.scene as! SnakeScene
            scene.numberOfPlayer = self.numberOfPlayer
            scene.playersTeam = self.selectedPlayer
            
            // Present the scene.
            skView.presentScene(scene)
        }
    }
    
    private func showMenu() {
        gamesCollectionView.isHidden = false
        for i in menuPlayerButton {
            i.isHidden = false
        }
        for i in menuLabel {
            i.isHidden = false
        }
    }
    
    private func hideMenu() {
        gamesCollectionView.isHidden = true
        for i in menuPlayerButton {
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
    
    //MARK: - Menu utils
    
    private func updateButton() {
        for team in teams {
            let index = self.teams.firstIndex(of: team)!
            if selectedPlayer.contains(team) { //Joueur sélectionné
                menuPlayerButton[index].setImage(UIImage(named: "\(team)PlayerSelected"), for: UIControl.State.normal)
            } else { //joueur non selectionné
                menuPlayerButton[index].setImage(UIImage(named: "\(team)NotSelected"), for: UIControl.State.normal)
            }
        }
    }
    
    private func displayWarningMessage(min : Int, max : Int) {
        self.warningLabel.text = "⚠️Ce jeu se joue seulement de \(min) à \(max) joueurs ⚠️"
        self.warningLabel.alpha = 1
        let timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
            UIView.animate(withDuration: 1, animations: {
                self.warningLabel.alpha = 0
            })
        }
    }
}

//MARK: - Collection View Delegate
extension MenuViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewGameCellContent.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gameCell", for: indexPath) as? GameCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let gameName = collectionViewGameCellContent[indexPath.row]["GameName"] as? String
        cell.delegate = self
        cell.gameNameLabel.text = gameName
        cell.gameImageButton.setImage(UIImage(named: collectionViewGameCellContent[indexPath.row]["GameImageName"] as! String), for: .normal)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected")
    }
    
}

//MARK: - Collection View Game Cell Delegate
extension MenuViewController : UICollectionViewGameCellDelegate {
    func gameButtonPressedFor(gameName: String) {
        if gameName == "Chateau" {
            self.displayChateauScene()
        } else if gameName == "Race" {
            self.displayRaceScene()
        } else if gameName == "Snake" {
            self.displaySnakeScene()
        }
    }
}
