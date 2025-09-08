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
    
//    func evaluateExpression(_ expression: String) -> Double? {
//        var cleaned = expression
//            .replacingOccurrences(of: " ", with: "")
//            .replacingOccurrences(of: "=", with: "")
//            .replacingOccurrences(of: ",", with: ".")
//
//        // Allow only digits, decimal point, (), and operators
//        let allowedCharacters = CharacterSet(charactersIn: "0123456789+-*/.()")
//        if cleaned.rangeOfCharacter(from: allowedCharacters.inverted) != nil {
//            return nil
//        }
//
//        // Prevent invalid operator sequences
//        let invalidPatterns = ["++", "--", "+*", "+/", "-+", "*+", "/+"]
//        for pattern in invalidPatterns {
//            if cleaned.contains(pattern) {
//                return nil
//            }
//        }
//
//        // Auto-balance parentheses
//        let openCount = cleaned.filter { $0 == "(" }.count
//        let closeCount = cleaned.filter { $0 == ")" }.count
//        if openCount > closeCount {
//            cleaned.append(String(repeating: ")", count: openCount - closeCount))
//        } else if closeCount > openCount {
//            cleaned = String(repeating: "(", count: closeCount - openCount) + cleaned
//        }
//
//        // Evaluate safely
//        let exp = NSExpression(format: cleaned)
//        if let result = exp.expressionValue(with: nil, context: nil) as? Double {
//            return result.isFinite ? result : nil // avoid NaN or Inf
//        }
//
//        return nil
//    }

}
