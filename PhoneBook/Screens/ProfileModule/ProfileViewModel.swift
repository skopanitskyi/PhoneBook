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
    var updateData: (() -> Void)? { get set }
    func logout()
    func getCoordinates(completion: @escaping ((CLLocationCoordinate2D?) -> Void))
    func getUserName() -> String?
    func getUserCity() -> String?
    func getUserStreet() -> String?
}

class ProfileViewModel: ProfileViewModelProtocol {
    
    // MARK: - Class instances
    
    /// Used to update data in a view
    public var updateData: (() -> Void)?
        
    /// Profile
    private var profile: Profile?
    
    /// Coordinator
    private let coordinator: ProfileCoordinator
    
    // MARK: - Class constructor
    
    /// Profile view model class constructor
    init(coordinator: ProfileCoordinator, profile: Profile?) {
        self.profile = profile
        self.coordinator = coordinator
        checkProfileData()
    }
    
    // MARK: - Class methods
    
    /// Tells coordinator that user is logout
    public func logout() {
        coordinator.logout()
    }
    
    /// Checks if user data is available. If they are not there, they are downloaded from the firebase.
    private func checkProfileData() {
        if profile == nil {
            FirebaseService().getUserData { [weak self] profile in
                self?.profile = profile
                self?.updateData?()
            }
        }
    }
    
    /// Returns coordinates depending on the user address
    /// - Parameter completion: User address in coordinates
    public func getCoordinates(completion: @escaping ((CLLocationCoordinate2D?) -> Void)) {
        
        guard let city = profile?.city, let street = profile?.street else { return }
        
        let adress = "\(city), \(street)"
        
        MapService().getCoordinates(with: adress) { coordinates in
            completion(coordinates)
        }
    }
    
    /// Return user full name
    public func getUserName() -> String? {
        return profile?.name
    }
    
    /// Return user city
    public func getUserCity() -> String? {
        return profile?.city
    }
    
    /// Return user street
    public func getUserStreet() -> String? {
        return profile?.street
    }
}