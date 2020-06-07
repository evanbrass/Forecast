//
//  ViewController.swift
//  Forecast
//
//  Created by Evan Brass on 6/2/20.
//  Copyright © 2020 Evan Brass. All rights reserved.
//

import UIKit
import GooglePlaces

/// A simple protocol for the delegate of the CityListViewController class
protocol CityListViewControllerDelegate: class {
    /// Fired when the `CityListViewController` is finished and passes back a city provider.
    func cityListViewControllerDidFinish(cityProvider: CityProviderProtocol)
}

/// The purpose of this class is to display a list of cities that the app is using.  Within this view controller we can
/// edit the city list by adding cities or swiping left to delete a city.  With more time it would be cool to update
/// this to include re-ordering of the cities.
class CityListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var cityProvider: CityProviderProtocol!
    weak var delegate: CityListViewControllerDelegate?
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ForecastTableViewCell", bundle: .main),
                           forCellReuseIdentifier: ForecastTableViewCell.reuseID)
    }

    private func presentGooglePlacesViewController() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
                                                            UInt(GMSPlaceField.placeID.rawValue) |
                                                            UInt(GMSPlaceField.addressComponents.rawValue) |
                                                            UInt(GMSPlaceField.coordinate.rawValue) )!
        autocompleteController.placeFields = fields
        
        // Filter on cities
        let filter = GMSAutocompleteFilter()
        filter.type = .city
        autocompleteController.autocompleteFilter = filter
        
        present(autocompleteController, animated: true, completion: nil)
    }
    
    private func addCity(_ city: City) {
        guard cityProvider.addCity(city) else {
            return
        }
        tableView.reloadData()
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }

    // MARK: - Actions
    
    @IBAction func addCityButtonAction(_ sender: Any) {
        presentGooglePlacesViewController()
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        delegate?.cityListViewControllerDidFinish(cityProvider: cityProvider)
    }
    
    // MARK: - UITableViewDelegate / DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityProvider.cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id = ForecastTableViewCell.reuseID
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! ForecastTableViewCell
        let city = cityProvider.cities[indexPath.row]
        cell.setCityName("\(city.name), \(city.state ?? "")")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ForecastTableViewCell.preferredHeight
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let city = cityProvider.cities[indexPath.row]
            cityProvider.deleteCity(city)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

extension CityListViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let newCity = City(name: place.name ?? "unknown",
                           state: stateCodeForPlace(place),
                           lat:place.coordinate.latitude,
                           lon: place.coordinate.longitude)
        addCity(newCity)
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // In a real world setting we would want to handle this error by presenting some feedback to the user
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
}

