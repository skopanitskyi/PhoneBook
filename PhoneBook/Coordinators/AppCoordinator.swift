//
//  AppCoordinator.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 08.08.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import UIKit

protocol Coordinator {
    func start()
}

class AppCoordinator: Coordinator {
    
    // MARK: - Class instances
    
    /// Window
    private let window: UIWindow
    
    /// Firebase service
    private let firebaseService: FirebaseService
    
    /// Tab bar coordinator
    private var tabBarCoordinator: TabBarCoordinator?
    
    /// Authentication coordinator
    private var authenticationCoordinator: AuthenticationCoordinator?
    
    /// Deeplink service
    private var deeplinkService: DeeplinkService?
    
    // MARK: - Class constructor
    
    /// App coordinator class constructor
    init(window: UIWindow) {
        self.window = window
        firebaseService = FirebaseService()
    }
    
    // MARK: - Class methods
    
    /// Creates an authentication coordinator that displays the authentication screen
    public func start() {
        authenticationCoordinator = AuthenticationCoordinator(window: window, appCoordinator: self)
        authenticationCoordinator?.start()
        deeplinkService = DeeplinkService(appCoordinator: self)
    }
    
    /// Displays screen that was selected using deeplink
    /// - Parameter name: Screen name
    public func showScreen(_ name: String) {
        deeplinkService?.showScreen(name, isAuthorized: tabBarCoordinator != nil)
    }
    
    /// Returns tab bar coordinator
    public func getTabBarCoordinator() -> TabBarCoordinator? {
        return tabBarCoordinator
    }
    
    /// Launches the application when authorization or registration is completed successfully
    /// - Parameter model: Stores user data
    public func startApp(model: Profile?) {
        tabBarCoordinator = TabBarCoordinator(window: window,
                                              firebaseService: firebaseService,
                                              appCoordinator: self,
                                              userModel: model)
        tabBarCoordinator?.start()
        deeplinkService?.openSavedLink()

        authenticationCoordinator = nil
    }
    
    /// Exits the main menu and displays the login screen
    public func logout() {
        start()
        tabBarCoordinator = nil
    }
}
