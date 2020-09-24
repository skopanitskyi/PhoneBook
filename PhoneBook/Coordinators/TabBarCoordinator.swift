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
    private let firebaseService: FirebaseService
    private let tabBarController: UITabBarController
    private weak var appCoordinator: AppCoordinator?
    private var tabBarCoordinators: [TabBarItemCoordinator] = []
    
    init(window: UIWindow, firebaseService: FirebaseService, appCoordinator: AppCoordinator) {
        self.window = window
        self.firebaseService = firebaseService
        self.appCoordinator = appCoordinator
        tabBarController = UITabBarController()
        
        
        let contactCoordinator = ContactsCoordinator(coordinator: self, firebaseService: firebaseService)
        contactCoordinator.start()
        
        let recentCoordinator = RecentCoordinator(coordinator: self, firebaseService: firebaseService)
        recentCoordinator.start()
        
        let favoritesCoordinator = FavoritesCoordinator(coordinator: self, firebaseService: firebaseService)
        favoritesCoordinator.start()
        
        let profileCoordinator = ProfileCoordinator(firebaseService: firebaseService, coordinator: self)
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
    
    public func logout() {
        appCoordinator?.logout()
    }
    
    public func addToRecent(contact: Contact) {
        let a = tabBarCoordinators[1] as? A
        a?.addToRecent(contact: contact)
    }
    
    public func updateFromRecent(contact: Contact) {
       let a = tabBarCoordinators[0] as? B
        a?.updateContact(contact: contact)
       let b = tabBarCoordinators[2] as? B
        b?.updateContact(contact: contact)
    }
    
    public func updateFromFavorite(contact: Contact) {
        let a = tabBarCoordinators[0] as? B
         a?.updateContact(contact: contact)
        let b = tabBarCoordinators[1] as? B
        b?.updateContact(contact: contact)
    }
}



