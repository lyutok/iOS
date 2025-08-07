//
//  CalculatorBrain.swift
//  BMI Calculator
//
//  Created by Lyudmila Tokar on 8/7/25.
//  Copyright © 2025 Angela Yu. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    
    func calculateBMI(_ weight: Float, _ height: Float) -> String {
        return String(format: "%.1f", weight / (height * height))
    }
}
