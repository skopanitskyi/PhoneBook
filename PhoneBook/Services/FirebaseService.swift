//
//  FirebaseService.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 06.09.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import Foundation
import Firebase
import FBSDKLoginKit

struct FieldNames {
    public static let collection = "users"
    public static let name = "name"
    public static let surname = "surname"
    public static let uid = "uid"
    public static let contacts = "contacts"
    public static let recent = "recent"
    public static let favorites = "favorites"
    public static let phone = "phone"
    public static let city = "city"
    public static let isFavorite = "isFavorite"
    public static let street = "street"
}

enum DownloadData: String {
    case contacts = "contacts"
    case recent = "recent"
    case favorites = "favorites"
}

class FirebaseService {
    
    // MARK: - Class instances
    
    /// Auth object for authentication
    private let auth = Auth.auth()
    
    /// Login manager
    private let loginManager = LoginManager()
    
    /// Firestore
    private let firestore = Firestore.firestore().collection(FieldNames.collection)
    
    /// User uid
    private var uid: String? {
        return auth.currentUser?.uid
    }
    
    // MARK: - Class methods
    
    /// Sign up the user and save his data in the database
    /// - Parameters:
    ///   - email: Entered email
    ///   - password: Entered password
    ///   - model: Store user data
    ///   - completion: Return the sign up result
    public func signUp(email: String, password: String, model: Profile, completion: @escaping (AuthResult) -> Void) {
            
        auth.createUser(withEmail: email, password: password) { (result, error) in
            
            if let _ = error {
                completion(.failure(.failedToCreateUser))
                return
            }
            
            guard let result = result else { return }
            self.getData(model: model, uid: result.user.uid) { data in
                self.addData(uid: result.user.uid, data: data) { result in
                    completion(result)
                }
            }
        }
    }
    
    /// Log in user by email and password
    /// - Parameters:
    ///   - email: User email
    ///   - password: User password
    ///   - completion: Return the log in result
    public func logIn(email: String, password: String, completion: @escaping (AuthResult) -> Void) {
        auth.signIn(withEmail: email, password: password) { (result, error) in
            if let _ = error {
                completion(.failure(.failedToLogin))
                return
            }
            completion(.success)
        }
    }
    
    /// Log in with facebook
    /// - Parameter completion: Return the log in result and user data
    public func logInWithFacebook(completion: @escaping (Profile?, AuthResult) -> Void) {
        
        loginManager.logIn(permissions: [.publicProfile, .email], viewController: nil) { result in
            
            switch result {
            case .failed:
                completion(nil, .failure(.failedToLogin))
            case .cancelled:
                completion(nil, .failure(.cancelled))
            case .success(_ , _, let token):
                let credential = FacebookAuthProvider.credential(withAccessToken: token.tokenString)
                self.logInWith(credential: credential) { (model, result) in
                    completion(model, result)
                }
            }
        }
    }
    
    /// Log in to firebase using facebook credential. Also saves user data if logged in for the first time
    /// - Parameters:
    ///   - credential: Authentication credential
    ///   - completion: Return the log in result and user data
    private func logInWith(credential: AuthCredential, completion: @escaping (Profile?, AuthResult) -> Void) {
        
        auth.signIn(with: credential) { (result, error) in
            if let _ = error {
                completion(nil, .failure(.failedToSignIn))
                return
            }
            
            guard let result = result, let userInfo = result.additionalUserInfo else { return }
            
            if userInfo.isNewUser {
                let model = Profile(name: result.user.displayName!, city: nil, street: nil)
                self.getData(model: model, uid: result.user.uid) { data in
                    self.addData(uid: result.user.uid, data: data) { result in
                        completion(model, result)
                    }
                }
            } else {
                completion(nil, .success)
            }
        }
    }
    
    /// Add user data to firestore
    /// - Parameters:
    ///   - uid: User uid
    ///   - data: Data which will be save
    ///   - completion: Return upgate result
    private func addData(uid: String, data: [String : Any], completion: @escaping (AuthResult) -> Void) {
        firestore.document(uid).setData(data) { error in
            if let _ = error {
                completion(.failure(.failedToAddData))
                return
            }
            completion(.success)
        }
    }
    
    /// Create user model which will be save in firestore
    /// - Parameters:
    ///   - model: Store user data
    ///   - uid: User uid
    ///   - completion: Return the model
    private func getData(model: Profile, uid: String, completion: @escaping (([String : Any]) -> Void)){
        
        
        getContacts { contacts in
            let favorites = contacts.filter { $0[FieldNames.isFavorite] as! Bool}
            
            let docData: [String : Any] = [
                FieldNames.name: model.name,
                FieldNames.city: model.city ?? "",
                FieldNames.street: model.street ?? "",
                FieldNames.favorites: favorites,
                FieldNames.uid: uid,
                FieldNames.contacts: contacts,
                FieldNames.recent: [],
            ]
            completion(docData)
        }
    }
    
    /// Fetch contacts from device storage
    /// - Parameter completion: Return contacts model for firebase
    private func getContacts(completion: @escaping ([[String : Any]]) -> Void) {
        
        ContactsService().fetchFromMocks { [weak self] result in
            guard let self = self else { return }
            completion(self.createModelToSave(data: result))
        }
    }
    
    /// Return user data saved in firestore
    /// - Parameters:
    ///   - data: Data which will be download
    ///   - completion: Return contacts data
    public func userSavedData(data: DownloadData, completion: @escaping (UserSavedData) -> Void) {
        
        guard let uid = uid else { return }
        
        firestore.document(uid).getDocument { (querySnapshot, error) in
            if let _ = error {
                completion(.failure(.failedToGetData))
                return
            }
            let contacts = self.createContactsModel(data: data, contacts: querySnapshot?.data())
            completion(.success(contacts))
        }
    }
    
    /// Sign out user from firebase
    /// - Parameter completion: Sign out results
    public func signOut(completion: (AuthResult) -> Void) {
        do {
            try auth.signOut()
            completion(.success)
        } catch {
            completion(.failure(.failedToSignOut))
        }
    }
    
    /// Update contacts data in firestore
    /// - Parameters:
    ///   - data: Data which will be update
    ///   - contacts: New contact data
    ///   - completion: Return update result
    public func updateAllContacts(for data: DownloadData, contacts: [Contact], completion: @escaping ((AuthResult) -> Void)) {
        
        guard let uid = uid else { return }
        let dataToUpdate = [data.rawValue : createModelToSave(data: contacts)]
        
        firestore.document(uid).updateData(dataToUpdate) { error in
            if let _ = error {
                completion(.failure(.failedToUpdateData))
                return
            }
            completion(.success)
        }
    }
    
    /// Create contacts model for save in firebase from array
    /// - Parameter data: Return the contacts model
    private func createModelToSave(data: [Contact]) -> [[String : Any]] {
        var contacts = [[String : Any]]()
        data.forEach { contact in
            contacts.append([FieldNames.name: contact.fullName,
                             FieldNames.phone: contact.phoneNumber,
                             FieldNames.city: contact.city,
                             FieldNames.isFavorite: contact.isFavorite,
                             FieldNames.street: contact.street])
        }
        return contacts
    }
    
    /// Create contacts array from data saved in firebase
    /// - Parameters:
    ///   - data: Contacts data which will be receive
    ///   - contacts: Saved contacts
    private func createContactsModel(data: DownloadData, contacts: [String : Any]?) -> [Contact] {
        let document = contacts?[data.rawValue] as? [[String : Any]]
        
        let contacts = document?.compactMap { data -> Contact? in
            guard let contact = Contact(data: data) else { return nil}
            return contact
        }
        return contacts!
    }
    
    
    /// Update contact data in all arrays in firebase
    /// - Parameters:
    ///   - name: Contact name, data whom will be update
    ///   - favorite: Favorite status of the contact
    public func updateContact(name: String, favorite: Bool) {
        firestore.document(uid!).getDocument { [weak self] (querySnapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard
                let self = self,
                let document = querySnapshot?.data(),
                let contactsData = document[FieldNames.contacts] as? [[String: Any]],
                let recentData = document[FieldNames.recent] as? [[String: Any]],
                let favoritesData = document[FieldNames.favorites] as? [[String: Any]]
            else { return }
            
            let contacts = self.changeFavoriteStatus(data: contactsData, name: name, favorite: favorite)
            let recent = self.changeFavoriteStatus(data: recentData, name: name, favorite: favorite)
            let favorites = self.deleteFromFavorite(data: favoritesData, name: name, favorite: favorite)
            
            querySnapshot?.reference.updateData([FieldNames.contacts : contacts,
                                                 FieldNames.recent : recent,
                                                 FieldNames.favorites : favorites]) { error in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    /// Searches for the desired contact in the array and changes his favorite status
    /// - Parameters:
    ///   - data: Array of the contacts
    ///   - name: Name of the contact to be changed
    ///   - favorite: Favorite status of the contact
    private func changeFavoriteStatus(data: [[String : Any]], name: String, favorite: Bool) -> [[String : Any]] {
        
        var contacts = data
        
        for i in 0..<contacts.count {
            if let contactName = contacts[i][FieldNames.name] as? String, contactName == name {
                contacts[i][FieldNames.isFavorite] = favorite
            }
        }
        return contacts
    }
    
    /// Removes a contact from favorites array
    /// - Parameters:
    ///   - data: Array of the contacts
    ///   - name: Name of the contact to be changed
    ///   - favorite: Favorite status of the contact
    private func deleteFromFavorite(data: [[String : Any]], name: String, favorite: Bool) -> [[String : Any]] {
        var contacts = data
        
        if !favorite {
            if let index = contacts.firstIndex(where: { $0["name"] as! String == name }) {
                contacts.remove(at: index)
            }
        }
        return contacts
    }
    
    
    /// Download user data from firestore
    /// - Parameter completion: Return user data
    public func getUserData(completion: @escaping ((Profile?) -> Void)) {
        firestore.document(uid!).getDocument { (querySnapshot, error) in
            if let _ = error {
                completion(nil)
                return
            }
            guard let document = querySnapshot?.data(),
                  let name = document[FieldNames.name] as? String,
                  let city = document[FieldNames.city] as? String,
                  let street = document[FieldNames.street] as? String
            else { return }
            
            let profile = Profile(name: name, city: city, street: street)
            completion(profile)
        }
    }
}
