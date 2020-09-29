//
//  AuthenticationCoordinator.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 05.09.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import UIKit

class AuthenticationCoordinator: Coordinator {
    
    private let window: UIWindow
    private weak var appCoordinator: AppCoordinator?
    private let navigationController: UINavigationController
    
    init(window: UIWindow, appCoordinator: AppCoordinator) {
        self.window = window
        self.appCoordinator = appCoordinator
        navigationController = UINavigationController()
    }
    
    public func start() {
        let loginCoordinator = LoginCoordinator(navigationController: navigationController,
                                                authenticationCoordinator: self)
        loginCoordinator.start()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    
    public func signUp() {
        let registrationCoordinator = RegistrationCoordinator(navigationController: navigationController, authenticationCoordinator: self)
        registrationCoordinator.start()
    }
    
    public func userDidSignUp(model: Profile) {
        appCoordinator?.startApp(model: model)
    }
    
    public func userDidLogIn(model: Profile?) {
        appCoordinator?.startApp(model: model)
    }
}
