//
//  CurrentForecastCell.swift
//  Forecast-SwiftUI
//
//  Created by Evan Brass on 6/8/20.
//  Copyright © 2020 Evan Brass. All rights reserved.
//

import SwiftUI

struct CurrentForecastCell: View {
    let city: City
    var forecast: HourlyForecastResponse? = nil
    
    var body: some View {
        HStack {
            Text(city.name)
            Spacer()
            if forecast != nil {
                Text("\(Int(forecast!.current.temp))º")
            }
        }
                .font(.largeTitle)
        .padding(.horizontal)
    }
}

// TODO:Evan move
let testCityLouisville = City(name: "Louisville", state: "KY", lat: 38.25, lon: -85.76)

let testTimeStamp = 1591650327
let testWeatherInfo = WeatherInfo(main: "Rain", description: "Very Rainy Description", icon: "10d")
let testHourlyTempInfo = HourlyTempInfo(time: testTimeStamp, temp: 88.2553, weather: [testWeatherInfo])
let testCurrentTempInfo = CurrentTempInfo(temp: 99.018, time: testTimeStamp, sunrise: testTimeStamp, sunset: testTimeStamp, weather: [testWeatherInfo])
let testForecast = HourlyForecastResponse(hourly: [testHourlyTempInfo],
                                          current: testCurrentTempInfo,
                                          timezoneOffset: 0)

struct CurrentForecastCell_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            CurrentForecastCell(city: testCityLouisville, forecast: testForecast)
                .frame(maxWidth: .infinity)
                .background(Color.yellow)
        }
    }
}
