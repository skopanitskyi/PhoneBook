//
//  LoginViewModel.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 04.09.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import Foundation

protocol LoginViewModelProtocol {
    var error: ((String?) -> Void)? { get set }
    func loginWithFacebook()
    func loginWithEmail(email: String?, password: String?)
    func signUp()
}

class LoginViewModel: LoginViewModelProtocol {
    
    // MARK: - Class instances
    
    /// Coordinator
    private let loginCoordinator: LoginCoordinator
    
    /// Service manager
    private let serviceManager: ServiceManager
    
    /// Used to show error on screen
    public var error: ((String?) -> Void)?
    
    // MARK: - Class constructor
    
    /// Login view model class constructor
    init(serviceManager: ServiceManager, loginCoordinator: LoginCoordinator) {
        self.serviceManager = serviceManager
        self.loginCoordinator = loginCoordinator
    }
    
    // MARK: - Class methods
    
    /// Performs authorization using facebook
    public func loginWithFacebook() {
        let firebaseService = serviceManager.getService(type: FirebaseService.self)
        firebaseService?.logInWithFacebook() { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let isNewUser, let name):
                    self?.fetchContact(isNewUser: isNewUser, name: name)
                case .failure(let error):
                    self?.error?(error.errorDescription)
                }
            }
        }
    }
    
    /// Requests contact data from the device internal storage. If they are received, then they are stored in the firestore
    /// - Parameters:
    ///   - isNewUser: Is user is new
    ///   - name: User name
    private func fetchContact(isNewUser: Bool?, name: String?) {
        let contactService = serviceManager.getService(type: ContactsService.self)
        if let isNewUser = isNewUser, let name = name, isNewUser {
            let profile = Profile(name: name, city: nil, street: nil)
            contactService?.fetchFromMocks { [weak self] contacts in
                self?.saveUserData(profile: profile, contacts: contacts)
            }
        } else {
            loginCoordinator.userDidLogIn(model: nil)
        }
    }
    
    /// Stores user data in a database
    /// - Parameters:
    ///   - profile: User data
    ///   - contacts: Contacts data
    private func saveUserData(profile: Profile, contacts: [Contact]) {
        let firebaseService = serviceManager.getService(type: FirebaseService.self)
        firebaseService?.saveNewUser(profile: profile, contacts: contacts) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.loginCoordinator.userDidLogIn(model: profile)
                case .failure(let error):
                    self?.error?(error.errorDescription)
                }
            }
        }
    }
    
    /// Performs authorization using email and password
    /// - Parameters:
    ///   - email: User email address
    ///   - password: User password
    public func loginWithEmail(email: String?, password: String?) {
        let firebaseService = serviceManager.getService(type: FirebaseService.self)
        if email!.isValidEmail && password!.isValidPassword {
            firebaseService?.logIn(email: email!, password: password!) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self?.loginCoordinator.userDidLogIn(model: nil)
                    case .failure(let error):
                        self?.error?(error.errorDescription)
                    }
                }
            }
        } else {
            error?("Login.PasswordOrEmailInvalid".localized)
        }
    }
    
    /// Tells the coordinator that the user wants to register
    public func signUp() {
        loginCoordinator.signUp()
    }
}
