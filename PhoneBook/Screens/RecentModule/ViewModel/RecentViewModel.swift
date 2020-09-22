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
    func numberOfRowsInSection() -> Int
    func getContactName(at index: Int) -> String
    func addToRecent(contact: Contact)
    func deleteContact(at index: Int)
    func deleteAllContacts()
    func downloadData()
    func showDetailsContact(at index: Int)
    func updateData()
}

class RecentViewModel: RecentViewModelProtocol {
    
    public var updateView: (() -> Void)?
    
    private var contacts = [Contact]()
    
    private let firebaseService: FirebaseService
    
    private let coordinator: RecentCoordinator
    
    init(coordinator: RecentCoordinator, firebaseService: FirebaseService) {
        self.coordinator = coordinator
        self.firebaseService = firebaseService
    }
    
    public func numberOfRowsInSection() -> Int {
        return contacts.count
    }
    
    public func getContactName(at index: Int) -> String {
        return contacts[index].fullName
    }
    
    public func addToRecent(contact: Contact) {
        contacts.insert(contact, at: 0)
        updateData()
        updateView?()
    }
    
    public func deleteContact(at index: Int) {
        contacts.remove(at: index)
        updateData()
    }
    
    public func deleteAllContacts() {
        contacts.removeAll()
        updateData()
        updateView?()
    }
    
    public func downloadData() {
        firebaseService.userSavedData(data: .recent) { [weak self] result in
            switch result {
            case .success(let contacts):
                self?.contacts = contacts
                self?.updateView?()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    public func updateData() {
        firebaseService.updateData(data: contacts) { result in
            switch result {
            case.success:
                print("Data saved")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    public func showDetailsContact(at index: Int) {
        coordinator.showDetailsContacts(contact: contacts[index])
    }
}
