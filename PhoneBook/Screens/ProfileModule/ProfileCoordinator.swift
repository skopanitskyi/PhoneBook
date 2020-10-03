//
//  ProfileCoordinator.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 24.08.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import UIKit

class ProfileCoordinator: TabBarItemCoordinator {
    
    // MARK: - Class instances

    /// Model
    private let model: Profile?
    
    /// Service manager
    private let serviceManager: ServiceManager
    
    /// Coordinator
    private weak var coordinator: TabBarCoordinator?
    
    /// Navigation controller
    public let navigationController: UINavigationController
    
    /// Tab bar item
    public let tabBarItem: UITabBarItem
    
    // MARK: - Class constructor
    
    /// Profile coordinator class constructor
    init(model: Profile?, serviceManager: ServiceManager, coordinator: TabBarCoordinator) {
        self.model = model
        self.serviceManager = serviceManager
        self.coordinator = coordinator
        navigationController = UINavigationController()
        tabBarItem = UITabBarItem(title: "Profile.Title".localized, image: UIImage(named: "profile"), tag: 3)
        navigationController.tabBarItem = tabBarItem
    }
    
    // MARK: - Class methods
    
    /// Creates a profile screen and displays it
    public func start() {
        guard let profileViewController = ScreensFactory.makeProfileScreen(serviceManager: serviceManager,
                                                                           coordinator: self,
                                                                           model: model) else { return }
        navigationController.pushViewController(profileViewController, animated: true)
    }
    
    /// User logout from the app
    public func logout() {
        coordinator?.logout()
    }
}
