//
//  SignUpCoordinator.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 05.09.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import UIKit

class RegistrationCoordinator: Coordinator {
    
    private weak var navigationController: UINavigationController?
    private weak var authenticationCoordinator: AuthenticationCoordinator?
    
    init(navigationController: UINavigationController, authenticationCoordinator: AuthenticationCoordinator) {
        self.navigationController = navigationController
        self.authenticationCoordinator = authenticationCoordinator
    }
    
    
    public func start() {
        guard let navigationController = navigationController else { return }
        let signUpCoordinator = SignUpCoordinator(navigationController: navigationController, registrationCoordinator: self)
        signUpCoordinator.start()
    }
}
