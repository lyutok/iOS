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
    @IBOutlet var currentDate: UILabel!
    
    @IBOutlet var workTimeLabel: UILabel!
    @IBOutlet var workCityLabel: UILabel!    
    @IBOutlet var workDayImage: UIImageView!
    
    @IBOutlet var currentTimeView: UIView!
    @IBOutlet var currentTimeBlurView: UIVisualEffectView!
    @IBOutlet var textTimeBlurView: UIVisualEffectView!
    @IBOutlet var workingHoursView: UIView!
    
    @IBOutlet var dayLabel: UILabel!
    
    @IBOutlet var workingHoursWork: UILabel!
    @IBOutlet var workingHoursCurrentLocation: UILabel!
    
    let locationManager = CLLocationManager()
    var editCityFlag = 0 // from which place Edit was clicked
    
    // Refresh on swipe down
    private let refreshControl = UIRefreshControl()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    // from files
    let timeBrain = TimeBrain()
    let locationBrain = LocationBrain()
    
    var lastLocation: CLLocation?
    var selectedWorkCity: CityItem?
    var selectedLocalCity: CityItem?
    
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
        
        // Load saved cities
        selectedLocalCity = CityStorage.loadLocalCity()
        selectedWorkCity = CityStorage.loadWorkCity()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        setupActivityIndicator()
        setupPullToRefresh()
        updateUI()
    }

    private func setupActivityIndicator() {
        activityIndicator.center = CGPoint(x: view.center.x, y: 100)
        activityIndicator.color = .white
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }

    private func setupPullToRefresh() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        panGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(panGesture)
    }
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        print("Pan detected: \(translation.y)")
        print("State: \(gesture.state.rawValue)")
        if gesture.state == .ended {
            print("Ended with translation: \(translation.y)")
        }
        
        if gesture.state == .ended && translation.y > 80 {
            print("Refreshing!")
            activityIndicator.startAnimating()
            updateUI()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    func updateUI() {
        guard let location = lastLocation else {
            locationManager.requestLocation()
            return
        }
        
        let now = Date()
        
        // MARK: - Local timezone (manual selection or device)
        let localTimeZone: TimeZone = {
            if let localCity = selectedLocalCity {
                return TimeZone(identifier: localCity.identifier) ?? .current
            }
            return .current
        }()
        
        // MARK: - Local time
        let gpsFreshness = now.timeIntervalSince(location.timestamp)
        let sourceDate = gpsFreshness < 30 ? location.timestamp : now
        let localOffset = localTimeZone.secondsFromGMT(for: now)
        let deviceOffset = TimeZone.current.secondsFromGMT(for: now)
        let adjustedDate = sourceDate.addingTimeInterval(TimeInterval(localOffset - deviceOffset))
        
        // Top date always uses GPS
        topDateLabel.text = timeBrain.formattedWeekdayAndDate(from: timeBrain.makeTime(from: sourceDate))
        currentTime.text = timeBrain.formattedTime(from: timeBrain.makeTime(from: adjustedDate))
        // Current date
        if selectedLocalCity != nil {
            currentDate.text = timeBrain.formattedWeekdayAndDate(from: timeBrain.makeTime(from: adjustedDate))
            currentDate.isHidden = false
        } else {
            currentDate.isHidden = true
        }
        
        // MARK: - Day/night icon for local city
        if selectedLocalCity != nil {
            // Manual city — use hour-based estimation
            var localCalendar = Calendar.current
            localCalendar.timeZone = localTimeZone
            let localHour = localCalendar.component(.hour, from: now)
            let phase = locationBrain.timePhase(for: localHour)
            currentDayImage.image = UIImage(systemName: phase.sfSymbol)
            currentDayImage.tintColor = phase.tintColor
        } else {
            // GPS location — use accurate Solar calculation
            let phase = locationBrain.timePhase(for: location)
            currentDayImage.image = UIImage(systemName: phase.sfSymbol)
            currentDayImage.tintColor = phase.tintColor
        }
        
        // MARK: - City name
        // Top labels - GPS
        locationBrain.reverseGeocode(location: location) { appLocation in
            let city = appLocation.city ?? "N/A"
            self.topCityLabel.text = city
            self.topCountryLabel.text = "\(appLocation.country ?? "N/A"), \(appLocation.subRegion ?? "N/A")"
        }
        
        // Card labels - manual selection or GPS
        if let localCity = selectedLocalCity {
            currentCity.text = "\(localCity.city) (Me)"
            self.workingHoursCurrentLocation.text = "\(localCity.city) time" // working hour section
        } else {
            locationBrain.reverseGeocode(location: location) { appLocation in
                let city = appLocation.city ?? "N/A"
                self.currentCity.text = "\(self.locationBrain.shortCityName(city: city)) (Me)"
                self.self.workingHoursCurrentLocation.text = "\(city) time" // working hour section
            }
        }
        
        
        // MARK: - Work city
        if let workCity = selectedWorkCity {
            let workTimeZone = TimeZone(identifier: workCity.identifier) ?? .current
            
            let localOffset = localTimeZone.secondsFromGMT(for: now)
            let workOffset = workTimeZone.secondsFromGMT(for: now)
            let differenceSeconds = workOffset - localOffset
            let differenceHours = differenceSeconds / 3600
            
            let sign = differenceHours >= 0 ? "+" : ""
            workCityLabel.text = "\(workCity.city) (\(sign)\(differenceHours)h)"
            
            workingHoursWork.text = "\(workCity.city) working hours" // working hour section
            
            let workAppTime = timeBrain.makeTime(from: now, in: workTimeZone)
            workTimeLabel.text = timeBrain.formattedTime(from: workAppTime)
            
            // Label day name
            let label = timeBrain.dayLabel(localTimeZone: localTimeZone, workTimeZone: workTimeZone)
            dayLabel.text = label  // hide if nil
            dayLabel.isHidden = label == nil
            
            // Work city icon
            var workCalendar = Calendar.current
            workCalendar.timeZone = workTimeZone
            let workHour = workCalendar.component(.hour, from: now)
            let workPhase = locationBrain.timePhase(for: workHour)
            workDayImage.image = UIImage(systemName: workPhase.sfSymbol)
            workDayImage.tintColor = workPhase.tintColor
        }
    }
    
    @IBAction func editButtonPressed(_ sender: UIButton) {
        if sender.tag == 0 {
                print("Edit local city")
            } else {
                print("Edit work city")
            }
        editCityFlag = sender.tag
        presentCitySearch()
    }
    
    private func presentCitySearch() {
        let citySearch = CitySearchViewController()
        citySearch.delegate = self
        let nav = UINavigationController(rootViewController: citySearch)
        present(nav, animated: true)
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
            lastLocation = location
            updateUI()
        }
    }
    
    // Called when location retrieval fails.
    // Code 1 (kCLErrorDenied) may briefly appear on first launch
    // during permission transition — safe to ignore if authorization is granted.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let clError = error as? CLError {
            switch clError.code {
            case .denied:
                if manager.authorizationStatus == .authorizedWhenInUse { return }
                print("Location access denied")
            case .locationUnknown:
                // harmless, iOS will retry automatically
                return
            default:
                print("Location error: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - Receive the city and time
extension StartViewController: CitySearchDelegate {
    
    func didSelectCity(_ city: CityItem) {
        print("Received: \(city.city)")
        print("Received Identifier: \(city.identifier)")
          
        if editCityFlag == 0 {
            selectedLocalCity = city
            CityStorage.saveLocalCity(city)
        } else {
            selectedWorkCity = city
            CityStorage.saveWorkCity(city)
        }
        updateUI()
    }
}
