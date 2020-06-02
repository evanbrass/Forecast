//
//  CitiesService.swift
//  Forecast
//
//  Created by Evan Brass on 6/2/20.
//  Copyright © 2020 Evan Brass. All rights reserved.
//

import Foundation

protocol CityServiceProtocol {
    var cities: [String] { get }
}

class CitiesService {
    var cities: [String] = ["Louisville"]
}
