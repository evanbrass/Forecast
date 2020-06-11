//
//  CityListViewModel.swift
//  Forecast-SwiftUI
//
//  Created by Evan Brass on 6/10/20.
//  Copyright © 2020 Evan Brass. All rights reserved.
//

import SwiftUI
import GooglePlaces

// TODO:Evan document
class CityListViewModel: NSObject, GMSAutocompleteViewControllerDelegate, ObservableObject {
    @Published var cities: [City] = []
    @Published var isShowingCityPicker = false
    private let cityProvider: CityProviderProtocol
    
    init(cityProvider: CityProviderProtocol) {
        self.cityProvider = cityProvider
        cities = cityProvider.cities
    }
    
    func deleteCityAtIndex(_ index: Int) {
        let city = cityProvider.cities[index]
        cityProvider.deleteCity(city)
        cities = cityProvider.cities
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let newCity = City(name: place.name ?? "unknown",
                           state: stateCodeForPlace(place),
                           lat:place.coordinate.latitude,
                           lon: place.coordinate.longitude)
        guard cityProvider.addCity(newCity) else {
            // TODO:Evan handle this
            return
        }
        cities = cityProvider.cities
        isShowingCityPicker = false
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        isShowingCityPicker = false
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        isShowingCityPicker = false
    }
}

