//
//  SignUpCoordinator.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 05.09.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import UIKit

class RegistrationCoordinator: Coordinator {
    
    // MARK: - Class instances
    
    /// Navigation controller
    private weak var navigationController: UINavigationController?
    
    /// Authentication coordinator
    private weak var authenticationCoordinator: AuthenticationCoordinator?
    
    // MARK: - Class constructor
    
    /// Registration coordinator class constructor
    init(navigationController: UINavigationController, authenticationCoordinator: AuthenticationCoordinator) {
        self.navigationController = navigationController
        self.authenticationCoordinator = authenticationCoordinator
    }
    
    // MARK: - Class methods
    
    /// Creates a sign up coordinator that displays a sign up screen
    public func start() {
        guard let navigationController = navigationController else { return }
        let signUpCoordinator = SignUpCoordinator(navigationController: navigationController, registrationCoordinator: self)
        signUpCoordinator.start()
    }
    
    /// Tells authentication coordinator that the user has successfully registered
    /// - Parameter model: Stores user data
    public func userDidSignUp(model: Profile) {
        authenticationCoordinator?.userDidSignUp(model: model)
    }
}
