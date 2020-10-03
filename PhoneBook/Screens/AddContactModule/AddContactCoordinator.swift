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
    
    /// Service manager
    private let serviceManager: ServiceManager
    
    /// Navigation controller
    private let navigationController: UINavigationController
    
    // MARK: - Class constructor
    
    /// Add contact coordinator class constructor
    init(coordinator: FavoritesCoordinator, serviceManager: ServiceManager, navigationController: UINavigationController) {
        self.coordinator = coordinator
        self.serviceManager = serviceManager
        self.navigationController = navigationController
    }
    
    // MARK: - Class methods
    
    /// Creates an add contact screen and displays it
    public func start() {
        guard let addContact = ScreensFactory.makeAddContactScreen(coordinator: self,
                                                                   serviceManager: serviceManager) else { return }
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
    }
}
