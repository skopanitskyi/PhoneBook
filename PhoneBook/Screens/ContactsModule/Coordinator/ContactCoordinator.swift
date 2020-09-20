//
//  ContactCoordinator.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 08.08.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import UIKit

class ContactsCoordinator: TabBarItemCoordinator {
    
    private let coordinator: TabBarCoordinator
    private let firebaseService: FirebaseService
    public let navigationController: UINavigationController
    public let tabBarItem: UITabBarItem

    
    
    init(coordinator: TabBarCoordinator, firebaseService: FirebaseService) {
        self.coordinator = coordinator
        navigationController = UINavigationController()
        tabBarItem = UITabBarItem(title: "Contacts.Title".localized, image: UIImage(named: "contacts"), tag: 0)
        navigationController.tabBarItem = tabBarItem
        self.firebaseService = firebaseService
    }
    
    
    public func start() {
        let contactsViewController = ScreensFactory.makeContactsScreen(coordinator: self,
                                                                       firebaseService: firebaseService)
        navigationController.pushViewController(contactsViewController, animated: true)
    }
    
    public func addToRecent(contact: Contact) {
        coordinator.addToRecent(contact: contact)
    }
}
