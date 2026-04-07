//
//  WorkingHoursStorage.swift
//  WhenItsTime
//
//  Created by Lyudmila Tokar.
//

import Foundation

struct WorkingHoursStorage {
    
    private static let key = "selectedWorkingHours"
    
    // MARK: - Save
    static func save(_ hours: WorkingHours?) {
        guard let hours = hours else {
            UserDefaults.standard.removeObject(forKey: key)
            return
        }
        let encoded = try? JSONEncoder().encode(hours)
        UserDefaults.standard.set(encoded, forKey: key)
    }
    
    // MARK: - Load
    static func load() -> WorkingHours? {
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(WorkingHours.self, from: data)
    }
}
