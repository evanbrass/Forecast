//
//  ForecastListView.swift
//  Forecast-SwiftUI
//
//  Created by Evan Brass on 6/8/20.
//  Copyright © 2020 Evan Brass. All rights reserved.
//

import SwiftUI

struct ForecastListView: View {
    private let cityProvider: CityProviderProtocol
    private let forecastService: ForecastServiceProtocol
    @State private var forecasts: [City: HourlyForecastResponse] = [:]
    @State private var isHourly = false // TODO:Evan update using userdefaults

    init(cityProvider: CityProviderProtocol, forecastService: ForecastServiceProtocol) {
        self.cityProvider = cityProvider
        self.forecastService = forecastService
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Current / Hourly Toggle
                GeometryReader { geometry in
                    ZStack {
                        RoundedRectangle(cornerRadius: 5.0)
                            .fill(Color.white)
                            .padding(4)
                            .frame(width: geometry.size.width / 2, height: geometry.size.height)
                            .offset(x: self.isHourly ? geometry.size.width / 4 : -geometry.size.width / 4)
                            .animation(.easeInOut(duration: 0.2))

                        HStack {
                            Text("Current")
                                .foregroundColor(!self.isHourly ? Color.black : Color.gray)
                                .frame(maxWidth: .infinity)
                            Text("Hourly")
                                .foregroundColor(self.isHourly ? Color.black : Color.gray)
                                .frame(maxWidth: .infinity)
                        }
                        .font(.callout)
                        .onTapGesture {
                            withAnimation(Animation.spring(response: 0.4, dampingFraction: 0.7, blendDuration: 0.5)) {
                                self.isHourly.toggle()
                            }
                        }
                    }
                }
                .frame(height: 50)
                .background(Color.init(hue: 0.0, saturation: 0.0, brightness: 0.9))

                // List
                ScrollView {
                    VStack {
                        ForEach(cityProvider.cities, id: \.self) { (city) in
                            ForecastListCell(cityName: city.name, isHourly: self.isHourly, forecast: self.forecasts[city])
                                .padding()
                                .onAppear {
                                    self.forecastService.getHourlyForecastForCity(city) { (forecast, error) in
                                        DispatchQueue.main.async {
                                            self.forecasts[city] = forecast
                                        }
                                    }
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Forecasts")
            .navigationBarItems(trailing:
                NavigationLink(destination: CityListView(citiesModel: CityListViewModel(cityProvider: cityProvider)), label: {
                    Text("Cities")
                })
            )
        }
    }
}


struct ForecastListView_Previews: PreviewProvider {
    static var previews: some View {
        ForecastListView(cityProvider: CitiesProvider(), forecastService: ForecastService())
    }
}
