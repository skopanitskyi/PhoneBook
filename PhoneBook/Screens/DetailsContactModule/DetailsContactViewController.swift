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
            // Show alert controller
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
            break
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
            
            let region = MKCoordinateRegion(center: locationManager.location!.coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
            
            mapView.setRegion(region, animated: true)
        case .denied:
            // Show alert controller
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        @unknown default:
            fatalError()
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
        
        let adress = "\(viewModel!.getContactCity()) \(viewModel!.getContactStreet())"
        
        MapService().getCoordinates(with: adress) { [weak self] contactCoordinate in
            
            let start = MKPlacemark(coordinate: coordinate)
            let end = MKPlacemark(coordinate: contactCoordinate!)
            
            let anotation = MKPointAnnotation()
            anotation.coordinate = contactCoordinate!
            anotation.title = self?.viewModel!.getContactName()
            
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: start)
            request.destination = MKMapItem(placemark: end)
            request.transportType = .automobile
            
            let direction = MKDirections(request: request)
            direction.calculate { (result, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                self?.mapView.addAnnotation(anotation)
                self?.mapView.removeOverlays(self!.mapView.overlays)
                self?.mapView.addOverlay(result!.routes.first!.polyline)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay)
        render.strokeColor = .blue
        render.lineWidth = 5
        return render
    }
}
