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
    private var navigationController: UINavigationController
    private let contactsService: ContactsService
    private var tabBarCoordinator: TabBarCoordinator?
    
    init(window: UIWindow) {
        self.window = window
        navigationController = UINavigationController()
        contactsService = ContactsService()
    }
    
    public func start() {
        tabBarCoordinator = TabBarCoordinator(window: window, contactsService: contactsService)
        tabBarCoordinator?.start()
    }
    
    public func showScreen(_ name: String) {
        let deeplinkService = DeeplinkService(appCoordinator: self)
        deeplinkService.showScreen(name)
    }
    
    public func getTabBarCoordinator() -> TabBarCoordinator? {
        return tabBarCoordinator
    }
}
