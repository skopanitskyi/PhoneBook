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
    
    init(fullName: String, phoneNumber: String) {
        self.fullName = fullName
        self.phoneNumber = phoneNumber
    }
}
