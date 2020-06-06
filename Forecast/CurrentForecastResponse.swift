//
//  CurrentForecastResponse.swift
//  Forecast
//
//  Created by Evan Brass on 6/2/20.
//  Copyright © 2020 Evan Brass. All rights reserved.
//

import UIKit
import CoreLocation

struct City: Codable, Equatable, Hashable {
    let name: String
    let state: String?
    let lat: Double
    let lon: Double

    var coord: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
}

struct TemperatureInfo: Codable {
    let temp: Double
    let feelsLike: Double
    
    private enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
    }
}

struct WeatherInfo: Codable {
    let main: String
    let description: String
    let icon: String
    
    var image: UIImage? {
        return UIImage(named: icon)
    }
}

// TODO:Evan remove and anything else here unused
struct CurrentForecastResponse: Codable {
    let info: TemperatureInfo
    let cityName: String
    let weather: [WeatherInfo]
    private enum CodingKeys: String, CodingKey {
        case info = "main"
        case cityName = "name"
        case weather
    }
}

struct HourlyTempInfo: Codable {
    let time: Int
    let temp: Double
    let weather: [WeatherInfo]
    
    private enum CodingKeys: String, CodingKey {
        case time = "dt"
        case temp
        case weather
    }
}

struct CurrentTempInfo: Codable {
    let temp: Double
    let time: Int
    let sunrise: Int
    let sunset: Int
    let weather: [WeatherInfo]
    
    private enum CodingKeys: String, CodingKey {
        case temp
        case time = "dt"
        case sunrise
        case sunset
        case weather
    }
}

struct HourlyForecastResponse: Codable {
    let hourly: [HourlyTempInfo]
    let current: CurrentTempInfo
    let timezoneOffset: Int
    
    private enum CodingKeys: String, CodingKey {
        case hourly
        case current
        case timezoneOffset = "timezone_offset"
    }
}

// TODO:Evan move
func timeTextForTimeStamp(_ time: Int) -> String {
    let date = Date(timeIntervalSince1970: Double(time))
    let dateString = date.description
    guard let firstComponent = dateString.split(separator: ":").first,
        var hour = Int(String(firstComponent.suffix(2))) else {
            return ""
    }
    var amPM = "AM"
    if hour == 0 {
        hour = 12
    } else if hour == 12 {
        amPM = "PM"
    } else if hour > 12 {
        hour = hour % 12
        amPM = "PM"
    }
    return "\(hour) \(amPM)"
}

