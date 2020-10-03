//
//  User.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 03.10.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import Foundation

class User: Codable {
    
    // MARK: - Class instances
    
    /// User name
    public let name: String
    
    /// User city
    public let city: String?
    
    /// User street
    public let street: String?
    
    /// User contacts
    public var contacts: [Contact]
    
    /// User recent contacts
    public var recent: [Contact]
    
    /// User favorites contacts
    public var favorites: [Contact]
    
    // MARK: Class constructor
    
    /// User class constructor
    init(name: String, city: String?, street: String?, contacts: [Contact], recent: [Contact], favorites: [Contact]) {
        self.name = name
        self.city = city
        self.street = street
        self.contacts = contacts
        self.recent = recent
        self.favorites = favorites
    }
    
    /// Coding keys for decoding and encoding
    private enum CodingKeys: String, CodingKey {
        case name
        case city
        case street
        case contacts
        case recent
        case favorites
    }
}
