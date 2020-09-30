//
//  LoginViewModel.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 04.09.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import Foundation

protocol LoginViewModelProtocol {
    func loginWithFacebook()
    func loginWithEmail(email: String?, password: String?)
    func signUp()
}

class LoginViewModel: LoginViewModelProtocol {
    
    // MARK: - Class instances
    
    /// Coordinator
    private let loginCoordinator: LoginCoordinator
    
    // MARK: - Class constructor
    
    /// Login view model class constructor
    init(loginCoordinator: LoginCoordinator) {
        self.loginCoordinator = loginCoordinator
    }
    
    // MARK: - Class methods
    
    /// Performs authorization using facebook
    public func loginWithFacebook() {
        FirebaseService().logInWithFacebook() { [weak self] model, result in
            switch result {
            case .success:
                self?.loginCoordinator.userDidLogIn(model: model)
            case .failure(let error):
                print(error.errorDescription!)
            }
        }
    }
    
    /// Performs authorization using email and password
    /// - Parameters:
    ///   - email: User email address
    ///   - password: User password
    public func loginWithEmail(email: String?, password: String?) {
        if email!.isValidEmail && password!.isValidPassword {
            FirebaseService().logIn(email: email!, password: password!) { [weak self] result in
                switch result {
                case .success:
                    self?.loginCoordinator.userDidLogIn(model: nil)
                case .failure(let error):
                    print(error.errorDescription!)
                }
            }
        } else {
            print("Password or email is invalid")
        }
    }
    
    /// Tells the coordinator that the user wants to register
    public func signUp() {
        loginCoordinator.signUp()
    }
}
