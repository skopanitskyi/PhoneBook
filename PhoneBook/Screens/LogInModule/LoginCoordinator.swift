//
//  LoginCoordinator.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 05.09.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import UIKit

class LoginCoordinator: Coordinator {
    
    private weak var navigationController: UINavigationController?
    private weak var authenticationCoordinator: AuthenticationCoordinator?
    
    init(navigationController: UINavigationController, authenticationCoordinator: AuthenticationCoordinator) {
        self.navigationController = navigationController
        self.authenticationCoordinator = authenticationCoordinator
    }
    
    
    public func start() {
        let loginController = UIStoryboard(name: "Login",
                                           bundle: nil).instantiateViewController(withIdentifier: "Login") as! LoginViewController
        let loginViewModel = LoginViewModel(loginCoordinator: self)
        loginController.viewModel = loginViewModel
        navigationController?.setViewControllers([loginController], animated: false)
    }
    
    public func signUp() {
        authenticationCoordinator?.signUp()
    }
    
    public func userDidLogIn() {
        authenticationCoordinator?.userDidLogIn()
    }
}
