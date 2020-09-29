//
//  ProfileViewModel.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 24.08.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import Foundation
import MapKit

protocol ProfileViewModelProtocol {
    func logout()
    func getCoordinates(completion: @escaping ((CLLocationCoordinate2D?) -> Void))
    func getUserName() -> String?
    func getUserCity() -> String?
    func getUserStreet() -> String?
}

class ProfileViewModel: ProfileViewModelProtocol {
        
    private var profile: Profile?
    
    private let coordinator: ProfileCoordinator
    
    init(coordinator: ProfileCoordinator, profile: Profile?) {
        self.profile = profile
        self.coordinator = coordinator
        checkProfileData()
    }
    
    public func logout() {
        coordinator.logout()
    }
    
    private func checkProfileData() {
        
        if profile == nil {
            FirebaseService().getUserData { [weak self] profile in
                self?.profile = profile
            }
        }
    }
    
    public func getCoordinates(completion: @escaping ((CLLocationCoordinate2D?) -> Void)) {
        
        guard let city = profile?.city, let street = profile?.street else { return }
        
        let adress = "\(city), \(street)"
        
        MapService().getCoordinates(with: adress) { coordinates in
            completion(coordinates)
        }
    }
    
    public func getUserName() -> String? {
        return profile?.name
    }
    
    public func getUserCity() -> String? {
        return profile?.city
    }
    
    public func getUserStreet() -> String? {
        return profile?.street
    }
}
