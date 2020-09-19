//
//  SignUpViewModel.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 05.09.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import Foundation

protocol SignUpViewModelProtocol {
    func signUp(email: String?, password: String?, name: String?, surname: String?, city: String?, street: String?)
}

class SignUpViewModel: SignUpViewModelProtocol {
    
    private let signUpCoordinator: SignUpCoordinator
    
    init(signUpCoordinator: SignUpCoordinator) {
        self.signUpCoordinator = signUpCoordinator
    }
    
    public func signUp(email: String?, password: String?, name: String?, surname: String?, city: String?, street: String?) {
        
        if email!.isValidEmail && password!.isValidPassword {
            guard
                let name = name,
                let surname = surname,
                let city = city,
                let street = street
            else { return }
            
            let signUpModel = SignUpModel(email: email!,
                                          password: password!,
                                          name: name,
                                          surname: surname,
                                          city: city,
                                          street: street)
            FirebaseService().signUp(model: signUpModel) { result in
                switch result {
                case .success:
                    self.signUpCoordinator.userDidSignUp()
                case .failure(let error):
                    if let error = error.errorDescription {
                        print(error)
                    }
                }
            }
        }
    }
}

