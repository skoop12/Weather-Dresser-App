//
//  AppDelegate.swift
//  WeatherDresser
//
//  Created by Sarah Koop on 3/3/19.
//  Copyright © 2019 Sarah Koop. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Variables

    var window: UIWindow?
    let defaults = UserDefaults.standard
    var openTimesIncrementer = 0

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if defaults.object(forKey: "openTimes") == nil {
            defaults.set(1, forKey: "openTimes")
            let currentDate = Date()
            let formatter = DateFormatter()
            formatter.timeStyle = .none
            formatter.dateFormat = "MM/dd/yyyy"
            let today = formatter.string(from: currentDate)
            defaults.set(today, forKey: "launchDate")
        } else {
            openTimesIncrementer = defaults.integer(forKey: "openTimes") + 1
            defaults.set(openTimesIncrementer, forKey: "openTimes")
        }
        
        defaults.set(true, forKey: "appLaunch")
        return true
    }


}

