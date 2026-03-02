//
//  WhenItsTimeBraine.swift
//  WhenItsTime
//
//  Created by Lyudmila Tokar on 2/25/26.
//

import Foundation

struct TimeBrain {
    
    // Create model from raw date
    func makeTime(from date: Date) -> AppTime {
        return AppTime(date: date)
    }
    
    // Getting date like: "Tue, 25 Feb"
    func formattedWeekdayAndDate(from appTime: AppTime) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, MMM dd"  // e.g., "Tue, 25 Feb"
        return formatter.string(from: appTime.date)
    }
    
//    // Medium formatted date (e.g. 25 Feb 2026)
//    func formattedDate(from appTime: AppTime) -> String {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .medium
//        formatter.timeStyle = .none
//        return formatter.string(from: appTime.date)
//    }
    
    // 24-hour formatted time (e.g. 13:53)
    func formattedTime(from appTime: AppTime) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_GB") // forces 24h
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: appTime.date)
    }
}
