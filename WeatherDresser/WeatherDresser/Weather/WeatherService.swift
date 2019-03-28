//
//  WeatherService.swift
//  WeatherDresser
//
//  Created by Sarah Koop on 3/6/19.
//  Copyright © 2019 Sarah Koop. All rights reserved.
//

import UIKit

// MARK: - Weather Data Structs

struct WeatherResult: Codable {
    let coord: [String: Float]
    let weather: [Weather]
    let main: [String: Float]
    let wind: [String: Float]?
    let snow: [String: Float]?
    let clouds: [String: Float]?
    let name: String
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

// MARK: - Weather API

class WeatherService {
    
    var dataTask: URLSessionDataTask?
    
    private let urlString = "https://api.openweathermap.org/data/2.5/weather?"
    
    func search(for location: String, completion: @escaping (WeatherResult?, Error?) -> ()) {
        
        // https://www.hackingwithswift.com/example-code/strings/replacing-text-in-a-string-using-replacingoccurrencesof
        let replaced = location.replacingOccurrences(of: " ", with: "+")
        
        guard let url = URL(string: urlString + replaced + "&APPID=" + Constants.apiKey) else {
            print("invalid url: \(urlString + location)")
            return
        }
        
        let urlRequest = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            
            guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
                DispatchQueue.main.async { completion(nil, error) }
                return
            }
            
            print("Status code: \(response.statusCode)")

            do {
                let decoder = JSONDecoder()
                let weatherResult = try decoder.decode(WeatherResult.self, from: data)
                DispatchQueue.main.async { completion(weatherResult, nil) }
            } catch (let error) {
                DispatchQueue.main.async { completion(nil, error) }
            }
        }
        task.resume()
    }
}


