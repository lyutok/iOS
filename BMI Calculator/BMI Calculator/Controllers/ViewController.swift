//
//  ViewController.swift
//  BMI Calculator
//
//  Created by Angela Yu on 21/08/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var heightLabel: UILabel!
    @IBOutlet var weightLabel: UILabel!
    
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
    
}

