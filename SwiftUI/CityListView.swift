//
//  CityListView.swift
//  Forecast-SwiftUI
//
//  Created by Evan Brass on 6/9/20.
//  Copyright © 2020 Evan Brass. All rights reserved.
//

import SwiftUI

// TODO:Evan move
class CityListViewModel: ObservableObject {
    @Published var cities: [City] = []
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
}

struct CityListView: View {
    @ObservedObject var citiesModel: CityListViewModel
    
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
            NavigationLink(destination: Text("Add city"), label: {
                Text("Add")
            })
        )
    }
}

//struct CityListView_Previews: PreviewProvider {
//    static var previews: some View {
//        CityListView()
//    }
//}
