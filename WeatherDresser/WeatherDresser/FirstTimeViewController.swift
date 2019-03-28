//
//  FirstTimeViewController.swift
//  WeatherDresser
//
//  Created by Sarah Koop on 3/13/19.
//  Copyright © 2019 Sarah Koop. All rights reserved.
//

import UIKit
import CoreLocation

class FirstTimeViewController: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate {
    
    // MARK: - Variables
    
    @IBOutlet weak var firstGetWeatherButton: UIButton!
    
    let firstSearch = UISearchBar()
    let defaults = UserDefaults.standard
    let locationManager = CLLocationManager()
    var userLocationCoords: String?
    let weatherResult = WeatherService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // https://stackoverflow.com/questions/1878595/how-to-make-a-circular-uiview/16584298
        firstGetWeatherButton.layer.cornerRadius =  10.0
        firstGetWeatherButton.layer.masksToBounds = true
        
        firstSearch.placeholder = "City or Zip Code"
        firstSearch.delegate = self
        firstSearch.backgroundColor = UIColor(named: "brightBlue")
        
        navigationItem.titleView = firstSearch
        navigationItem.setHidesBackButton(true, animated: true)
    }
    
    // MARK: - Actions

    @IBAction func showWeather(_ sender: Any) {
        // https://stackoverflow.com/questions/25296691/get-users-current-location-coordinates
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.authorizationStatus() != .denied {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        } else {
            // https://developer.apple.com/documentation/uikit/uialertcontroller
            let alert = UIAlertController(title: "Location Needed",
                                          message: "Enable location services for current location weather or use search bar to search by city",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default Action"),
                                          style: .default,
                                          handler: { _ in if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                                            UIApplication.shared.open(settingsURL)
                                            }
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Search & Location Functions
    
    // https://stackoverflow.com/questions/7447248/reset-text-in-textfield-of-uisearchbar-when-x-button-is-clicked-but-not-resign
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let location = "q=" + firstSearch.text!
        firstSearch.resignFirstResponder()
        defaults.set(location, forKey: "Location")
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0,
                                                                  y: 0,
                                                                  width: self.view.bounds.width,
                                                                  height: self.view.bounds.height))
        activityIndicator.color = UIColor(named: "brightBlue")
        activityIndicator.hidesWhenStopped = true
        self.view.addSubview(activityIndicator)
        weatherResult.search(for: location, completion: { weather, error in
            // https://developer.apple.com/documentation/uikit/uialertcontroller
            guard let _ = weather, error == nil else {
                print(error ?? "unknown error")
                // https://stackoverflow.com/questions/38340493/emoji-in-ios-app-alerts-and-notifications-xcode-swift
                let errorAlert = UIAlertController(title: "Search Error",
                                                   message: "Something went wrong \u{1F615} try again later",
                                                   preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"),
                                                   style: .default,
                                                   handler: { _ in NSLog("The \"OK\" alert occured.") }
                ))
                self.present(errorAlert, animated: true, completion: nil)
                activityIndicator.stopAnimating()
                return
            }
            activityIndicator.stopAnimating()
            self.performSegue(withIdentifier: "showWeatherView", sender: self)
        })
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // https://stackoverflow.com/questions/25296691/get-users-current-location-coordinates
        guard let locationCoords: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        guard self.userLocationCoords == nil else { return }
        self.userLocationCoords = "lat=" + String(locationCoords.latitude) + "&lon=" + String(locationCoords.longitude)
        defaults.set(self.userLocationCoords, forKey: "Location")
        defaults.set(true, forKey: "notFirstTime")
        performSegue(withIdentifier: "showWeatherView", sender: self)
    }
    
    // MARK: - Navigation

    // https://stackoverflow.com/questions/26207846/pass-data-through-segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showWeatherView" {
            defaults.set(true, forKey: "notFirstTime")
            let vc = segue.destination as! ViewController
            vc.isFirstTimeOpeningApp = false
        }
    }
}
