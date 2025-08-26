//
//  Billequal.swift
//  Billequal
//
//  Created by Lyudmila Tokar on 8/26/25.
//

struct Bill {
    var total: Double
    var pplNumber: Int
    var tips: Double
    
    var eachToPay: Double {
            let baseShare = total / Double(pplNumber)
            return baseShare + (baseShare * tips / 100)
        }
}

