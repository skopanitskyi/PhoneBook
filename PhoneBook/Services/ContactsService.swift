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
    
    // MARK: - Class instances
    
    /// Contact store
    private let contactStore = CNContactStore()
    
    /// Return  data keys to be requested
    private var keysToFetch: [CNKeyDescriptor] {
        return [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey] as [CNKeyDescriptor]
    }
    
    /// Return request to get contacts
    private var fetchRequest: CNContactFetchRequest {
        return CNContactFetchRequest(keysToFetch: keysToFetch)
    }
    
    // MARK: - Class methods
    
    /// Requests contact data from the internal storage of the device
    /// - Parameter completion: Returns received contacts
    public func fetchFromStorage(completion: @escaping ([Contact]) -> Void) {
        var contacts = [Contact]()
        
        contactStore.requestAccess(for: .contacts) { (access, error) in
            
            if access {
                do {
                    try self.contactStore.enumerateContacts(with: self.fetchRequest) { (contact, mutablePointer) in
                        let name = "\(contact.givenName) \(contact.familyName)"
                        let phone = contact.phoneNumbers.first?.value.stringValue ?? ""
                        let contact = Contact(fullName: name, phoneNumber: phone, city: "", street: "", isFavorite: false)
                        contacts.append(contact)
                    }
                    completion(contacts)
                } catch (let error) {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    /// Fetch mocks contacts
    /// - Parameter completion: Returns  contacts
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
}
