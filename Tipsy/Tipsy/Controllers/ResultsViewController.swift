//
//  ResultsViewController.swift
//  Tipsy
//
//  Created by Lyudmila Tokar on 8/12/25.
//  Copyright © 2025 The App Brewery. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {
    
    @IBOutlet var totalLabel: UILabel!
    @IBOutlet var settingsLabel: UILabel!
    
    var tipsValue: Double?
    var splitNumberValue: Double?
    var billValue: Double?
    var resultValue: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
//        print(String(format: "%.2f", resultValue ?? 0.0))
//        print(Int((tipsValue ?? 0) * 100))

        totalLabel.text = String(format: "%.2f", resultValue ?? 0.0)
        settingsLabel.text = "Split between \(Int(splitNumberValue ?? 1)) people, with \(Int((tipsValue ?? 0) * 100))% tip."
    }
    
    @IBAction func recalculatePressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
