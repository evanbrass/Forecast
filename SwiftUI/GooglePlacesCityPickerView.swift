//
//  GooglePlacesCityPickerView.swift
//  Forecast-SwiftUI
//
//  Created by Evan Brass on 6/10/20.
//  Copyright © 2020 Evan Brass. All rights reserved.
//

import SwiftUI
import GooglePlaces

// TODO:Evan document
struct GooglePlacesCityPickerView: UIViewControllerRepresentable {
    weak var delegate: GMSAutocompleteViewControllerDelegate?
    
    typealias UIViewControllerType = GMSAutocompleteViewController
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<GooglePlacesCityPickerView>) -> GMSAutocompleteViewController {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self.delegate
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
            UInt(GMSPlaceField.placeID.rawValue) |
            UInt(GMSPlaceField.addressComponents.rawValue) |
            UInt(GMSPlaceField.coordinate.rawValue) )!
        autocompleteController.placeFields = fields
        
        // Filter on cities
        let filter = GMSAutocompleteFilter()
        filter.type = .city
        autocompleteController.autocompleteFilter = filter
        return autocompleteController
    }
    
    func updateUIViewController(_ uiViewController: GMSAutocompleteViewController, context: UIViewControllerRepresentableContext<GooglePlacesCityPickerView>) {
        
    }
}
