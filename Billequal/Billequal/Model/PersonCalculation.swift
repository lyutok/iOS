//
//  CellBillData.swift
//  Billequal
//
//  Created by Lyudmila Tokar on 9/12/25.
//

struct PersonCalculation {
    
    var name: String
    var result: Double
    var resultWithTips: Double
    
    mutating func calculateWithTips(tips: Double) -> Double {
        return result + (result * tips / 100)
    }
}
