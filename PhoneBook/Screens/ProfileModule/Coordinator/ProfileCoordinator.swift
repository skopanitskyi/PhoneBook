//
//  ProfileCoordinator.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 24.08.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import UIKit

class ProfileCoordinator: TabBarItemCoordinator {
    
    public let navigationController: UINavigationController
    public let tabBarItem: UITabBarItem
    
    init() {
        navigationController = UINavigationController()
        tabBarItem = UITabBarItem(title: "Profile.Title".localized, image: UIImage(named: "profile"), tag: 3)
        navigationController.tabBarItem = tabBarItem
    }
    
    
    public func start() {
        let profileViewController = ProfileViewController()
        let profileViewModel = ProfileViewModel()
        profileViewController.viewModel = profileViewModel
        navigationController.pushViewController(profileViewController, animated: true)
    }
}
