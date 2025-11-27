
//import Expression
//
//let exp = Expression("10 + 3 * 2")
//let result = try? exp.evaluate()
//print(result ?? 0)  // 16


import Foundation

func evaluate(_ math: String) -> Double? {
    let exp = NSExpression(format: math)
    return exp.expressionValue(with: nil, context: nil) as? Double
}

print(evaluate("0")!)     // 16
print(evaluate("2 * (10 + 5)")!)   // 30
print(evaluate("10 / 2.5")!)
print(evaluate("3 / 9")!)
