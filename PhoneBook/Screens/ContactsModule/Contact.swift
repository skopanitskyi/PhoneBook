//
//  Contact.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 31.07.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import Foundation

class Contact: Codable {
    
    /// Full user name
    public let fullName: String
    
    /// User phone number
    public let phoneNumber: String
    
    /// User city
    public let city: String
    
    /// User street
    public let street: String
    
    /// Is user favorite
    public var isFavorite: Bool
    
    // MARK: - Class constructors
    
    /// Contact class constructor
    init(fullName: String, phoneNumber: String, city: String, street: String, isFavorite: Bool) {
        self.fullName = fullName
        self.phoneNumber = phoneNumber
        self.city = city
        self.street = street
        self.isFavorite = isFavorite
    }
}
