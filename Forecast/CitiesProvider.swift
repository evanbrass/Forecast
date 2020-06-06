//
//  CitiesService.swift
//  Forecast
//
//  Created by Evan Brass on 6/2/20.
//  Copyright © 2020 Evan Brass. All rights reserved.
//

import Foundation
import CoreLocation


/// This protocol describes the duties of an object that will be providing and managing city data to this app.
/// Currently, in it's small form, it's being backed by UserDefaults, but this could be extended to use a database
/// or some other method. Keeping it abstract allows the implementation details to be hidden.
protocol CityProviderProtocol {
    /// The current cities available
    var cities: [City] { get }
    
    /// Add a city to the available cities.
    /// - Returns: false if the city was not added (due to duplicate entry)
    func addCity(_ city: City) -> Bool
    
    /// Delete a city from available cities
    func deleteCity(_ city: City)
}

class CitiesProvider: CityProviderProtocol {
    private(set) var cities: [City] = [
        // Provide a default city... why not Lousiville??
        City(name: "Louisville", state: "KY", lat: 38.25, lon: -85.76)
    ]
    
    // Used to keep track of duplicates. Overkill since our array won't be too large - but hey, future proofing.
    private var cityHash: Set<City> = []
    private let defaultsCityKey = "cities"
    
    init() {
        // Retreive saved city list from UserDefaults
        if let cityData = UserDefaults.standard.data(forKey: defaultsCityKey),
            let decoded = try? JSONDecoder().decode([City].self, from: cityData) {
            cities = decoded
            cityHash = Set(cities)
        }
    }
    
    func saveData() {
        if let data = try? JSONEncoder().encode(cities) {
            UserDefaults.standard.set(data, forKey: defaultsCityKey)
        }
    }
    
    func addCity(_ city: City) -> Bool {
        guard !cityHash.contains(city) else {
            return false
        }
        cities.append(city)
        cityHash.insert(city)
        saveData()
        return true
    }
    
    func deleteCity(_ city: City) {
        cityHash.remove(city)
        if let removeIndex = cities.firstIndex(where: {$0.name == city.name}) {
            cities.remove(at: removeIndex)
        }
        saveData()
    }
}
