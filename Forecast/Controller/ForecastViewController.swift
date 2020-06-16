//
//  ForecastViewController.swift
//  Forecast
//
//  Created by Evan Brass on 6/2/20.
//  Copyright © 2020 Evan Brass. All rights reserved.
//

import UIKit

// TODO:Evan document

/// This view controller is responsible for displaying forecast data for all the available cities.
/// The `cityProvider` and `forecastService` are 2 objects that must be injected to this class.
/// There are 2 display modes, current and hourly (controlled by the `isHourly` property)
/// In "current" mode we only show the current temperature and condition for the city.
/// In "hourly" mode we show the temp and condition for the next 7 hours.
class ForecastViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CityListViewControllerDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    /// Injected
    var cityProvider: CityProviderProtocol!
    var forecastService: ForecastServiceProtocol!
    
    private let refreshControl = UIRefreshControl()
    private var isHourly: Bool = false {
        didSet {
            UserDefaults.standard.set(isHourly, forKey: "isHourly")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        isHourly = UserDefaults.standard.bool(forKey: "isHourly")
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshUI()
    }

    private func setupUI() {
        navigationController?.navigationBar.isHidden = true
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.light(.medium)], for: .normal)
        
        // TableView
        tableView.register(UINib(nibName: "ForecastTableViewCell", bundle: .main),
                           forCellReuseIdentifier: ForecastTableViewCell.reuseID)
        tableView.register(UINib(nibName: "HourlyForecastTableViewCell", bundle: .main),
                           forCellReuseIdentifier: HourlyForecastTableViewCell.reuseID)
        tableView.delegate = self
        tableView.dataSource = self
        
        // Refresh Control
        refreshControl.attributedTitle = NSAttributedString(string: "Refresh Data")
        refreshControl.addTarget(self, action: #selector(pullToRefresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    private func refreshUI() {
        tableView.reloadData()
        segmentedControl.selectedSegmentIndex = isHourly ? 1 : 0
    }

    // MARK: - Actions

    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        isHourly = sender.selectedSegmentIndex == 1
        refreshUI()
    }

    @IBAction func citiesButtonAction(_ sender: Any) {
        navigateToCities()
    }
    
    // MARK: - Navigation
    
    func navigateToCities() {
        let id = "CityListViewController"
        if let viewController = storyboard?.instantiateViewController(withIdentifier: id) as? CityListViewController {
            viewController.cityProvider = cityProvider
            viewController.delegate = self
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func navigateToDetail(city: City) {
        let id = "ForecastDetailViewController"
        if let detailVC = storyboard?.instantiateViewController(identifier: id) as? ForecastDetailViewController {
            detailVC.city = city
            detailVC.forecastService = forecastService
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    @objc private func pullToRefresh(_ sender: AnyObject) {
        forecastService.clearCache()
        refreshUI()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.refreshControl.endRefreshing()
        }
    }
    
    // MARK: - UITableViewDelegate / DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityProvider.cities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id = isHourly ? HourlyForecastTableViewCell.reuseID : ForecastTableViewCell.reuseID
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! ForecastConfigurable
        let city = cityProvider.cities[indexPath.row]
        cell.setCityName(city.name)
        
        // Note 2 things:
        // 1 - The ForecastService will use a cached response if it exists to avoid making the same call twice, so it
        //     is fine to call `getHourlyForecaseForCity` many times for the same city as the data will already be
        //     cached.
        // 2 - With the free Open Weather API license, there is no batch downloading of data, so we have to fetch each
        //     city's data one at a time.  Otherwise it would be nice to make 1 network call on app launch to save some
        //     bandwidth and performance.
        forecastService.getHourlyForecastForCity(city) {(forecast, error) in
            guard error == nil, let forecast = forecast else {
                // We could choose to handle this in a number of ways, but for now, just forgo populating weather data
                return
            }
            DispatchQueue.main.async {
                cell.configureWithForecast(forecast)
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return isHourly ? HourlyForecastTableViewCell.preferredHeight : ForecastTableViewCell.preferredHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = cityProvider.cities[indexPath.row]
        navigateToDetail(city: city)
    }
    
    // MARK: - CityListViewControllerDelegate
    
    func cityListViewControllerDidFinish(cityProvider: CityProviderProtocol) {
        self.cityProvider = cityProvider
        refreshUI()
    }
}

