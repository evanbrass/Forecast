//
//  CitiesService.swift
//  Forecast
//
//  Created by Evan Brass on 6/2/20.
//  Copyright © 2020 Evan Brass. All rights reserved.
//

import Foundation
import CoreLocation

protocol CityProviderProtocol {
    var cities: [City] { get }
    func addCity(_ city: City) -> Bool
    func deleteCity(_ city: City)
}

class CitiesProvider: CityProviderProtocol {
    private(set) var cities: [City] = [
        City(name: "Louisville", state: "KY", lat: 38.25, lon: -85.76)
    ]
    private var cityHash: Set<City> = [] // Used to keep track of duplicates
    private let defaultsCityKey = "cities"
    
    init() {
        // Retreive saved city list
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
            // TODO:Evan throw? bool might be good enough
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
