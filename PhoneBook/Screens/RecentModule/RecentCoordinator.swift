//
//  RecentCoordinator.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 08.08.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import UIKit

protocol UpdateRecentContacts {
    func addToRecent(contact: Contact)
}

class RecentCoordinator: TabBarItemCoordinator {
    
    // MARK: - Class instances
    
    /// Coordinator
    private let coordinator: TabBarCoordinator
    
    /// Firebase service
    private let firebaseService: FirebaseService
    
    /// Recent view controller
    private var recentViewController: RecentViewController?
    
    /// Navigation controller
    public let navigationController: UINavigationController
    
    /// Tab bar item
    public let tabBarItem: UITabBarItem
    
    // MARK: - Class constructor
    
    /// Recent coordinator class constructor
    init(coordinator: TabBarCoordinator, firebaseService: FirebaseService) {
        self.coordinator = coordinator
        self.firebaseService = firebaseService
        navigationController = UINavigationController()
        tabBarItem = UITabBarItem(title: "Recent.Title".localized, image: UIImage(named: "recent"), tag: 1)
        navigationController.tabBarItem = tabBarItem
    }
    
    // MARK: - Class methods
    
    /// Creates a recent screen and displays it
    public func start() {
        recentViewController = ScreensFactory.makeRecentScreen(coordinator: self, firebaseService: firebaseService)
        navigationController.pushViewController(recentViewController!, animated: true)
    }
    
    /// Creates a details contact coordinator and transfers contact data to him
    /// - Parameter contact: The contact, data of which will be displayed
    public func showDetailsContacts(contact: Contact) {
        let detailsCoordinator = DetailsContactCoordinator(coordinator: self,
                                                           navigationController: navigationController,
                                                           contact: contact,
                                                           firebaseService: firebaseService)
        detailsCoordinator.start()
    }
}

// MARK: - UpdateRecentContacts

extension RecentCoordinator: UpdateRecentContacts {
    
    func addToRecent(contact: Contact) {
        recentViewController?.viewModel.addToRecent(contact: contact)
    }
}

// MARK: - UpdateFavoriteContactStatus

extension RecentCoordinator: UpdateFavoriteContactStatus {
    func updateContact(contact: Contact) {
        recentViewController?.viewModel.updateContactData(contact: contact)
    }
}

// MARK: - UpdateDataFromDetailsContact

extension RecentCoordinator: UpdateDataFromDetailsContact {
    public func updateRecentData(contact: Contact) {
        recentViewController?.viewModel.updateContactData(contact: contact)
        coordinator.updateFromRecent(contact: contact)
    }
}
