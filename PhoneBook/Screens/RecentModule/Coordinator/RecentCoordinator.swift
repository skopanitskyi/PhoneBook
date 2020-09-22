//
//  RecentCoordinator.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 08.08.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import UIKit

class RecentCoordinator: TabBarItemCoordinator {
    
    private let firebaseService: FirebaseService
    private var recentViewController: RecentViewController?
    public let navigationController: UINavigationController
    public let tabBarItem: UITabBarItem
    
    init(firebaseService: FirebaseService) {
        self.firebaseService = firebaseService
        navigationController = UINavigationController()
        tabBarItem = UITabBarItem(title: "Recent.Title".localized, image: UIImage(named: "recent"), tag: 1)
        navigationController.tabBarItem = tabBarItem
    }
    
    public func start() {
        recentViewController = ScreensFactory.makeRecentScreen(coordinator: self, firebaseService: firebaseService)
        navigationController.pushViewController(recentViewController!, animated: true)
    }
    
    public func showDetailsContacts(contact: Contact) {
        let detailsCoordinator = DetailsContactCoordinator(coordinator: self,
                                                           navigationController: navigationController,
                                                           contact: contact,
                                                           firebaseService: firebaseService)
        detailsCoordinator.start()
    }
    
    
    public func updateRecentData() {
        recentViewController?.viewModel.updateData()
    }
}

extension RecentCoordinator: A {
    
    func addToRecent(contact: Contact) {
        recentViewController?.viewModel.addToRecent(contact: contact)
    }
}
