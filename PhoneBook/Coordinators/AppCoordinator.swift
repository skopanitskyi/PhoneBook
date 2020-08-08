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
    private let contactsService = ContactsService()
    
    init(window: UIWindow) {
        self.window = window
        navigationController = UINavigationController()
    }
    
    public func start() {
        let tabBarCoordinator = TabBarCoordinator(window: window, contactsService: contactsService)
        tabBarCoordinator.start()
    }
}
