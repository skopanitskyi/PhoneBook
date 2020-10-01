//
//  ProfileViewController.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 24.08.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import UIKit
import MapKit

class ProfileViewController: UITableViewController {
    
    // MARK: - Class instances
    
    /// Distance in meters from the current location
    private let distance: CLLocationDistance = 500
    
    /// View model
    public var viewModel: ProfileViewModelProtocol?
    
    // MARK: - Outlets
    
    /// Data labels
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    /// Data name labels
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var street: UILabel!
    @IBOutlet weak var logOutButton: UIButton!
    
    // MARK: - Class life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localizable()
        setPointOnMap()
        setUserData()
        showError()
        updateUserData()
    }
    
    // MARK: - Actions
    
    @IBAction func logoutTapped(_ sender: Any) {
        viewModel?.logout()
    }
    
    // MARK: - Class methods
    
    /// Localiza data name labels
    private func localizable() {
        title = "Profile.Title".localized
        name.text = "Profile.FullNameLabel".localized
        city.text = "Profile.CityLabel".localized
        street.text = "Profile.StreetLabel".localized
        logOutButton.setTitle("Profile.LogOutButton".localized, for: .normal)
    }
    
    /// Set annotation at the user address
    private func setPointOnMap() {
        viewModel?.getCoordinates { [weak self] coordinates in
            guard let self = self else { return }
            
            if let coordinates = coordinates {
                let anotation = MKPointAnnotation()
                let region = MKCoordinateRegion(center: coordinates,
                                                latitudinalMeters: self.distance,
                                                longitudinalMeters: self.distance)
                anotation.coordinate = coordinates
                self.mapView.setRegion(region, animated: true)
                self.mapView.addAnnotation(anotation)
            }
        }
    }
    
    /// Displays an error if it appears
    private func showError() {
        viewModel?.error = { [weak self] message in
            self?.showError(message: message)
        }
    }
    
    /// Update user data
    private func updateUserData() {
        viewModel?.updateData = { [weak self] in
            self?.setPointOnMap()
            self?.setUserData()
        }
    }
    
    /// Set user data
    private func setUserData() {
        nameLabel.text = viewModel?.getUserName()
        cityLabel.text = viewModel?.getUserCity()
        streetLabel.text = viewModel?.getUserStreet()
    }
}

