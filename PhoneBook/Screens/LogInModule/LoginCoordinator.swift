//
//  LoginCoordinator.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 05.09.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import UIKit

class LoginCoordinator: Coordinator {
    
    // MARK: - Class instances
    
    /// Service manager
    private let serviceManager: ServiceManager
    
    /// Navigation controller
    private weak var navigationController: UINavigationController?
    
    /// Coordinator
    private weak var authenticationCoordinator: AuthenticationCoordinator?
    
    // MARK: - Class constructor
    
    /// Login coordinator class constructor
    init(serviceManager: ServiceManager,
         navigationController: UINavigationController,
         authenticationCoordinator: AuthenticationCoordinator) {
        self.serviceManager = serviceManager
        self.navigationController = navigationController
        self.authenticationCoordinator = authenticationCoordinator
    }
    
    // MARK: - Class methods
    
    /// Creates a login screen and displays it
    public func start() {
        guard let loginController = ScreensFactory.makeLoginScreen(serviceManager: serviceManager,
                                                                   coordinator: self) else { return }
        navigationController?.setViewControllers([loginController], animated: false)
    }
    
    /// Tells the coordinator that the user wants to register
    public func signUp() {
        authenticationCoordinator?.signUp()
    }
    
    /// Tells the coordinator that the user is logged in
    public func userDidLogIn(model: Profile?) {
        authenticationCoordinator?.userDidLogIn(model: model)
    }
}
