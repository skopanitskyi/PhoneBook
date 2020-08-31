//
//  TabBarCoordinator.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 08.08.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import UIKit

enum TabBarScreen: Int {
    case contacts = 0
    case recent = 1
    case favorites = 2
    case profile = 3
}

protocol TabBarItemCoordinator {
    var navigationController: UINavigationController { get }
    var tabBarItem: UITabBarItem { get }
}

class TabBarCoordinator: Coordinator {
    
    private var window: UIWindow
    private let contactsService: ContactsService
    private let tabBarController: UITabBarController
    private var tabBarCoordinators: [TabBarItemCoordinator]
    
    init(window: UIWindow, contactsService: ContactsService) {
        self.window = window
        self.contactsService = contactsService
        tabBarController = UITabBarController()
        
        
        let contactCoordinator = ContactsCoordinator(contactsService: contactsService)
        contactCoordinator.start()
        
        let recentCoordinator = RecentCoordinator(contactsService: contactsService)
        recentCoordinator.start()
        
        let favoritesCoordinator = FavoritesCoordinator()
        favoritesCoordinator.start()
        
        let profileCoordinator = ProfileCoordinator()
        profileCoordinator.start()
        
        tabBarController.viewControllers = [contactCoordinator.navigationController,
                                            recentCoordinator.navigationController,
                                            favoritesCoordinator.navigationController,
                                            profileCoordinator.navigationController]
        
        tabBarCoordinators = [contactCoordinator, recentCoordinator, favoritesCoordinator, profileCoordinator]
    }
    
    public func start() {
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
    
    public func selectItem(at index: TabBarScreen) {
        let selectedIndex = index.rawValue
        tabBarController.selectedIndex = selectedIndex
        let navigationController = getNavigationController(at: selectedIndex)
        navigationController?.popViewController(animated: false)
    }
    
    private func getNavigationController(at index: Int)  -> UINavigationController? {
        if index < tabBarCoordinators.count {
            return tabBarCoordinators[index].navigationController
        }
        return nil
    }
}
