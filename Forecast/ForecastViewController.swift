//
//  ForecastViewController.swift
//  Forecast
//
//  Created by Evan Brass on 6/2/20.
//  Copyright © 2020 Evan Brass. All rights reserved.
//

import UIKit

class ForecastViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CityListViewControllerDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!

    var cityService: CityProviderProtocol! // TODO:Evan these will go on the view model most likely
    let forecastService = ForecastService() // TODO:Evan inject

    // TODO:Evan read/write to user defaults
    private var isHourly: Bool = false {
        didSet {
            UserDefaults.standard.set(isHourly, forKey: "isHourly")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO:
        forecastService.clearCache()
        isHourly = UserDefaults.standard.bool(forKey: "isHourly")
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshUI()
    }

    private func setupUI() {
        navigationController?.navigationBar.isHidden = true
        // TODO:Evan make strings constants
        
        // TableView
        tableView.register(UINib(nibName: "ForecastTableViewCell", bundle: .main),
                           forCellReuseIdentifier: ForecastTableViewCell.reuseID)
        tableView.register(UINib(nibName: "HourlyForecastTableViewCell", bundle: .main),
                           forCellReuseIdentifier: HourlyForecastTableViewCell.reuseID)
        tableView.delegate = self
        tableView.dataSource = self
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
            viewController.cityProvider = cityService
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
    
    // MARK: - UITableViewDelegate / DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityService.cities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id = isHourly ? HourlyForecastTableViewCell.reuseID : ForecastTableViewCell.reuseID
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! ForecastConfigurable
        let city = cityService.cities[indexPath.row]
        cell.cityNameLabel.text = city.name
        
        forecastService.getHourlyForecastForCity(city) {(forecast, error) in
            guard error == nil else {
                // TODO:Evan handle
                return
            }
            guard let forecast = forecast else {
                // TODO:Evan handle
                return
            }
            // store in memory
            DispatchQueue.main.async {
                if let visible = tableView.indexPathsForVisibleRows, visible.contains(indexPath) {
                    cell.configureWithForecast(forecast)
                }
            }
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return isHourly ? HourlyForecastTableViewCell.preferredHeight : ForecastTableViewCell.preferredHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = cityService.cities[indexPath.row]
        navigateToDetail(city: city)
    }
    
    // MARK: - CityListViewControllerDelegate
    
    func cityListViewControllerDidFinish(dataService: CityProviderProtocol) {
        self.cityService = dataService
        refreshUI()
    }
}

