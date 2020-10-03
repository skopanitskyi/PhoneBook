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
    private let serviceManager: ServiceManager
    
    /// Tab bar coordinator
    private var tabBarCoordinator: TabBarCoordinator?
    
    /// Authentication coordinator
    private var authenticationCoordinator: AuthenticationCoordinator?
    
    // MARK: - Class constructor
    
    /// App coordinator class constructor
    init(window: UIWindow) {
        self.window = window
        serviceManager = ServiceManager()
        startService()
    }
    
    // MARK: - Class methods
    
    /// Creates an authentication coordinator that displays the authentication screen
    public func start() {
        authenticationCoordinator = AuthenticationCoordinator(serviceManager: serviceManager,
                                                              window: window,
                                                              appCoordinator: self)
        authenticationCoordinator?.start()
    }
    
    /// Initializes services required for initial work
    private func startService() {
        serviceManager.addService(service: FirebaseService())
        serviceManager.addService(service: DeeplinkService(appCoordinator: self))
        serviceManager.addService(service: ContactsService())
    }
    
    /// Initializes all services
    private func startAllService() {
        serviceManager.addService(service: MapService())
    }
    
    /// Removes services that are not needed
    private func deleteService() {
        serviceManager.deleteService(type: MapService.self)
    }
    
    /// Displays screen that was selected using deeplink
    /// - Parameter name: Screen name
    public func showScreen(_ name: String) {
        let deeplinkService = serviceManager.getService(type: DeeplinkService.self)
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
                                              serviceManager: serviceManager,
                                              appCoordinator: self,
                                              userModel: model)
        tabBarCoordinator?.start()
        let deeplinkService = serviceManager.getService(type: DeeplinkService.self)
        deeplinkService?.openSavedLink()
        startAllService()
        authenticationCoordinator = nil
    }
    
    /// Exits the main menu and displays the login screen
    public func logout() {
        start()
        deleteService()
        tabBarCoordinator = nil
    }
}
