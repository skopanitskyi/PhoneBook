//
//  DeeplinkService.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 31.08.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import Foundation

enum DeeplinkScreens: String {
    case contacts = "contacts"
    case recent = "recent"
    case favorite = "favorites"
    case profile = "profile"
}

class DeeplinkService {
    
    private let appCoordinator: AppCoordinator
    
    init(appCoordinator: AppCoordinator) {
        self.appCoordinator = appCoordinator
    }
    
    public func showScreen( _ name: String) {
        
        guard let screen = DeeplinkScreens.init(rawValue: name) else { return }
        
        switch screen {
        case .contacts:
            displayContacts()
        case .recent:
            displayRecent()
        case .favorite:
            displayFavorite()
        case .profile:
            displayProfile()
        }
    }
    
    private func displayContacts() {
        setSelectedTabBarItem(at: TabBarScreen.contacts)
    }
    
    private func displayRecent() {
        setSelectedTabBarItem(at: TabBarScreen.recent)
    }
    
    private func displayFavorite() {
        setSelectedTabBarItem(at: TabBarScreen.favorites)
    }
    
    private func displayProfile() {
        setSelectedTabBarItem(at: TabBarScreen.profile)
    }
    
    private func setSelectedTabBarItem(at index: TabBarScreen) {
        appCoordinator.getTabBarCoordinator()?.selectItem(at: index)
    }
}
