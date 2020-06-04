//
//  ViewController.swift
//  Forecast
//
//  Created by Evan Brass on 6/2/20.
//  Copyright © 2020 Evan Brass. All rights reserved.
//

import UIKit
import GooglePlaces

protocol CityListViewControllerDelegate: class {
    // TODO:Evan return protocol
    func cityListViewControllerDidFinish(dataService: CityProviderProtocol)
}

class CityListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var cityProvider: CityProviderProtocol! // TODO:Evan inject
    weak var delegate: CityListViewControllerDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ForecastTableViewCell", bundle: .main),
                           forCellReuseIdentifier: ForecastTableViewCell.reuseID)
    }
    

    // Present the Autocomplete view controller when the button is pressed.
    func autocompleteClicked() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
                                                         UInt(GMSPlaceField.placeID.rawValue) |
                                                        UInt(GMSPlaceField.addressComponents.rawValue) |
            UInt(GMSPlaceField.coordinate.rawValue))!
        autocompleteController.placeFields = fields
        
        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .city
        autocompleteController.autocompleteFilter = filter
        
        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
    }
    
    // MARK: - Actions
    
    @IBAction func addCityButtonAction(_ sender: Any) {
        autocompleteClicked()
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        delegate?.cityListViewControllerDidFinish(dataService: cityProvider)
    }
    
    // MARK: - UITableViewDelegate / DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityProvider.cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ForecastTableViewCell.reuseID, for: indexPath) as! ForecastTableViewCell
        let city = cityProvider.cities[indexPath.row]
        cell.cityNameLabel?.text = "\(city.name), \(city.state ?? "")"
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
    
    // TODO:Evan in a business rules class?
    func stateCodeForPlace(_ place: GMSPlace) -> String? {
        var code: String? = nil
        
        if let components = place.addressComponents, components.count > 0 {
            if let state = components.first(where: { $0.types.contains(kGMSPlaceTypeAdministrativeAreaLevel1)}) {
                code = state.shortName ?? state.name
            } else if let country = components.first(where: { $0.types.contains(kGMSPlaceTypeCountry)}) {
                code = country.shortName ?? country.name
            } else {
                code = components.last?.shortName ?? components.last?.name
            }
        }
        return code
    }
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let newCity = City(name: place.name ?? "unknown",
                           state: stateCodeForPlace(place),
                           lat:place.coordinate.latitude,
                           lon: place.coordinate.longitude)
        if !cityProvider.addCity(newCity) {
            // TODO:Evan warn user it's already added, possible not dismiss, so they can keep searching??
        }
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
}

