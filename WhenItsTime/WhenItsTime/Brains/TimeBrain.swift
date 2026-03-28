//
//  WhenItsTimeBraine.swift
//  WhenItsTime
//
//  Created by Lyudmila Tokar on 2/25/26.
//

import Foundation

struct TimeBrain {
    
    // Create model from raw date, optionally pinned to a specific timezone
    func makeTime(from date: Date, in timeZone: TimeZone = .current) -> AppTime {
        return AppTime(date: date, timeZone: timeZone)
    }
    
    // Getting date like: "Tue, 25 Feb"
    func formattedWeekdayAndDate(from appTime: AppTime) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, MMM dd"  // e.g., "Tue, 25 Feb"
        return formatter.string(from: appTime.date)
    }
    
    // 24-hour formatted time (e.g. 13:53), respects appTime's timezone
    func formattedTime(from appTime: AppTime) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_GB") // forces 24h
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = appTime.timeZone
        return formatter.string(from: appTime.date)
    }
    
    // Day label (current, next)
    func dayLabel(localTimeZone: TimeZone, workTimeZone: TimeZone, now: Date = Date()) -> String? {
        var localCalendar = Calendar.current
        localCalendar.timeZone = localTimeZone
        
        var workCalendar = Calendar.current
        workCalendar.timeZone = workTimeZone
        
        let localDay = localCalendar.component(.day, from: now)
        let workDay = workCalendar.component(.day, from: now)
        
        if workDay < localDay {
            return "(previous day)"
        } else if workDay > localDay {
            return "(next day)"
        } else {
            return nil // same day, no label needed
        }
    }
}
