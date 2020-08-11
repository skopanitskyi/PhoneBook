//
//  FilteredContactsViewModel.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 10.08.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import Foundation


protocol FilteredContactsViewModelProtocol {
    func set(contacts: [Contact])
    var updateTableView: (() -> Void)? { get set }
    func numberOfRowsInSection() -> Int
    func getContact(at index: Int) -> Contact
}

class FilteredContactsViewModel: FilteredContactsViewModelProtocol {
    
    public var updateTableView: (() -> Void)?
    
    private var filteredContacts = [Contact]()
    
    public func set(contacts: [Contact]) {
        filteredContacts = contacts
        updateTableView?()
    }
    
    public func numberOfRowsInSection() -> Int {
        return filteredContacts.count
    }
    
    public func getContact(at index: Int) -> Contact {
        return filteredContacts[index]
    }
}
