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
                return "Ends in \(minutes)min"
            }
            return "Ends in \(hours)h \(minutes)min"
        } else {
            if hours == 0 {
                return "Starts in \(minutes)min"
            }
            return "Starts in \(hours)h \(minutes)min"
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
            return "☑ Available in \(days)d \(hours)h \(minutes)min"
        } else {
            return "☑ Available in \(hours)h \(minutes)min"
        }
    }
    
    // MARK: - Best time to connect
//    struct BestTimeResult {
//        enum Quality {
//            case ideal    // overlap in 08:00–22:00
//            case early    // 06:00–08:00
//            case late     // 22:00–02:00
//            case offTime  // fallback (02:00–06:00 or none)
//        }
//        let quality: Quality
//        let startHour: Int
//        let startMinute: Int
//        let endHour: Int
//        let endMinute: Int
//    }
//
//    func bestTimeToConnect(localStartSeconds: Int, localEndSeconds: Int) -> BestTimeResult? {
//        // Available zones in minutes
//        let perfectStart = 8 * 60    // 08:00
//        let perfectEnd = 22 * 60     // 22:00
//        let stretchStart = 6 * 60    // 06:00
//        let stretchEnd = 8 * 60      // 08:00
//        let lateStart = 22 * 60      // 22:00
//        let lateEnd = 26 * 60        // 02:00 next day (26h)
//
//        let workStart = localStartSeconds / 60
//        let workEnd = localEndSeconds / 60
//        
//        // Helper to find overlap
//        func overlap(zoneStart: Int, zoneEnd: Int) -> (Int, Int)? {
//            for offset in [-24*60, 0, 24*60] {
//                let shiftedStart = workStart + offset
//                let shiftedEnd = workEnd + offset
//                let start = max(shiftedStart, zoneStart)
//                let end = min(shiftedEnd, zoneEnd)
//                if start < end { return (start, end) }
//            }
//            return nil
//        }
//        
//        // Priority 1 — Perfect zone
//        if let (start, end) = overlap(zoneStart: perfectStart, zoneEnd: perfectEnd) {
//            return BestTimeResult(quality: .ideal,
//                                startHour: (start % (24*60)) / 60, startMinute: start % 60,
//                                endHour: (end % (24*60)) / 60, endMinute: end % 60)
//        }
//        
//        // Priority 2a — Stretch zone
//        if let (start, end) = overlap(zoneStart: stretchStart, zoneEnd: stretchEnd) {
//            return BestTimeResult(quality: .early,
//                                startHour: (start % (24*60)) / 60, startMinute: start % 60,
//                                endHour: (end % (24*60)) / 60, endMinute: end % 60)
//        }
//        
//        // Priority 2b — Late zone
//        if let (start, end) = overlap(zoneStart: lateStart, zoneEnd: lateEnd) {
//            return BestTimeResult(quality: .late,
//                                startHour: (start % (24*60)) / 60, startMinute: start % 60,
//                                endHour: (end % (24*60)) / 60, endMinute: end % 60)
//        }
//        
//        // Priority 3 — No good time
//        return BestTimeResult(quality: .offTime,
//                            startHour: 0, startMinute: 0,
//                            endHour: 0, endMinute: 0)
//    }
    
    // MARK: - Best time to connect
    struct BestTimeResult {
        enum Quality {
            case ideal
            case early
            case late
            case none
        }
        
        let quality: Quality
        let startHour: Int
        let startMinute: Int
        let endHour: Int
        let endMinute: Int
        let confidence: Int   // 0–100
    }

    func bestTimeToConnect(localStartSeconds: Int, localEndSeconds: Int) -> BestTimeResult? {
        
        // Zones (in minutes)
        let perfectStart = 8 * 60
        let perfectEnd   = 22 * 60
        
        let earlyStart   = 6 * 60
        let earlyEnd     = 8 * 60
        
        let lateStart    = 22 * 60
        let lateEnd      = 26 * 60 // 02:00 next day
        
        let workStart = localStartSeconds / 60
        let workEnd   = localEndSeconds / 60
        
        struct ZoneResult {
            let quality: BestTimeResult.Quality
            let start: Int
            let end: Int
            let duration: Int
            let weight: Double
            
            var score: Double {
                return Double(duration) * weight
            }
        }
        
        // MARK: - Overlap helper
        func overlaps(zoneStart: Int, zoneEnd: Int) -> [(Int, Int)] {
            var results: [(Int, Int)] = []
            
            for offset in [-24*60, 0, 24*60] {
                let shiftedStart = workStart + offset
                let shiftedEnd   = workEnd + offset
                
                let start = max(shiftedStart, zoneStart)
                let end   = min(shiftedEnd, zoneEnd)
                
                if start < end {
                    results.append((start, end))
                }
            }
            
            return results
        }
        
        var candidates: [ZoneResult] = []
        
        // Ideal
        for (start, end) in overlaps(zoneStart: perfectStart, zoneEnd: perfectEnd) {
            candidates.append(ZoneResult(
                quality: .ideal,
                start: start,
                end: end,
                duration: end - start,
                weight: 1.0
            ))
        }
        
        // Early
        for (start, end) in overlaps(zoneStart: earlyStart, zoneEnd: earlyEnd) {
            candidates.append(ZoneResult(
                quality: .early,
                start: start,
                end: end,
                duration: end - start,
                weight: 0.7
            ))
        }
        
        // Late
        for (start, end) in overlaps(zoneStart: lateStart, zoneEnd: lateEnd) {
            candidates.append(ZoneResult(
                quality: .late,
                start: start,
                end: end,
                duration: end - start,
                weight: 0.5
            ))
        }
        
        // MARK: - No overlap
        guard let best = candidates.max(by: { $0.score < $1.score }) else {
            return BestTimeResult(
                quality: .none,
                startHour: 0,
                startMinute: 0,
                endHour: 0,
                endMinute: 0,
                confidence: 0
            )
        }
        
        // MARK: - Confidence calculation
        let maxWorkDuration = max(0, (workEnd - workStart + 24*60) % (24*60))
        let maxScore = Double(maxWorkDuration) * 1.0
        
        let confidence: Int
        if maxScore > 0 {
            confidence = Int((best.score / maxScore) * 100)
        } else {
            confidence = 0
        }
        
        let finalConfidence = min(max(confidence, 0), 100)
        
        // MARK: - Return result
        return BestTimeResult(
            quality: best.quality,
            startHour: (best.start % (24*60)) / 60,
            startMinute: best.start % 60,
            endHour: (best.end % (24*60)) / 60,
            endMinute: best.end % 60,
            confidence: finalConfidence
        )
    }
    
}

