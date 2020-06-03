//
//  ForecastViewController.swift
//  Forecast
//
//  Created by Evan Brass on 6/2/20.
//  Copyright © 2020 Evan Brass. All rights reserved.
//

import UIKit

class ForecastViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    let dataService = DataService() // TODO:Evan inject

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
    }

    private func setupUI() {
        navigationController?.navigationBar.isHidden = true
        // TODO:Evan make strings constants
        
        // TableView
        tableView.register(UINib(nibName: "ForecastTableViewCell", bundle: .main),
                                forCellReuseIdentifier: "ForecastTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
    }

    @IBAction func currentButtonAction(_ sender: Any) {
        
    }
    
    @IBAction func hourlyButtonAction(_ sender: Any) {
        
    }
    
    @IBAction func citiesButtonAction(_ sender: Any) {
        let viewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "CityListViewController")
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    // MARK: - UITableViewDelegate / DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataService.cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastTableViewCell", for: indexPath) as? ForecastTableViewCell else {
            return UITableViewCell()
        }
        
        cell.cityNameLabel.text = dataService.cities[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ForecastTableViewCell.preferredHeight
    }
    

}
