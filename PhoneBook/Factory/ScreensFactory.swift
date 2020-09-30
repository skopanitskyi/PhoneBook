//
//  ScreensFactory.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 20.09.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import UIKit

/// Identifiers used for screens
struct ScreenIdentifier {
    public static let signUp = "SignUp"
    public static let login = "Login"
    public static let profile = "Profile"
    public static let favorites = "Favorites"
    public static let details = "DetailsContact"
    public static let add = "AddContact"
}

/// Screens factory protocol
protocol ScreensFactoryProtocol {
    static func makeSignUpScreen(coordinator: SignUpCoordinator) -> SignUpViewController?
    
    static func makeLoginScreen(coordinator: LoginCoordinator) -> LoginViewController?
    
    static func makeProfileScreen(coordinator: ProfileCoordinator, model: Profile?) -> ProfileViewController?
    
    static func makeFavoritesScreen(coordinator: FavoritesCoordinator,
                                    firebaseService: FirebaseService) -> FavoritesViewController?
    
    static func makeContactsScreen(coordinator: ContactsCoordinator,
                                   firebaseService: FirebaseService) -> ContactsViewController
    
    static func makeRecentScreen(coordinator: RecentCoordinator,
                                 firebaseService: FirebaseService) -> RecentViewController
    
    static func makeDetailsContactScreen(coordinator: DetailsContactCoordinator,
                                         contact: Contact,
                                         firebaseService: FirebaseService) -> DetailsContactViewController?
    
    static func makeAddContactScreen(coordinator: AddContactCoordinator,
                                     firebaseService: FirebaseService) -> AddContactViewController?
}

/// Creates view objects
class ScreensFactory: ScreensFactoryProtocol {
    

    /// Creates an object of the SignUpViewController class
    /// - Parameter coordinator: An object of the SignUpCoordinator class, which is responsible for the logic of displaying screens
    public static func makeSignUpScreen(coordinator: SignUpCoordinator) -> SignUpViewController? {
        let signUpController = createScreen(identifier: ScreenIdentifier.signUp, type: SignUpViewController.self)
        let signUpViewModel = SignUpViewModel(signUpCoordinator: coordinator)
        signUpController?.viewModel = signUpViewModel
        return signUpController
    }
    
    /// Creates an object of the LoginViewController class
    /// - Parameter coordinator:An object of the LoginCoordinator class, which is responsible for the logic of displaying screens
    public static func makeLoginScreen(coordinator: LoginCoordinator) -> LoginViewController? {
        let loginController = createScreen(identifier: ScreenIdentifier.login, type: LoginViewController.self)
        let loginViewModel = LoginViewModel(loginCoordinator: coordinator)
        loginController?.viewModel = loginViewModel
        return loginController
    }
    
    /// Creates an object of the ProfileViewController class
    /// - Parameters:
    ///   - coordinator: An object of the ProfileCoordinator class, which is responsible for the logic of displaying screens
    ///   - model: Contains user data such as: full name, city, street.
    public static func makeProfileScreen(coordinator: ProfileCoordinator, model: Profile?) -> ProfileViewController? {
        let profileViewController = createScreen(identifier: ScreenIdentifier.profile,
                                                 type: ProfileViewController.self)
        let profileViewModel = ProfileViewModel(coordinator: coordinator, profile: model)
        profileViewController?.viewModel = profileViewModel
        return profileViewController
    }
    
    /// Creates an object of the FavoritesViewController class
    /// - Parameters:
    ///   - coordinator: An object of the FavoritesCoordinator class, which is responsible for the logic of displaying screens
    ///   - firebaseService: Helps login/logout and save and retrieve data from firebase
    public static func makeFavoritesScreen(coordinator: FavoritesCoordinator,
                                           firebaseService: FirebaseService) -> FavoritesViewController? {
        let favoritesViewController = createScreen(identifier: ScreenIdentifier.favorites,
                                                   type: FavoritesViewController.self)
        let favoritesViewModel = FavoritesViewModel(coordinator: coordinator, firebaseService: firebaseService)
        favoritesViewController?.viewModel = favoritesViewModel
        return favoritesViewController
    }
    
    /// Creates an object of the ContactsViewController class
    /// - Parameters:
    ///   - coordinator: An object of the ContactsCoordinator class, which is responsible for the logic of displaying screens
    ///   - firebaseService: Helps login/logout and save and retrieve data from firebase
    public static func makeContactsScreen(coordinator: ContactsCoordinator,
                                          firebaseService: FirebaseService) -> ContactsViewController {
        let contactsViewController = ContactsViewController()
        let viewModel = ContactsViewModel(firebaseService: firebaseService, coordinator: coordinator)
        contactsViewController.viewModel = viewModel
        return contactsViewController
    }
    
    /// Creates an object of the RecentViewController class
    /// - Parameters:
    ///   - coordinator: An object of the RecentCoordinator class, which is responsible for the logic of displaying screens
    ///   - firebaseService: Helps login/logout and save and retrieve data from firebase
    public static func makeRecentScreen(coordinator: RecentCoordinator,
                                        firebaseService: FirebaseService) -> RecentViewController {
        let recentViewController = RecentViewController()
        let viewModel = RecentViewModel(coordinator: coordinator, firebaseService: firebaseService)
        recentViewController.viewModel = viewModel
        return recentViewController
    }
    
    /// Creates an object of the DetailsContactViewController class
    /// - Parameters:
    ///   - coordinator: An object of the DetailsContactCoordinator class, which is responsible for the logic of displaying screens
    ///   - contact: Contains contact details: full name, phone number, address, whether the contact is a favorite
    ///   - firebaseService: Helps login/logout and save and retrieve data from firebase
    public static func makeDetailsContactScreen(coordinator: DetailsContactCoordinator,
                                                contact: Contact,
                                                firebaseService: FirebaseService) -> DetailsContactViewController? {
        
        let detailsViewController = createScreen(identifier: ScreenIdentifier.details,
                                                 type: DetailsContactViewController.self)
        let viewModel = DetailContactViewModel(coordinator: coordinator,
                                               contact: contact,
                                               firebaseService: firebaseService)
        detailsViewController?.viewModel = viewModel
        return detailsViewController
    }
    
    /// Creates an object of the AddContactViewController class
    /// - Parameters:
    ///   - coordinator: An object of the AddContactCoordinator class, which is responsible for the logic of displaying screens
    ///   - firebaseService: Helps login/logout and save and retrieve data from firebase
    public static func makeAddContactScreen(coordinator: AddContactCoordinator,
                                            firebaseService: FirebaseService) -> AddContactViewController? {
        
        let addContact = createScreen(identifier: ScreenIdentifier.add, type: AddContactViewController.self)
        let viewModel = AddContactViewModel(coordinator: coordinator, firebaseService: firebaseService)
        addContact?.viewModel = viewModel
        return addContact
    }
    
    
    /// Creates and returns an object of the specified class that inherits from the UIViewController class
    /// - Parameters:
    ///   - identifier: Identifier used for storyboard and viewController
    ///   - controller: The type of object to be returned
    private static func createScreen<T: UIViewController>(identifier: String, type: T.Type) -> T? {
        let controller = UIStoryboard(name: identifier, bundle: nil).instantiateViewController(withIdentifier: identifier)
        return controller as? T
    }
}
