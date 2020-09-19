//
//  ProfileCoordinator.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 24.08.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import UIKit

class ProfileCoordinator: TabBarItemCoordinator {

    private let firebaseService: FirebaseService
    private weak var coordinator: TabBarCoordinator?
    public let navigationController: UINavigationController
    public let tabBarItem: UITabBarItem
    
    init(firebaseService: FirebaseService, coordinator: TabBarCoordinator) {
        self.firebaseService = firebaseService
        self.coordinator = coordinator
        navigationController = UINavigationController()
        tabBarItem = UITabBarItem(title: "Profile.Title".localized, image: UIImage(named: "profile"), tag: 3)
        navigationController.tabBarItem = tabBarItem
    }
    
    public func start() {
        let profileViewController = UIStoryboard(name: "Profile",
        bundle: nil).instantiateViewController(withIdentifier: "Profile") as! ProfileViewController
        let profileViewModel = ProfileViewModel(coordinator: self)
        profileViewController.viewModel = profileViewModel
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
