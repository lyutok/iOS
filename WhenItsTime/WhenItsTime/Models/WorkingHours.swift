//
//  WorkingHours.swift
//  WhenItsTime
//
//  Created by Lyudmila Tokar on 3/31/26.
//

import Foundation
import UIKit

struct WorkingHours: Codable {
    var startHour: Int    // e.g. 9
    var startMinute: Int  // e.g. 0
    var endHour: Int      // e.g. 18
    var endMinute: Int    // e.g. 0
    
    var displayString: String {
        return String(format: "%02d:%02d - %02d:%02d", startHour, startMinute, endHour, endMinute)
    }
    
    // Presets
    static let presets: [WorkingHours] = [
        WorkingHours(startHour: 9,  startMinute: 0, endHour: 18, endMinute: 0),
        WorkingHours(startHour: 10, startMinute: 0, endHour: 19, endMinute: 0),
        WorkingHours(startHour: 8,  startMinute: 0, endHour: 17, endMinute: 0)
    ]
    
    func timeSFSymbolAndColor(for hour: Int) -> (name: String, color: UIColor) {
        switch hour {
        case 0..<6:   return ("bed.double.fill", .systemGray)
        case 6..<9:   return ("cup.and.saucer.fill", .systemBrown)
        case 9..<19:  return ("sun.max.fill", .systemYellow)
        case 19..<22: return ("sunset.fill", .systemOrange)
            default:  return ("moon.stars.fill", .systemBlue)
        }
    }
    
    static func whdayLabel(localStartSeconds: Int, localEndSeconds: Int) -> String? {
        if localEndSeconds > 86400 {
            return "ׁ· next day"
        } else if localStartSeconds < 0 {
            return "· previous day"
        } else {
            return nil // same day — no label needed
        }
    }
    
    // MARK: - Working hours status
    func isCurrentlyWorking(currentHour: Int, currentMinute: Int) -> Bool {
        let currentTotalMinutes = currentHour * 60 + currentMinute
        let startTotalMinutes = startHour * 60 + startMinute
        let endTotalMinutes = endHour * 60 + endMinute
        
        return currentTotalMinutes >= startTotalMinutes && currentTotalMinutes < endTotalMinutes
    }

    func timeUntilChange(currentHour: Int, currentMinute: Int) -> String {
        let currentTotalMinutes = currentHour * 60 + currentMinute
        let startTotalMinutes = startHour * 60 + startMinute
        let endTotalMinutes = endHour * 60 + endMinute
        
        let isWorking = isCurrentlyWorking(currentHour: currentHour, currentMinute: currentMinute)
        
        let targetMinutes = isWorking ? endTotalMinutes : startTotalMinutes
        var diff = targetMinutes - currentTotalMinutes
        
        // Handle next day wraparound
        if diff < 0 { diff += 24 * 60 }
        
        let hours = diff / 60
        let minutes = diff % 60
        
        if isWorking {
            if hours == 0 {
                return "⏰ Ends in \(minutes)min"
            }
            return "⏰ Ends in \(hours)h \(minutes)min"
        } else {
            if hours == 0 {
                return "⏰ Start in \(minutes)min"
            }
            return "⏰ Start in \(hours)h \(minutes)min"
        }
    }
    
    // MARK: - Weekend check
    func isWeekend(in timeZone: TimeZone, now: Date = Date()) -> Bool {
        var calendar = Calendar.current
        calendar.timeZone = timeZone
        let weekday = calendar.component(.weekday, from: now)
        return weekday == 1 || weekday == 7  // 1 = Sunday, 7 = Saturday
    }

    func nextMondayString(in timeZone: TimeZone, now: Date = Date()) -> String {
        var calendar = Calendar.current
        calendar.timeZone = timeZone
        let weekday = calendar.component(.weekday, from: now)
        
        // Days until Monday
        let daysUntilMonday: Int
        switch weekday {
        case 1: daysUntilMonday = 1  // Sunday → tomorrow
        case 7: daysUntilMonday = 2  // Saturday → 2 days
        default: daysUntilMonday = 0 // weekday (shouldn't happen)
        }
        
        let nextMonday = calendar.date(byAdding: .day, value: daysUntilMonday, to: now)!
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"  // "Monday"
        formatter.timeZone = timeZone
        
        return formatter.string(from: nextMonday)
    }
    
    func timeUntilWeekend(in timeZone: TimeZone, now: Date = Date()) -> String {
        var calendar = Calendar.current
        calendar.timeZone = timeZone
        
        let nextMonday = calendar.nextDate(
            after: now,
            matching: DateComponents(hour: startHour, minute: startMinute, weekday: 2),
            matchingPolicy: .nextTime
        )!
        
        let diff = Int(nextMonday.timeIntervalSince(now))
        let days = diff / 86400
        let hours = (diff % 86400) / 3600
        let minutes = (diff % 3600) / 60
        
        if days > 0 {
            return "Back to work in \(days)d \(hours)h \(minutes)min"
        } else {
            return "Back to work in \(hours)h \(minutes)min"
        }
    }
    
}

