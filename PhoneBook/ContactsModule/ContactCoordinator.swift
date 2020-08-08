//
//  ContactCoordinator.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 08.08.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import UIKit

class ContactCoordinator: Coordinator {
    
    private let navigationController: UINavigationController
    private let contactsService: ContactsService
    
    init(navigationController: UINavigationController, contactsService: ContactsService) {
        self.navigationController = navigationController
        self.contactsService = contactsService
    }
    
    
    func start() {
        let viewController = ContactsViewController()
        let viewModel = ContactsViewModel(contactsService: contactsService)
        viewController.viewModel = viewModel
        navigationController.pushViewController(viewController, animated: true)
    }
}
