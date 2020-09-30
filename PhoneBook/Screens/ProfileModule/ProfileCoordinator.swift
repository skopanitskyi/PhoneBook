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
    
    /// Firebase service
    private let firebaseService: FirebaseService
    
    /// Coordinator
    private weak var coordinator: TabBarCoordinator?
    
    /// Navigation controller
    public let navigationController: UINavigationController
    
    /// Tab bar item
    public let tabBarItem: UITabBarItem
    
    // MARK: - Class constructor
    
    /// Profile coordinator class constructor
    init(model: Profile?, firebaseService: FirebaseService, coordinator: TabBarCoordinator) {
        self.model = model
        self.firebaseService = firebaseService
        self.coordinator = coordinator
        navigationController = UINavigationController()
        tabBarItem = UITabBarItem(title: "Profile.Title".localized, image: UIImage(named: "profile"), tag: 3)
        navigationController.tabBarItem = tabBarItem
    }
    
    // MARK: - Class methods
    
    /// Creates a profile screen and displays it
    public func start() {
        guard let profileViewController = ScreensFactory.makeProfileScreen(coordinator: self, model: model) else { return }
        navigationController.pushViewController(profileViewController, animated: true)
    }
    
    /// User logout from the app
    public func logout() {
        firebaseService.signOut { result in
            switch result {
            case .success:
                coordinator?.logout()
            case .failure(let error):
                if let error = error.errorDescription {
                    print(error)
                }
            }
        }
    }
}
