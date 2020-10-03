//
//  ContactCoordinator.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 08.08.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import UIKit

protocol UpdateFavoriteContactStatus {
    func updateContact(contact: Contact)
}

class ContactsCoordinator: TabBarItemCoordinator {

    // MARK: - Class instances
    
    /// Contacts view controller
    private var contactsViewController: ContactsViewController?
    
    /// Tab bar coordinator
    private let coordinator: TabBarCoordinator
    
    /// Service manager
    private let serviceManager: ServiceManager
    
    /// Navigation controller
    public let navigationController: UINavigationController
    
    /// Tab bar item
    public let tabBarItem: UITabBarItem
    
    // MARK: - Class constructor
    
    /// Contacts coordinator class constructor
    init(coordinator: TabBarCoordinator, serviceManager: ServiceManager) {
        self.coordinator = coordinator
        self.serviceManager = serviceManager
        navigationController = UINavigationController()
        tabBarItem = UITabBarItem(title: "Contacts.Title".localized, image: UIImage(named: "contacts"), tag: 0)
        navigationController.tabBarItem = tabBarItem
    }
    
    // MARK: Class methods
    
    /// Creates a contacts screen and displays it
    public func start() {
        contactsViewController = ScreensFactory.makeContactsScreen(coordinator: self,
                                                                   serviceManager: serviceManager)
        navigationController.pushViewController(contactsViewController!, animated: true)
    }
    
    /// Adds contact to recent
    /// - Parameter contact: The contact to be added to recent
    public func addToRecent(contact: Contact) {
        coordinator.addToRecent(contact: contact)
    }
}

// MARK: - UpdateFavoriteContactStatus

extension ContactsCoordinator: UpdateFavoriteContactStatus {
    func updateContact(contact: Contact) {
        contactsViewController?.viewModel?.updateContact(contact: contact)
    }
}
