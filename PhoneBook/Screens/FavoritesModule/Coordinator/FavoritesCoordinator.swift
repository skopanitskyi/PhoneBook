//
//  FavoritesCoordinator.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 24.08.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import UIKit

class FavoritesCoordinator: TabBarItemCoordinator {
    
   public let navigationController: UINavigationController
   public let tabBarItem: UITabBarItem
    
    init() {
        navigationController = UINavigationController()
        tabBarItem = UITabBarItem(title: "Favorites.Title".localized, image: UIImage(named: "favorites"), tag: 2)
        navigationController.tabBarItem = tabBarItem
    }
    
    public func start() {
        let favoritesViewController = FavoritesViewController()
        let favoritesViewModel = FavoritesViewModel()
        favoritesViewController.viewModel = favoritesViewModel
        navigationController.pushViewController(favoritesViewController, animated: true)
    }
}
