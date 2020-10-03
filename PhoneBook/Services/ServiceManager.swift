//
//  ServiceManager.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 03.10.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import Foundation

protocol Service {
    
}

class ServiceManager {
    
    // MARK: - Class instances
    
    /// Store services
    private var services = [String : Service]()
    
    // MARK: - Class methods
    
    /// Adds the received service to dictionary
    /// - Parameter service: Service for saving
    public func addService<T: Service>(service: T) {
        let key = "\(T.self)"
        services[key] = service
    }
    
    /// Returns the specified service from the dictionary
    /// - Parameter service: The type of service to be returned
    public func getService<T: Service>(type: T.Type) -> T? {
        let key = "\(type.self)"
        return services[key] as? T
    }
    
    /// Removes the specified service from the dictionary
    /// - Parameter service: The type of service to be deleted
    public func deleteService<T: Service>(type: T.Type) {
        let key = "\(type.self)"
        if let index = services.index(forKey: key) {
            services.remove(at: index)
        }
    }
    
}
