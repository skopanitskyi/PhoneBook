//
//  AddContactCoordinator.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 25.09.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import UIKit

class AddContactCoordinator: Coordinator {
    
    private let coordinator: FavoritesCoordinator
    private let firebaseService: FirebaseService
    private let navigationController: UINavigationController
    
    init(coordinator: FavoritesCoordinator, firebaseService: FirebaseService, navigationController: UINavigationController) {
        self.coordinator = coordinator
        self.firebaseService = firebaseService
        self.navigationController = navigationController
    }
    
    public func start() {
        let addContact = ScreensFactory.makeAddContactScreen(coordinator: self, firebaseService: firebaseService)
        navigationController.present(addContact, animated: true, completion: nil)
    }
    
    public func dismiss() {
        navigationController.dismiss(animated: true, completion: nil)
    }
}

extension AddContactCoordinator: UpdateData {
    func updateRecentData(contact: Contact) {
        coordinator.updateRecentData(contact: contact)
        firebaseService.some(name: contact.fullName, favorite: contact.isFavorite)
    }
}
