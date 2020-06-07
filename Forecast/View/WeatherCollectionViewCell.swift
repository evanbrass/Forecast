//
//  WeatherCollectionViewCell.swift
//  Forecast
//
//  Created by Evan Brass on 6/7/20.
//  Copyright © 2020 Evan Brass. All rights reserved.
//

import UIKit

/// This collection view cell is used in the collection view in `ForecastDetailViewController`.  It displays
/// the time, temperature, and condition icon for a forecast
class WeatherCollectionViewCell: UICollectionViewCell {
    private var weatherView = HourlyForecastInfoView(timeStamp: 0, temp: 44, image: nil)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        weatherView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(weatherView)
        NSLayoutConstraint.activate([
            weatherView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            weatherView.topAnchor.constraint(equalTo: contentView.topAnchor),
            weatherView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            weatherView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    func configureWith(timestamp: Int, temp: Int, image: UIImage?) {
        weatherView.timeLabel.text = timeTextForTimeStamp(timestamp)
        weatherView.imageView.image = image
        weatherView.tempLabel.text = "\(temp)"
    }
}
