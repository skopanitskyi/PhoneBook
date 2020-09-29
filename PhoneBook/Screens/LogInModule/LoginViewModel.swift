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
    
    private let loginCoordinator: LoginCoordinator
    
    init(loginCoordinator: LoginCoordinator) {
        self.loginCoordinator = loginCoordinator
    }
    
    public func loginWithFacebook() {
        FirebaseService().logInWithFacebook() { model, result in
            switch result {
            case .success:
                self.loginCoordinator.userDidLogIn(model: model)
            case .failure(let error):
                print(error.errorDescription!)
            }
        }
    }
    
    public func loginWithEmail(email: String?, password: String?) {
        if email!.isValidEmail && password!.isValidPassword {
            FirebaseService().logIn(email: email!, password: password!) { result in
                switch result {
                case .success:
                    self.loginCoordinator.userDidLogIn(model: nil)
                case .failure(let error):
                    print(error.errorDescription!)
                }
            }
        } else {
            print("Password or email is invalid")
        }
    }
    
    public func signUp() {
        loginCoordinator.signUp()
    }
}
