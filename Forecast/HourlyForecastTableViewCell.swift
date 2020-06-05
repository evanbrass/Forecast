//
//  HourlyForecastTableViewCell.swift
//  Forecast
//
//  Created by Evan Brass on 6/3/20.
//  Copyright © 2020 Evan Brass. All rights reserved.
//

import UIKit

// TODO:Evan move somewhere else?
protocol ForecastConfigurable: UITableViewCell {
//    func setCityNameText(_ name: String)
    var cityNameLabel: UILabel! { get set }
    func configureWithForecast(_ forecast: HourlyForecastResponse)
}

class HourlyForecastTableViewCell: UITableViewCell, ForecastConfigurable {
    static let reuseID = "HourlyForecastTableViewCell"
    static let preferredHeight: CGFloat = 100
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var forecastStack: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    override func prepareForReuse() {
        for subView in forecastStack.arrangedSubviews {
            subView.removeFromSuperview()
        }
    }
    
    func setup() {
        cityNameLabel.font = .light(.large)
        forecastStack.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5).isActive = true
        forecastStack.distribution = .fillEqually
    }

    func configureWithForecast(_ forecast: HourlyForecastResponse) {
        let label = UILabel(frame: .zero)
        label.text = "\(Int(forecast.current.temp))"
        label.font = .light()
        forecastStack.addArrangedSubview(label)
    }
}
