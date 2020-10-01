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
    
    // MARK: - Class instances
    
    /// Reuse identifier for anotation
    private let reuseIdentifier = "anotation"
    
    /// Distance in meters from the current location
    private let distance: CLLocationDistance = 5000
    
    /// Is contact favorite
    private var isFavorite: Bool?
    
    /// Location manager
    private let locationManager = CLLocationManager()
    
    /// View model
    public var viewModel: DetailsContactViewModelProtocol?
    
    // MARK: - Outlet
    
    /// Data name labels
    
    @IBOutlet weak var nameLocalization: UILabel!
    @IBOutlet weak var phoneLocalization: UILabel!
    @IBOutlet weak var cityLocalization: UILabel!
    @IBOutlet weak var streetLocalization: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    /// Data labels
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var street: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Class life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localization()
        setInformation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupMapView()
    }
    
    // MARK: - Actions
    
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        changeFavoriteStatus()
        viewModel?.updateFavoriteStatus()
    }
    
    @IBAction func cancellButtonTapped(_ sender: Any) {
        viewModel?.closeDetailsContact()
    }
    
    // MARK: - Class methods
    
    /// Change  favorite status and favorite status image
    private func changeFavoriteStatus() {
        guard let favoriteStatus = isFavorite else { return }
        isFavorite = !favoriteStatus
        changeFavoriteStatusImage()
    }
    
    /// Localize view
    private func localization() {
        nameLocalization.text = "DetailsProfile.Name".localized
        phoneLocalization.text = "DetailsProfile.Phone".localized
        cityLocalization.text = "DetailsProfile.City".localized
        streetLocalization.text = "DetailsProfile.Street".localized
    }
    
    /// Set user data
    private func setInformation() {
        name.text = viewModel?.getContactName()
        phone.text = viewModel?.getContactPhone()
        city.text = viewModel?.getContactCity()
        street.text = viewModel?.getContactStreet()
        isFavorite = viewModel?.getFavoriteStatus()
        changeFavoriteStatusImage()
    }
    
    /// Change image for favorite status
    private func changeFavoriteStatusImage() {
        if isFavorite! {
            favoriteButton.setImage(UIImage(named: "Icon-Small"), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(named: "Icon-Small-1"), for: .normal)
        }
    }
    
    /// Setup map view
    private func setupMapView() {
        
        let isLocationEnabled = CLLocationManager.locationServicesEnabled()
        
        if isLocationEnabled {
            mapView.delegate = self
            setupLocationManager()
            checkAutorization()
        } else {
            applicationDoesntHaveUserLocaction()
        }
    }
    
    /// Setup location manager
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    /// Check authorization status
    private func checkAutorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
            showUserLocation()
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
            showUserLocation()
        case .denied:
            applicationDoesntHaveUserLocaction()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        @unknown default:
            fatalError()
        }
    }
    
    /// Show the user geolocation if available. If the location could not be retrieved, it displays an error
    private func showUserLocation() {
        if let coordinate = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: coordinate,
                                            latitudinalMeters: distance,
                                            longitudinalMeters: distance)
            mapView.setRegion(region, animated: true)
        } else {
            showAlert(title: "DetailsProfile.AlertTitile.FailedToShowLocation".localized,
                      message: nil,
                      leftButton: "DetailsProfile.LeftButton.FailedToShowLocation".localized,
                      rightButton: nil,
                      cancel: false,
                      style: .alert,
                      completion: nil)
        }
    }
    
    /// Displays that the application does not have access to the location and asks to enable it
    private func applicationDoesntHaveUserLocaction() {
        showAlert(title: "DetailsProfile.AlertTitile.NoGeolocation".localized,
                  message: "DetailsProfile.AlertMessage.NoGeolocation".localized,
                  leftButton: "DetailsProfile.LeftButton.NoGeolocation".localized,
                  rightButton: "DetailsProfile.RightButton.NoGeolocation".localized,
                  cancel: false,
                  style: .alert) { isAccess in
            if let url = URL(string: UIApplication.openSettingsURLString), isAccess {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension DetailsContactViewController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkAutorization()
    }
}

// MARK: - MKMapViewDelegate

extension DetailsContactViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var viewMarker: MKMarkerAnnotationView
        
        if let view = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? MKMarkerAnnotationView {
            view.annotation = annotation
            viewMarker = view
        } else {
            viewMarker = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
        }
        return viewMarker
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        guard let coordinate = locationManager.location?.coordinate else { return }
        
        viewModel?.getRouteToContact(userCoordinate: coordinate) { [weak self] (route, anotation) in
            guard let self = self, let route = route, let anotation = anotation else { return }
            self.mapView.removeOverlays(self.mapView.overlays)
            self.mapView.addAnnotation(anotation)
            self.mapView.addOverlay(route.polyline)
            
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay)
        render.strokeColor = .blue
        render.lineWidth = 5
        return render
    }
}
