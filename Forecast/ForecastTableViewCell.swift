//
//  ForecastTableViewCell.swift
//  Forecast
//
//  Created by Evan Brass on 6/2/20.
//  Copyright © 2020 Evan Brass. All rights reserved.
//

import UIKit
import SDWebImage

class ForecastTableViewCell: UITableViewCell, ForecastConfigurable {
    static let preferredHeight: CGFloat = 80
    static let reuseID = "ForecastTableViewCell"

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var hStack: UIStackView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    private func setup() {
        cityNameLabel.font = .thin(.title)
        temperatureLabel.font = .thin(.title)
        hStack.isLayoutMarginsRelativeArrangement = true
        hStack.layoutMargins = cellMargins
    }

    func configureWithForecast(_ forecast: HourlyForecastResponse) {
        temperatureLabel.text = "\(Int(forecast.current.temp))"
        iconImageView.image = forecast.current.weather.first?.image
//        iconImageView.sd_setImage(with: forecast.current.weather.first?.iconURL, completed: nil)
    }

    override func prepareForReuse() {
        // TODO:Evan Cancel download task
        temperatureLabel.text = nil
    }

}
