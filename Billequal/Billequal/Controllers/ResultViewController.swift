//
//  ResultViewController.swift
//  Billequal
//
//  Created by Liudmyla Tokar on 8/18/25.
//

//import UIKit
//import GoogleMobileAds
//
//class ResultViewController: UIViewController {
//    
//    var billValues: Bill?
//    let textToShare = ""
//    var shouldShowAd = true // ads
//
//    @IBOutlet var resultToPayLabel: UILabel!
//    @IBOutlet var resultNote: UILabel!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        if let bill = billValues {
//            resultToPayLabel.text = String(format: "%.2f", bill.eachToPay)
//            resultNote.text = "(\(String(format: "%.0f", bill.tips))% tips included)"
//        }
//    }
//    
//    // Google ads
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        AdManager.shared.loadAd()
//    }
//    
//    func generateTextToShare() -> String {
//        return """
//                Each person pays: \(String(format: "%.2f", billValues?.eachToPay ?? 0.0)) (\(String(format: "%.0f", billValues?.tips ?? 0.0))% tips included)
//                Total bill: \(String(format: "%.2f", billValues?.total ?? 0.0))
//                
//                — Billequal • Making splits simple
//                """
//    }
//    
//    @IBAction func copyButtonPressed(_ sender: UIButton) {
//        UIPasteboard.general.string = generateTextToShare()
//        // Animate to "Copied ☑️"
//            UIView.transition(with: sender, duration: 0.25, options: .transitionCrossDissolve) {
//                sender.setTitle("Copied ☑️", for: .normal)
//            }
//
//        // Reset after 1.5 seconds
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//            UIView.transition(with: sender, duration: 0.25, options: .transitionCrossDissolve) {
//                sender.setTitle("Copy", for: .normal)
//            }
//        }
//    }
//    
//    @IBAction func shareButtonPressed(_ sender: UIButton) {
//        // Text or data to share      
//        let textToShare = generateTextToShare()
//            
//        ShareHelper.presentShareSheet(from: self, sender: sender, text: textToShare)
//    }
//    
//    @IBAction func reCalculateButtonPressed(_ sender: UIButton) {
//        self.dismiss(animated: true, completion: nil)
//    }
//}

import UIKit
import GoogleMobileAds

class ResultViewController: UIViewController {
    
    var billValues: Bill?
    var shouldShowAd = true // show ad ONLY once per appearance
    
    @IBOutlet var resultToPayLabel: UILabel!
    @IBOutlet var resultNote: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let bill = billValues {
            resultToPayLabel.text = String(format: "%.2f", bill.eachToPay)
            resultNote.text = "(\(String(format: "%.0f", bill.tips))% tips included)"
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Load next ad
        AdManager.shared.loadAd()
        
        // Show ad ONCE
        if shouldShowAd {
            shouldShowAd = false
            AdManager.shared.showInterstitial(from: self)
        }
    }
    
    // SHARE TEXT
    func generateTextToShare() -> String {
            return """
                Each person pays: \(String(format: "%.2f", billValues?.eachToPay ?? 0.0)) (\(String(format: "%.0f", billValues?.tips ?? 0.0))% tips included)
                Total bill: \(String(format: "%.2f", billValues?.total ?? 0.0))

                — Billequal • Making splits simple
                """
        }
    
    @IBAction func copyButtonPressed(_ sender: UIButton) {
        UIPasteboard.general.string = generateTextToShare()
        UIView.transition(with: sender, duration: 0.25, options: .transitionCrossDissolve) {
            sender.setTitle("Copied ☑️", for: .normal)
        }
        // Reset after 1.5 sec
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            UIView.transition(with: sender, duration: 0.25, options: .transitionCrossDissolve) {
                sender.setTitle("Copy", for: .normal)
            }
        }
    }
    
    @IBAction func shareButtonPressed(_ sender: UIButton) {
        ShareHelper.presentShareSheet(from: self, sender: sender, text: generateTextToShare())
    }
    
    @IBAction func reCalculateButtonPressed(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
