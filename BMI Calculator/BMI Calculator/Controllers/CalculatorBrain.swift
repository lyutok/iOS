//
//  CalculatorBrain.swift
//  BMI Calculator
//
//  Created by Lyudmila Tokar on 8/7/25.
//  Copyright © 2025 Angela Yu. All rights reserved.
//

import UIKit

struct CalculatorBrain {
    
    var bmi: BMI?
    
    mutating func calculateBMI(_ weight: Float, _ height: Float) {
        let bmiValue = weight / (height * height)
        
        if bmiValue < 18.5 {
            bmi = BMI(value: bmiValue, advice: "Eat more pies", color: .cyan)
        } else if bmiValue < 24.9 {
            bmi = BMI(value: bmiValue, advice: "Fit as a fiddle", color: .green)
        } else {
            bmi = BMI(value: bmiValue, advice: "Eat less pies", color: .red )
        }
    }
}
