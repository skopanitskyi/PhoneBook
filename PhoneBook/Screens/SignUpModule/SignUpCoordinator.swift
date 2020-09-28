//
//  SignUpCoordinator.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 05.09.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import UIKit

class SignUpCoordinator: Coordinator {
    
    private let navigationController: UINavigationController
    private let registrationCoordinator: RegistrationCoordinator
    
    init(navigationController: UINavigationController, registrationCoordinator: RegistrationCoordinator) {
        self.navigationController = navigationController
        self.registrationCoordinator = registrationCoordinator
    }
    
    public func start() {
        let signUpController = ScreensFactory.makeSignUpScreen(coordinator: self)
        navigationController.pushViewController(signUpController, animated: true)
    }
    
    public func userDidSignUp(model: SignUpModel) {
        registrationCoordinator.userDidSignUp(model: model)
    }
}
