//
//  HourlyForecastTableViewCell.swift
//  Forecast
//
//  Created by Evan Brass on 6/3/20.
//  Copyright © 2020 Evan Brass. All rights reserved.
//

import UIKit

/// Describes behavior of a tableview cell which can be configured
protocol ForecastConfigurable: UITableViewCell {
    func setCityName(_ name: String?)
    func configureWithForecast(_ forecast: HourlyForecastResponse)
}

class HourlyForecastTableViewCell: UITableViewCell, ForecastConfigurable {
    static let reuseID = "HourlyForecastTableViewCell"
    static let preferredHeight: CGFloat = 120
    @IBOutlet private weak var cityNameLabel: UILabel!
    @IBOutlet private weak var forecastStack: UIStackView!
    @IBOutlet private weak var mainStack: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func prepareForReuse() {
        for subView in forecastStack.arrangedSubviews {
            subView.removeFromSuperview()
        }
    }
    
    private func setupUI() {
        selectionStyle = .none
        mainStack.isLayoutMarginsRelativeArrangement = true
        mainStack.layoutMargins = cellMargins
        cityNameLabel.font = .light(.large)
        forecastStack.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.6).isActive = true
        forecastStack.distribution = .fillEqually
    }
    
    func setCityName(_ name: String?) {
        cityNameLabel.text = name
    }

    func configureWithForecast(_ forecast: HourlyForecastResponse) {
        guard forecastStack.arrangedSubviews.isEmpty else {
            return
        }
        // Add hourly info views
        for tempInfo in forecast.hourly.prefix(7) {
            let infoView = HourlyForecastInfoView(timeStamp: tempInfo.time + forecast.timezoneOffset,
                                                  temp: tempInfo.temp,
                                                  image: tempInfo.weather.first?.image)
            forecastStack.addArrangedSubview(infoView)
        }
    }
}
