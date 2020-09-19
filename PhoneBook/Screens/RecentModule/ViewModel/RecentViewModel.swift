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
    
    private var contacts = [Contact]()
    
    private let firebaseService: FirebaseService
    
    init(firebaseService: FirebaseService) {
        self.firebaseService = firebaseService
    }
    
    public func numberOfRowsInSection() -> Int {
       return contacts.count
    }

    public func getContactName(at index: Int) -> String {
        return contacts[index].fullName
    }
}
