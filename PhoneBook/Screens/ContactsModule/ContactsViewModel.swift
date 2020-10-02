//
//  ContactsViewModel.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 01.08.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import UIKit

protocol ContactsViewModelProtocol {
    var isFiltering: Bool { get set }
    var updateTableView:(() -> Void)? { get set }
    var error: ((String?) -> Void)? { get set }
    func fetchContactsData()
    func getContact(at indexPath: IndexPath) -> Contact
    func numberOfRowsInSection(section: Int) -> Int
    func titleForHeaderInSection(section: Int) -> String?
    func numberOfSections() -> Int
    func reverse(isAscending: Bool)
    func getFilteredContacts(name: String)
    func makeCall(at indexPath: IndexPath)
    func updateContact(contact: Contact)
}

class ContactsViewModel: ContactsViewModelProtocol {
    
    // MARK: - Class instances
    
    /// Stores a value that indicates whether a contact is currently being searched for in the table
    public var isFiltering = false
    
    /// Stores the value of how the table is currently sorted
    private var isAscending = true
    
    /// Used to update data in a table view
    public var updateTableView: (() -> Void)?
    
    /// Used to show error on screen
    public var error: ((String?) -> Void)?
    
    /// Stores all contacts
    private var contacts = [[Contact]]()
    
    /// Stores sorted contacts
    private var filteredContacts = [[Contact]]()
    
    /// Firebase service
    private let firebaseService: FirebaseService
    
    /// Coordinator
    private let coordinator: ContactsCoordinator
    
    // MARK: - Class constructor
    
    init(firebaseService: FirebaseService, coordinator: ContactsCoordinator) {
        self.firebaseService = firebaseService
        self.coordinator = coordinator
    }
    
    // MARK: - Class methods
    
    /// Requests saved contact data from firebase
    public func fetchContactsData() {
        firebaseService.getData(for: .contacts) { [weak self] result in
            switch result {
            case .success(let contacts):
                self?.createTwoDimensional(array: contacts)
                self?.updateTableView?()
            case .failure(let error):
                self?.error?(error.errorDescription)
            }
        }
    }
    
    /// Returns the contact at the specified index path
    /// - Parameter indexPath: Index path by which the contact will be received
    public func getContact(at indexPath: IndexPath) -> Contact {
        return isFiltering ? filteredContacts[indexPath.section][indexPath.row] :
                             contacts[indexPath.section][indexPath.row]
                             
    }
    
    /// Returns title for the header for a specific section
    /// - Parameter section: Index of the section for which the title will be returned
    public func titleForHeaderInSection(section: Int) -> String? {
        return isFiltering ? filteredContacts[section].first?.fullName.first?.uppercased() :
                             contacts[section].first?.fullName.first?.uppercased()
    }
    
    /// Returns number of rows for a specific section
    /// - Parameter section: Index of the section for which number of rows will be returned
    public func numberOfRowsInSection(section: Int) -> Int {
        return isFiltering ? filteredContacts[section].count : contacts[section].count
    }
    
    /// Returns number number of sections
    public func numberOfSections() -> Int {
        return isFiltering ? filteredContacts.count : contacts.count
    }
    
    /// Creates a two-dimensional array from an array
    /// - Parameter array: Array to be converted a two-dimensional
    private func createTwoDimensional(array: [Contact]) {
        let uniqueCharacters = getUniqueCharacters(contacts: array)
        var index = 0
        
        uniqueCharacters.sorted().forEach { [weak self] character in
            let contacts = array.filter{ $0.fullName.first == character }
            self?.contacts.insert(contacts, at: index)
            index += 1
        }
    }
    
    /// Returns an array of all possible first characters of contact names
    /// - Parameter contacts: Contacts from which characters will be obtained
    private func getUniqueCharacters(contacts: [Contact]) -> [Character] {
        var characters = [Character]()
        
        for contact in contacts {
            if let character = contact.fullName.first {
                if !characters.contains(character) {
                    characters.append(character)
                }
            }
        }
        return characters
    }

    /// Sorts the array in the opposite direction if the selected sort differs from the current one
    /// - Parameter isAscending: Ascending sorting selected
    public func reverse(isAscending: Bool) {
        if isAscending != self.isAscending {
            contacts.reverse()
            updateTableView?()
            self.isAscending = isAscending
        }
    }
    
    /// Filters contacts by a given name and stores them in the appropriate array
    /// - Parameter name: Name by which contacts will be filtered
    public func getFilteredContacts(name: String) {
        var index = 0
        filteredContacts.removeAll()
        
        for contact in contacts {
            let filtered = contact.filter { $0.fullName.lowercased().contains(name) }
            if filtered.count > 0 {
                filteredContacts.insert(filtered, at: index)
                index += 1
            }
        }
        updateTableView?()
    }
    
    /// Calls the selected contact and adds them to recent
    /// - Parameter indexPath: Index path selected contact
    public func makeCall(at indexPath: IndexPath) {
        let contact = getContact(at: indexPath)
        let phoneNumber = contact.phoneNumber.removeWhitespaces()
        if let url = URL(string: "tel://\(phoneNumber)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            coordinator.addToRecent(contact: contact)
        }
    }
    
    /// Refreshes data between stored contact and received
    /// - Parameter contact: Received contact with new data
    public func updateContact(contact: Contact) {
        for i in 0..<contacts.count {
            for j in 0..<contacts[i].count {
                if contacts[i][j].fullName == contact.fullName {
                    contacts[i][j].isFavorite = contact.isFavorite
                    break
                }
            }
        }
    }
}
