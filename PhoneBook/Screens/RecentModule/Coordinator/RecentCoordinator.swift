//
//  RecentCoordinator.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 08.08.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import UIKit

class RecentCoordinator: TabBarItemCoordinator {
    
    private let contactsService: ContactsService
    public let navigationController: UINavigationController
    public let tabBarItem: UITabBarItem
    
    init(contactsService: ContactsService) {
        self.contactsService = contactsService
        navigationController = UINavigationController()
        tabBarItem = UITabBarItem(title: "Recent.Title".localized, image: UIImage(named: "recent"), tag: 1)
        navigationController.tabBarItem = tabBarItem
    }
    
    func start() {
        let viewController = RecentViewController()
        let viewModel = RecentViewModel(contactsService: contactsService)
        viewController.viewModel = viewModel
        navigationController.pushViewController(viewController, animated: true)
    }
}
