//
//  ForecastListCell.swift
//  Forecast-SwiftUI
//
//  Created by Evan Brass on 6/9/20.
//  Copyright © 2020 Evan Brass. All rights reserved.
//

import SwiftUI

struct ForecastListCell: View {
    // TODO: don't know a better way to do this at the moment - tried various experiments with buggy results
    // when trying to set the frame of the HStack below to always be the width of the parent view
    // We have to use a geometry reader and pass it in... don't like this
    // Was the only way to get the city name font to work properly with min scale factor.
    let width: CGFloat
    
    let cityName: String
    let isHourly: Bool
    var forecast: HourlyForecastResponse?

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(cityName)
                    .animatableFont(size: isHourly ? 20 : 40)
                    .minimumScaleFactor(0.2)
                    .animation(Animation.easeInOut(duration: 0.2))

                Spacer()

                if forecast != nil {
                    Text("\(Int(forecast!.current.temp))º")
                        .scaleEffect(isHourly ? 0.5 : 1.0, anchor: .trailing)
                        .opacity(isHourly ? 0 : 1.0)
                }
            }
            .frame(width: width, height: 40)
            .font(.largeTitle)
            .background(Color.white)
            .zIndex(10)
            
            if forecast != nil {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(forecast!.hourly.prefix(12), id: \.time) { (tempInfo) in
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
                            .scaleEffect(self.isHourly ? CGSize(width: 1, height: 1) : CGSize(width: 0.5, height: 0.2), anchor: .top)
                            .offset(x: 1, y: self.isHourly ? 0.0 : -20)
                        }
                    }
                }
                .frame(maxHeight: isHourly ? .infinity : 0)
                .zIndex(1)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

