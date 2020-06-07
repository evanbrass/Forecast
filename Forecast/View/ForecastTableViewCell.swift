//
//  ForecastTableViewCell.swift
//  Forecast
//
//  Created by Evan Brass on 6/2/20.
//  Copyright © 2020 Evan Brass. All rights reserved.
//

import UIKit


class ForecastTableViewCell: UITableViewCell, ForecastConfigurable {
    static let preferredHeight: CGFloat = 80
    static let reuseID = "ForecastTableViewCell"

    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var cityNameLabel: UILabel!
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var hStack: UIStackView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        selectionStyle = .none
        cityNameLabel.font = .thin(.title)
        temperatureLabel.font = .thin(.title)
        hStack.isLayoutMarginsRelativeArrangement = true
        hStack.layoutMargins = cellMargins
    }
    
    func setCityName(_ name: String?) {
        cityNameLabel.text = name
    }

    func configureWithForecast(_ forecast: HourlyForecastResponse) {
        temperatureLabel.text = "\(Int(forecast.current.temp))"
        iconImageView.image = forecast.current.weather.first?.image
    }

    override func prepareForReuse() {
        temperatureLabel.text = nil
    }

}
