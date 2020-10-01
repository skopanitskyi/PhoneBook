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
    func updateFavoriteStatus()
    func closeDetailsContact()
    func getContactName() -> String
    func getContactPhone() -> String
    func getContactCity() -> String
    func getContactStreet() -> String
    func getFavoriteStatus() -> Bool
    func getRouteToContact(userCoordinate: CLLocationCoordinate2D,
                           completion: @escaping ((MKRoute?, MKPointAnnotation?) -> Void))
}

class DetailContactViewModel: DetailsContactViewModelProtocol {
    
    // MARK: - Class instances
    
    /// Coordinator
    private let coordinator: DetailsContactCoordinator
    
    /// Contact
    private var contact: Contact
    
    /// Firebase service
    private let firebaseService: FirebaseService
    
    /// Return contact full address
    private var address: String {
        return "\(contact.city), \(contact.street)"
    }
    
    // MARK: - Class constructor
    
    /// Detail contact view model class constructor
    init(coordinator: DetailsContactCoordinator, contact: Contact, firebaseService: FirebaseService) {
        self.coordinator = coordinator
        self.contact = contact
        self.firebaseService = firebaseService
    }
    
    // MARK: - Class methods
    
    /// Update favorite status in firebase and another controllers
    public func updateFavoriteStatus() {
        contact.isFavorite = !contact.isFavorite
        firebaseService.updateContact(name: contact.fullName, favorite: contact.isFavorite)
        coordinator.updateRecentData(contact: contact)
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
                                  completion: @escaping ((MKRoute?, MKPointAnnotation?) -> Void)) {
        
        MapService().getRoute(userCoordinate: userCoordinate,
                                  address: address,
                                  name: contact.fullName) { (direction, anotation) in
            completion(direction, anotation)
        }
    }
}
