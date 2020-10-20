//
//  WeatherService.swift
//  PetesWeather
//
//  Created by Peter Ent on 10/1/20.
//

import SwiftUI
import MapKit
import Alamofire

/**
 * Connects to the openweather.com REST API service and processes the results into data structures
 * using the Decodable protocol.
 */
class WeatherService {
    
    enum WeatherUnits: String {
        case imperial = "imperial"
        case metric = "metric"
    }
    
    private let apiKey = "<add your openweather.com API key here>"
        
    func getAllWeatherInfo(for location: CLLocationCoordinate2D, units: WeatherUnits, onComplete: @escaping ((WeatherData?)->Void)) {
        let lat = location.latitude
        let lon = location.longitude
        AF.request("https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&exclude=minutely,alerts&units=\(units.rawValue)&appid=\(apiKey)").responseJSON { response in
            if let error = response.error {
                print("We have an error: \(error)")
                onComplete(nil)
            }
            if let data = response.data {
                do {
                    let allWd = try JSONDecoder().decode(WeatherData.self, from: data)
                    DispatchQueue.main.async {
                        onComplete(allWd)
                    }
                } catch {
                    print("JSON decoding error: \(error)")
                    onComplete(nil)
                }
            }
        }
    }
    
}

