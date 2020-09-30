//
//  SignUpViewModel.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 05.09.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import Foundation

protocol SignUpViewModelProtocol {
    func validate(email: String?, password: String?, name: String?, surname: String?, city: String?, street: String?)
}

class SignUpViewModel: SignUpViewModelProtocol {
    
    // MARK: - Class instances
    
    private let signUpCoordinator: SignUpCoordinator
    
    // MARK: - Class constructor
    
    init(signUpCoordinator: SignUpCoordinator) {
        self.signUpCoordinator = signUpCoordinator
    }
    
    // MARK: - Class methods
    
    /// Checks data for correctness. If the data is correct, the registration method is called
    /// - Parameters:
    ///   - email:    User email
    ///   - password: User password
    ///   - name:     User name
    ///   - surname:  User surname
    ///   - city:     User city
    ///   - street:   User street
    public func validate(email: String?, password: String?, name: String?, surname: String?, city: String?, street: String?) {
        
        if email!.isValidEmail && password!.isValidPassword {
            guard
                let name = name,
                let surname = surname,
                let city = city,
                let street = street
            else { return }
            
            let profile = Profile(name: "\(name) \(surname)", city: city, street: street)
            signUp(email: email!, password: password!, profile: profile)
        }
    }
    
    /// Registers a new user and stores his data in firebase
    /// - Parameters:
    ///   - email:    User email
    ///   - password: User password
    ///   - profile:  Stored user data
    private func signUp(email: String, password: String, profile: Profile) {
        FirebaseService().signUp(email: email, password: password, model: profile) { [weak self] result in
            switch result {
            case .success:
                self?.signUpCoordinator.userDidSignUp(model: profile)
            case .failure(let error):
                if let error = error.errorDescription {
                    print(error)
                }
            }
        }
    }
}

