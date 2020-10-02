//
//  RecentViewModel.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 08.08.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import Foundation

protocol RecentViewModelProtocol {
    var updateView: (() -> Void)? { get set }
    var error: ((String?) -> Void)? { get set }
    func numberOfRowsInSection() -> Int
    func getContactName(at index: Int) -> String
    func addToRecent(contact: Contact)
    func deleteContact(at index: Int)
    func deleteAllContacts()
    func downloadData()
    func showDetailsContact(at index: Int)
    func updateDataInFirebase()
    func updateContactData(contact: Contact)
}

class RecentViewModel: RecentViewModelProtocol {
    
    // MARK: - Class instances
    
    /// Used to update data in a table view
    public var updateView: (() -> Void)?
    
    /// Used to show error on screen
    public var error: ((String?) -> Void)?
    
    /// Stores recent contacts
    private var contacts = [Contact]()
    
    /// Firebase service
    private let firebaseService: FirebaseService
    
    /// Coordinator
    private let coordinator: RecentCoordinator
    
    // MARK: - Class constructor
    
    /// Recent view model class constructor
    init(coordinator: RecentCoordinator, firebaseService: FirebaseService) {
        self.coordinator = coordinator
        self.firebaseService = firebaseService
    }
    
    // MARK: - Class methods
    
    /// Return number of rows in section
    public func numberOfRowsInSection() -> Int {
        return contacts.count
    }
    
    /// Return contact name
    /// - Parameter index: Contact index
    public func getContactName(at index: Int) -> String {
        return contacts[index].fullName
    }
    
    /// Adds the specified contact to recent
    /// - Parameter contact: The contact to be added to recent
    public func addToRecent(contact: Contact) {
        contacts.insert(contact, at: 0)
        updateDataInFirebase()
        updateView?()
    }
    
    /// Removes a contact from recent at the specified index
    /// - Parameter index: The index by which the contact will be deleted
    public func deleteContact(at index: Int) {
        contacts.remove(at: index)
        updateDataInFirebase()
    }
    
    /// Removes all contacts from recent
    public func deleteAllContacts() {
        contacts.removeAll()
        updateDataInFirebase()
        updateView?()
    }
    
    /// Download recent contacts data from firebase
    public func downloadData() {
        firebaseService.getData(for: .recent) { [weak self] result in
            switch result {
            case .success(let contacts):
                self?.contacts = contacts
                self?.updateView?()
            case .failure(let error):
                self?.error?(error.errorDescription)
            }
        }
    }
    
    /// Update contact recent data in firebase
    public func updateDataInFirebase() {
        firebaseService.updateAllContacts(for: .recent, contacts: contacts) { [weak self] result in
            switch result {
            case.success:
                print("Data saved")
            case .failure(let error):
                self?.error?(error.errorDescription)
            }
        }
    }
    
    /// Tells the coordinator to display details contact screen
    /// - Parameter index: Index of contact which data will be display
    public func showDetailsContact(at index: Int) {
        coordinator.showDetailsContacts(contact: contacts[index])
    }
    
    /// Refreshes data between stored contact and received
    /// - Parameter contact: Received contact with new data
    func updateContactData(contact: Contact) {
        for recentContact in contacts {
            if recentContact.fullName == contact.fullName {
                recentContact.isFavorite = contact.isFavorite
            }
        }
    }
}
