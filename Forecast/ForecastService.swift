//
//  ForecastService.swift
//  Forecast
//
//  Created by Evan Brass on 6/3/20.
//  Copyright © 2020 Evan Brass. All rights reserved.
//

import Foundation

typealias GetCurrentForecastCompletion = (CurrentForecastResponse?, Error?) -> ()
typealias GetHourlyForecastCompletion = (HourlyForecastResponse?, Error?) -> ()

enum TempUnit: String {
    case fahrenheit = "imperial"
    case celsius = "metric"
}

class ForecastService {
    let appID = "5d7687b3c7704da50b6b4a7ae278329f" // API Key
    let tempUnit: TempUnit = .fahrenheit // TODO:Evan make this changeable
    
    /*
    https://api.openweathermap.org/data/2.5/onecall?lat=\(city.lat)&lon=\(city.lon)&exclude={part}
    https://api.openweathermap.org/data/2.5/onecall?lat=\(city.lat)&lon=\(city.lon)&appid=\(appID)
     
     parts can exclude:
     current
     minutely
     hourly
     daily
 */
    
    func clearCache() {
        URLCache.shared.removeAllCachedResponses()
    }

    func getHourlyForecastForCity(_ city: City, completion: @escaping GetHourlyForecastCompletion) {
        let urlString = "https://api.openweathermap.org/data/2.5/onecall?lat=\(city.lat)&lon=\(city.lon)&exclude=minutely,daily&appid=\(appID)&units=\(tempUnit.rawValue)"
        guard let url = URL(string: urlString) else {
            // TODO:Evan throw exception that we failed because of bad url
            assertionFailure("This shouldn't happen, something wrong with the id")
            return
        }
        
        // Return cache if exists
        if let cached = URLCache.shared.cachedResponse(for: URLRequest(url: url)) {
            do {
                let decodedData = try JSONDecoder().decode(HourlyForecastResponse.self, from: cached.data)
                completion(decodedData, nil)
            } catch {
                // continue to fetch
                return
            }
        } else {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard error == nil else {
                    // TODO:Evan handle
                    assertionFailure(error!.localizedDescription)
                    return
                }
                
                if let data = data {
                    do {
                        let forecast = try JSONDecoder().decode(HourlyForecastResponse.self, from: data)
                        completion(forecast, nil)
                    } catch let error {
                        // TODO:evan custom error
                        print(error.localizedDescription)
                        completion(nil, error)
                    }
                } else {
                    // TODO:Evan handle
                    print("something went wrong, there's no data")
                    assertionFailure()
                }
            }.resume()
        }
    }

    func getCurrentForecastForCity(_ city: City, completion: @escaping GetCurrentForecastCompletion) {
        // TODO:Evan make this a function to return a URL
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(Float(city.lat))&lon=\(Float(city.lon))&appid=\(appID)&units=\(tempUnit.rawValue)"

        guard let url = URL(string: urlString) else {
            // TODO:Evan throw exception that we failed because of bad url
            assertionFailure("This shouldn't happen, something wrong with the id")
            return
        }
        
        // TODO:Evan check cache
//        if let cached = URLCache.shared.cachedResponse(for: URLRequest(url: url)) {
//            do {
//                let decodedData = try JSONDecoder().decode(CurrentForecastResponse.self, from: cached.data)
//                completion(decodedData, nil)
//            } catch let error {
//                // TODO:evan custom error
//                print(error.localizedDescription)
//                completion(nil, error)
//            }
//            return
//        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                // TODO:Evan handle
                assertionFailure(error!.localizedDescription)
                return
            }
            
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode(CurrentForecastResponse.self, from: data)
                    completion(decodedData, nil)
                } catch let error {
                    // TODO:evan custom error
                    print(error.localizedDescription)
                    completion(nil, error)
                }
            } else {
                // TODO:Evan handle
                print("something went wrong, there's no data")
                assertionFailure()
            }

        }.resume()
    }
}
