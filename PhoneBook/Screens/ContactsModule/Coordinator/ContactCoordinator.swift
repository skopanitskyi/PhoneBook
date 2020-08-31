//
//  ContactCoordinator.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 08.08.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import UIKit

class ContactsCoordinator: TabBarItemCoordinator {
    
    public let navigationController: UINavigationController
    public let tabBarItem: UITabBarItem
    private let contactsService: ContactsService
    
    init( contactsService: ContactsService) {
        navigationController = UINavigationController()
        tabBarItem = UITabBarItem(title: "Contacts.Title".localized, image: UIImage(named: "contacts"), tag: 0)
        navigationController.tabBarItem = tabBarItem
        self.contactsService = contactsService
    }
    
    
    func start() {
        let viewController = ContactsViewController()
        let viewModel = ContactsViewModel(contactsService: contactsService)
        viewController.viewModel = viewModel
        navigationController.pushViewController(viewController, animated: true)
    }
}
