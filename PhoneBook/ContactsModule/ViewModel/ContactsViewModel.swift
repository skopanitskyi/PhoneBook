//
//  ContactsViewModel.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 01.08.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import Foundation

protocol ContactsViewModelProtocol {
    var updateTableView:(() -> Void)? { get set }
    func fetchContactsData()
    func getContact(at indexPath: IndexPath) -> Contact
    func numberOfRowsInSection(section: Int) -> Int
    func titleForHeaderInSection(section: Int) -> String
    func numberOfSections() -> Int
    func reverse(isAlpabetic: Bool)
    func addToRecent(contact: Contact)
}

class ContactsViewModel: ContactsViewModelProtocol {
    
    private var isAlpabetic = true
    
    public var updateTableView: (() -> Void)?
    
    private var contacts = [[Contact]]()
    
    private let contactsService: ContactsService
    
    init(contactsService: ContactsService) {
        self.contactsService = contactsService
    }
    
    public func fetchContactsData() {
        if !StorageService.fileExists(StorageService.fileName, in: .documents) {
            contactsService.fetchContactsData { [weak self] contacts in
                DispatchQueue.main.async {
                    self?.createTwoDimensional(array: contacts)
                    self?.updateTableView?()
                    StorageService.store(self?.contacts, to: .documents, as: StorageService.fileName)
                }
            }
        } else {
            contacts = StorageService.retrieve(StorageService.fileName, from: .documents, as: [[Contact]].self)
            updateTableView?()
        }
    }
    
    public func addToRecent(contact: Contact) {
        contactsService.add(contact: contact)
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
    
    public func reverse(isAlpabetic: Bool) {
        if isAlpabetic != self.isAlpabetic {
            contacts.reverse()
            updateTableView?()
            self.isAlpabetic = !self.isAlpabetic
        }
    }
}
