//
//  DetailsContactViewModel.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 21.09.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import Foundation

protocol DetailsContactViewModelProtocol {
    func updateFavoriteStatus()
}

class DetailContactViewModel: DetailsContactViewModelProtocol {
    
    private var contact: Contact
    private let firebaseService: FirebaseService
    
    init(contact: Contact, firebaseService: FirebaseService) {
        self.contact = contact
        self.firebaseService = firebaseService
    }
    
    public func updateFavoriteStatus() {
        contact.isFavorite = !contact.isFavorite
        firebaseService.some(name: contact.fullName)
    }
}
