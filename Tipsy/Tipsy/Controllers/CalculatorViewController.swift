//
//  ViewController.swift
//  Tipsy
//
//  Created by Angela Yu on 09/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    @IBOutlet var billTextField: UITextField!
    @IBOutlet var zeroPctButton: UIButton!
    @IBOutlet var tenPctButton: UIButton!
    @IBOutlet var twentyPctButton: UIButton!
    @IBOutlet var splitNumberLabel: UILabel!
    
    var tips = 0.1
    
    @IBAction func tipChanged(_ sender: UIButton) {
        
        zeroPctButton.isSelected = false
        tenPctButton.isSelected = false
        twentyPctButton.isSelected = false
        
        sender.isSelected = true
        
        if sender.isSelected == true {
            sender.tintColor = #colorLiteral(red: 0.3287626505, green: 0.6941674948, blue: 0.4237300754, alpha: 1)
        }
        
        tips = Double(sender.currentTitle?.replacingOccurrences(of: "%", with: "").trimmingCharacters(in: .whitespaces) ?? "0.0" )! / 100
        
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        
    }
    
    @IBAction func calculatePressed(_ sender: UIButton) {
        
        print(tips)
    }
    
}

