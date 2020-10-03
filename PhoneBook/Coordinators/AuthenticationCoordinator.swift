//
//  AuthenticationCoordinator.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 05.09.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import UIKit

class AuthenticationCoordinator: Coordinator {
    
    // MARK: - Class instances
    
    /// Service manager
    private let serviceManager: ServiceManager
    
    /// Winidow
    private let window: UIWindow
    
    /// App coordinator
    private weak var appCoordinator: AppCoordinator?
    
    /// Navigation controller
    private let navigationController: UINavigationController
    
    // MARK: - Class constructor
    
    /// AuthenticationCoordinator class constructor
    init(serviceManager: ServiceManager, window: UIWindow, appCoordinator: AppCoordinator) {
        self.serviceManager = serviceManager
        self.window = window
        self.appCoordinator = appCoordinator
        navigationController = UINavigationController()
    }
    
    // MARK: - Class methods
    
    /// Creates a login coordinator that displays a login screen
    public func start() {
        let loginCoordinator = LoginCoordinator(serviceManager: serviceManager,
                                                navigationController: navigationController,
                                                authenticationCoordinator: self)
        loginCoordinator.start()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    /// Creates a registration coordinator
    public func signUp() {
        let registrationCoordinator = RegistrationCoordinator(navigationController: navigationController,
                                                              authenticationCoordinator: self,
                                                              serviceManager: serviceManager)
        registrationCoordinator.start()
    }
    
    /// Tells the app coordinator that the user has registered
    /// - Parameter model: Stores user data
    public func userDidSignUp(model: Profile) {
        appCoordinator?.startApp(model: model)
    }
    
    /// Tells the app coordinator that the user is logged in
    /// - Parameter model: Stores user data
    public func userDidLogIn(model: Profile?) {
        appCoordinator?.startApp(model: model)
    }
}
