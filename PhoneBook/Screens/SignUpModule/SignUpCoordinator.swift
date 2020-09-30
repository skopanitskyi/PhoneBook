//
//  SignUpCoordinator.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 05.09.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import UIKit

class SignUpCoordinator: Coordinator {
    
    // MARK: - Class instances
    
    /// Navigation controller
    private let navigationController: UINavigationController
    
    /// Coordinator
    private let registrationCoordinator: RegistrationCoordinator
    
    // MARK: - Class constructor
    
    /// Sign up coordinator class constructor
    init(navigationController: UINavigationController, registrationCoordinator: RegistrationCoordinator) {
        self.navigationController = navigationController
        self.registrationCoordinator = registrationCoordinator
    }
    
    // MARK: - Class methods
    
    /// Creates a sign up screen and displays it
    public func start() {
        guard let signUpController = ScreensFactory.makeSignUpScreen(coordinator: self) else { return }
        navigationController.pushViewController(signUpController, animated: true)
    }
    
    /// Tells the coordinator that the user is sign up
    /// - Parameter model: Stores user data
    public func userDidSignUp(model: Profile) {
        registrationCoordinator.userDidSignUp(model: model)
    }
}
