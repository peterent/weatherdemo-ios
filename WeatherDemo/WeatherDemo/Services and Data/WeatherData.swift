//
//  WeatherData.swift
//  PetesWeather
//
//  Created by Peter Ent on 10/5/20.
//

import SwiftUI

// All of the different weather condition codes in openweather.com mapped to
// the main asset name minus "-Day" or "-Night" which is determined at runtime.

fileprivate let iconMap: [Int: String] = [
    200: "Thunder",
    201: "Thunder",
    202: "Thunder-Heavy",
    210: "Thunder",
    211: "Thunder",
    212: "Thunder-Heavy",
    221: "Thunder",
    230: "Thunder-Drizzle",
    231: "Thunder-Drizzle",
    232: "Thunder-Drizzle",
    300: "Scattered-Showers",
    301: "Rain-Drizzle",
    302: "Scattered-Showers",
    310: "Scattered-Showers",
    311: "Rain-Drizzle",
    312: "Scattered-Showers",
    313: "Scattered-Showers",
    314: "Scattered-Showers",
    321: "Rain-Drizzle",
    500: "Rain",
    501: "Rain",
    502: "Rain-Heavy",
    503: "Rain-Heavy",
    504: "Rain-Heavy",
    511: "Sleet",
    520: "Rain",
    521: "Rain",
    522: "Rain",
    531: "Rain",
    600: "Snow",
    601: "Snow",
    602: "Snow-Heavy",
    611: "Sleet",
    612: "Sleet",
    613: "Sleet",
    615: "Snow",
    616: "Snow",
    620: "Snow",
    621: "Snow",
    622: "Snow",
    701: "Mist",
    711: "Smoke",
    721: "Haze",
    741: "Fog",
    761: "Dust",
    762: "Ash",
    771: "Squalls",
    781: "Tornado",
    800: "Clear",
    801: "Mostly-Clear",
    802: "Few-Clouds",
    803: "Cloudy",
    804: "Cloudy"
]

/**
 * The data returns by the openweather.com REST API. Its JSON return value is
 * decoded into these structures.
 */
struct WeatherData: Decodable {
    
    struct Weather: Decodable {
        var id: Int?
        var main: String?
        var description: String?
        var icon: String?
    }
    
    struct Temp: Decodable {
        var day: Double?
        var min: Double?
        var max: Double?
        var night: Double?
        var eve: Double?
        var morn: Double?
    }
    
    struct CurrentWeather: Decodable {
        var dt: Double?
        var sunrise: Double?
        var sunset: Double?
        var temp: Double?
        var feels_like: Double?
        var pressure: Double?
        var humidity: Double?
        var dew_point: Double?
        var uvi: Double?
        var clouds: Double?
        var visibility: Double?
        var wind_speed: Double?
        var wind_deg: Double?
        var weather: [Weather]?
        
        func temperature() -> String {
            guard let temp = temp else { return "" }
            return String(format: "%.0f°", temp)
        }
        
        func humidityAsString() -> String {
            guard let humidity = humidity else { return "?%" }
            return String(format: "%.0f", humidity) + "%"
        }
        
        func dewPointAsString() -> String {
            guard let dewp = dew_point else { return "?%" }
            return String(format: "%0.f°", dewp)
        }
        
        func cloudinessAsString() -> String {
            guard let cloudiness = clouds else { return "0%" }
            return String(format: "%0.f", cloudiness) + "%"
        }
        
        func pressureAsString() -> String {
            guard let pressure = pressure else { return "? mb"}
            return String(format: "%.0f mb", pressure)
        }
        
        func feelsLikeAsString() -> String {
            guard let feels_like = feels_like else { return "" }
            return String(format: "%.0f°", feels_like)
        }
        
        func uviAsString() -> String {
            guard let uvi = uvi else { return "0" }
            return String(format: "%.0f", uvi)
        }
        
        func visibilityAsString() -> String {
            guard let vis = visibility else { return "0 m" }
            return String(format: "%.0f m", vis)
        }
        
        func currentCondition() -> String {
            return weather?.first?.description ?? "unknown"
        }
        
        func isDay() -> Bool {
            guard let now = dt, let sunrise = sunrise, let sunset = sunset else { return true }
            return sunrise <= now && now <= sunset
        }
        
        func image() -> UIImage? {
            guard let weather = weather?.first else { return nil }
            guard let iconId = weather.id else { return nil }
            guard let iconName = iconMap[iconId] else { return nil }
            let dayOrNight = isDay() ? "-Day" : "-Night"
            let image = UIImage(named: iconName + dayOrNight)
            return image
        }
    }
    
    struct HourlyWeather: Decodable {
        var dt: Double?
        var temp: Double?
        var feels_like: Double?
        var pressure: Double?
        var humidity: Double?
        var dew_point: Double?
        var clouds: Double?
        var visibility: Double?
        var wind_speed: Double?
        var wind_deg: Double?
        var rain: [String: Double]?
    }
    
    struct DailyWeather: Decodable {
        var dt: Double?
        var sunrise: Double?
        var sunset: Double?
        var temp: Temp?
        var feels_like: Temp?
        var pressure: Double?
        var humidity: Double?
        var dew_point: Double?
        var wind_speed: Double?
        var wind_deg: Double?
        var weather: [Weather]?
        var clouds: Double?
        var pop: Double?
        var rain: Double?
        var uvi: Double?
        
        func currentCondition() -> String {
            return weather?.first?.description ?? "unknown"
        }
        
        func daysHi() -> String {
            guard let max = temp?.max else { return "" }
            return String(format: "%.0f°", max)
        }
        
        func daysLo() -> String {
            guard let min = temp?.min else { return "" }
            return String(format: "%.0f°", min)
        }
        
        func image() -> UIImage? {
            guard let weather = weather?.first else { return nil }
            guard let iconId = weather.id else { return nil }
            guard let iconName = iconMap[iconId] else { return nil }
            let dayOrNight = "-Day" // just use the Day image for these
            let image = UIImage(named: iconName + dayOrNight)
            return image
        }
    }
    
    var lat: Double?
    var lon: Double?
    var timezone: String?
    var timezone_offset: Int?
    var current: CurrentWeather?
    var hourly: [HourlyWeather]?
    var daily: [DailyWeather]?
    
    func isDay() -> Bool {
        guard let current = current else { return false }
        return current.isDay()
    }
    
    func sunriseTime() -> String {
        guard let current = current, let tzOffset = timezone_offset else { return "0:00 am" }
        guard let sunrise = current.sunrise else { return "0:00 am" }
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        formatter.timeZone = TimeZone(secondsFromGMT: tzOffset)
        return formatter.string(from: Date(timeIntervalSince1970: sunrise))
    }
    
    func sunsetTime() -> String {
        guard let current = current, let tzOffset = timezone_offset else { return "0:00 am" }
        guard let sunset = current.sunset else { return "0:00 am" }
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        formatter.timeZone = TimeZone(secondsFromGMT: tzOffset)
        return formatter.string(from: Date(timeIntervalSince1970: sunset))
    }
}
