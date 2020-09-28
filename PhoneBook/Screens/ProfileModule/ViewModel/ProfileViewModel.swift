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
    
    private var model: SignUpModel?
    
    private let coordinator: ProfileCoordinator
    
    init(coordinator: ProfileCoordinator, model: SignUpModel?) {
        self.model = model
        self.coordinator = coordinator
    }
    
    public func logout() {
        coordinator.logout()
    }
    
    public func getCoordinates(completion: @escaping ((CLLocationCoordinate2D?) -> Void)) {
        
        guard let city = model?.city, let street = model?.street else { return }
        
        let adress = "\(city), \(street)"
        
        MapService().getCoordinates(with: adress) { coordinates in
            completion(coordinates)
        }
    }
    
    public func getUserName() -> String? {
        let name = model!.name!
        let surname = model!.surname!
        return "\(name) \(surname)"
    }
    
    public func getUserCity() -> String? {
        return model?.city
    }
    
    public func getUserStreet() -> String? {
        return model?.street
    }
}
