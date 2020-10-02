//
//  FirebaseService.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 06.09.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import FBSDKLoginKit

enum SavedContacts: String {
    case contacts = "contacts"
    case recent = "recent"
    case favorites = "favorites"
}

class User: Codable {
    public let name: String
    public let city: String?
    public let street: String?
    public var contacts: [Contact]
    public var recent: [Contact]
    public var favorites: [Contact]
    
    init(name: String, city: String?, street: String?, contacts: [Contact], recent: [Contact], favorites: [Contact]) {
        self.name = name
        self.city = city
        self.street = street
        self.contacts = contacts
        self.recent = recent
        self.favorites = favorites
    }
    
    private enum CodingKeys: String, CodingKey {
        case name
        case city
        case street
        case contacts
        case recent
        case favorites
    }
}

class FirebaseService {
    
    // MARK: - Class instances
    
    /// Auth object for authentication
    private let auth = Auth.auth()
    
    /// Login manager
    private let loginManager = LoginManager()
    
    /// Firestore
    private let firestore = Firestore.firestore().collection("users")
    
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
    public func signUp(email: String, password: String, completion: @escaping (AuthResult) -> Void) {
        
        auth.createUser(withEmail: email, password: password) { (result, error) in
            
            if let _ = error {
                completion(.failure(.failedToCreateUser))
                return
            }
            completion(.success)
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
    public func logInWithFacebook(completion: @escaping (FacebookAuth) -> Void) {
        
        loginManager.logIn(permissions: [.publicProfile, .email], viewController: nil) { [weak self] result in
            
            switch result {
            case .failed:
                completion(.failure(.failedToLogin))
            case .cancelled:
                completion(.failure(.cancelled))
            case .success(_ , _, let token):
                let credential = FacebookAuthProvider.credential(withAccessToken: token.tokenString)
                self?.logInWith(credential: credential) { result in
                    completion(result)
                }
            }
        }
    }
    
    /// Log in to firebase using facebook credential. Also saves user data if logged in for the first time
    /// - Parameters:
    ///   - credential: Authentication credential
    ///   - completion: Return the log in result and user data
    private func logInWith(credential: AuthCredential, completion: @escaping ((FacebookAuth) -> Void)) {
        
        auth.signIn(with: credential) { (result, error) in
            if let _ = error {
                completion(.failure(.failedToSignIn))
                return
            }
            let isNewUser = result?.additionalUserInfo?.isNewUser
            let name = result?.additionalUserInfo?.username
            completion(.success(isNewUser, name))
        }
    }
    
    public func saveNewUser(profile: Profile, contacts: [Contact], completion: @escaping ((AuthResult) -> Void)) {
        let user = createUserModel(contacts: contacts, profile: profile)
        setUserDataInStorage(user: user) { result in
            completion(result)
        }
    }
    
    private func createUserModel(contacts: [Contact], profile: Profile) -> User {
        return User(name: profile.name,
                    city: profile.city,
                    street: profile.street,
                    contacts: contacts,
                    recent: [],
                    favorites: contacts.filter{ $0.isFavorite })
    }
    
    /// Return user data saved in firestore
    /// - Parameters:
    ///   - data: Data which will be download
    ///   - completion: Return contacts data
    public func getData(for contacts: SavedContacts, completion: @escaping (ContactsData) -> Void) {
        
        getUserDataFromStorage { [unowned self] result in
            switch result {
            case .success(let user):
                let contacts = self.getSelectedContacts(contacts: contacts, user: user)
                completion(.success(contacts))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func getSelectedContacts(contacts: SavedContacts, user: User) -> [Contact] {
        switch contacts {
        case .contacts:
            return user.contacts
        case .favorites:
            return user.favorites
        case .recent:
            return user.recent
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
    public func updateAllContacts(for data: SavedContacts, contacts: [Contact], completion: @escaping ((AuthResult) -> Void)) {
        // FIXME: -
        
        getUserDataFromStorage { [weak self] user in
            switch user {
            case .success(let user):
                self?.setNewData(for: data, user: user, contacts: contacts)
            // FIXME: - completion error
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func setNewData(for data: SavedContacts, user: User,contacts: [Contact]) {
        switch data {
        case .contacts:
            user.contacts = contacts
        case .favorites:
            user.favorites = contacts
        case .recent:
            user.recent = contacts
        }
        
        setUserDataInStorage(user: user) { result in
            // FIXME: - completion error
        }
    }
    
    /// Update contact data in all arrays in firebase
    /// - Parameters:
    ///   - name: Contact name, data whom will be update
    ///   - favorite: Favorite status of the contact
    public func updateContact(name: String, favorite: Bool) {
        getUserDataFromStorage { [weak self] result in
            switch result {
            case .success(let user):
                self?.updateDataInArrays(user: user, name: name, favorite: favorite)
            case .failure(let error):
                break
            }
        }
    }
    
    private func updateDataInArrays(user: User, name: String, favorite: Bool) {
        user.contacts.filter { $0.fullName == name }.first?.isFavorite = favorite
        user.recent.filter { $0.fullName == name }.forEach { $0.isFavorite = favorite }
        if !favorite {
            guard let index = user.favorites.firstIndex(where: { $0.fullName == name }) else { return }
            user.favorites.remove(at: index)
        } else {
            guard let contact = user.contacts.filter ({ $0.fullName == name}).first else { return }
            user.favorites.append(contact)
        }
        setUserDataInStorage(user: user) { result in
            // FIXME: - result
        }
    }
    
    /// Download user data from firestore
    /// - Parameter completion: Return user data
    public func getUserData(completion: @escaping ((Profile?) -> Void)) {
        getUserDataFromStorage { result in
            switch result {
            case .success(let user):
                let profile = Profile(name: user.name, city: user.city, street: user.street)
                completion(profile)
            case .failure(let error):
                completion(nil)
            }
        }
    }
    
    
    private func setUserDataInStorage(user: User, completion: @escaping ((AuthResult) -> Void)) {
        do {
            if let uid = uid {
                try firestore.document(uid).setData(from: user)
                completion(.success)
            }
        } catch {
            completion(.failure(.failedToAddData))
        }
    }
    
    private func getUserDataFromStorage(completion: @escaping ((UserData) -> Void)) {
        
        guard let uid = uid else { return }
        
        firestore.document(uid).getDocument { (document, error) in
            do {
                if let user = try document?.data(as: User.self) {
                    completion(.success(user))
                }
            } catch {
                completion(.failure(.failedToGetData))
            }
        }
    }
}

