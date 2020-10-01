//
//  AddContactViewModel.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 25.09.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import Foundation

protocol AddContactViewModelProtocol {
    var updateView: (() -> ())? { get set }
    var error: ((String?) -> Void)? { get set }
    func fetchContacts()
    func numberOfRowsInSection() -> Int
    func getContactName(at index: Int) -> String
    func cancel()
    func deleteCell(at name: String) -> Int?
}

class AddContactViewModel: AddContactViewModelProtocol {
    
    // MARK: - Class instances
    
    /// Update table view data
    public var updateView: (() -> ())?
    
    /// Used to show error on screen
    public var error: ((String?) -> Void)?
    
    /// Coordinator
    private let coordinator: AddContactCoordinator
    
    /// Firebase service
    private let firebaseService: FirebaseService
    
    /// Store unfavorite contacts
    private var contacts = [Contact]()
    
    // MARK: - Class constructor
    
    /// Add contact view model
    init(coordinator: AddContactCoordinator, firebaseService: FirebaseService) {
        self.coordinator = coordinator
        self.firebaseService = firebaseService
    }
    
    // MARK: - Class methods
    
    /// Get contact data from firebase
    public func fetchContacts() {
        firebaseService.userSavedData(data: .contacts) { [weak self] result in
            switch result {
            case .success(let contacts):
                let unfavorites = contacts.filter { !$0.isFavorite }
                self?.contacts = unfavorites
                self?.updateView?()
            case .failure(let error):
                self?.error?(error.errorDescription)
            }
        }
    }
    
    /// Return number of rows in section
    public func numberOfRowsInSection() -> Int {
        return contacts.count
    }
    
    /// Return contact name
    /// - Parameter index: Contact index
    public func getContactName(at index: Int) -> String {
        return contacts[index].fullName
    }
    
    /// Tells  coordinator to close contact screen add
    public func cancel() {
        coordinator.dismiss()
    }
    
    /// Removes contact by name and returns its index
    /// - Parameter name: Contact name
    public func deleteCell(at name: String) -> Int? {
        if let index = contacts.firstIndex(where: {$0.fullName == name }) {
            contacts[index].isFavorite = true
            coordinator.updateRecentData(contact: contacts[index])
            contacts.remove(at: index)
            return index
        }
        return nil
    }
}
