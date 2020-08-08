//
//  TabBarCoordinator.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 08.08.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import UIKit

class TabBarCoordinator: Coordinator {
    
    private var window: UIWindow
    private let contactsService: ContactsService
    private let tabBarController = UITabBarController()
    
    init(window: UIWindow, contactsService: ContactsService) {
        self.window = window
        self.contactsService = contactsService
    }
    
    public func start() {
        
        let contactNavigationController = UINavigationController()
        contactNavigationController.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 0)
        let contactCoordinator = ContactCoordinator(navigationController: contactNavigationController, contactsService: contactsService)
        contactCoordinator.start()
        
        let recentNavigationController = UINavigationController()
        recentNavigationController.tabBarItem = UITabBarItem(tabBarSystemItem: .recents, tag: 1)
        let recentCoordinator = RecentCoordinator(navigationController: recentNavigationController, contactsService: contactsService)
        recentCoordinator.start()
        
        tabBarController.viewControllers = [contactNavigationController, recentNavigationController]
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
}
