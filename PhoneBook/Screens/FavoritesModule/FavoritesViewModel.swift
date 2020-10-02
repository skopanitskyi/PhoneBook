//
//  FavoritesViewModel.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 24.08.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import Foundation

protocol FavoritesViewModelProtocol {
    var updateView: (() -> Void)? { get set }
    var error: ((String?) -> Void)? { get set }
    func fetchFavoritesContacts()
    func numberOfRowsInSection() -> Int
    func remove(at index: Int)
    func move(from: Int, to: Int)
    func getContactName(at index: Int) -> String
    func updateContact(contact: Contact)
    func showDetailsContact(at index: Int)
    func showAddContactController()
}

class FavoritesViewModel: FavoritesViewModelProtocol {
    
    // MARK: - Class instances
    
    /// Used to update data in a table view
    public var updateView: (() -> Void)?
    
    /// Used to show error on screen
    public var error: ((String?) -> Void)?
    
    /// Store favorites contacts
    private var favoritesContacts = [Contact]()
    
    /// Coordinator
    private let coordinator: FavoritesCoordinator
    
    /// Firebase service
    private let firebaseService: FirebaseService
    
    // MARK: - Class constructor
    
    /// Favorites view model class constructor
    init(coordinator: FavoritesCoordinator, firebaseService: FirebaseService) {
        self.coordinator = coordinator
        self.firebaseService = firebaseService
    }
    
    // MARK: - Class methods
    
    /// Get favorites contacts from firebase
    public func fetchFavoritesContacts() {
        firebaseService.getData(for: .favorites) { [weak self] result in
            switch result {
            case.success(let contacts):
                self?.favoritesContacts = contacts
                self?.updateView?()
            case .failure(let error):
                self?.error?(error.errorDescription)
            }
        }
    }
    
    /// Return number of rows in section
    public func numberOfRowsInSection() -> Int {
        return favoritesContacts.count
    }
    
    /// Remove contact from favorites at the specified index
    /// - Parameter index: The index by which the contact will be deleted
    public func remove(at index: Int) {
        let contact = favoritesContacts[index]
        contact.isFavorite = false
        firebaseService.updateContact(name: contact.fullName, favorite: contact.isFavorite)
        coordinator.updateContactData(contact: contact)
        favoritesContacts.remove(at: index)
    }
    
    /// Moves a contact to a new index
    /// - Parameters:
    ///   - from: The index from which the contact will be moved
    ///   - to: The index to which the contact will be moved
    public func move(from: Int, to: Int) {
        let contact = favoritesContacts.remove(at: from)
        favoritesContacts.insert(contact, at: to)
        updateFavoritesContactsInFirebase()
    }
    
    /// Return contact full name
    /// - Parameter index: Contact index
    public func getContactName(at index: Int) -> String {
        return favoritesContacts[index].fullName
    }
    
    /// Update  data of the changed contact
    /// - Parameter contact: Received contact with new data
    public func updateContact(contact: Contact) {
        if contact.isFavorite {
            favoritesContacts.insert(contact, at: 0)
            updateFavoritesContactsInFirebase()
        } else {
            guard let index = favoritesContacts.firstIndex (where: { $0.fullName == contact.fullName }) else { return }
            favoritesContacts.remove(at: index)
        }
        updateView?()
    }
    
    /// Update favorites contacts in firebase
    private func updateFavoritesContactsInFirebase() {
        firebaseService.updateAllContacts(for: .favorites, contacts: favoritesContacts) { [weak self] result in
            switch result {
            case .success:
                print("Data saved")
            case .failure(let error):
                if let title = error.errorDescription {
                    self?.error?(title)
                }
            }
        }
    }
    
    /// Tells coordinator to display details contact screen
    /// - Parameter index: Index of contact which data will be display
    public func showDetailsContact(at index: Int) {
        coordinator.showDetailsContact(contact: favoritesContacts[index])
    }
    
    /// Tells coordinator to display add contact screen
    public func showAddContactController() {
        coordinator.showAddContactController()
    }
}
