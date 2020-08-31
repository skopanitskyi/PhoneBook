//
//  RecentViewModel.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 08.08.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import Foundation

protocol RecentViewModelProtocol {
    func numberOfRowsInSection() -> Int
    func getContactName(at index: Int) -> String
}

class RecentViewModel: RecentViewModelProtocol {
    
    private let contactsService: ContactsService
    
    init(contactsService: ContactsService) {
        self.contactsService = contactsService
    }
    
    public func numberOfRowsInSection() -> Int {
       return contactsService.getContacts().count
    }
    
    public func getContactName(at index: Int) -> String {
        return contactsService.getContacts()[index].fullName
    }
}
