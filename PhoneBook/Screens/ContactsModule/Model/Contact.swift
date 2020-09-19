//
//  Contact.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 31.07.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import Foundation

class Contact: Codable {
    
    public let fullName: String
    public let phoneNumber: String
    public let city: String
    public let street: String
    public var isFavorite: Bool
    
    init(fullName: String, phoneNumber: String, city: String, street: String) {
        self.fullName = fullName
        self.phoneNumber = phoneNumber
        self.city = city
        self.street = street
        isFavorite = false
    }
}
