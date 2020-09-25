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
    func fetchFavoritesContacts()
    func numberOfRowsInSection() -> Int
    func remove(at index: Int)
    func move(from: Int, to: Int)
    func getContactName(at index: Int) -> String
    func updateContact(contact: Contact)
    func showDetailsContact(at index: Int)
    func showAddButtonController()
}

class FavoritesViewModel: FavoritesViewModelProtocol {
    
    public var updateView: (() -> Void)?
    
    private var favoritesContacts = [Contact]()
    
    private let coordinator: FavoritesCoordinator
    private let firebaseService: FirebaseService
    
    init(coordinator: FavoritesCoordinator, firebaseService: FirebaseService) {
        self.coordinator = coordinator
        self.firebaseService = firebaseService
    }
    
    public func fetchFavoritesContacts() {
        firebaseService.userSavedData(data: .favorites) { result in
            switch result {
            case.success(let contacts):
                self.favoritesContacts = contacts
                self.updateView?()
            case .failure(let error):
                print(error.errorDescription!)
            }
        }
    }
    
    public func numberOfRowsInSection() -> Int {
        return favoritesContacts.count
    }
    
    public func remove(at index: Int) {
        let contact = favoritesContacts[index]
        contact.isFavorite = false
        firebaseService.some(name: contact.fullName, favorite: contact.isFavorite)
        coordinator.s(contact: contact)
        favoritesContacts.remove(at: index)
    }
    
    public func move(from: Int, to: Int) {
        let contact = favoritesContacts.remove(at: from)
        favoritesContacts.insert(contact, at: to)
        firebaseService.updateData(fors: "favorites", data: favoritesContacts) { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                print(error.errorDescription!)
            }
        }
    }
    
    public func getContactName(at index: Int) -> String {
        return favoritesContacts[index].fullName
    }
    
    public func updateContact(contact: Contact) {
        if contact.isFavorite {
            favoritesContacts.insert(contact, at: 0)
            firebaseService.updateData(fors: "favorites", data: favoritesContacts) { (AuthResult) in
                
            }
        } else {
            guard let index = favoritesContacts.firstIndex (where: { $0.fullName == contact.fullName }) else { return }
            favoritesContacts.remove(at: index)
        }
        updateView?()
    }
    
    public func showDetailsContact(at index: Int) {
        coordinator.showDetailsContact(contact: favoritesContacts[index])
    }
    
    public func showAddButtonController() {
        coordinator.showAddButtonController()
    }
}
