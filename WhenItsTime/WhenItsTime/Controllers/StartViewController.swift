//
//  ViewController.swift
//  TimeMesh
//
//  Created by Lyudmila Tokar on 1/28/26.
//

import UIKit
import CoreLocation

class StartViewController: UIViewController {
    
    // top location, time section
    @IBOutlet var topCityLabel: UILabel!
    @IBOutlet var topCountryLabel: UILabel!
    @IBOutlet var topDateLabel: UILabel!
    
    // current location / working hours section
    @IBOutlet var currentCity: UILabel!
    @IBOutlet var currentTime: UILabel!
    @IBOutlet var currentDayImage: UIImageView!
    @IBOutlet var currentDate: UILabel!
    
    @IBOutlet var workTimeLabel: UILabel!
    @IBOutlet var timeDifferenceLabel: UILabel!
    @IBOutlet var workCityLabel: UILabel!
    @IBOutlet var workDayImage: UIImageView!
    
    @IBOutlet var currentTimeView: UIView!
    @IBOutlet var currentTimeBlurView: UIVisualEffectView!
    @IBOutlet var textTimeBlurView: UIVisualEffectView!
    @IBOutlet var dayLabel: UILabel! // label for city time
    
    // Prompt section
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var countdownLabel: UILabel!
    
    @IBOutlet var bestTimeLabel: UILabel!
    @IBOutlet var yourTimeLabel: UILabel!
    @IBOutlet var theirTimeLabel: UILabel!
    @IBOutlet var confidanceLable: UILabel!
    
    // Working Hours section
    @IBOutlet var workingHoursView: UIView!
    @IBOutlet var workingHoursWork: UILabel!
    @IBOutlet var workingHours: UILabel!
    @IBOutlet var workingHoursCurrentLocation: UILabel!
    @IBOutlet var startWorkingHoursInLocalTime: UILabel!
    
    var selectedWorkingHours: WorkingHours = WorkingHours.presets[0]
    
    @IBOutlet var startWHimg: UIImageView!
    @IBOutlet var endWHimg: UIImageView!
    
    @IBOutlet var endWorkingHoursInLocalTime: UILabel!
    
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
        
        // Adjust long city names to fit within their borders
        let labelsToShrink = [
            currentCity, workCityLabel, topCityLabel, topCountryLabel,
            workingHoursWork, workingHoursCurrentLocation
        ]
        
        for label in labelsToShrink {
            label?.adjustsFontSizeToFitWidth = true
            label?.minimumScaleFactor = 0.5
            label?.lineBreakMode = .byTruncatingTail
        }
        
        // Load saved cities
        selectedLocalCity = CityStorage.loadLocalCity()
        selectedWorkCity = CityStorage.loadWorkCity()
        
        // Load saved working hours
        if let savedWH = WorkingHoursStorage.load() {
            selectedWorkingHours = savedWH
        }
        
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
        let now = Date()
        
        // If we don't have a location yet, request one (but don't bail out)
        if lastLocation == nil {
            locationManager.requestLocation()
        }
        
        // MARK: - Local timezone (manual selection or device)
        let localTimeZone: TimeZone = {
            if let localCity = selectedLocalCity {
                return TimeZone(identifier: localCity.identifier) ?? .current
            }
            return .current
        }()
        
        // MARK: - Local time
        let sourceDate: Date
        if let location = lastLocation {
            let gpsFreshness = now.timeIntervalSince(location.timestamp)
            sourceDate = gpsFreshness < 30 ? location.timestamp : now
        } else {
            sourceDate = now
        }
        let localOffset = localTimeZone.secondsFromGMT(for: now)
        let deviceOffset = TimeZone.current.secondsFromGMT(for: now)
        let adjustedDate = sourceDate.addingTimeInterval(TimeInterval(localOffset - deviceOffset))
        
        // Top date
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
        } else if let location = lastLocation {
            // GPS location — use accurate Solar calculation
            let phase = locationBrain.timePhase(for: location)
            currentDayImage.image = UIImage(systemName: phase.sfSymbol)
            currentDayImage.tintColor = phase.tintColor
        } else {
            // No GPS yet — fall back to hour-based estimation using device timezone
            let localHour = Calendar.current.component(.hour, from: now)
            let phase = locationBrain.timePhase(for: localHour)
            currentDayImage.image = UIImage(systemName: phase.sfSymbol)
            currentDayImage.tintColor = phase.tintColor
        }
        
        // MARK: - City name
        if let location = lastLocation {
            // Single reverse geocode for both top labels and card labels
            locationBrain.reverseGeocode(location: location) { appLocation in
                let city = appLocation.city ?? "N/A"
                
                // Top labels - always from GPS
                self.topCityLabel.text = city
                self.topCountryLabel.text = "\(appLocation.country ?? "N/A"), \(appLocation.subRegion ?? "N/A")"
                
                // Card labels - manual selection or GPS
                if let localCity = self.selectedLocalCity {
                    self.currentCity.text = "\(localCity.city)"
                    self.workingHoursCurrentLocation.text = self.selectedWorkCity != nil ? "\(localCity.city)" : ""
                } else {
                    self.currentCity.text = "\(self.locationBrain.shortCityName(city: city))"
                    self.workingHoursCurrentLocation.text = self.selectedWorkCity != nil ? "\(city)" : ""
                }
            }
        } else {
            // No GPS yet — show what we can
            if let localCity = selectedLocalCity {
                currentCity.text = "\(localCity.city)"
                topCityLabel.text = localCity.city
                self.workingHoursCurrentLocation.text = self.selectedWorkCity != nil ? "\(localCity.city)" : ""
            } else {
                // Use city name from timezone identifier as a fallback (e.g. "Atlantic/Canary" → "Canary")
                let tzCity = localTimeZone.identifier
                    .split(separator: "/").last
                    .map { $0.replacingOccurrences(of: "_", with: " ") } ?? "Current Location"
                currentCity.text = "\(tzCity)"
                topCityLabel.text = tzCity
                self.workingHoursCurrentLocation.text = self.selectedWorkCity != nil ? "\(tzCity)" : ""
            }
        }
        
        // MARK: - Work city
        var differenceSeconds: Int = 0
        var differenceHours: Int = 0
        
        if let workCity = selectedWorkCity {
            let workTimeZone = TimeZone(identifier: workCity.identifier) ?? .current
            
            let localOffset = localTimeZone.secondsFromGMT(for: now)
            let workOffset = workTimeZone.secondsFromGMT(for: now)
            differenceSeconds = workOffset - localOffset
            differenceHours = differenceSeconds / 3600
            let differenceMinutes = (abs(differenceSeconds) % 3600) / 60
            
            let sign = differenceSeconds >= 0 ? "+" : "-"
            let offsetLabel: String
            if differenceMinutes == 30 {
                offsetLabel = "\(sign)\(abs(differenceHours)).5h"
            } else if differenceMinutes != 0 {
                offsetLabel = String(format: "%@%d:%02dh", sign, abs(differenceHours), differenceMinutes)
            } else {
                offsetLabel = "\(sign)\(abs(differenceHours))h"
            }
            workCityLabel.text = "\(workCity.city)"
            timeDifferenceLabel.text = offsetLabel
            
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
            
            // MARK: - Working hours status
            let workMinute = workCalendar.component(.minute, from: now)
            
            if selectedWorkingHours.isWeekend(in: workTimeZone) {
                // Get current day name in work city timezone
                let dayFormatter = DateFormatter()
                dayFormatter.dateFormat = "EEEE"  // "Saturday"
                dayFormatter.timeZone = workTimeZone
                let dayName = dayFormatter.string(from: now)
                
                statusLabel.text = "It is \(dayName) in \(workCity.city)"
                countdownLabel.text = selectedWorkingHours.timeUntilWeekend(in: workTimeZone)
            } else {
                let isWorking = selectedWorkingHours.isCurrentlyWorking(currentHour: workHour, currentMinute: workMinute)
                statusLabel.text = isWorking ? "☑ \(workCity.city) is in working hours" : "\(workCity.city) is out of working hours"
                countdownLabel.text = selectedWorkingHours.timeUntilChange(currentHour: workHour, currentMinute: workMinute)
            }
        }
            
        // MARK: - Working Hours
        workingHours.text = selectedWorkingHours.displayString
        
        var localStartSeconds: Int = 0
        var localEndSeconds: Int = 0
        var currentWorkTimeZone: TimeZone = .current
        
        // Working hours in local time
        if let workCity = selectedWorkCity {
            currentWorkTimeZone = TimeZone(identifier: workCity.identifier) ?? .current
            let hours = selectedWorkingHours
            localStartSeconds = hours.startHour * 3600 + hours.startMinute * 60 - differenceSeconds
            localEndSeconds = hours.endHour * 3600 + hours.endMinute * 60 - differenceSeconds
            
            // Normalize to 0..<86400 to handle negative values correctly
            // (Swift's % preserves sign, so -1800 % 3600 = -1800, not 1800)
            let normStart = ((localStartSeconds % 86400) + 86400) % 86400
            let normEnd   = ((localEndSeconds   % 86400) + 86400) % 86400
            
            let localStartHour = normStart / 3600
            let localStartMin  = (normStart % 3600) / 60
            let localEndHour   = normEnd / 3600
            let localEndMin    = (normEnd % 3600) / 60
            
            
            let localWorkingHours = WorkingHours(
                                            startHour: localStartHour,
                                            startMinute: localStartMin,
                                            endHour: localEndHour,
                                            endMinute: localEndMin
                                            )
            
            let whDayLabel = WorkingHours.whdayLabel(
                localStartSeconds: localStartSeconds,
                localEndSeconds: localEndSeconds
            )
            
            let startWH = localWorkingHours.timeSFSymbolAndColor(for: localStartHour)
            startWHimg.image = UIImage(systemName: startWH.name)
            startWHimg.tintColor = startWH.color
            startWorkingHoursInLocalTime.text = String(format: "%02d:%02d -", localStartHour, localStartMin)
            
            let endWH = localWorkingHours.timeSFSymbolAndColor(for: localEndHour)
            endWHimg.image = UIImage(systemName: endWH.name)
            endWHimg.tintColor = endWH.color
            endWorkingHoursInLocalTime.text = String(format: "%02d:%02d \(whDayLabel ?? "")", localEndHour, localEndMin)
        } else {
            workingHoursCurrentLocation.text = ""
            startWorkingHoursInLocalTime.text = ""
            endWorkingHoursInLocalTime.text = ""
            startWHimg.image = nil
            endWHimg.image = nil
        }
        
        // MARK: - Best time to connect
        func confidenceLabel(_ value: Int) -> String {
            switch value {
            case 75...100: return "Strong overlap"
            case 40..<75:  return "Good overlap"
            case 15..<40:  return "Limited overlap"
            case 1..<15:   return "Very limited"
            default:       return "No overlap"
            }
        }
        
        let bestTime = selectedWorkingHours.bestTimeToConnect(
            localStartSeconds: localStartSeconds,
            localEndSeconds: localEndSeconds
        )
        
        if let best = bestTime {
            let mondayPrefix = selectedWorkingHours.isWeekend(in: currentWorkTimeZone) ? "Mon, " : ""
            
            let timeRange = String(format: "%02d:%02d", best.startHour, best.startMinute) + " - " +
                            String(format: "%02d:%02d", best.endHour, best.endMinute)
            
//            let timePoint = String(format: "%02d:%02d", best.startHour, best.startMinute)
            
            let confidenceText = confidenceLabel(best.confidence)

            // 1. Handle "none"
            if best.quality == .none {
                bestTimeLabel.text = "Outside typical working hours."
                yourTimeLabel.text = "No overlap window"
                
                theirTimeLabel.isHidden = true
                theirTimeLabel.text = nil
                
                confidanceLable.isHidden = true
                confidanceLable.text = nil
                
                return
            }

            // 2. Shared UI (only for valid cases)
            theirTimeLabel.isHidden = false
            confidanceLable.isHidden = false

            let theirStartTotalSeconds = best.startHour * 3600 + best.startMinute * 60 + differenceSeconds
            let theirEndTotalSeconds = best.endHour * 3600 + best.endMinute * 60 + differenceSeconds
            
            let theirDayLabel = WorkingHours.whdayLabel(localStartSeconds: theirStartTotalSeconds, localEndSeconds: theirEndTotalSeconds) ?? ""
            
            let normTheirStart = ((theirStartTotalSeconds % 86400) + 86400) % 86400
            let normTheirEnd = ((theirEndTotalSeconds % 86400) + 86400) % 86400
            
            let theirTimeRange = String(format: "%02d:%02d - %02d:%02d", 
                                        normTheirStart / 3600, (normTheirStart % 3600) / 60,
                                        normTheirEnd / 3600, (normTheirEnd % 3600) / 60)

            yourTimeLabel.text = "· Your time: \(mondayPrefix)\(timeRange)"
            theirTimeLabel.text = "· Their time: \(mondayPrefix)\(theirTimeRange) \(theirDayLabel)"
            confidanceLable.text = confidenceText

            // 3.  Switch titles
            switch best.quality {
            case .ideal:
                bestTimeLabel.text = "Good time to connect:"
                
            case .early:
                bestTimeLabel.text = "Slightly early, but workable:"
                
            case .late:
                bestTimeLabel.text = "Late, but still reasonable:"
                
            case .none:
                break // already handled
            }
        }
}
    
    
    @IBAction func editWorkingHoursPressed(_ sender: UIButton) {
        presentWorkingHours()
    }
    
    private func presentWorkingHours() {
        let workingHoursVC = WorkingHoursViewController()
        workingHoursVC.initialWorkingHours = selectedWorkingHours
        workingHoursVC.delegate = self
        let nav = UINavigationController(rootViewController: workingHoursVC)
        present(nav, animated: true)
    }
    
    @IBAction func editButtonPressed(_ sender: UIButton) {
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

// MARK: - Receive Working hours
extension StartViewController: WorkingHoursDelegate {
    func didSaveWorkingHours(_ hours: WorkingHours) {
        selectedWorkingHours = hours
        WorkingHoursStorage.save(hours)
        
        updateUI()
    }
}
