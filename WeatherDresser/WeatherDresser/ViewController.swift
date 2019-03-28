//
//  ViewController.swift
//  WeatherDresser
//
//  Created by Sarah Koop on 3/3/19.
//  Copyright © 2019 Sarah Koop. All rights reserved.
//

import UIKit
import CoreLocation
import StoreKit

class ViewController: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate {
    
    // MARK: - Variables
    
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var temperatureImage: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var whatToWearButton: UIButton!
    @IBOutlet weak var weatherBackgroundView: UIView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet weak var getWeatherButton: UIButton!
    
    let weatherResult = WeatherService()
    var weather: WeatherResult?
    let weatherDetailSetup = WeatherView()
    let clothingView = ClothingView()
    var clothingNeeded: [String] = []
    let locationManager = CLLocationManager()
    var userLocationCoords: String?
    let defaults = UserDefaults.standard
    var isFirstTimeOpeningApp = true
    var openTimesCount = 0
    var splashScreen: SplashScreenView?
    var activityIndicator: UIActivityIndicatorView?
    var activityView: UIView?
    var askedForReview: Bool?
    
    // MARK: - View Loading
    
    override func viewDidLayoutSubviews() {
        // https://stackoverflow.com/questions/44662936/view-changes-size-depending-on-device-screen-size-but-should-have-a-fixed-size
        // https://stackoverflow.com/questions/1878595/how-to-make-a-circular-uiview/16584298
        weatherBackgroundView.layer.cornerRadius =  weatherBackgroundView.frame.size.width/2
        weatherBackgroundView.layer.masksToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if defaults.bool(forKey: "appLaunch") {
            splashScreen = SplashScreenView(frame: CGRect(x: 0, y: 0, width: self.navigationController!.view.bounds.width, height: self.navigationController!.view.bounds.height))
            self.navigationController!.view.addSubview(splashScreen!)
            defaults.set(false, forKey: "appLaunch")
        }
        
        // https://medium.com/@abhimuralidharan/asking-customers-for-ratings-and-reviews-from-inside-the-app-in-ios-d85f256dd4ef
        openTimesCount = defaults.integer(forKey: "openTimes")
        if openTimesCount  == 3 && askedForReview == nil {
            SKStoreReviewController.requestReview()
            askedForReview = true
        }
        
        // https://stackoverflow.com/questions/8221787/perform-segue-on-viewdidload
        // https://stackoverflow.com/questions/35234204/change-a-xcode-view-after-a-certain-time
        guard isFirstTimeOpeningApp else { return }
        if defaults.bool(forKey: "notFirstTime") {
            isFirstTimeOpeningApp = false
        } else {
            self.view.isHidden = true
            self.navigationItem.hidesBackButton = true
            _ = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(ViewController.removeSplashScreen), userInfo: nil, repeats: false)
            performSegue(withIdentifier: "showFirstTimeView", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard defaults.bool(forKey: "notFirstTime") else { return }
        
        searchBar.placeholder = "City or Zip Code"
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        navigationItem.setHidesBackButton(true, animated: true)

        getWeatherButton.layer.cornerRadius =  10.0
        getWeatherButton.layer.masksToBounds = true
        whatToWearButton.layer.cornerRadius =  10.0
        whatToWearButton.layer.masksToBounds = true
        
        // https://www.hackingwithswift.com/example-code/system/how-to-save-user-settings-using-userdefaults
        guard (self.userLocationCoords != nil) else {
            guard let savedLocation = defaults.object(forKey: "Location") as? String else {
                getWeatherData(for: "q=Chicago")
                splashScreen?.removeFromSuperview()
                return
            }
            getWeatherData(for: savedLocation)
            splashScreen?.removeFromSuperview()
            return
        }
        splashScreen?.removeFromSuperview()
    }
    
    @objc func removeSplashScreen() -> Void {
        splashScreen?.removeFromSuperview()
    }

    // MARK: - Actions
    
    @IBAction func callAPI(_ sender: Any) {
        // https://stackoverflow.com/questions/25296691/get-users-current-location-coordinates
        locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.authorizationStatus() != .denied {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.startUpdatingLocation()
        } else {
            // https://developer.apple.com/documentation/uikit/uialertcontroller
            let alert = UIAlertController(title: "Location Needed",
                                          message: "Enable location services for current location weather or use search bar to search by city",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default Action"),
                                          style: .default,
                                          handler: { _ in
                                            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                                                UIApplication.shared.open(settingsURL)
                                                }
            }))
            present(alert, animated: true, completion: nil)
        }
        guard userLocationCoords != nil else { return }
        getWeatherData(for: userLocationCoords!)
    }
    
    // MARK: - Search & Location Functions

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // https://stackoverflow.com/questions/25296691/get-users-current-location-coordinates
        guard let locationCoords: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        guard self.userLocationCoords == nil else { return }
        self.userLocationCoords = "lat=" + String(locationCoords.latitude) + "&lon=" + String(locationCoords.longitude)
        getWeatherData(for: self.userLocationCoords!)
    }
    
    // https://stackoverflow.com/questions/7447248/reset-text-in-textfield-of-uisearchbar-when-x-button-is-clicked-but-not-resign
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let location = searchBar.text!
        searchBar.resignFirstResponder()
        getWeatherData(for: "q="+location)
        searchBar.text = nil
    }
    
    func getWeatherData(for location: String) -> Void {
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0,
                                                                  y: 0,
                                                                  width: self.navigationController!.view.bounds.width,
                                                                  height: self.navigationController!.view.bounds.height))
        activityIndicator!.color = UIColor(named: "brightBlue")
        activityIndicator!.hidesWhenStopped = true
        
        activityView = UIView(frame: CGRect(x: 0,
                                            y: 0,
                                            width: self.navigationController!.view.bounds.width,
                                            height: self.navigationController!.view.bounds.height))
        activityView?.backgroundColor = UIColor(named: "lightBlue")
        activityView?.alpha = 1
        activityView!.addSubview(activityIndicator!)
        self.navigationController!.view.addSubview(activityView!)

        activityIndicator!.startAnimating()
        
        defaults.set(location, forKey: "Location")
        
        weatherResult.search(for: location, completion: { weather, error in
            // https://developer.apple.com/documentation/uikit/uialertcontroller
            guard let weather = weather, error == nil else {
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
                self.splashScreen?.isHidden = true
                self.activityView?.isHidden = true
                self.activityIndicator!.stopAnimating()
                return
            }
            self.weather = weather

            let tempFahrenheit = self.convertTemp(temp: Float(weather.main["temp"]!))
            self.temperatureImage.image = UIImage(named: self.weatherDetailSetup.getTemperatureImage(for: tempFahrenheit))
            self.temperatureLabel.text = String(tempFahrenheit) + "°"
            
            self.weatherDescriptionLabel.text = weather.weather[0].description
            let weatherDesc = self.weatherDetailSetup.getMainWeatherImage(for: weather.weather[0].main, and: weather.weather[0].description)
            self.weatherImage.image = UIImage(named: weatherDesc)
            if weatherDesc == "partialClouds" || weatherDesc == "sun" {
                self.weatherBackgroundView.backgroundColor = UIColor(named: "royalBlue")
            } else {
                self.weatherBackgroundView.backgroundColor = UIColor(named: "gold")
            }
            
            self.clothingNeeded = self.clothingView.getAppropriateClothing(for: weather.weather[0].main, and: tempFahrenheit)
            self.splashScreen?.isHidden = true
            self.activityView?.isHidden = true
            self.activityIndicator!.stopAnimating()
        })
    }
    
    func convertTemp(temp: Float) -> Int {
        return Int(round((temp - 273.15) * 1.8 + 32))
    }
    
    // MARK: - Navigation & Preparation Functions
    
    // https://stackoverflow.com/questions/26207846/pass-data-through-segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showClothingTableView" {
            let vc = segue.destination as! ClothingTableViewController
            vc.clothing = self.clothingNeeded
            vc.location = defaults.object(forKey: "Location") as? String
            vc.isANewDay = isNewDay()
        }
    }
    
    // https://stackoverflow.com/questions/24070450/how-to-get-the-current-time-as-datetime
    func isNewDay() -> Bool {
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .short
        let today = formatter.string(from: currentDate)
        let previousDate = defaults.object(forKey: "date") as? String ?? ""
        defaults.set(today, forKey: "date")
        return today != previousDate
    }
}


