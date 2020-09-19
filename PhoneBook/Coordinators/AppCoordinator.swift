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
    
    private let window: UIWindow
    private let firebaseService: FirebaseService
    private var tabBarCoordinator: TabBarCoordinator?
    private var authenticationCoordinator: AuthenticationCoordinator?
    
    init(window: UIWindow) {
        self.window = window
        firebaseService = FirebaseService()
    }
    
    public func start() {
        authenticationCoordinator = AuthenticationCoordinator(window: window, appCoordinator: self)
        authenticationCoordinator?.start()
    }
    
    public func showScreen(_ name: String) {
        let deeplinkService = DeeplinkService(appCoordinator: self)
        deeplinkService.showScreen(name)
    }
    
    public func getTabBarCoordinator() -> TabBarCoordinator? {
        return tabBarCoordinator
    }
    
    public func startApp() {
        tabBarCoordinator = TabBarCoordinator(window: window, firebaseService: firebaseService, appCoordinator: self)
        tabBarCoordinator?.start()
        
        authenticationCoordinator = nil
    }
    
    public func logout() {
        start()
        tabBarCoordinator = nil
    }
}
