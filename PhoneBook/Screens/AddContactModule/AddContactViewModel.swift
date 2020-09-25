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
    func fetchContacts()
    func numberOfRowsInSection() -> Int
    func getContactName(at index: Int) -> String
    func cancel()
    func deleteCell(at name: String) -> Int?
}

class AddContactViewModel: AddContactViewModelProtocol {
    
    public var updateView: (() -> ())?
    
    private let coordinator: AddContactCoordinator
    
    private let firebaseService: FirebaseService
    
    private var contacts = [Contact]()
    
    
    init(coordinator: AddContactCoordinator, firebaseService: FirebaseService) {
        self.coordinator = coordinator
        self.firebaseService = firebaseService
    }
    
    public func fetchContacts() {
        firebaseService.userSavedData(data: .contacts) { [weak self] result in
            switch result {
            case .success(let contacts):
                let unfavorites = contacts.filter { !$0.isFavorite }
                self?.contacts = unfavorites
                self?.updateView?()
            case .failure(let error):
                if let error = error.errorDescription {
                    print(error)
                }
            }
        }
    }
    
    public func numberOfRowsInSection() -> Int {
        return contacts.count
    }
    
    public func getContactName(at index: Int) -> String {
        return contacts[index].fullName
    }
    
    public func cancel() {
        coordinator.dismiss()
    }
    
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
