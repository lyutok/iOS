//
//  ResultViewController.swift
//  Billequal
//
//  Created by Lyudmila Tokar on 8/18/25.
//

import UIKit

class ResultViewController: UIViewController {
    
    var totalValue: Double?
    var tipsValue: Double?
    var pplNumberValue: Int?
    var eachToPayValue: Double?
    
    @IBOutlet var resultToPayLabel: UILabel!
    @IBOutlet var resultNote: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultToPayLabel.text = String(format: "%.2f", eachToPayValue ?? 0.0)
        resultNote.text = "\(String(format: "%.0f", tipsValue ?? 0.0))% tips included."
    }
    
    @IBAction func shareButtonPressed(_ sender: UIButton) {
        // Text or data to share
        let textToShare = "Here’s \(String(format: "%.2f", totalValue ?? 0.0)) bill split: \(String(format: "%.2f", eachToPayValue ?? 0.0)) 💸 each, \(String(format: "%.0f", tipsValue ?? 0.0))% included."
            
            let items: [Any] = [textToShare]
            
            let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
            
            // For iPad: present in a popover
            if let popoverController = activityVC.popoverPresentationController {
                popoverController.sourceView = sender
            }
            
            present(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func reCalculateButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
