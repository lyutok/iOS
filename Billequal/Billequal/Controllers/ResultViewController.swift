//
//  ResultViewController.swift
//  Billequal
//
//  Created by Lyudmila Tokar on 8/18/25.
//

import UIKit

class ResultViewController: UIViewController {
    
    var billValues: Bill?
    
    @IBOutlet var resultToPayLabel: UILabel!
    @IBOutlet var resultNote: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let bill = billValues {
            resultToPayLabel.text = String(format: "%.2f", bill.eachToPay)
            resultNote.text = "\(String(format: "%.0f", bill.tips))% tips included."
        }
    }
    
    @IBAction func shareButtonPressed(_ sender: UIButton) {
        // Text or data to share
//        let textToShare = """
//                        Here’s \(String(format: "%.2f", billValues?.total ?? 0.0)) bill split: \(String(format: "%.2f", billValues?.eachToPay ?? 0.0)) 💸 each, \(String(format: "%.0f", billValues?.tips ?? 0.0))% included.
//                        — Sent from Billequal
//                        """
//        
        let textToShare = """
                        
                        Each person pays: 💸\(String(format: "%.2f", billValues?.eachToPay ?? 0.0)) (\(String(format: "%.0f", billValues?.tips ?? 0.0))% tips included)
                        Total bill: 💸\(String(format: "%.2f", billValues?.total ?? 0.0)) 
                        — Sent from Billequal
                        """
            
        ShareHelper.presentShareSheet(from: self, sender: sender, text: textToShare)
    }
    
    @IBAction func reCalculateButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
