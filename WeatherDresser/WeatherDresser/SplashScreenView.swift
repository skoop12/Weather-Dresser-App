//
//  SplashScreenView.swift
//  WeatherDresser
//
//  Created by Sarah Koop on 3/17/19.
//  Copyright © 2019 Sarah Koop. All rights reserved.
//

import UIKit

class SplashScreenView: UIView {
    
    // MARK: - Variables
    
    var overlay : UIView?
    var versionLabel: UILabel!
    var appNameLabel: UILabel!
    
    // MARK: - Initializers
    
    // https://blog.usejournal.com/custom-uiview-in-swift-done-right-ddfe2c3080a
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {
        // https://stackoverflow.com/questions/21850436/add-a-uiview-above-all-even-the-navigation-bar
        backgroundColor = UIColor(named: "brightBlue")
        
        // https://stackoverflow.com/questions/25965239/how-do-i-get-the-app-version-and-build-number-using-swift
        let versionNumber = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
        
        versionLabel = UILabel(frame: CGRect(x:0, y: self.frame.size.height/2, width: self.frame.size.width, height: 300))
        versionLabel.text = "Version: " + versionNumber!
        versionLabel.font = versionLabel.font.withSize(20)
        versionLabel.textAlignment = .center
        versionLabel.textColor = .white
        
        appNameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 500 ))
        appNameLabel.text = "Weather Dresser"
        appNameLabel.textAlignment = .center
        appNameLabel.font = appNameLabel.font.withSize(40)
        appNameLabel.textColor = .white
        
        self.addSubview(appNameLabel)
        self.addSubview(versionLabel)
    }
}
