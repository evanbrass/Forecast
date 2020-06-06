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
    var cityNameLabel: UILabel! { get set }
    func configureWithForecast(_ forecast: HourlyForecastResponse)
}

class HourlyForecastTableViewCell: UITableViewCell, ForecastConfigurable {
    static let reuseID = "HourlyForecastTableViewCell"
    static let preferredHeight: CGFloat = 120
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var forecastStack: UIStackView!
    @IBOutlet weak var mainStack: UIStackView!
    
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
        selectionStyle = .none
        mainStack.isLayoutMarginsRelativeArrangement = true
        mainStack.layoutMargins = cellMargins
        cityNameLabel.font = .light(.large)
        forecastStack.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.6).isActive = true
        forecastStack.distribution = .fillEqually
    }

    func configureWithForecast(_ forecast: HourlyForecastResponse) {
        // Add hourly info views
        for tempInfo in forecast.hourly.prefix(7) {
            let infoView = HourlyForecastInfoView(timeStamp: tempInfo.time + forecast.timezoneOffset,
                                                  temp: tempInfo.temp,
                                                  image: tempInfo.weather.first?.image)
            forecastStack.addArrangedSubview(infoView)
        }
    }
}

// TODO:Evan move
class HourlyForecastInfoView: UIView {
    var timeLabel = UILabel(frame: .zero)
    var imageView = UIImageView(frame: .zero)
    var tempLabel = UILabel(frame: .zero)

    init(timeStamp: Int, temp: Double, image: UIImage?) {
        super.init(frame: .zero)
        
        // Time Label:
        timeLabel.text = timeTextForTimeStamp(timeStamp)
        timeLabel.font = .thin(.small)
        timeLabel.textAlignment = .center
        timeLabel.minimumScaleFactor = 0.5
        timeLabel.adjustsFontSizeToFitWidth = true

        // ImageView
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)

        // TempLabel
        tempLabel.text = "\(Int(temp))"
        tempLabel.font = .thin(.large)
        tempLabel.textAlignment = .center

        // Stack
        let stack = UIStackView(arrangedSubviews: [timeLabel, imageView, tempLabel])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        
        // Constraints
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
