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
    
    /// Distance in meters from the current location
    private let distance: CLLocationDistance = 500
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var street: UILabel!
    @IBOutlet weak var logOutButton: UIButton!
    
    public var viewModel: ProfileViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localizable()
        setPointOnMap()
        setUserData()
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        viewModel?.logout()
    }
    
    private func localizable() {
        title = "Profile.Title".localized
        name.text = "Profile.FullNameLabel".localized
        city.text = "Profile.CityLabel".localized
        street.text = "Profile.StreetLabel".localized
        logOutButton.setTitle("Profile.LogOutButton".localized, for: .normal)
    }
    
    private func setPointOnMap() {
        
        viewModel?.getCoordinates { coordinates in
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
    
    private func setUserData() {
        nameLabel.text = viewModel?.getUserName()
        cityLabel.text = viewModel?.getUserCity()
        streetLabel.text = viewModel?.getUserStreet()
    }
}

