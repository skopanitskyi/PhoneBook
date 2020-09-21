//
//  ContactsViewModel.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 01.08.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import UIKit

protocol ContactsViewModelProtocol {
    var updateTableView:(() -> Void)? { get set }
    func fetchContactsData()
    func getContact(at indexPath: IndexPath) -> Contact
    func numberOfRowsInSection(section: Int) -> Int
    func titleForHeaderInSection(section: Int) -> String
    func numberOfSections() -> Int
    func reverse(isAscending: Bool)
    func getFilteredContacts(name: String) -> [Contact]
    func makeCall(at indexPath: IndexPath)
}

class ContactsViewModel: ContactsViewModelProtocol {
    
    private var isAscending = true
    
    public var updateTableView: (() -> Void)?
    
    private var contacts = [[Contact]]()
    
    private let firebaseService: FirebaseService
    
    private let coordinator: ContactsCoordinator
        
    init(firebaseService: FirebaseService, coordinator: ContactsCoordinator) {
        self.firebaseService = firebaseService
        self.coordinator = coordinator
    }
    
    public func fetchContactsData() {
        firebaseService.userSavedData(data: .contacts) { result in
            switch result {
            case .success(let contacts):
                self.createTwoDimensional(array: contacts)
                self.updateTableView?()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    public func getContact(at indexPath: IndexPath) -> Contact {
        return contacts[indexPath.section][indexPath.row]
    }
    
    public func titleForHeaderInSection(section: Int) -> String {
        return contacts[section].first?.fullName.first?.uppercased() ?? ""
    }
    
    public func numberOfRowsInSection(section: Int) -> Int {
        return contacts[section].count
    }
    
    public func numberOfSections() -> Int {
        return contacts.count
    }
    
    private func createTwoDimensional(array: [Contact]) {
        let uniqueCharacters = getUniqueCharacters(contacts: array)
        var index = 0
        
        uniqueCharacters.sorted().forEach { character in
            let contacts = array.filter{ $0.fullName.first == character }
            self.contacts.insert(contacts, at: index)
            index += 1
        }
    }
    
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
    
    public func reverse(isAscending: Bool) {
        if isAscending != self.isAscending {
            contacts.reverse()
            updateTableView?()
            self.isAscending = !self.isAscending
        }
    }
    
    public func getFilteredContacts(name: String) -> [Contact] {
        
        var filteredContacts = [Contact]()
        
        for contact in contacts {
            contact.filter { $0.fullName.lowercased().contains(name) }.forEach { filteredContact in
                filteredContacts.append(filteredContact)
            }
        }
        return filteredContacts
    }
    
    public func makeCall(at indexPath: IndexPath) {
        let contact = getContact(at: indexPath)
        let phoneNumber = contact.phoneNumber.removeWhitespaces()
        if let url = URL(string: "tel://\(phoneNumber)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            coordinator.addToRecent(contact: contact)
        }
    }
}
