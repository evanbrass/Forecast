//
//  PureFunctions.swift
//  Forecast
//
//  Created by Evan Brass on 6/5/20.
//  Copyright © 2020 Evan Brass. All rights reserved.
//

import Foundation
import GooglePlaces

// TODO:Evan document

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

func stateCodeForPlace(_ place: GMSPlace) -> String? {
    var code: String? = nil
    
    if let components = place.addressComponents, components.count > 0 {
        if let state = components.first(where: { $0.types.contains(kGMSPlaceTypeAdministrativeAreaLevel1)}) {
            code = state.shortName ?? state.name
        } else if let country = components.first(where: { $0.types.contains(kGMSPlaceTypeCountry)}) {
            code = country.shortName ?? country.name
        } else {
            code = components.last?.shortName ?? components.last?.name
        }
    }
    return code
}

