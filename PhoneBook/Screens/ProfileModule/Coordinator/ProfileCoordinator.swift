//
//  ProfileCoordinator.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 24.08.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import UIKit

class ProfileCoordinator: TabBarItemCoordinator {

    private let model: Profile?
    private let firebaseService: FirebaseService
    private weak var coordinator: TabBarCoordinator?
    public let navigationController: UINavigationController
    public let tabBarItem: UITabBarItem
    
    init(model: Profile?, firebaseService: FirebaseService, coordinator: TabBarCoordinator) {
        self.model = model
        self.firebaseService = firebaseService
        self.coordinator = coordinator
        navigationController = UINavigationController()
        tabBarItem = UITabBarItem(title: "Profile.Title".localized, image: UIImage(named: "profile"), tag: 3)
        navigationController.tabBarItem = tabBarItem
    }
    
    public func start() {
        let profileViewController = ScreensFactory.makeProfileScreen(coordinator: self, model: model)
        navigationController.pushViewController(profileViewController, animated: true)
    }
    
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
