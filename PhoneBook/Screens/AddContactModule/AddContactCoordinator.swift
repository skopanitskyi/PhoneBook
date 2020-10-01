//
//  AddContactCoordinator.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 25.09.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import UIKit

class AddContactCoordinator: Coordinator {
    
    // MARK: - Class instances
    
    /// Coordinator
    private let coordinator: FavoritesCoordinator
    
    /// Firebase service
    private let firebaseService: FirebaseService
    
    /// Navigation controller
    private let navigationController: UINavigationController
    
    // MARK: - Class constructor
    
    /// Add contact coordinator class constructor
    init(coordinator: FavoritesCoordinator, firebaseService: FirebaseService, navigationController: UINavigationController) {
        self.coordinator = coordinator
        self.firebaseService = firebaseService
        self.navigationController = navigationController
    }
    
    // MARK: - Class methods
    
    /// Creates an add contact screen and displays it
    public func start() {
        guard let addContact = ScreensFactory.makeAddContactScreen(coordinator: self,
                                                                   firebaseService: firebaseService) else { return }
        navigationController.present(addContact, animated: true, completion: nil)
    }
    
    /// Close add contact screen
    public func dismiss() {
        navigationController.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UpdateDataFromDetailsContact

extension AddContactCoordinator: UpdateDataFromDetailsContact {
    func updateRecentData(contact: Contact) {
        coordinator.updateRecentData(contact: contact)
        firebaseService.updateContact(name: contact.fullName, favorite: contact.isFavorite)
    }
}
