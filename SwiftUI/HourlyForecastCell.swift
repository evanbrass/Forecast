//
//  HourlyForecastCell.swift
//  Forecast-SwiftUI
//
//  Created by Evan Brass on 6/8/20.
//  Copyright © 2020 Evan Brass. All rights reserved.
//

import SwiftUI

struct HourlyForecastCell: View {
    let city: City
    var forecast: HourlyForecastResponse? = nil
    
    var body: some View {
        VStack(spacing: 4) {
            
            Text(city.name)
                .frame(maxWidth: .infinity, alignment: .leading)

            if forecast != nil {
                HStack {
                    ForEach(forecast!.hourly.prefix(5), id: \.time) { (tempInfo) in
                        VStack(spacing: 0) {
                            // Time label
                            Text(timeTextForTimeStamp(tempInfo.time + self.forecast!.timezoneOffset))
                                .font(.footnote)
                            
                            // Image
                            if tempInfo.weather.first?.image != nil {
                                Image(uiImage: tempInfo.weather.first!.image!)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40, alignment: .center)
                            }
                            
                            // Temp
                            Text("\(Int(tempInfo.temp))º")
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct HourlyForecastCell_Previews: PreviewProvider {
    static var previews: some View {
        HourlyForecastCell(city: testCityLouisville, forecast: testForecast)
    }
}
