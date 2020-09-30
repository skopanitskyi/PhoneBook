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
    
    // MARK: - Class instances
    
    /// User model which stores user data
    private let userModel: Profile?
    
    /// Window
    private var window: UIWindow
    
    /// Firebase service
    private let firebaseService: FirebaseService
    
    /// Tab bar controller
    private let tabBarController: UITabBarController
    
    /// App coordinator
    private weak var appCoordinator: AppCoordinator?
    
    /// Store tab bar coordinators
    private var tabBarCoordinators: [TabBarItemCoordinator] = []
    
    // MARK: - Class constructor
    
    /// TabBarCoordinator class constructor
    init(window: UIWindow, firebaseService: FirebaseService, appCoordinator: AppCoordinator, userModel: Profile?) {
        self.userModel = userModel
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
        
        let profileCoordinator = ProfileCoordinator(model: userModel, firebaseService: firebaseService, coordinator: self)
        profileCoordinator.start()
        
        tabBarController.viewControllers = [contactCoordinator.navigationController,
                                            recentCoordinator.navigationController,
                                            favoritesCoordinator.navigationController,
                                            profileCoordinator.navigationController]
        
        tabBarCoordinators = [contactCoordinator, recentCoordinator, favoritesCoordinator, profileCoordinator]
    }
    
    // MARK: - Class methods
    
    /// Declares a tab bar controller as a root controller
    public func start() {
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
    
    /// Displays the screen at the selected index
    /// - Parameter index: Screen index
    public func selectItem(at index: TabBarScreen) {
        let selectedIndex = index.rawValue
        tabBarController.selectedIndex = selectedIndex
        let navigationController = getNavigationController(at: selectedIndex)
        navigationController?.popViewController(animated: false)
    }
    
    /// Returns the navigation controller at the specified index
    /// - Parameter index: Navigation controller index
    private func getNavigationController(at index: Int)  -> UINavigationController? {
        if index < tabBarCoordinators.count {
            return tabBarCoordinators[index].navigationController
        }
        return nil
    }
    
    /// Tells the app coordinator that the user is logout
    public func logout() {
        appCoordinator?.logout()
    }
    
    /// Add contact to recent
    /// - Parameter contact: Contact to be added to recent
    public func addToRecent(contact: Contact) {
        let recentCoordinator = tabBarCoordinators[1] as? UpdateRecentContacts
        recentCoordinator?.addToRecent(contact: contact)
    }
    
    /// Refreshes contact details from recent in other controllers
    /// - Parameter contact: The contact whose details will be updated
    public func updateFromRecent(contact: Contact) {
       let contactCoordinator = tabBarCoordinators[0] as? UpdateFavoriteContactStatus
        contactCoordinator?.updateContact(contact: contact)
       let favoritesCoordinator = tabBarCoordinators[2] as? UpdateFavoriteContactStatus
        favoritesCoordinator?.updateContact(contact: contact)
    }
    
    /// Refreshes contact details from favorite in other controllers
    /// - Parameter contact: The contact whose details will be updated
    public func updateFromFavorite(contact: Contact) {
        let contactCoordinator = tabBarCoordinators[0] as? UpdateFavoriteContactStatus
        contactCoordinator?.updateContact(contact: contact)
        let recentCoordinator = tabBarCoordinators[1] as? UpdateFavoriteContactStatus
        recentCoordinator?.updateContact(contact: contact)
    }
}



