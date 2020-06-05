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
        mainStack.isLayoutMarginsRelativeArrangement = true
        mainStack.layoutMargins = cellMargins
        cityNameLabel.font = .light(.large)
        forecastStack.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.6).isActive = true
        forecastStack.distribution = .fillEqually
    }

    func configureWithForecast(_ forecast: HourlyForecastResponse) {
        // Add little view for current
        let currentInfoView = HourlyForecastInfoView(timeStamp: forecast.current.time,
                                                     temp: forecast.current.temp,
                                                     iconURL: forecast.current.weather.first?.iconURL)
        forecastStack.addArrangedSubview(currentInfoView)
        
        // Add hourly info views
        for tempInfo in forecast.hourly.prefix(6) {
            let infoView = HourlyForecastInfoView(timeStamp: tempInfo.time,
                                                  temp: tempInfo.temp,
                                                  iconURL: tempInfo.weather.first?.iconURL)
            forecastStack.addArrangedSubview(infoView)
        }
    }
}

// TODO:Evan move
class HourlyForecastInfoView: UIView {

    init(timeStamp: Int, temp: Double, iconURL: URL?) {
        super.init(frame: .zero)

        // Time Label:
        // TODO:Evan determine time
        let label = UILabel(frame: .zero)
        label.text = "12:34"
        label.font = .thin(.small)
        label.textAlignment = .center
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true

        // ImageView
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.sd_setImage(with: iconURL, completed: nil)
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)

        // TempLabel
        let tempLabel = UILabel(frame: .zero)
        tempLabel.text = "\(Int(temp))"
        tempLabel.font = .thin(.large)
        tempLabel.textAlignment = .center

        // Stack
        let stack = UIStackView(arrangedSubviews: [label, imageView, tempLabel])
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
