//
//  Extensions.swift
//  C-CalculV3
//
//  Created by Charles on 9/14/19.
//  Copyright © 2019 charles. All rights reserved.
//

import Foundation
import UIKit
import GameKit

var gameTypePlaying = 0
var difficultyPlaying = 0
var highScores = [[[Double]]]()
let themeColor = UIColor(red: 255/255, green: 119/255, blue: 71/255, alpha: 1)


enum Vibration {
    case error
    case success
    case warning
    case light
    case medium
    case heavy
    case selection
    
    func vibrate() {
        
        switch self {
        case .error:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
            
        case .success:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            
        case .warning:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.warning)
            
        case .light:
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
            
        case .medium:
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            
        case .heavy:
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
            
        case .selection:
            let generator = UISelectionFeedbackGenerator()
            generator.selectionChanged()
            
        }
    }
    
}


//Upload to GC
func uploadHighScores(currentHighScore: Double, operation: Int) {
    if GKLocalPlayer.local.isAuthenticated  {
        var scoreReporter = GKScore()
        
        switch operation {
        case 0:
            scoreReporter = GKScore(leaderboardIdentifier: "fastest.time.addition.2")
        case 1:
            scoreReporter = GKScore(leaderboardIdentifier: "fastest.time.soustraction")
        case 2:
            scoreReporter = GKScore(leaderboardIdentifier: "fastest.time.multiplication")
        case 3:
            scoreReporter = GKScore(leaderboardIdentifier: "fastest.time.division.2")
        case 4:
            scoreReporter = GKScore(leaderboardIdentifier: "fastest.time.all")
            
        default:
            scoreReporter = GKScore(leaderboardIdentifier: "fastest.time.addition")
            
        }
        
        scoreReporter.value = Int64(currentHighScore*10)
        
        let scoreArray: [GKScore] = [scoreReporter]
        
        GKScore.report(scoreArray, withCompletionHandler: nil)
    }
}

//Check Achievements
func checkAchievements(currentTime: Double, currentDifficulty: Int, currentGameMode: Int) {
    var achievementsArray = [GKAchievement]()
    //Fast Player
    if currentTime <= 5 {
        let achievement = GKAchievement(identifier: "fast.player")
        achievement.percentComplete = 100
        achievement.showsCompletionBanner = true
        achievementsArray.append(achievement)
    }
    
    //Amazing Practice
    var hasWonAchievement = true
    for ihighScores in highScores {
        for jhighScores in ihighScores {
            if jhighScores.count < 3 {
                hasWonAchievement = false
            }
        }
    }
    
    if hasWonAchievement {
        let achievement = GKAchievement(identifier: "amazing.practice")
        achievement.percentComplete = 100
        achievement.showsCompletionBanner = true
        achievementsArray.append(achievement)
    }
    
    //Off Day
    if currentTime >= 100 {
        let achievement = GKAchievement(identifier: "off.day")
        achievement.percentComplete = 100
        achievement.showsCompletionBanner = true
        achievementsArray.append(achievement)
    }
    
    //Diverse Player
    hasWonAchievement = true
    for ihighScores in highScores {
        if ihighScores[0].count == 0 && ihighScores[1].count == 0 && ihighScores[2].count == 0 {
            hasWonAchievement = false
        }
    }
    
    if hasWonAchievement {
        let achievement = GKAchievement(identifier: "diverse.player")
        achievement.percentComplete = 100
        achievement.showsCompletionBanner = true
        achievementsArray.append(achievement)
    }
    
    
    
    //upload achievements if any
    if achievementsArray.count > 0 {
        GKAchievement.report(achievementsArray, withCompletionHandler: nil)
    }
    
}



// Screen width.
public var screenWidth: CGFloat {
    return UIScreen.main.bounds.width
}

// Screen height.
public var screenHeight: CGFloat {
    return UIScreen.main.bounds.height
}

/*
 switch UIDevice().type {
 case .iPhone4: //Done
     sizeLabel = 20
     sizeButtons = 20
 case .iPhone4S: //Done
     sizeLabel = 20
     sizeButtons = 20
 case .iPhone5: //Done
     sizeLabel = 25
     sizeButtons = 25
 case .iPhone5S: //Done
     sizeLabel = 25
     sizeButtons = 25
 case .iPhone5C: //Done
     sizeLabel = 25
     sizeButtons = 25
 case .iPhoneSE: //Done
     sizeLabel = 30
     sizeButtons = 30
 case .iPhone6: //Done
     sizeLabel = 30
     sizeButtons = 40
 case .iPhone6S: //Done
     sizeLabel = 30
     sizeButtons = 40
 case .iPhone7: //Done
     sizeLabel = 30
     sizeButtons = 40
 case .iPhone8: //Done
     sizeLabel = 30
     sizeButtons = 45
 case .iPhone6Plus: //Done
     sizeLabel = 45
     sizeButtons = 50
 case .iPhone6SPlus: //Done
     sizeLabel = 45
     sizeButtons = 50
 case .iPhone7Plus: //Done
     sizeLabel = 45
     sizeButtons = 50
 case .iPhone8Plus: //Done
     sizeLabel = 45
     sizeButtons = 50
 default:
     print()
 }
 */


/*
 switch UIDevice().type {
 case .iPhone4:
     size = 38
 case .iPhone4S:
     size = 38
 case .iPhone5:
     size = 38
 case .iPhone5S:
     size = 38
 case .iPhone5C:
     size = 38
 case .iPhoneSE:
     size = 38
 case .iPhone6:
     size = 55
 case .iPhone6S:
     size = 55
 case .iPhone7:
     size = 55
 case .iPhone8:
     size = 55
 case .iPhone6Plus:
     size = 65
 case .iPhone6SPlus:
     size = 65
 case .iPhone7Plus:
     size = 65
 case .iPhone8Plus:
     size = 65
 case .iPhoneX:
     size = 85
 case .iPhoneXR:
     size = 85
 case .iPhoneXS:
     size = 85
 case .iPhoneXSMax:
     size = 85
 case .iPhone11:
     size = 85
 case .iPhone11Pro:
     size = 85
 case .iPhone11ProMax:
     size = 85
 default:
     size = 38
 }
 */
