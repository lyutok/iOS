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
    var splitNumber = 1.0
    var bill = 0.0
    
    @IBAction func tipChanged(_ sender: UIButton) {
        billTextField.endEditing(true)
        
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
        splitNumber = Double(sender.value)
        splitNumberLabel.text = String(format: "%.0f" , splitNumber)
        
    }
    
    @IBAction func calculatePressed(_ sender: UIButton) {
        bill = Double(billTextField.text!) ?? 0.0
//        print(tips)
//        print(splitNumber)
//        print(bill)
        
        performSegue(withIdentifier: "goToResults", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        if segue.identifier == "goToResults" {
            // Pass the selected object to the new view controller.
            let destinationVC = segue.destination as! ResultsViewController
            destinationVC.tipsValue = tips
            destinationVC.splitNumberValue = splitNumber
            destinationVC.billValue = bill
            destinationVC.resultValue = (bill / splitNumber) + (bill / splitNumber) * tips
        }
    }
}

