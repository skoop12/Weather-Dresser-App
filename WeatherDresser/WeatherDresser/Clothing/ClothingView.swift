//
//  ClothingView.swift
//  WeatherDresser
//
//  Created by Sarah Koop on 3/8/19.
//  Copyright © 2019 Sarah Koop. All rights reserved.
//

import UIKit

class ClothingView: UIView {

    func getAppropriateClothing(for weather: String, and temperature: Int) -> [String] {
        var temperatureRange = ""
        
        if temperature < 33 {
            temperatureRange = "cold"
        } else if temperature < 50 {
            temperatureRange = "mildCold"
        } else if temperature < 65 {
            temperatureRange = "mild"
        } else if temperature < 70 {
            temperatureRange = "warm"
        } else {
            temperatureRange = "hot"
        }
        
        switch temperatureRange {
        case "cold":
            if (weather == "Rain" || weather == "Drizzle" || weather == "Thunderstorm") {
                return ["pants","sweater","socks","boots","winterCoat","winterHat","scarf","mittens","umbrella"]
            } else if weather == "Snow" {
                return ["pants","sweater","snowPants","socks","snowBoots","winterCoat","winterHat","scarf","mittens"]
            } else {
                return ["pants","sweater","socks","boots","winterCoat","winterHat","scarf","mittens"]
            }
        case "mildCold":
            if (weather == "Rain" || weather == "Drizzle" || weather == "Thunderstorm") {
                return ["pants","tshirt","sweatshirt","socks","rainBoots","rainJacket","umbrella"]
            } else {
                return ["pants","tshirt","sweatshirt","socks","boots","winterCoat"]
            }
        case "mild":
            if (weather == "Rain" || weather == "Drizzle" || weather == "Thunderstorm") {
                return ["tshirt","pants","socks","rainBoots","rainJacket","umbrella"]
            } else {
                return ["pants","tshirt","lightJacket","socks","slipOns"]
            }
        case "warm":
            if (weather == "Rain" || weather == "Drizzle" || weather == "Thunderstorm") {
                return ["tshirt","pants","socks","rainBoots","rainJacket","umbrella"]
            } else {
                return ["pants","tshirt","socks","slipOns"]
            }
        case "hot":
            if (weather == "Rain" || weather == "Drizzle" || weather == "Thunderstorm") {
                return ["shorts","tshirt","socks","rainBoots","rainJacket","umbrella"]
            } else {
                return ["shorts","tshirt","sandals"]
            }
        default:
            return ["pants","tshirt","sweatshirt","lightJacket","socks","slipOns"]
        }
    }
    
    func getClothingLabel(for clothing: String) -> String {
        switch clothing {
        case "lightJacket":
            return "Light Jacket"
        case "mittens":
            return "Mittens"
        case "rainBoots":
            return "Rain Boots"
        case "rainJacket":
            return "Rain Jacket"
        case "scarf":
            return "Scarf"
        case "slipOns":
            return "Regular Shoes"
        case "snowBoots":
            return "Winter Boots"
        case "snowPants":
            return "Snow Pants"
        case "umbrella":
            return "Umbrella"
        case "winterCoat":
            return "Winter Coat"
        case "winterHat":
            return "Winter Hat"
        case "sweater":
            return "Sweater"
        case "tshirt":
            return "Shirt"
        case "sweatshirt":
            return "Sweatshirt"
        case "boots":
            return "Boots"
        case "shorts":
            return "Shorts"
        case "sandals":
            return "Sandals"
        case "socks":
            return "Socks"
        case "pants":
            return "Pants"
        default:
            return ""
        }
    }
}
