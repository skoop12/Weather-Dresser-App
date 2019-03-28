//
//  WeatherViewController.swift
//  WeatherDresser
//
//  Created by Sarah Koop on 3/8/19.
//  Copyright © 2019 Sarah Koop. All rights reserved.
//

import UIKit

class WeatherView: UIView {

    func getMainWeatherImage(for mainWeather: String, and detailedWeather: String) -> String {
        switch mainWeather {
        case "Clouds":
            if detailedWeather == "few clouds" || detailedWeather == "scattered clouds" {
                return "partialClouds"
            } else {
                return "clouds"
            }
        case "Clear":
            return "sun"
        case "Snow":
            return "snow"
        case "Atmosphere":
            return "clouds"
        case "Rain":
            return "rain"
        case "Drizzle":
            return "rain"
        case "Thunderstorm":
            return "thunderstorm"
        default:
            return "partialClouds"
        }
    }
    
    func getTemperatureImage(for temperature: Int) -> String {
        if temperature < 45 {
            return "cold"
        } else if temperature < 75 {
            return "warm"
        } else {
            return "hot"
        }
    }

}
