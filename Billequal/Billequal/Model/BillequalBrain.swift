//
//  BillequalBrain.swift
//  Billequal
//
//  Created by Lyudmila Tokar on 8/26/25.
//

import UIKit

struct BillequalBrain {
    var bill: Bill?
    
    mutating func createBill(total: Double, pplNumber: Int, tips: Double) {
        bill = Bill(total: total, pplNumber: pplNumber, tips: tips)
    }
    
    func evaluateExpression(_ expression: String) -> Double? {
        let cleaned = expression
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "=", with: "")
            .replacingOccurrences(of: ",", with: ".")

        
        // only allow digits, decimal point, (), and operators
        let allowedCharacters = CharacterSet(charactersIn: "0123456789+-*/.()")
        if cleaned.rangeOfCharacter(from: allowedCharacters.inverted) != nil {
            return nil // invalid input
        }
        
        // Evaluate with NSExpression
        let exp = NSExpression(format: cleaned)
        if let result = exp.expressionValue(with: nil, context: nil) as? Double {
            return result
        }
        
        return nil
    }
}
