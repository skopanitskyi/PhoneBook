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
    static func makeSignUpScreen(coordinator: SignUpCoordinator, serviceManager: ServiceManager) -> SignUpViewController?
    
    static func makeLoginScreen(serviceManager: ServiceManager, coordinator: LoginCoordinator) -> LoginViewController?
    
    static func makeProfileScreen(serviceManager: ServiceManager,
                                  coordinator: ProfileCoordinator,
                                  model: Profile?) -> ProfileViewController?
    
    static func makeFavoritesScreen(coordinator: FavoritesCoordinator,
                                    serviceManager: ServiceManager) -> FavoritesViewController?
    
    static func makeContactsScreen(coordinator: ContactsCoordinator,
                                   serviceManager: ServiceManager) -> ContactsViewController
    
    static func makeRecentScreen(coordinator: RecentCoordinator,
                                 serviceManager: ServiceManager) -> RecentViewController
    
    static func makeDetailsContactScreen(coordinator: DetailsContactCoordinator,
                                         contact: Contact,
                                         serviceManager: ServiceManager) -> DetailsContactViewController?
    
    static func makeAddContactScreen(coordinator: AddContactCoordinator,
                                     serviceManager: ServiceManager) -> AddContactViewController?
}

/// Creates view objects
class ScreensFactory: ScreensFactoryProtocol {
    

    /// Creates an object of the SignUpViewController class
    /// - Parameter coordinator: An object of the SignUpCoordinator class, which is responsible for the logic of displaying screens
    public static func makeSignUpScreen(coordinator: SignUpCoordinator,
                                        serviceManager: ServiceManager) -> SignUpViewController? {
        
        let signUpController = createScreen(identifier: ScreenIdentifier.signUp, type: SignUpViewController.self)
        let signUpViewModel = SignUpViewModel(signUpCoordinator: coordinator, serviceManager: serviceManager)
        signUpController?.viewModel = signUpViewModel
        return signUpController
    }
    
    /// Creates an object of the LoginViewController class
    /// - Parameters:
    ///   - coordinator:An object of the LoginCoordinator class, which is responsible for the logic of displaying screens
    ///   - firebaseService: Helps login/logout and save and retrieve data from firebase
    public static func makeLoginScreen(serviceManager: ServiceManager, coordinator: LoginCoordinator) -> LoginViewController? {
        let loginController = createScreen(identifier: ScreenIdentifier.login, type: LoginViewController.self)
        let loginViewModel = LoginViewModel(serviceManager: serviceManager, loginCoordinator: coordinator)
        loginController?.viewModel = loginViewModel
        return loginController
    }
    
    /// Creates an object of the ProfileViewController class
    /// - Parameters:
    ///   - coordinator: An object of the ProfileCoordinator class, which is responsible for the logic of displaying screens
    ///   - model: Contains user data such as: full name, city, street.
    public static func makeProfileScreen(serviceManager: ServiceManager,
                                         coordinator: ProfileCoordinator,
                                         model: Profile?) -> ProfileViewController? {
        
        let profileViewController = createScreen(identifier: ScreenIdentifier.profile, type: ProfileViewController.self)
        let profileViewModel = ProfileViewModel(serviceManager: serviceManager, coordinator: coordinator, profile: model)
        profileViewController?.viewModel = profileViewModel
        return profileViewController
    }
    
    /// Creates an object of the FavoritesViewController class
    /// - Parameters:
    ///   - coordinator: An object of the FavoritesCoordinator class, which is responsible for the logic of displaying screens
    ///   - firebaseService: Helps login/logout and save and retrieve data from firebase
    public static func makeFavoritesScreen(coordinator: FavoritesCoordinator,
                                           serviceManager: ServiceManager) -> FavoritesViewController? {
        
        let favoritesController = createScreen(identifier: ScreenIdentifier.favorites, type: FavoritesViewController.self)
        let favoritesViewModel = FavoritesViewModel(coordinator: coordinator, serviceManager: serviceManager)
        favoritesController?.viewModel = favoritesViewModel
        return favoritesController
    }
    
    /// Creates an object of the ContactsViewController class
    /// - Parameters:
    ///   - coordinator: An object of the ContactsCoordinator class, which is responsible for the logic of displaying screens
    ///   - firebaseService: Helps login/logout and save and retrieve data from firebase
    public static func makeContactsScreen(coordinator: ContactsCoordinator,
                                          serviceManager: ServiceManager) -> ContactsViewController {
        
        let contactsViewController = ContactsViewController()
        let viewModel = ContactsViewModel(serviceManager: serviceManager, coordinator: coordinator)
        contactsViewController.viewModel = viewModel
        return contactsViewController
    }
    
    /// Creates an object of the RecentViewController class
    /// - Parameters:
    ///   - coordinator: An object of the RecentCoordinator class, which is responsible for the logic of displaying screens
    ///   - firebaseService: Helps login/logout and save and retrieve data from firebase
    public static func makeRecentScreen(coordinator: RecentCoordinator,
                                        serviceManager: ServiceManager) -> RecentViewController {
        
        let recentViewController = RecentViewController()
        let viewModel = RecentViewModel(coordinator: coordinator, serviceManager: serviceManager)
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
                                                serviceManager: ServiceManager) -> DetailsContactViewController? {
        
        let detailsController = createScreen(identifier: ScreenIdentifier.details, type: DetailsContactViewController.self)
        let viewModel = DetailContactViewModel(coordinator: coordinator,
                                               contact: contact,
                                               serviceManager: serviceManager)
        detailsController?.viewModel = viewModel
        return detailsController
    }
    
    /// Creates an object of the AddContactViewController class
    /// - Parameters:
    ///   - coordinator: An object of the AddContactCoordinator class, which is responsible for the logic of displaying screens
    ///   - firebaseService: Helps login/logout and save and retrieve data from firebase
    public static func makeAddContactScreen(coordinator: AddContactCoordinator,
                                            serviceManager: ServiceManager) -> AddContactViewController? {
        
        let addContact = createScreen(identifier: ScreenIdentifier.add, type: AddContactViewController.self)
        let viewModel = AddContactViewModel(coordinator: coordinator, serviceManager: serviceManager)
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
