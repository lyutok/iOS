//
//  CityStorage.swift
//  WhenItsTime
//
//  Created by Lyudmila Tokar on 3/28/26.
//

import Foundation

struct CityStorage {
    
    private static let localCityKey = "selectedLocalCity"
    private static let workCityKey = "selectedWorkCity"
    
    // MARK: - Save
    static func saveLocalCity(_ city: CityItem?) {
        save(city, forKey: localCityKey)
    }
    
    static func saveWorkCity(_ city: CityItem?) {
        save(city, forKey: workCityKey)
    }
    
    // MARK: - Load
    static func loadLocalCity() -> CityItem? {
        load(forKey: localCityKey)
    }
    
    static func loadWorkCity() -> CityItem? {
        load(forKey: workCityKey)
    }
    
    // MARK: - Private helpers
    private static func save(_ city: CityItem?, forKey key: String) {
        guard let city = city else {
            UserDefaults.standard.removeObject(forKey: key)
            return
        }
        let encoded = try? JSONEncoder().encode(city)
        UserDefaults.standard.set(encoded, forKey: key)
    }
    
    private static func load(forKey key: String) -> CityItem? {
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(CityItem.self, from: data)
    }
}
