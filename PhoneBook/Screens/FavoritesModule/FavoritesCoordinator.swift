//
//  FavoritesCoordinator.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 24.08.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import UIKit

class FavoritesCoordinator: TabBarItemCoordinator {
    
    // MARK: - Class instances
    
    /// Coordinator
    private let coordinator: TabBarCoordinator
    
    /// Favorites view controller
    private var favoritesViewController: FavoritesViewController?
    
    /// Firebase service
    private let firebaseService: FirebaseService
    
    /// Navigation controller
    public let navigationController: UINavigationController
    
    /// Tab bar item
    public let tabBarItem: UITabBarItem
    
    // MARK: - Class constructor
    
    /// Favorites coordinator class constructor
    init(coordinator: TabBarCoordinator, firebaseService: FirebaseService) {
        self.coordinator = coordinator
        self.firebaseService = firebaseService
        navigationController = UINavigationController()
        tabBarItem = UITabBarItem(title: "Favorites.Title".localized, image: UIImage(named: "favorites"), tag: 2)
        navigationController.tabBarItem = tabBarItem
    }
    
    // MARK: - Class methods
    
    /// Creates a favorites screen and displays it
    public func start() {
        favoritesViewController = ScreensFactory.makeFavoritesScreen(coordinator: self, firebaseService: firebaseService)
        navigationController.pushViewController(favoritesViewController!, animated: true)
    }
    
    /// Creates a details contact coordinator and transfers contact data to him
    /// - Parameter contact: The contact, data of which will be displayed
    public func showDetailsContact(contact: Contact) {
        let detailsCoordinator = DetailsContactCoordinator(coordinator: self, navigationController: navigationController, contact: contact, firebaseService: firebaseService)
        detailsCoordinator.start()
    }
    
    /// Tells the coordinator that the data of one of the contacts have changed
    /// - Parameter contact: Received contact with new data
    public func updateContactData(contact: Contact) {
        coordinator.updateFromFavorite(contact: contact)
    }
    
    /// Creates add contact coordinator
    public func showAddContactController() {
        let addContactCoordinator = AddContactCoordinator(coordinator: self,
                                                          firebaseService: firebaseService,
                                                          navigationController: navigationController)
        addContactCoordinator.start()
    }
}

// MARK: - UpdateFavoriteContactStatus

extension FavoritesCoordinator: UpdateFavoriteContactStatus {
    public func updateContact(contact: Contact) {
        favoritesViewController?.viewModel?.updateContact(contact: contact)
    }
}

// MARK: - UpdateDataFromDetailsContact

extension FavoritesCoordinator: UpdateDataFromDetailsContact {
    public func updateRecentData(contact: Contact) {
        favoritesViewController?.viewModel?.updateContact(contact: contact)
        coordinator.updateFromFavorite(contact: contact)
    }
}
