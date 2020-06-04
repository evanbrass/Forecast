//
//  ForecastTableViewCell.swift
//  Forecast
//
//  Created by Evan Brass on 6/2/20.
//  Copyright © 2020 Evan Brass. All rights reserved.
//

import UIKit
import SDWebImage

class ForecastTableViewCell: UITableViewCell {
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
    
    // TODO:Evan change to viewModel?
    func configureWithCity(city: City, forecastService: ForecastService) {
        cityNameLabel.text = "\(city.name)  "
        forecastService.getCurrentForecastForCity(city) { [weak self] (forecast, error) in
            guard error == nil else {
                // TODO:Evan handle
                assertionFailure()
                return
            }
            if let temp = forecast?.info.temp {
                DispatchQueue.main.async {
                    self?.temperatureLabel.text = "\(Int(temp))"
                    // TODO:Evan need a function to determine weather it's daytime or nightime in city
                    self?.iconImageView.sd_setImage(with: forecast?.weather.first?.iconURL, completed: nil)
                }
            }
        }
    }
    
    override func prepareForReuse() {
        // TODO:Evan Cancel download task
        temperatureLabel.text = nil
    }

}
