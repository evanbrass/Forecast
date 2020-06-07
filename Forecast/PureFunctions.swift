//
//  PureFunctions.swift
//  Forecast
//
//  Created by Evan Brass on 6/5/20.
//  Copyright © 2020 Evan Brass. All rights reserved.
//

import Foundation
import GooglePlaces

/// This file holds pure functions that can be easily tested.  I like this method of moving any business logic out into
/// functions.  You could also house these within structs for organization purposes, or if you were using Objective-C
/// as well, you could put them in a class.



/// Converts a UTC timestamp into a short string.  Example 1591565541 -> "9 PM"
/// - Parameter time: The UTC timestamp
/// - Returns: A string with the format "Hour {AM/PM}"
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

/// Parses the passed in place and returns the state if it exists. If not it will try and use the country if it can
/// find it, and if all else fails, return nil
/// - Parameter place: The GMSPlace (Google Places API)
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

