//
//  GameView.swift
//  C-CalculV3
//
//  Created by Charles on 9/8/19.
//  Copyright © 2019 charles. All rights reserved.
//

import Foundation
import UIKit
import GameKit


class HomeView: UIViewController, GKGameCenterControllerDelegate {
    
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet var ButtonsOutlet: [UIButton]!
    @IBOutlet var MoreButtonsOutlet: [UIButton]!
    
    
    var needGameCenterInfo = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpButtons()
        adjustDarkMode()
        getHighScores()
        authPlayer()
        adjustConstraints()
        
    }
    
    func setUpButtons(){
        
        
        ButtonsOutlet.forEach({ (button) in
            button.layer.cornerRadius = 10
            button.layer.borderWidth = 1
            
        })
            
        MoreButtonsOutlet.forEach({ (button) in
            button.setTitleColor(themeColor, for: .normal)
            button.setImage(button.imageView?.image?.withRenderingMode(.alwaysTemplate), for: .normal)
            button.imageView?.contentMode = .scaleAspectFit
            button.tintColor = themeColor
        })
        
        if let previousGameCenterInfo = UserDefaults.standard.value(forKey: "needGameCenterInfo") as? Bool {
            needGameCenterInfo = previousGameCenterInfo
        }
        
        
    }
    func adjustConstraints(){
        var sizeLabel: CGFloat = 60
        var sizeButtons: CGFloat = 80
        
        if screenHeight < 500 {
            sizeLabel = 20
            sizeButtons = 20
        }
        else if screenHeight < 600 { //iPhone 5 Done
            sizeLabel = 21
            sizeButtons = 30
        }
        else if screenHeight < 700 { //iPhone 8 Done
            sizeLabel = 35
            sizeButtons = 45
        }
        else if screenHeight < 800 { //iPhone 8 Plus Done
            sizeLabel = 53
            sizeButtons = 53
        }
        else { //iPhone X and beyond
            sizeLabel = 80
            sizeButtons = 75
        }
        
        
        TitleLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: sizeLabel).isActive = true
        MoreButtonsOutlet[1].bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -sizeButtons).isActive = true
        
    }
    
    func adjustDarkMode(){
        self.view.backgroundColor = traitCollection.userInterfaceStyle == .light ? UIColor.white : UIColor.black
        
        let textColor = traitCollection.userInterfaceStyle == .light ? UIColor.black : UIColor.white
        ButtonsOutlet.forEach({ (button) in
            button.layer.borderColor = textColor.cgColor
            button.setTitleColor(textColor, for: .normal)
        })
    }
    
    func getHighScores() {
        highScores = [[[],[],[]],[[],[],[]],[[],[],[]],[[],[],[]],[[],[],[]]] //Empty highScores
        if let previousHighScores = UserDefaults.standard.value(forKey: "highScores") as? [[[Double]]] {
            highScores = previousHighScores
        }
    }
    
    
    //Authenticate player in game center
    func authPlayer(){
        let localPlayer = GKLocalPlayer.local
        
        localPlayer.authenticateHandler = {
            (view, error) in
            
            if view == nil || error != nil {
                //ERROR
            }
            else {
                self.present(view!, animated: true)
            }
        }
        
    }
    
    
    func showLeaderboard() {
        let gameCenterView = GKGameCenterViewController()
        gameCenterView.gameCenterDelegate = self
        self.present(gameCenterView, animated: true, completion: nil)
    }
    
    
    @IBAction func StartGame(_ sender: UIButton) {
        var gameType = 0
        
        guard let title = sender.titleLabel?.text else { return }
        
        switch  title{
        case "Addition":
            gameType = 0
        case "Soustraction":
            gameType = 1
        case "Multiplication":
            gameType = 2
        case "Division":
            gameType = 3
        case "All":
            gameType = 4
        default:
            gameType = 0
        }
        
        let alertView = UIAlertController(title: "Difficulty", message: "You're about to play \(title), what difficulty level do you want ?", preferredStyle: .alert)
        alertView.view.tintColor = themeColor
        alertView.addAction(UIAlertAction(title: "Easy", style: .default, handler: { (action) in
            difficultyPlaying = 0
            gameTypePlaying = gameType
            self.performSegue(withIdentifier: "startGame", sender: self)
        }))
        alertView.addAction(UIAlertAction(title: "Medium", style: .default, handler: { (action) in
            difficultyPlaying = 1
            gameTypePlaying = gameType
            self.performSegue(withIdentifier: "startGame", sender: self)
        }))
        //if gameType != 2 && gameType != 3 && gameType != 4{
        alertView.addAction(UIAlertAction(title: "Hard", style: .default, handler: { (action) in
            difficultyPlaying = 2
            gameTypePlaying = gameType
            self.performSegue(withIdentifier: "startGame", sender: self)
        }))
        //}
        alertView.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            difficultyPlaying = 0
            gameTypePlaying = 0
        }))
        self.present(alertView, animated: true)
    }
    
    
    @IBAction func GameCenterAction(_ sender: Any) {
        if needGameCenterInfo {
            let alertView = UIAlertController(title: "Note", message: "High Scores leaderboards are only made up of hard mode scores.", preferredStyle: .alert)
            alertView.view.tintColor = themeColor
            alertView.addAction(UIAlertAction(title: "Got it", style: .cancel, handler: { (action) in
                self.showLeaderboard()
            }))
            alertView.addAction(UIAlertAction(title: "Don't ask again", style: .default, handler: { (action) in
                self.needGameCenterInfo = false
                UserDefaults.standard.set(self.needGameCenterInfo, forKey: "needGameCenterInfo")
                self.showLeaderboard()
            }))
            self.present(alertView, animated: true)
        }
        else{
            showLeaderboard()
        }
    }
    
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true)
    }
    
    
}
