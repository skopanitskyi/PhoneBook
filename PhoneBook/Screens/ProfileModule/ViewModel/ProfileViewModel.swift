//
//  ProfileViewModel.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 24.08.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import Foundation

protocol ProfileViewModelProtocol {
    func logout()
}

class ProfileViewModel: ProfileViewModelProtocol {
    
    private let coordinator: ProfileCoordinator
    
    init(coordinator: ProfileCoordinator) {
        self.coordinator = coordinator
    }
    
    public func logout() {
        coordinator.logout()
    }
}
