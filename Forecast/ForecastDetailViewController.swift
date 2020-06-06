//
//  ForecastDetailViewController.swift
//  Forecast
//
//  Created by Evan Brass on 6/5/20.
//  Copyright © 2020 Evan Brass. All rights reserved.
//

import UIKit

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
//        weatherView.alpha = 0
    }

    func configureWith(timestamp: Int, temp: Int, image: UIImage?) {
        weatherView.timeLabel.text = timeTextForTimeStamp(timestamp)
        weatherView.imageView.image = image
        weatherView.tempLabel.text = "\(temp)"
//        weatherView.alpha = 1
    }
    
    override func prepareForReuse() {
//        weatherView.alpha = 0
    }
}

class ForecastDetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    // Explicity unwrapping these so we crash if we forgot to inject them
    var city: City!
    var forecastService: ForecastService!
    private var forecast: HourlyForecastResponse?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    private func setupUI() {
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCell", for: indexPath) as! WeatherCollectionViewCell
        let tempInfo = forecast!.hourly[indexPath.row]
        cell.configureWith(timestamp: tempInfo.time + forecast!.timezoneOffset,
                           temp: Int(tempInfo.temp),
                           image: tempInfo.weather.first?.image)
        return cell
    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 60, height: 80)
//    }
    

    

}
