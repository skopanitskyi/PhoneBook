//
//  DetailsContactViewController.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 21.09.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import UIKit
import MapKit

class DetailsContactViewController: UITableViewController {
    
    @IBOutlet weak var nameLocalization: UILabel!
    @IBOutlet weak var phoneLocalization: UILabel!
    @IBOutlet weak var cityLocalization: UILabel!
    @IBOutlet weak var streetLocalization: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var street: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
    private var isFavorite: Bool?
    
    private let locationManager = CLLocationManager()
    
    
    public var viewModel: DetailsContactViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localization()
        setInformation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setup()
    }
    
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        changeImage()
        viewModel?.updateFavoriteStatus()
    }
    
    @IBAction func cancellButtonTapped(_ sender: Any) {
        viewModel?.closeDetailsContact()
    }
    
    private func changeImage() {
        guard let favoriteStatus = isFavorite else { return }
        isFavorite = !favoriteStatus
        setupImage()
    }
    
    private func localization() {
        nameLocalization.text = "DetailsProfile.Name".localized
        phoneLocalization.text = "DetailsProfile.Phone".localized
        cityLocalization.text = "DetailsProfile.City".localized
        streetLocalization.text = "DetailsProfile.Street".localized
    }
    
    private func setInformation() {
        name.text = viewModel?.getContactName()
        phone.text = viewModel?.getContactPhone()
        city.text = viewModel?.getContactCity()
        street.text = viewModel?.getContactStreet()
        isFavorite = viewModel?.getFavoriteStatus()
        setupImage()
    }
    
    private func setupImage() {
        if isFavorite! {
            favoriteButton.setImage(UIImage(named: "Icon-Small"), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(named: "Icon-Small-1"), for: .normal)
        }
    }
    
    private func setup() {
        
        let isLocationEnabled = CLLocationManager.locationServicesEnabled()
        
        if isLocationEnabled {
            setupLocationManadger()
            checkAutorization()
        } else {
            // Show alert controller
        }
    }
    
    private func setupLocationManadger() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    private func checkAutorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
        case .denied:
            // Show alert controller
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        }
    }
}
extension DetailsContactViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last?.coordinate {
            let region = MKCoordinateRegion(center: location, latitudinalMeters: 5000, longitudinalMeters: 5000)
            self.mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkAutorization()
    }
    
}
