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

class GameView: UIViewController {
    
    //Variables
    var time: Double = 0
    var points: Int = 0
    var timer: Timer = Timer()
    var timerRunning: Bool = false
    var userAnswer: Int = 0
    var actualAnswer: Int = 0
    
    @IBOutlet weak var TimerLabel: UILabel!
    @IBOutlet weak var PointsLabel: UILabel!
    
    @IBOutlet weak var OperationLabel: UILabel!
    @IBOutlet weak var FirstNumberLabel: UILabel!
    @IBOutlet weak var SecondNumberLabel: UILabel!
    @IBOutlet weak var AnswerLabel: UILabel!
    @IBOutlet weak var BarImageView: UIImageView!
    
    @IBOutlet var AnswerButtonsOutlet: [UIButton]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLabels()
        adjustDarkMode()
    }
    
    
    func setupLabels() {
        TimerLabel.text = "\(time) s"
        PointsLabel.text = "\(points+1)/5"
        OperationLabel.text = "+"
        FirstNumberLabel.text = "0"
        SecondNumberLabel.text = "0"
        AnswerLabel.text = "0"
        
        adjustFontSize()
        
        AnswerButtonsOutlet.forEach { (button) in
            button.layer.cornerRadius = 10
            button.layer.borderWidth = 1
        }
        AnswerButtonsOutlet[11].setTitle("Start", for: .normal)
        
        let tripleTap = UILongPressGestureRecognizer(target: self, action: #selector(endGame))
        AnswerButtonsOutlet[10].addGestureRecognizer(tripleTap)
    }
    
    func adjustDarkMode(){
        let textColor = traitCollection.userInterfaceStyle == .dark ? UIColor.white : UIColor.black
        let backgroundColor = traitCollection.userInterfaceStyle == .dark ? UIColor.black : UIColor.white
        
        self.view.backgroundColor = traitCollection.userInterfaceStyle == .dark ? UIColor.black : UIColor.white
        
        BarImageView.backgroundColor = textColor
        
        TimerLabel.textColor = textColor
        PointsLabel.textColor = textColor
        FirstNumberLabel.textColor = textColor
        SecondNumberLabel.textColor = textColor
        AnswerLabel.textColor = textColor
        OperationLabel.textColor = textColor
        
        AnswerButtonsOutlet.forEach { (button) in
            button.layer.borderColor = textColor.cgColor
            button.setTitleColor(textColor, for: .normal)
        }
        AnswerButtonsOutlet[11].setTitleColor(themeColor, for: .normal)
        AnswerButtonsOutlet[11].layer.borderColor = themeColor.cgColor
        
        AnswerButtonsOutlet[10].setTitleColor(themeColor, for: .normal)
        AnswerButtonsOutlet[10].layer.borderColor = themeColor.cgColor
    }
    
    func adjustFontSize(){
        var size = OperationLabel.font.pointSize
        
        if screenHeight < 500 {
            size = 35
        }
        else if screenHeight < 600 { //iPhone 5 Done
            size = 38
        }
        else if screenHeight < 700 { //iPhone 8 Done
            size = 55
        }
        else if screenHeight < 800 { //iPhone 8 Plus Done
            size = 75
        }
        else{ //iPhone X and beyond
            size = 85
        }
        
        OperationLabel.font = OperationLabel.font.withSize(size)
        FirstNumberLabel.font = OperationLabel.font.withSize(size)
        SecondNumberLabel.font = OperationLabel.font.withSize(size)
        AnswerLabel.font = OperationLabel.font.withSize(size)
    }
    
    func startGame(){
        startTimer()
        makeNewQuestion()
        userAnswer = 0
        AnswerLabel.text = "\(userAnswer)"
        AnswerButtonsOutlet[11].setTitle("Enter", for: .normal)
    }
    
    func startTimer(){
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { (timer) in
            self.time += 0.1
            self.time = (self.time*10).rounded()/10
            self.TimerLabel.text = "\(self.time) s"
            
            if self.time > 20 {
                self.TimerLabel.textColor = .red
            }
            else{
                self.TimerLabel.textColor = self.traitCollection.userInterfaceStyle == .light ? UIColor.black : UIColor.white
            }
            self.timerRunning = true
        })
    }
    
    func stopTimer(){
        timer.invalidate()
        timerRunning = false
        AnswerButtonsOutlet[11].setTitle("Next", for: .normal)
    }
    
    func checkAnswer(){
        
        if userAnswer == actualAnswer {
            points += 1
            self.PointsLabel.text = "\(points+1)/5"
            stopTimer()
            checkWon()
            Vibration.error.vibrate()
        }
        else{
            userAnswer = 0
            AnswerLabel.text = "\(userAnswer)"
        }
        
    }
    
    func checkWon(){
        if points >= 5 {
            let alertView = UIAlertController(title: "You finished!", message: "Congrats, you finished in \(time) seconds", preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                //self.performSegue(withIdentifier: "endGame", sender: self)
                self.dismiss(animated: true)
            }))
            self.present(alertView, animated: true)
            
            
            if highScores[gameTypePlaying][difficultyPlaying].count < 20 {
                highScores[gameTypePlaying][difficultyPlaying].append(time)
                highScores[gameTypePlaying][difficultyPlaying].sort()
            }
            else if time < highScores[gameTypePlaying][difficultyPlaying].last ?? 0 {
                highScores[gameTypePlaying][difficultyPlaying].removeLast()
                highScores[gameTypePlaying][difficultyPlaying].append(time)
                highScores[gameTypePlaying][difficultyPlaying].sort()
            }
            
            saveHighScores()
            uploadHighScores(currentHighScore: highScores[gameTypePlaying][2].first ?? 10000000, operation: gameTypePlaying)
            checkAchievements(currentTime: time, currentDifficulty: difficultyPlaying, currentGameMode: gameTypePlaying)
        }
    }
    
    
    @objc func endGame() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    func makeNewQuestion() {
        var operationInt = Int(arc4random_uniform(4))
        if gameTypePlaying <= 3{
            operationInt = gameTypePlaying
        }
        var operation = ""
        
        //for +/-
        //Easy: 0-10
        //Meidum: 11-100
        //Hard: 111-999
        
        //for *//
        //Easy: 0-10
        //Meidum: 11-20
        //Hard: 21-100
        
        var firstNumber = 0
        var secondNumber = 0
        
        if operationInt <= 1 {
            switch difficultyPlaying {
            case 0:
                firstNumber = Int(arc4random_uniform(11))
                secondNumber = Int(arc4random_uniform(11))
            case 1:
                firstNumber = Int(arc4random_uniform(90)+11)
                secondNumber = Int(arc4random_uniform(90)+11)
            case 2:
                firstNumber = Int(arc4random_uniform(889)+111)
                secondNumber = Int(arc4random_uniform(889)+111)
            default:
                firstNumber = Int(arc4random_uniform(11))
                secondNumber = Int(arc4random_uniform(11))
            }
        }
        else{
            switch difficultyPlaying {
            case 0:
                firstNumber = Int(arc4random_uniform(11))
                secondNumber = Int(arc4random_uniform(11))
            case 1:
                firstNumber = Int(arc4random_uniform(20)+11)
                secondNumber = Int(arc4random_uniform(20)+11)
            case 2:
                firstNumber = Int(arc4random_uniform(70)+31)
                secondNumber = Int(arc4random_uniform(70)+31)
            default:
                firstNumber = Int(arc4random_uniform(11))
                secondNumber = Int(arc4random_uniform(11))
            }
        }
        
        
        switch operationInt {
        case 0:
            operation = "+"
            actualAnswer = firstNumber + secondNumber
        case 1:
            operation = "-"
            if secondNumber > firstNumber {
                let a = firstNumber
                firstNumber = secondNumber
                secondNumber = a
            }
            
            actualAnswer = firstNumber - secondNumber
        case 2:
            operation = "x"
            firstNumber = firstNumber / 4 + 1
            secondNumber = secondNumber / 4 + 1
            
            actualAnswer = firstNumber * secondNumber
        case 3:
            operation = "÷"
            let a = firstNumber / 4 + 1
            let b = secondNumber / 4 + 1
            firstNumber = a * b
            secondNumber = a
            
            actualAnswer = firstNumber / secondNumber
        default:
            operation = "+"
            actualAnswer = firstNumber + secondNumber
        }
        
        FirstNumberLabel.text = numberToString(number: firstNumber)
        SecondNumberLabel.text = numberToString(number: secondNumber)
        OperationLabel.text = "\(operation)"
    }
    
    
    
    func numberToString(number: Int) -> String {
        if number <= 9 {
            return "\(number)"
        }
        else if number <= 99 {
            return "\((number/10)%10) \(number%10)"
        }
        else if number <= 999{
            return "\((number/100)%10) \((number/10)%10) \(number%10)"
        }
        else{
            return "\((number/1000)%10) \((number/100)%10) \((number/10)%10) \(number%10)"
        }
    }
    
    func saveHighScores() {
        UserDefaults.standard.set(highScores, forKey: "highScores")
    }
    
    
    
    @IBAction func AnswerButtonsAction(_ sender: UIButton) {
        var indexOfButton = 0
        
        for index in 0...AnswerButtonsOutlet.count-1 {
            if sender == AnswerButtonsOutlet[index] {
                indexOfButton = index
            }
        }
        
        if indexOfButton < 10 && userAnswer <= 999{
            userAnswer = userAnswer*10 + indexOfButton
        }
        else if indexOfButton == 10 {
            userAnswer = 0
        }
        else if indexOfButton == 11 {
            if timerRunning {
                checkAnswer()
            }
            else{
                startGame()
            }
        }
        AnswerLabel.text = numberToString(number: userAnswer)
        
        
    }
    
}

