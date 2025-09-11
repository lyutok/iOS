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
}
