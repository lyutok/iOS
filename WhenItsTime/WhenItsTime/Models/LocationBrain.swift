//
//  LocationBrain.swift
//  WhenItsTime
//
//  Created by Lyudmila Tokar on 2/25/26.
//

import Foundation
import CoreLocation
//import Solar

struct LocationBrain {
    
    let geocoder = CLGeocoder()
    
    func makeLocation(from location: CLLocation) -> AppLocation {
        return AppLocation(location: location)
    }
    
    func reverseGeocode(location: CLLocation, completion: @escaping (AppLocation) -> Void) {
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            var appLocation = AppLocation(location: location)
            
            if let error = error {
                print("Geocode error: \(error.localizedDescription)")
                completion(appLocation)
                return
            }
            
            if let placemark = placemarks?.first {
                appLocation.city = placemark.locality ?? "Unknown city"
                appLocation.country = placemark.country ?? "Unknown country"
                appLocation.region = placemark.administrativeArea ?? "Unknown region"
                appLocation.subRegion = placemark.subAdministrativeArea ?? ""
                appLocation.administrativeArea = placemark.administrativeArea ?? "Unknown region"
            }
            
            completion(appLocation)
        }
    }
    
    func shortCityName(city: String) -> String {
        // If very long (more than 2 words), shorten
        let words = city.split(separator: " ")
        if words.count > 2 {
            return words.prefix(2).joined(separator: " ")
        }
        return city
    }
    
//    // Day/Night icons
//    func timePhase(for location: CLLocation, date: Date = Date()) -> TimePhase {
//            
//            guard let solar = Solar(for: date, coordinate: location.coordinate),
//                  let sunrise = solar.sunrise,
//                  let sunset = solar.sunset else {
//                return .day // safe fallback
//            }
//            
//            let oneHour: TimeInterval = 60 * 60
//            
//            if date >= sunrise && date < sunrise.addingTimeInterval(oneHour) {
//                return .sunrise
//            } else if date >= sunrise.addingTimeInterval(oneHour) &&
//                        date < sunset.addingTimeInterval(-oneHour) {
//                return .day
//            } else if date >= sunset.addingTimeInterval(-oneHour) &&
//                        date < sunset {
//                return .sunset
//            } else {
//                return .night
//            }
//        }
//}
//
//
//enum TimePhase {
//    case sunrise
//    case day
//    case sunset
//    case night
//    
//    var sfSymbol: String {
//        switch self {
//        case .sunrise:
//            return "sunrise.fill"
//        case .day:
//            return "sun.max.fill"
//        case .sunset:
//            return "sunset.fill"
//        case .night:
//            return "moon.stars.fill"
//        }
//    }
}
