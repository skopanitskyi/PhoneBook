//
//  DetailsContactViewModel.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 21.09.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import Foundation
import MapKit

protocol DetailsContactViewModelProtocol {
    var error: ((String?) -> Void)? { get set }
    func updateFavoriteStatus()
    func closeDetailsContact()
    func getContactName() -> String
    func getContactPhone() -> String
    func getContactCity() -> String
    func getContactStreet() -> String
    func getFavoriteStatus() -> Bool
    func getRouteToContact(userCoordinate: CLLocationCoordinate2D,
                           completion: @escaping ((MKRoute, MKPointAnnotation) -> Void))
}

class DetailContactViewModel: DetailsContactViewModelProtocol {
    
    // MARK: - Class instances
    
    /// Used to show error on screen
    public var error: ((String?) -> Void)?
    
    /// Coordinator
    private let coordinator: DetailsContactCoordinator
    
    /// Contact
    private var contact: Contact
    
    /// Service manager
    private let serviceManager: ServiceManager
    
    /// Return contact full address
    private var address: String {
        return "\(contact.city), \(contact.street)"
    }
    
    /// Return contact full name
    private var name: String {
        return contact.fullName
    }
    
    // MARK: - Class constructor
    
    /// Detail contact view model class constructor
    init(coordinator: DetailsContactCoordinator, contact: Contact, serviceManager: ServiceManager) {
        self.coordinator = coordinator
        self.contact = contact
        self.serviceManager = serviceManager
    }
    
    // MARK: - Class methods
    
    /// Update favorite status in firebase and another controllers
    public func updateFavoriteStatus() {
        contact.isFavorite = !contact.isFavorite
        coordinator.updateRecentData(contact: contact)
        let firebaseService = serviceManager.getService(type: FirebaseService.self)
        firebaseService?.updateContact(name: contact.fullName, favorite: contact.isFavorite) { [weak self] result in
            switch result {
            case .success:
                print("Data updated")
            case .failure(let error):
                self?.error?(error.errorDescription)
            }
        }
    }
    
    /// Tells the coordinator to close the details contact screen
    public func closeDetailsContact() {
        coordinator.closeDetailsContact()
    }
    
    /// Return contact full name
    public func getContactName() -> String {
        return contact.fullName
    }
    
    /// Return contact phone number
    public func getContactPhone() -> String {
        return contact.phoneNumber
    }
    
    /// Return contact city
    public func getContactCity() -> String {
        return contact.city
    }
    
    /// Return contact street
    public func getContactStreet() -> String {
        return contact.street
    }
    
    /// Return favorite status
    public func getFavoriteStatus() -> Bool {
        return contact.isFavorite
    }
    
    /// Returns a route to a contact and his annotation
    /// - Parameters:
    ///   - userCoordinate: User current coordinates
    ///   - completion: Contains route and annotation
    public func getRouteToContact(userCoordinate: CLLocationCoordinate2D,
                                  completion: @escaping ((MKRoute, MKPointAnnotation) -> Void)) {
        
        let mapService = serviceManager.getService(type: MapService.self)
        mapService?.getCoordinates(with: address) { [weak self] result in
            switch result {
            case .success(let coordinate):
                self?.calculateRoute(userCoordinate: userCoordinate, contactCoordinate: coordinate) { completion($0, $1) }
            case .failure(let error):
                self?.error?(error.errorDescription)
            }
        }
    }
    
    private func calculateRoute(userCoordinate: CLLocationCoordinate2D,
                                contactCoordinate: CLLocationCoordinate2D,
                                completion: @escaping ((MKRoute, MKPointAnnotation) -> Void)) {
        
        guard let mapService = serviceManager.getService(type: MapService.self) else { return }
        mapService.getRoute(userCoordinate: userCoordinate, contactCoordinate: contactCoordinate) { [unowned self] result in
            switch result {
            case .success(let route):
                let anotation = mapService.getAnotation(coordinate: contactCoordinate, name: self.name)
                completion(route, anotation)
            case .failure(let error):
                self.error?(error.errorDescription)
            }
        }
    }
}
