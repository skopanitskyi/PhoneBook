//
//  DetailsContactViewModel.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 21.09.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import Foundation

protocol DetailsContactViewModelProtocol {
    func updateFavoriteStatus()
    func closeDetailsContact()
    func getContactName() -> String
    func getContactPhone() -> String
    func getContactCity() -> String
    func getContactStreet() -> String
    func getFavoriteStatus() -> Bool
}

class DetailContactViewModel: DetailsContactViewModelProtocol {
    
    private let coordinator: DetailsContactCoordinator
    private var contact: Contact
    private let firebaseService: FirebaseService
    
    init(coordinator: DetailsContactCoordinator, contact: Contact, firebaseService: FirebaseService) {
        self.coordinator = coordinator
        self.contact = contact
        self.firebaseService = firebaseService
    }
    
    public func updateFavoriteStatus() {
        contact.isFavorite = !contact.isFavorite
        coordinator.updateRecentData()
    }
    
    public func closeDetailsContact() {
        coordinator.closeDetailsContact()
    }
    
    public func getContactName() -> String {
        return contact.fullName
    }
    
    public func getContactPhone() -> String {
        return contact.phoneNumber
    }
    
    public func getContactCity() -> String {
        return contact.city
    }
    
    public func getContactStreet() -> String {
        return contact.street
    }
    
    public func getFavoriteStatus() -> Bool {
        return contact.isFavorite
    }
}
