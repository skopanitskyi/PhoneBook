//
//  ScreensFactory.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 20.09.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import UIKit

protocol ScreensFactoryProtocol {
    static func makeSignUpScreen(coordinator: SignUpCoordinator) -> SignUpViewController
    static func makeLoginScreen(coordinator: LoginCoordinator) -> LoginViewController
    static func makeProfileScreen(coordinator: ProfileCoordinator) -> ProfileViewController
    static func makeFavoritesScreen() -> FavoritesViewController
    static func makeContactsScreen(coordinator: ContactsCoordinator, firebaseService: FirebaseService) -> ContactsViewController
    static func makeRecentScreen(firebaseService: FirebaseService) -> RecentViewController
}

class ScreensFactory: ScreensFactoryProtocol {
    
    public static func makeSignUpScreen(coordinator: SignUpCoordinator) -> SignUpViewController {
        let signUpController = UIStoryboard(name: "SignUp",
                                            bundle: nil).instantiateViewController(withIdentifier: "SignUp") as! SignUpViewController
        let signUpViewModel = SignUpViewModel(signUpCoordinator: coordinator)
        signUpController.viewModel = signUpViewModel
        return signUpController
    }
    
    public static func makeLoginScreen(coordinator: LoginCoordinator) -> LoginViewController {
        let loginController = UIStoryboard(name: "Login",
                                           bundle: nil).instantiateViewController(withIdentifier: "Login") as! LoginViewController
        let loginViewModel = LoginViewModel(loginCoordinator: coordinator)
        loginController.viewModel = loginViewModel
        return loginController
    }
    
    public static func makeProfileScreen(coordinator: ProfileCoordinator) -> ProfileViewController {
        let profileViewController = UIStoryboard(name: "Profile",
                                                 bundle: nil).instantiateViewController(withIdentifier: "Profile") as! ProfileViewController
        let profileViewModel = ProfileViewModel(coordinator: coordinator)
        profileViewController.viewModel = profileViewModel
        return profileViewController
    }
    
    public static func makeFavoritesScreen() -> FavoritesViewController {
        let favoritesViewController = FavoritesViewController()
        let favoritesViewModel = FavoritesViewModel()
        favoritesViewController.viewModel = favoritesViewModel
        return favoritesViewController
    }
    
    public static func makeContactsScreen(coordinator: ContactsCoordinator, firebaseService: FirebaseService) -> ContactsViewController {
        let contactsViewController = ContactsViewController()
        let viewModel = ContactsViewModel(firebaseService: firebaseService, coordinator: coordinator)
        contactsViewController.viewModel = viewModel
        return contactsViewController
    }
    
    public static func makeRecentScreen(firebaseService: FirebaseService) -> RecentViewController {
        let recentViewController = RecentViewController()
        let viewModel = RecentViewModel(firebaseService: firebaseService)
        recentViewController.viewModel = viewModel
        return recentViewController
    }
}