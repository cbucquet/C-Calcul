//
//  AboutView.swift
//  C-CalculV3
//
//  Created by Charles on 9/14/19.
//  Copyright © 2019 charles. All rights reserved.
//

import Foundation
import UIKit
import StoreKit

class AboutView: UIViewController {
    
    @IBOutlet weak var PresentationTitleLabel: UILabel!
    @IBOutlet weak var PresentationTextView: UITextView!
    
    /*@IBOutlet weak var UsTitleLabel: UILabel!
    @IBOutlet weak var UsTextView: UITextView!*/
    
    @IBOutlet weak var ShareTitleLabel: UILabel!
    @IBOutlet weak var RateButtonOutlet: UIButton!
    @IBOutlet weak var ShareButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        adjustDarkMode()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.PresentationTextView.setContentOffset(CGPoint.zero, animated: false)
        //self.UsTextView.setContentOffset(CGPoint.zero, animated: false)
    }
    
    func setupViews() {
        PresentationTitleLabel.text = "What is Calculations?"
        PresentationTextView.text = "    Born in 2015, Calculations a mathematical skill trainer for anybody looking to improve their competence. Simply click on the operation you want to master, choose a level of difficulty, and get to ready to answer 2+3 questions as quickly as you possibly can. Your high scores are saved under the designated page (accesible through the crown). You can also compete on the world leaderboard, competeing with people across the globe. Keep practising to reach number 1!"
        PresentationTextView.textAlignment = .justified
        
        /*UsTitleLabel.text = "Who are we?"
        UsTitleLabel.textColor = textColor
        UsTextView.text = "Mi casa es mi casa"
        UsTextView.textColor = textColor
        UsTextView.backgroundColor = backgroundColor
        UsTextView.textAlignment = .justified*/
        
        ShareTitleLabel.text = "Please consider sharing or rating the app"
        
        ShareButtonOutlet.layer.cornerRadius = 10
        ShareButtonOutlet.layer.borderColor = themeColor.cgColor
        ShareButtonOutlet.layer.borderWidth = 1
        ShareButtonOutlet.setTitle("Share", for: .normal)
        ShareButtonOutlet.setTitleColor(themeColor, for: .normal)
        
        RateButtonOutlet.layer.cornerRadius = 10
        RateButtonOutlet.layer.borderColor = themeColor.cgColor
        RateButtonOutlet.layer.borderWidth = 1
        RateButtonOutlet.setTitle("Rate", for: .normal)
        RateButtonOutlet.setTitleColor(themeColor, for: .normal)
    }
    
    func adjustDarkMode() {
        let textColor = traitCollection.userInterfaceStyle == .dark ? UIColor.white : UIColor.black
        let backgroundColor = traitCollection.userInterfaceStyle == .dark ? UIColor.black : UIColor.white
        
        self.view.backgroundColor = backgroundColor

        PresentationTitleLabel.textColor = textColor
        PresentationTextView.textColor = textColor
        PresentationTextView.backgroundColor = backgroundColor
        
        ShareTitleLabel.textColor = textColor
    }
    
    @IBAction func RateButtonAction(_ sender: Any) {
        SKStoreReviewController.requestReview()
    }
    @IBAction func ShareButtonAction(_ sender: Any) {
        
        var activityView = UIActivityViewController(activityItems: ["I have found an amazing mathematical skills trainer app: ℂalculations. Make sure to download it on the App Store. https://itunes.apple.com/app/apple-store/id995798031?mt=8"], applicationActivities: nil)
        
        if let logoImage = UIImage(named: "logo") {
            activityView = UIActivityViewController(activityItems: ["I have found an amazing mathematical skills trainer app: ℂalculations. Make sure to download it on the App Store. https://itunes.apple.com/app/apple-store/id995798031?mt=8", logoImage], applicationActivities: nil)
        }
        
        activityView.popoverPresentationController?.sourceView = self.view
        activityView.excludedActivityTypes = [UIActivity.ActivityType.copyToPasteboard,
                                              UIActivity.ActivityType.saveToCameraRoll,
                                              UIActivity.ActivityType.airDrop,
                                              UIActivity.ActivityType.assignToContact,
                                              UIActivity.ActivityType.markupAsPDF,
                                              UIActivity.ActivityType.openInIBooks,
                                              UIActivity.ActivityType.print]
        present(activityView, animated: true, completion: nil)
    }
    @IBAction func BackButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
