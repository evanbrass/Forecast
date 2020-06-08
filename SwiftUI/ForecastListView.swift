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
    private var isHourly = true

    init(cityProvider: CityProviderProtocol, forecastService: ForecastServiceProtocol) {
        self.cityProvider = cityProvider
        self.forecastService = forecastService
    }
    
    var body: some View {
        VStack {
            HStack {
                Button("Current") {
                    print("current")
                }
                .frame(maxWidth: .infinity)
                Button("Hourly") {
                    print("hourly")
                }
                .frame(maxWidth: .infinity)
            }
            .frame(height: 50)
            
            List {
                ForEach(cityProvider.cities, id: \.self) { (city) in
                    Group {
                        if self.isHourly {
                            // Hourly Cell
                            HourlyForecastCell(city: city, forecast: self.forecasts[city])
                        } else {
                            CurrentForecastCell(city: city, forecast: self.forecasts[city])
                        }
                    } // End group
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
}

struct ForecastListView_Previews: PreviewProvider {
    static var previews: some View {
        ForecastListView(cityProvider: CitiesProvider(), forecastService: ForecastService())
    }
}
