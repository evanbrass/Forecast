//
//  CityListView.swift
//  Forecast-SwiftUI
//
//  Created by Evan Brass on 6/9/20.
//  Copyright © 2020 Evan Brass. All rights reserved.
//

import SwiftUI
import GooglePlaces

// TODO:Evan document
struct CityListView: View {
    @ObservedObject var citiesModel: CityListViewModel
    @State var x = false

    var body: some View {
        NavigationView {
            List {
                ForEach(citiesModel.cities, id: \.self) { (city) in
                    Text(city.name)
                        .frame(height: 60)
                        .font(.title)
                }
                .onDelete { (indexSet) in
                    for i in indexSet {
                        self.citiesModel.deleteCityAtIndex(i)
                    }
                }
            }
        }
        .navigationBarTitle("Cities")
        .navigationBarItems(trailing:
            Button("Add") {
                self.citiesModel.isShowingCityPicker.toggle()
            }.sheet(isPresented: self.$citiesModel.isShowingCityPicker, content: {
                GooglePlacesCityPickerView(delegate: self.citiesModel as GMSAutocompleteViewControllerDelegate)
            })
        )
    }
}
