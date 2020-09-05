//
//  LoginViewModel.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 04.09.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import FBSDKLoginKit
import Firebase
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
        
        let loginManager = LoginManager()
        loginManager.logIn(permissions: [.publicProfile, .email], viewController: nil) { (result) in
            switch result {
            case .failed(let error):
                print(error.localizedDescription)
            case .cancelled:
                break
            case .success(_, _, let token):
                let credential = FacebookAuthProvider.credential(withAccessToken: token.tokenString)
                
                Auth.auth().signIn(with: credential) { (result, error) in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    
                    print("Success login facebook")
                }
            }
        }
    }
    
    public func loginWithEmail(email: String?, password: String?) {
        if email!.isValidEmail && password!.isValidPassword {
            Auth.auth().signIn(withEmail: email!, password: password!) { (result, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                print("Firebase is sig in")
            }
        } else {
            print("Password or email is invalid")
        }
    }
    
    public func signUp() {
        loginCoordinator.signUp()
    }
}
