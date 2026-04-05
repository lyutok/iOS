//
//  WorkingHours.swift
//  WhenItsTime
//
//  Created by Lyudmila Tokar on 3/31/26.
//

import Foundation

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
    
//    var localDisplayString: String {
//        let startEmoji = timeEmoji(for: startHour)
//        let endEmoji = timeEmoji(for: endHour)
//        return "\(startEmoji) \(String(format: "%02d:%02d", startHour, startMinute)) - \(endEmoji) \(String(format: "%02d:%02d", endHour, endMinute))"
//    }
    
    func localDisplayString(dayLabel: String?) -> String {
        let startEmoji = timeEmoji(for: startHour)
        let endEmoji = timeEmoji(for: endHour)
        let time = "\(startEmoji) \(String(format: "%02d:%02d", startHour, startMinute)) - \(endEmoji) \(String(format: "%02d:%02d", endHour, endMinute))"
        
        if let label = dayLabel {
            return "\(time) \(label)"
        }
        return time
    }
    
    private func timeEmoji(for hour: Int) -> String {
        switch hour {
        case 0..<6:   return "😴"
        case 6..<9:   return "🌅"
        case 9..<19:  return "☀️"
        case 19..<22: return "🌆"
        default:      return "😴"  // 22-23
        }
    }
    
    static func whdayLabel(localStartSeconds: Int, localEndSeconds: Int) -> String? {
        if localEndSeconds > 86400 {
            return "(+1 day)"
        } else if localStartSeconds < 0 {
            return "(-1 day)"
        } else {
            return nil // same day — no label needed
        }
    }
    
}
