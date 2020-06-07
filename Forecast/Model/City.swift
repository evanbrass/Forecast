//
//  City.swift
//  Forecast
//
//  Created by Evan Brass on 6/5/20.
//  Copyright © 2020 Evan Brass. All rights reserved.
//

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

