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
    var error: ((String?) -> Void)? { get set }
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
    
    /// Used to show error on screen
    public var error: ((String?) -> Void)?
    
    /// Profile
    private var profile: Profile?
    
    /// Coordinator
    private let coordinator: ProfileCoordinator
    
    /// Service manager
    private let serviceManager: ServiceManager
    
    // MARK: - Class constructor
    
    /// Profile view model class constructor
    init(serviceManager: ServiceManager, coordinator: ProfileCoordinator, profile: Profile?) {
        self.serviceManager = serviceManager
        self.profile = profile
        self.coordinator = coordinator
        checkProfileData()
    }
    
    // MARK: - Class methods
    
    /// Tells coordinator that user is logout
    public func logout() {
        let firebaseService = serviceManager.getService(type: FirebaseService.self)
        firebaseService?.signOut { [weak self] result in
            switch result {
            case .success:
                self?.coordinator.logout()
            case .failure(let error):
                self?.error?(error.errorDescription)
            }
        }
    }
    
    /// Checks if user data is available. If they are not there, they are downloaded from the firebase.
    private func checkProfileData() {
        
        if profile == nil {
            let firebaseService = serviceManager.getService(type: FirebaseService.self)
            firebaseService?.getUserData { [weak self] result in
                switch result {
                case .success(let profile):
                    self?.profile = profile
                    self?.updateData?()
                case .failure(let error):
                    self?.error?(error.errorDescription)
                }
            }
        }
    }
    
    /// Returns coordinates depending on the user address
    /// - Parameter completion: User address in coordinates
    public func getCoordinates(completion: @escaping ((CLLocationCoordinate2D?) -> Void)) {
        
        guard let city = profile?.city, let street = profile?.street else {
            error?("CoordinatesError.FailedToGetCoordinates".localized)
            return
        }
        
        let address = "\(city), \(street)"
        let mapService = serviceManager.getService(type: MapService.self)
        
        mapService?.getCoordinates(with: address) { [weak self] result in
            switch result {
            case .success(let coordinates):
                completion(coordinates)
            case .failure(let error):
                self?.error?(error.errorDescription)
            }
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
