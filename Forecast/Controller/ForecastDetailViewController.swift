//
//  ForecastDetailViewController.swift
//  Forecast
//
//  Created by Evan Brass on 6/5/20.
//  Copyright © 2020 Evan Brass. All rights reserved.
//

import UIKit

/// This class shows the forecast details of a selected city.  With more time I would like to modify the collection
/// view to show day details, make a cool background depending on the weather condition, and add some more information.
class ForecastDetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    /// Injected
    var city: City!
    var forecastService: ForecastServiceProtocol!
    private var forecast: HourlyForecastResponse?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
        fetchForecastData()
    }
    
    private func setupUI() {
        // Collection View
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 50, height: 80)
        collectionView.collectionViewLayout = layout
        collectionView.register(WeatherCollectionViewCell.self, forCellWithReuseIdentifier: "WeatherCell")
        collectionView.dataSource = self
        collectionView.delegate = self

        titleLabel.text = city.name
        titleLabel.font = .light(.title)
        
        descriptionLabel.font = .thin(.large)
        
        tempLabel.font = .thin(.yuge)
    }
    
    private func fetchForecastData() {
        forecastService.getHourlyForecastForCity(city, completion: { [weak self] (forecast, error) in
            guard let forecast = forecast, let self = self else {
                assertionFailure("this shouldn't happen, investigate")
                return
            }
            self.forecast = forecast
            DispatchQueue.main.async {
                self.refreshUI(forecast: forecast)
            }
        })
    }
    
    private func refreshUI(forecast: HourlyForecastResponse) {
        descriptionLabel.text = forecast.current.weather.first?.description
        tempLabel.text = " \(Int(forecast.current.temp))º"
        collectionView.reloadData()
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - UICollectionViewDelegate / DataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let forecast = forecast else {
            return 0
        }
        return forecast.hourly.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCell",
                                                      for: indexPath) as! WeatherCollectionViewCell
        let tempInfo = forecast!.hourly[indexPath.row]
        cell.configureWith(timestamp: tempInfo.time + forecast!.timezoneOffset,
                           temp: Int(tempInfo.temp),
                           image: tempInfo.weather.first?.image)
        return cell
    }

}
