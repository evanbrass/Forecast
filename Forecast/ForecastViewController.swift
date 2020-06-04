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
    var cityService: CityProviderProtocol! // TODO:Evan inject

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if cityService.cities.count > 0 {
            let f = ForecastService()
            f.getCurrentForecastForCity(cityService.cities[0]) { (response, error) in
                // TODO:Evan handle
            }
        }
        setupUI()
    }

    private func setupUI() {
        navigationController?.navigationBar.isHidden = true
        // TODO:Evan make strings constants
        
        // TableView
        tableView.register(UINib(nibName: "ForecastTableViewCell", bundle: .main),
                           forCellReuseIdentifier: ForecastTableViewCell.reuseID)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - Actions

    @IBAction func currentButtonAction(_ sender: Any) {
        
    }
    
    @IBAction func hourlyButtonAction(_ sender: Any) {
        
    }
    
    @IBAction func citiesButtonAction(_ sender: Any) {
        
        if let viewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "CityListViewController") as? CityListViewController {
            viewController.cityProvider = cityService
            viewController.delegate = self
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    // MARK: - UITableViewDelegate / DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityService.cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ForecastTableViewCell.reuseID, for: indexPath) as? ForecastTableViewCell else {
            return UITableViewCell()
        }
        let city = cityService.cities[indexPath.row]
        cell.cityNameLabel?.text = "\(city.name), \(city.state ?? "")"

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ForecastTableViewCell.preferredHeight
    }
    
    // MARK: - CityListViewControllerDelegate
    
    func cityListViewControllerDidFinish(dataService: CityProviderProtocol) {
        self.cityService = dataService
        tableView.reloadData()
    }
}

