//
//  HighScoresView.swift
//  C-CalculV3
//
//  Created by Charles on 9/10/19.
//  Copyright © 2019 charles. All rights reserved.
//

import Foundation
import UIKit

class HighScoreView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var HighScoreTypeSegmentControl: UISegmentedControl!
    @IBOutlet weak var HighScoreTableView: UITableView!
    @IBOutlet weak var HighScoreTitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        adjustDarkMode()
    }
    
    func setupViews(){
        HighScoreTableView.delegate = self
        HighScoreTableView.dataSource = self
        
        HighScoreTypeSegmentControl.setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: "KidZone", size: 35) ?? UIFont.systemFontSize, NSAttributedString.Key.foregroundColor: themeColor], for: .normal)
        HighScoreTypeSegmentControl.tintColor = themeColor
    }
    
    func adjustDarkMode(){
        let textColor = traitCollection.userInterfaceStyle == .dark ? UIColor.white : UIColor.black
        let backgroundColor = traitCollection.userInterfaceStyle == .dark ? UIColor.black : UIColor.white
        
        self.view.backgroundColor = backgroundColor
        HighScoreTableView.backgroundColor = backgroundColor
        
        HighScoreTitleLabel.textColor = textColor
        
    }
    
    @IBAction func HighScoreTypeChange(_ sender: Any) {
        HighScoreTableView.reloadData()
    }
    @IBAction func BackButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(highScores[HighScoreTypeSegmentControl.selectedSegmentIndex][0].count, highScores[HighScoreTypeSegmentControl.selectedSegmentIndex][1].count, highScores[HighScoreTypeSegmentControl.selectedSegmentIndex][2].count) + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "highScoreCell")
        
        let textColor = traitCollection.userInterfaceStyle == .light ? UIColor.black : UIColor.white

        (cell?.viewWithTag(1) as! UILabel).textColor = textColor
        (cell?.viewWithTag(2) as! UILabel).textColor = textColor
        (cell?.viewWithTag(3) as! UILabel).textColor = textColor
        
        if indexPath.row == 0 {
            (cell?.viewWithTag(1) as! UILabel).text = "Easy"
            (cell?.viewWithTag(2) as! UILabel).text = "Medium"
            (cell?.viewWithTag(3) as! UILabel).text = "Hard"
        }
        else{
            if highScores[HighScoreTypeSegmentControl.selectedSegmentIndex][0].count >= indexPath.row {
                (cell?.viewWithTag(1) as! UILabel).text = "\(highScores[HighScoreTypeSegmentControl.selectedSegmentIndex][0][indexPath.row-1])"
            }
            else{
                (cell?.viewWithTag(1) as! UILabel).text = " "
            }
            if highScores[HighScoreTypeSegmentControl.selectedSegmentIndex][1].count >= indexPath.row {
                (cell?.viewWithTag(2) as! UILabel).text = "\(highScores[HighScoreTypeSegmentControl.selectedSegmentIndex][1][indexPath.row-1])"
            }
            else{
                (cell?.viewWithTag(2) as! UILabel).text = " "
            }
            if highScores[HighScoreTypeSegmentControl.selectedSegmentIndex][2].count >= indexPath.row {
                (cell?.viewWithTag(3) as! UILabel).text = "\(highScores[HighScoreTypeSegmentControl.selectedSegmentIndex][2][indexPath.row-1])"
            }
            else{
                (cell?.viewWithTag(3) as! UILabel).text = " "
            }
        }
        
        return cell!
    }
    
}
