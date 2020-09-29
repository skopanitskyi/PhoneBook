//
//  ContactsService.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 02.08.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import Foundation
import Contacts

class ContactsService {
    
    private let contactStore = CNContactStore()
    
    public func fetchFromStorage(completion: @escaping ([Contact]) -> Void) {
        var contacts = [Contact]()
        
        contactStore.requestAccess(for: .contacts) { (access, error) in
            
            if access {
                do {
                    try self.contactStore.enumerateContacts(with: self.fetchRequest) { (contact, mutablePointer) in
                        let name = "\(contact.givenName) \(contact.familyName)"
                        let phone = contact.phoneNumbers.first?.value.stringValue ?? ""
                        contacts.append(Contact(fullName: name,
                                                phoneNumber: phone,
                                                city: "",
                                                street: "",
                                                isFavorite: false))
                    }
                    completion(contacts)
                    
                } catch (let error) {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    public func fetchFromMocks(completion: @escaping ([Contact]) -> Void) {
        if let path = Bundle.main.path(forResource: "Contacts", ofType: "json") {
            DispatchQueue.global(qos: .default).async {
                do {
                    let url = URL(fileURLWithPath: path)
                    let data = try Data(contentsOf: url)
                    let contacts = try JSONDecoder().decode([Contact].self, from: data)
                    completion(contacts)
                } catch(let error) {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private var keysToFetch: [CNKeyDescriptor] {
        return [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey] as [CNKeyDescriptor]
    }
    
    private var fetchRequest: CNContactFetchRequest {
        return CNContactFetchRequest(keysToFetch: keysToFetch)
    }
}
