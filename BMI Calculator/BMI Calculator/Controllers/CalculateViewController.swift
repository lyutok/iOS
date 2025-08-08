//
//  ViewController.swift
//  BMI Calculator
//
//  Created by Angela Yu on 21/08/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit

class CalculateViewController: UIViewController {
    
    @IBOutlet var heightLabel: UILabel!
    @IBOutlet var weightLabel: UILabel!
    
    @IBOutlet var heightSlider: UISlider!
    @IBOutlet var weightSlider: UISlider!
    
    var calculatorBrain = CalculatorBrain()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func weightSliderChange(_ sender: UISlider) {
        
        weightLabel.text = String(format: "%.0f Kg", sender.value)
    }
    @IBAction func heightSliderChange(_ sender: UISlider) {
        
        heightLabel.text = String(format: "%.2f m", sender.value)
    }
    
    @IBAction func calculateButtonPressed(_ sender: UIButton) {
        let weight = weightSlider.value
        let height = heightSlider.value
        
        calculatorBrain.calculateBMI(weight, height)
        
        self.performSegue(withIdentifier: "goToResult", sender: self)
        
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "goToResult" {
                
                let destinationVC = segue.destination as! ResultViewController
                let bmi = calculatorBrain.bmi?.value ?? 0.0
                destinationVC.bmiValue = String(format: "%.1f", bmi)
                destinationVC.advice = calculatorBrain.bmi?.advice ?? "BMI"
                destinationVC.color = calculatorBrain.bmi?.color ?? #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }
    }
}

