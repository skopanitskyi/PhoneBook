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

typealias AuthResults = ((AuthResult) -> Void)
typealias AuthFacebook = ((FacebookAuth) -> Void)
typealias ProfileResults = ((ProfileResult) -> Void)
typealias UserInformation = ((UserData) -> Void)
typealias ContactsInformation = ((ContactsData) -> Void)

enum SavedContacts: String {
    case contacts = "contacts"
    case recent = "recent"
    case favorites = "favorites"
}

class FirebaseService: Service {

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
    
    /// Sign up the user
    /// - Parameters:
    ///   - email: Entered email
    ///   - password: Entered password
    ///   - model: Store user data
    ///   - completion: Return the sign up result
    public func signUp(email: String, password: String, completion: @escaping AuthResults) {
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
    ///   - completion: Return the login result
    public func logIn(email: String, password: String, completion: @escaping AuthResults) {
        auth.signIn(withEmail: email, password: password) { (result, error) in
            if let _ = error {
                completion(.failure(.failedToLogin))
                return
            }
            completion(.success)
        }
    }
    
    /// Log in with facebook
    /// - Parameter completion: Return the login result and user data
    public func logInWithFacebook(completion: @escaping AuthFacebook) {
        
        loginManager.logIn(permissions: [.publicProfile, .email], viewController: nil) { [weak self] result in
            switch result {
            case .failed:
                completion(.failure(.failedToLogin))
            case .cancelled:
                completion(.failure(.cancelled))
            case .success(_ , _, let token):
                let credential = FacebookAuthProvider.credential(withAccessToken: token.tokenString)
                self?.logInWith(credential: credential) { completion($0) }
            }
        }
    }
    
    /// Log in to firebase using facebook credential
    /// - Parameters:
    ///   - credential: Authentication credential
    ///   - completion: Return the log in result and user data
    private func logInWith(credential: AuthCredential, completion: @escaping AuthFacebook) {
        
        auth.signIn(with: credential) { (result, error) in
            if let _ = error {
                completion(.failure(.failedToSignIn))
                return
            }
            let isNewUser = result?.additionalUserInfo?.isNewUser
            let name = result?.user.displayName
            completion(.success(isNewUser, name))
        }
    }
    
    /// Saves new user data to firestore
    /// - Parameters:
    ///   - profile: User data
    ///   - contacts: User contacts from device storage
    ///   - completion: Return save result
    public func saveNewUser(profile: Profile, contacts: [Contact], completion: @escaping AuthResults) {
        let user = createUserModel(contacts: contacts, profile: profile)
        setUserDataInStorage(user: user) { completion($0) }
    }
    
    /// Creates a user model from input data
    /// - Parameters:
    ///   - contacts: User contacts from device storage
    ///   - profile: User data
    private func createUserModel(contacts: [Contact], profile: Profile) -> User {
        return User(name: profile.name,
                    city: profile.city,
                    street: profile.street,
                    contacts: contacts,
                    recent: [],
                    favorites: contacts.filter { $0.isFavorite })
    }
    
    /// Return user data saved in firestore
    /// - Parameters:
    ///   - data: Data which will be download
    ///   - completion: Return contacts data
    public func getData(for contacts: SavedContacts, completion: @escaping ContactsInformation) {
        
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
    
    /// Return selected contacts
    /// - Parameters:
    ///   - contacts: Contact details to be returned
    ///   - user: Contains contact data
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
    public func signOut(completion: AuthResults) {
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
    public func updateAllContacts(for data: SavedContacts, contacts: [Contact], completion: @escaping AuthResults) {
        
        getUserDataFromStorage { [weak self] user in
            switch user {
            case .success(let user):
                self?.setNewData(for: data, user: user, contacts: contacts) { completion($0) }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// Adds new contact details to the specified array
    /// - Parameters:
    ///   - data: Data to be updated
    ///   - user: Current user model
    ///   - contacts: New contacts data
    ///   - completion: Return save result
    private func setNewData(for data: SavedContacts, user: User, contacts: [Contact], completion: @escaping AuthResults) {
        switch data {
        case .contacts:
            user.contacts = contacts
        case .favorites:
            user.favorites = contacts
        case .recent:
            user.recent = contacts
        }
        setUserDataInStorage(user: user) { completion($0) }
    }
    
    /// Update contact data in all arrays in firebase
    /// - Parameters:
    ///   - name: Contact name, data whom will be update
    ///   - favorite: Favorite status of the contact
    public func updateContact(name: String, favorite: Bool, completion: @escaping AuthResults) {
        getUserDataFromStorage { [weak self] result in
            switch result {
            case .success(let user):
                self?.updateDataInArrays(user: user, name: name, favorite: favorite) { completion($0) }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// Updates user data in all arrays
    /// - Parameters:
    ///   - user: Current user model
    ///   - name: Contact name
    ///   - favorite: Is contact favorite
    ///   - completion: Return save result
    private func updateDataInArrays(user: User, name: String, favorite: Bool, completion: @escaping AuthResults) {
        user.contacts.filter { $0.fullName == name }.first?.isFavorite = favorite
        user.recent.filter { $0.fullName == name }.forEach { $0.isFavorite = favorite }
        
        if !favorite {
            guard let index = user.favorites.firstIndex(where: { $0.fullName == name }) else { return }
            user.favorites.remove(at: index)
        } else {
            guard let contact = user.contacts.filter ({ $0.fullName == name}).first else { return }
            user.favorites.append(contact)
        }
        setUserDataInStorage(user: user) { completion($0) }
    }
    
    /// Download user data from firestore
    /// - Parameter completion: Return user data
    public func getUserData(completion: @escaping ProfileResults) {
        getUserDataFromStorage { result in
            switch result {
            case .success(let user):
                let profile = Profile(name: user.name, city: user.city, street: user.street)
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// Saves and updates user data in firestore
    /// - Parameters:
    ///   - user: User data model
    ///   - completion: Return save result
    private func setUserDataInStorage(user: User, completion: @escaping AuthResults) {
        do {
            if let uid = uid {
                try firestore.document(uid).setData(from: user)
                completion(.success)
            }
        } catch {
            completion(.failure(.failedToAddData))
        }
    }
    
    /// Returns the data of the current user from the database
    /// - Parameter completion: Returns the data or the error that occurred
    private func getUserDataFromStorage(completion: @escaping UserInformation) {
        
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

