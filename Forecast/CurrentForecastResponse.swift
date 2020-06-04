//
//  CurrentForecastResponse.swift
//  Forecast
//
//  Created by Evan Brass on 6/2/20.
//  Copyright © 2020 Evan Brass. All rights reserved.
//

/*
 {
   "coord": {
     "lon": -85.76,
     "lat": 38.25
   },
   "weather": [
     {
       "id": 801,
       "main": "Clouds",
       "description": "few clouds",
       "icon": "02d"
     }
   ],
   "base": "stations",
   "main": {
     "temp": 304.59,
     "feels_like": 300.55,
     "temp_min": 303.71,
     "temp_max": 305.37,
     "pressure": 1017,
     "humidity": 33
   },
   "visibility": 16093,
   "wind": {
     "speed": 7.2,
     "deg": 260
   },
   "clouds": {
     "all": 20
   },
   "dt": 1591127876,
   "sys": {
     "type": 1,
     "id": 5801,
     "country": "US",
     "sunrise": 1591093265,
     "sunset": 1591146090
   },
   "timezone": -14400,
   "id": 4299276,
   "name": "Louisville",
   "cod": 200
 }
 */

import Foundation
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
    
    var iconURL: URL? {
        let urlString = "https://openweathermap.org/img/wn/\(icon)@2x.png"
        return URL(string: urlString)
    }
}

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
