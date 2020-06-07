//
//  ForecastService.swift
//  Forecast
//
//  Created by Evan Brass on 6/3/20.
//  Copyright © 2020 Evan Brass. All rights reserved.
//

import Foundation


/// ForecastServiceProtocol describes behavior of an object that will manage and provide any weather forcast related
/// data for this app.  Currently we are using the open weather map API: https://openweathermap.org/current
protocol ForecastServiceProtocol {
    
    /// Clear any cached responses
    func clearCache()
    
    /// Fetches the hourly and current forcast for a city in one call.
    /// If an error occurs it will be present in the completion block and the forecast will be nil
    func getHourlyForecastForCity(_ city: City, completion: @escaping GetHourlyForecastCompletion)
}

enum TempUnit: String {
    case fahrenheit = "imperial"
    case celsius = "metric"
}

typealias GetHourlyForecastCompletion = (HourlyForecastResponse?, Error?) -> ()

enum ForecastServiceError: Error {
    case noData
}

class ForecastService: ForecastServiceProtocol {
    let appID = "5d7687b3c7704da50b6b4a7ae278329f" // API Key
    // TODO: Make this to a user setting
    let tempUnit: TempUnit = .fahrenheit

    func clearCache() {
        URLCache.shared.removeAllCachedResponses()
    }

    func getHourlyForecastForCity(_ city: City, completion: @escaping GetHourlyForecastCompletion) {
        let urlString = "https://api.openweathermap.org/data/2.5/onecall?lat=\(city.lat)&lon=\(city.lon)&exclude=minutely,daily&appid=\(appID)&units=\(tempUnit.rawValue)"
        guard let url = URL(string: urlString) else {
            // It's unlikey that this will happen if we have things setup properly, but if it does, assert
            // wo we can catch it in the dev environment
            assertionFailure("Something went wrong constructing the url")
            completion(nil, nil)
            return
        }
        
        if let cached = URLCache.shared.cachedResponse(for: URLRequest(url: url)),
            let decodedData = try? JSONDecoder().decode(HourlyForecastResponse.self, from: cached.data) {
            // Return cache if exists
            completion(decodedData, nil)
        } else {
            // Fetch new data
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    completion(nil, error)
                    return
                }
                
                if let data = data {
                    do {
                        let forecast = try JSONDecoder().decode(HourlyForecastResponse.self, from: data)
                        completion(forecast, nil)
                    } catch let error {
                        completion(nil, error)
                    }
                } else {
                    assertionFailure("Successful call, but no data returned")
                    completion(nil, ForecastServiceError.noData)
                }
            }.resume()
        }
    }
}
