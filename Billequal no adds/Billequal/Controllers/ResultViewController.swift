//
//  ResultViewController.swift
//  Billequal
//
//  Created by Liudmyla Tokar on 8/18/25.
//

import UIKit

class ResultViewController: UIViewController {
    
    var billValues: Bill?
    let textToShare = ""
    
    @IBOutlet var resultToPayLabel: UILabel!
    @IBOutlet var resultNote: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let bill = billValues {
            resultToPayLabel.text = String(format: "%.2f", bill.eachToPay)
            resultNote.text = "(\(String(format: "%.0f", bill.tips))% tip included)"
        }
    }
    
    func generateTextToShare() -> String {
        return """
                Each person pays: \(String(format: "%.2f", billValues?.eachToPay ?? 0.0)) (\(String(format: "%.0f", billValues?.tips ?? 0.0))% tip included)
                Total bill: \(String(format: "%.2f", billValues?.total ?? 0.0))
                
                Billequal • Making splits simple
                """
    }
    
    @IBAction func copyButtonPressed(_ sender: UIButton) {
        UIPasteboard.general.string = generateTextToShare()
        // Animate to "Copied ☑️"
            UIView.transition(with: sender, duration: 0.25, options: .transitionCrossDissolve) {
                sender.setTitle("Copied ☑️", for: .normal)
            }

        // Reset after 1.5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            UIView.transition(with: sender, duration: 0.25, options: .transitionCrossDissolve) {
                sender.setTitle("Copy", for: .normal)
            }
        }
    }
    
    @IBAction func shareButtonPressed(_ sender: UIButton) {
        // Text or data to share      
        let textToShare = generateTextToShare()
            
        ShareHelper.presentShareSheet(from: self, sender: sender, text: textToShare)
    }
    
    @IBAction func reCalculateButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
