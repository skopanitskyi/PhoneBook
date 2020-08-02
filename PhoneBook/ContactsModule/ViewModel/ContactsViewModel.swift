//
//  ContactsViewModel.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 01.08.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import Foundation

protocol ContactsViewModelProtocol {
    var updateTableView:(() -> Void)? { get set }
    var contacts: [[Contact]] { get set }
    func fetchContactsData()
}

class ContactsViewModel: ContactsViewModelProtocol {
    
    public var updateTableView: (() -> Void)?
    
    public var contacts = [[Contact]]()
    
    public func fetchContactsData() {
        if !StorageService.fileExists(StorageService.fileName, in: .documents) {
            ContactsService.shared.fetchContactsData { [weak self] contacts in
                DispatchQueue.main.async {
                    self?.contacts = contacts
                    self?.updateTableView?()
                    StorageService.store(contacts, to: .documents, as: StorageService.fileName)
                }
            }
        } else {
            contacts = StorageService.retrieve(StorageService.fileName, from: .documents, as: [[Contact]].self)
            updateTableView?()
        }
    }
}
