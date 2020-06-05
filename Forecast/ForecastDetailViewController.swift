//
//  ForecastDetailViewController.swift
//  Forecast
//
//  Created by Evan Brass on 6/5/20.
//  Copyright © 2020 Evan Brass. All rights reserved.
//

import UIKit

class ForecastDetailViewController: UIViewController {
    // Explicity unwrapping these so we crash if we forgot to inject them
    var city: City!
    var forecastService: ForecastService!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    private func setupUI() {
        titleLabel.text = city.name
        titleLabel.font = .light(.title)
        descriptionLabel.font = .thin(.large)
        tempLabel.font = .thin(.yuge)
        
        forecastService.getHourlyForecastForCity(city, completion: { [weak self] (forecast, error) in
            guard let forecast = forecast, let self = self else {
                assertionFailure("this shouldn't happen, investigate")
                return
            }
            DispatchQueue.main.async {
                self.refreshUI(forecast: forecast)
            }
        })
    }
    
    private func refreshUI(forecast: HourlyForecastResponse) {
        descriptionLabel.text = forecast.current.weather.first?.description
        tempLabel.text = " \(Int(forecast.current.temp))º"
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    

}
