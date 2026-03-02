//
//  ViewController.swift
//  TimeMesh
//
//  Created by Lyudmila Tokar on 1/28/26.
//

import UIKit
import CoreLocation

class StartViewController: UIViewController {
    
    @IBOutlet var topCityLabel: UILabel!
    @IBOutlet var topCountryLabel: UILabel!
    @IBOutlet var topDateLabel: UILabel!
    
    @IBOutlet var currentCity: UILabel!
    @IBOutlet var currentTime: UILabel!
    @IBOutlet var currentDayImage: UIImageView!
    
    @IBOutlet var currentTimeView: UIView!
    @IBOutlet var currentTimeBlurView: UIVisualEffectView!
    @IBOutlet var textTimeBlurView: UIVisualEffectView!
    @IBOutlet var workingHoursView: UIView!
    
    let locationManager = CLLocationManager()
    
    // from files
    let timeBrain = TimeBrain()
    let locationBrain = LocationBrain()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Shadow on container
        currentTimeView.layer.cornerRadius = 20
        currentTimeView.layer.shadowColor = UIColor.black.cgColor
        currentTimeView.layer.shadowOpacity = 0.15
        currentTimeView.layer.shadowRadius = 10
        currentTimeView.layer.shadowOffset = CGSize(width: 0, height: 6)
        currentTimeView.layer.masksToBounds = false
        
        // Corner clipping on blur
        currentTimeBlurView.layer.cornerRadius = 20
        currentTimeBlurView.clipsToBounds = true
        currentTimeBlurView.layer.borderWidth = 1
        currentTimeBlurView.layer.borderColor = UIColor.white.withAlphaComponent(0.22).cgColor
        
        textTimeBlurView.layer.cornerRadius = 20
        textTimeBlurView.clipsToBounds = true
        textTimeBlurView.layer.borderWidth = 1
        textTimeBlurView.effect = UIBlurEffect(style: .systemThinMaterialLight)
        textTimeBlurView.layer.borderColor = UIColor.white.withAlphaComponent(0.6).cgColor
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
}
    

extension StartViewController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                manager.requestLocation()
            }
        case .denied, .restricted:
            print("Location access denied")
        case .notDetermined:
            break
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Got location data
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            print(location.timestamp)
            let appTime = timeBrain.makeTime(from: location.timestamp)

//            print("Date:", timeBrain.formattedWeekdayAndDate(from: appTime))
            self.topDateLabel.text = timeBrain.formattedWeekdayAndDate(from: appTime)
//            print("Time:", timeBrain.formattedTime(from: appTime))
            self.currentTime.text = timeBrain.formattedTime(from: appTime)
            
            let myLocation = location
            
//            let phase = locationBrain.timePhase(for: myLocation)
//            let iconName = phase.sfSymbol

//            currentDayImage.image = UIImage(systemName: iconName)

            locationBrain.reverseGeocode(location: myLocation) { appLocation in
                let city = appLocation.city ?? "N/A"
                self.topCityLabel.text = city
                self.currentCity.text = "\(self.locationBrain.shortCityName(city: city)) (Me)"
                self.topCountryLabel.text = "\(appLocation.country ?? "N/A"), \(appLocation.subRegion ?? "N/A")"
                print("Region: \(appLocation.country ?? "N/A")")
                print("Subregion: \(appLocation.subRegion ?? "N/A")")
                print("AdministrativeArea: \(appLocation.administrativeArea ?? "N/A")")
            }
        }
    }
    
    // Called when location retrieval fails.
    // Code 1 (kCLErrorDenied) may briefly appear on first launch
    // during permission transition — safe to ignore if authorization is granted.
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            
            if let clError = error as? CLError,
               clError.code == .denied,
               manager.authorizationStatus == .authorizedWhenInUse {
                return // harmless first-launch race condition
            }
            
            print("Location error: \(error.localizedDescription)")
        }
}
