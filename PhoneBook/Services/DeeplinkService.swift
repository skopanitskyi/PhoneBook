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
    
    // MARK: - Class instances
    
    /// App coordinator
    private let appCoordinator: AppCoordinator
    
    /// Store screen name which will be shown after authorization
    private var screenName: String?
    
    // MARK: - Class constructor
    
    /// Deeplink service class constructor
    init(appCoordinator: AppCoordinator) {
        self.appCoordinator = appCoordinator
    }
    
    // MARK: - Class methods
    
    /// Displays the selected screen
    /// - Parameters:
    ///   - name: Name of the screen to be displayed
    ///   - isAuthorized: Is user authorized
    public func showScreen( _ name: String, isAuthorized: Bool) {
        
        guard let screen = DeeplinkScreens.init(rawValue: name) else { return }
        
        if !isAuthorized {
            screenName = name
            return
        }
        
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
    
    /// Displays the selected screen after login
    public func openSavedLink() {
        if let url = screenName {
            showScreen(url, isAuthorized: true)
            screenName = nil
        }
    }
    
    /// Display contacts screnn
    private func displayContacts() {
        setSelectedTabBarItem(at: TabBarScreen.contacts)
    }
    
    /// Display recent screen
    private func displayRecent() {
        setSelectedTabBarItem(at: TabBarScreen.recent)
    }
    
    /// Display favorite screen
    private func displayFavorite() {
        setSelectedTabBarItem(at: TabBarScreen.favorites)
    }
    
    /// Display profile screen
    private func displayProfile() {
        setSelectedTabBarItem(at: TabBarScreen.profile)
    }
    
    /// Tells the tab bar coordinator which screen to display
    /// - Parameter index: Index of screen
    private func setSelectedTabBarItem(at index: TabBarScreen) {
        appCoordinator.getTabBarCoordinator()?.selectItem(at: index)
    }
}
