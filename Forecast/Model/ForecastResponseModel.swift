//
//  ForecastResponseModel.swift
//  Forecast
//
//  Created by Evan Brass on 6/5/20.
//  Copyright © 2020 Evan Brass. All rights reserved.
//

import UIKit

/// This file contains the codable response objects returned by the forecast api.  Since they are small, I kept them
/// in one place instead of creating separate files for each.

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

struct WeatherInfo: Codable {
    let main: String
    let description: String
    let icon: String
    
    var image: UIImage? {
        return UIImage(named: icon)
    }
}
