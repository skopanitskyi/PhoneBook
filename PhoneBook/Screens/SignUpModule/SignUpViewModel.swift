//
//  SignUpViewModel.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 05.09.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import Foundation

protocol SignUpViewModelProtocol {
    var error: ((String?) -> Void)? { get set }
    func validate(email: String?, password: String?, name: String?, surname: String?, city: String?, street: String?)
}

class SignUpViewModel: SignUpViewModelProtocol {
    
    // MARK: - Class instances
    
    /// Coordinator
    private let signUpCoordinator: SignUpCoordinator
    
    /// Used to show error on screen
    public var error: ((String?) -> Void)?
    
    // MARK: - Class constructor
    
    /// Sign up view model class constructor
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
        
        guard
            let email = email, email.count > 0,
            let password = password, password.count > 0
        else {
            error?("AuthenticationErrors.FieldsNotFilled".localized)
            return
        }
        
        if email.isValidEmail && password.isValidPassword {
            if let profile = getProfile(name: name, surname: surname, city: city, street: street) {
                signUp(email: email, password: password, profile: profile)
            }
        } else {
            error?("Login.PasswordOrEmailInvalid".localized)
        }
    }
    
    /// Checks the entered data for correctness
    /// - Parameters:
    ///   - name:     User name
    ///   - surname:  User surname
    ///   - city:     User city
    ///   - street:   User street
    private func getProfile(name: String?, surname: String?, city: String?, street: String?) -> Profile? {
        guard
            let name = name, name.count > 0,
            let surname = surname, surname.count > 0,
            let city = city, city.count > 0,
            let street = street, street.count > 0
        else {
            error?("AuthenticationErrors.FieldsNotFilled".localized)
            return nil
        }
        return Profile(name: "\(name) \(surname)", city: city, street: street)
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
                self?.error?(error.errorDescription)
            }
        }
    }
}

