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
    static func makeFavoritesScreen(coordinator: FavoritesCoordinator, firebaseService: FirebaseService) -> FavoritesViewController
    static func makeContactsScreen(coordinator: ContactsCoordinator, firebaseService: FirebaseService) -> ContactsViewController
    static func makeRecentScreen(coordinator: RecentCoordinator, firebaseService: FirebaseService) -> RecentViewController
    static func makeDetailsContactScreen(coordinator: DetailsContactCoordinator, contact: Contact, firebaseService: FirebaseService) -> DetailsContactViewController
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
    
    public static func makeFavoritesScreen(coordinator: FavoritesCoordinator, firebaseService: FirebaseService) -> FavoritesViewController {
        let favoritesViewController = UIStoryboard(name: "Favorites",
                                                 bundle: nil).instantiateViewController(withIdentifier: "Favorites") as! FavoritesViewController
        
//        let favoritesViewController = FavoritesViewController()
        let favoritesViewModel = FavoritesViewModel(coordinator: coordinator, firebaseService: firebaseService)
        favoritesViewController.viewModel = favoritesViewModel
        return favoritesViewController
    }
    
    public static func makeContactsScreen(coordinator: ContactsCoordinator, firebaseService: FirebaseService) -> ContactsViewController {
        let contactsViewController = ContactsViewController()
        let viewModel = ContactsViewModel(firebaseService: firebaseService, coordinator: coordinator)
        contactsViewController.viewModel = viewModel
        return contactsViewController
    }
    
    public static func makeRecentScreen(coordinator: RecentCoordinator, firebaseService: FirebaseService) -> RecentViewController {
        let recentViewController = RecentViewController()
        let viewModel = RecentViewModel(coordinator: coordinator, firebaseService: firebaseService)
        recentViewController.viewModel = viewModel
        return recentViewController
    }
    
    public static func makeDetailsContactScreen(coordinator: DetailsContactCoordinator,
                                                contact: Contact,
                                                firebaseService: FirebaseService) -> DetailsContactViewController {
        
        let detailsViewController = UIStoryboard(name: "DetailsContact",
                                                 bundle: nil).instantiateViewController(withIdentifier: "DetailsContact") as! DetailsContactViewController
        let viewModel = DetailContactViewModel(coordinator: coordinator,
                                               contact: contact,
                                               firebaseService: firebaseService)
        detailsViewController.viewModel = viewModel
        return detailsViewController
    }
}
