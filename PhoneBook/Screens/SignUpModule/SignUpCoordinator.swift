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
    private weak var registrationCoordinator: RegistrationCoordinator?
    
    init(navigationController: UINavigationController, registrationCoordinator: RegistrationCoordinator) {
        self.navigationController = navigationController
        self.registrationCoordinator = registrationCoordinator
    }
    
    public func start() {
        let signUpController = UIStoryboard(name: "SignUp",
                                            bundle: nil).instantiateViewController(withIdentifier: "SignUp") as! SignUpViewController
        let signUpViewModel = SignUpViewModel()
        signUpController.viewModel = signUpViewModel
        navigationController.pushViewController(signUpController, animated: true)
    }
}
