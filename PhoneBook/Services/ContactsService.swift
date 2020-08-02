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
    
    public static let shared = ContactsService()
    
    private let contactStrore = CNContactStore()
    
    private init() { }
    
    public func fetchContactsData(completion: @escaping ([[Contact]]) -> Void) {
        
        var contacts = [Contact]()
        
        contactStrore.requestAccess(for: .contacts) { (access, error) in
            
            if access {
                do {
                    try self.contactStrore.enumerateContacts(with: self.fetchRequest) { (contact, mutablePointer) in
                        let contact = Contact(fullName: "\(contact.givenName) \(contact.familyName)",
                            phoneNumber: contact.phoneNumbers.first?.value.stringValue ?? "")
                        contacts.append(contact)
                    }
                    
                    completion(self.convertToTwoDimensional(array: contacts))
                    
                } catch (let error) {
                    print(error)
                }
            }
        }
    }
    
    private func convertToTwoDimensional(array: [Contact]) -> [[Contact]] {
        var result = [[Contact]]()
        var uniqueCharacters = Set<Character>()
        var index = 0
        
        array.forEach { contact in
            if let character = contact.fullName.first {
                uniqueCharacters.insert(character)
            }
        }
        
        uniqueCharacters.sorted().forEach { uniqueCharacter in
            let contacts = array.filter { contact in
                guard let character = contact.fullName.first else { return false }
                return uniqueCharacter == character
            }
            result.insert(contacts, at: index)
            index += 1
        }
        return result
    }
    
    private var keysToFetch: [CNKeyDescriptor] {
        return [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey] as [CNKeyDescriptor]
    }
    
    private var fetchRequest: CNContactFetchRequest {
        return CNContactFetchRequest(keysToFetch: keysToFetch)
    }
}
