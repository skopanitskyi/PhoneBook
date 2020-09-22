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
    
    init(fullName: String, phoneNumber: String, city: String, street: String, isFavorite: Bool) {
        self.fullName = fullName
        self.phoneNumber = phoneNumber
        self.city = city
        self.street = street
        self.isFavorite = isFavorite
    }
    
    convenience init?(data: [String:Any]) {
        guard
            let fullName = data["name"] as? String,
            let phoneNumber = data["phone"] as? String,
            let city = data["city"] as? String,
            let street = data["street"] as? String,
            let isFavorite = data["isFavorite"] as? Bool
        else {
            return nil
        }
        self.init(fullName: fullName, phoneNumber: phoneNumber, city: city, street: street, isFavorite: isFavorite)
    }
}
