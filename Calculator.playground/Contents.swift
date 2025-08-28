import UIKit

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

if let result = evaluateExpression("(12+23)/2-1.99") {
    print("Result = \(result)")   // 16.51
} else {
    print("Invalid input")
}

print(evaluateExpression("qw+we+34="))
print(evaluateExpression("12+34="))
print(evaluateExpression("12+34-1,3/2-2*10="))
