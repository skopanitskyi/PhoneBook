//
//  FavoritesCoordinator.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 24.08.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import UIKit

class FavoritesCoordinator: TabBarItemCoordinator {
    
    private let coordinator: TabBarCoordinator
    private var favoritesViewController: FavoritesViewController?
    private let firebaseService: FirebaseService
    public let navigationController: UINavigationController
    public let tabBarItem: UITabBarItem
    
    init(coordinator: TabBarCoordinator, firebaseService: FirebaseService) {
        self.coordinator = coordinator
        self.firebaseService = firebaseService
        navigationController = UINavigationController()
        tabBarItem = UITabBarItem(title: "Favorites.Title".localized, image: UIImage(named: "favorites"), tag: 2)
        navigationController.tabBarItem = tabBarItem
    }
    
    public func start() {
        favoritesViewController = ScreensFactory.makeFavoritesScreen(coordinator: self, firebaseService: firebaseService)
        navigationController.pushViewController(favoritesViewController!, animated: true)
    }
    
    public func showDetailsContact(contact: Contact) {
        let detailsCoordinator = DetailsContactCoordinator(coordinator: self, navigationController: navigationController, contact: contact, firebaseService: firebaseService)
        detailsCoordinator.start()
    }
    
    public func s(contact: Contact) {
        coordinator.updateFromFavorite(contact: contact)
    }

    
}

extension FavoritesCoordinator: B {
    public func updateContact(contact: Contact) {
        favoritesViewController?.viewModel?.updateContact(contact: contact)
    }
}

extension FavoritesCoordinator: UpdateData {
    public func updateRecentData(contact: Contact) {
        favoritesViewController?.viewModel?.updateContact(contact: contact)
        coordinator.updateFromFavorite(contact: contact)
    }
}
