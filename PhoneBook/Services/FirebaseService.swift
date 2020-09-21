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
    public static let phone = "phone"
    public static let city = "city"
    public static let isFavorite = "isFavorite"
    public static let street = "street"
}

enum DownloadData: String {
    case contacts = "contacts"
    case recent = "recent"
}

class FirebaseService {
    
    private let auth = Auth.auth()
    
    private let loginManager = LoginManager()
    
    private let firestore = Firestore.firestore().collection(FieldNames.collection)
    
    private var uid: String? {
        return auth.currentUser?.uid
    }
    
    public func signUp(model: SignUpModel, completion: @escaping (AuthResult) -> Void) {
        
        guard let email = model.email, let password = model.password else { return }
        
        auth.createUser(withEmail: email, password: password) { (result, error) in
            
            if let _ = error {
                completion(.failure(.failedToCreateUser))
                return
            }
            
            guard let result = result else { return }
            let data = self.getData(model: model, uid: result.user.uid)
            self.addData(uid: result.user.uid, data: data) { result in
                completion(result)
            }
        }
    }
    
    public func logIn(email: String, password: String, completion: @escaping (AuthResult) -> Void) {
        auth.signIn(withEmail: email, password: password) { (result, error) in
            if let _ = error {
                completion(.failure(.failedToLogin))
                return
            }
            completion(.success)
        }
    }
    
    public func logInWithFacebook(completion: @escaping (AuthResult) -> Void) {
        
        loginManager.logIn(permissions: [.publicProfile, .email], viewController: nil) { result in
            
            switch result {
            case .failed:
                completion(.failure(.failedToLogin))
            case .cancelled:
                completion(.failure(.cancelled))
            case .success(_ , _, let token):
                let credential = FacebookAuthProvider.credential(withAccessToken: token.tokenString)
                self.logInWith(credential: credential) { result in
                    completion(result)
                }
            }
        }
    }
    
    private func logInWith(credential: AuthCredential, completion: @escaping (AuthResult) -> Void) {
        
        auth.signIn(with: credential) { (result, error) in
            if let _ = error {
                completion(.failure(.failedToSignIn))
                return
            }
            
            guard let result = result, let userInfo = result.additionalUserInfo else { return }
            
            if userInfo.isNewUser {
                let model = SignUpModel(email: result.user.email, password: nil, name: result.user.displayName, surname: nil, city: nil, street: nil)
                let data = self.getData(model: model, uid: result.user.uid)
                self.addData(uid: result.user.uid, data: data) { result in
                    completion(result)
                }
            } else {
                completion(.success)
            }
        }
    }
    
    private func addData(uid: String, data: [String : Any], completion: @escaping (AuthResult) -> Void) {
        firestore.document(uid).setData(data) { error in
            if let _ = error {
                completion(.failure(.failedToAddData))
                return
            }
            completion(.success)
        }
    }
    
    private func getData(model: SignUpModel, uid: String) -> [String : Any] {
        
        var contacts = [[String : Any]]()
        
        getContacts { contact in
            contacts = contact
        }
        
        let docData: [String : Any] = [
            FieldNames.name: model.name ?? "",
            FieldNames.surname: model.surname ?? "",
            FieldNames.city: model.city ?? "",
            FieldNames.street: model.street ?? "",
            FieldNames.uid: uid,
            FieldNames.contacts: contacts,
            FieldNames.recent: [[String : Any]](),
        ]
        return docData
    }
    
    private func getContacts(completion: @escaping ([[String : Any]]) -> Void) {
        
        ContactsService().fetchContactsData { result in
            completion(self.createModelToSave(data: result))
        }
    }
    
    public func userSavedData(data: DownloadData, completion: @escaping (UserSavedData) -> Void) {
        
        guard let uid = uid else { return }
        
        firestore.document(uid).getDocument { (querySnapshot, error) in
            if let _ = error {
                completion(.failure(.failedToGetData))
                return
            }
            let contacts = self.createContactsModel(some: data, data: querySnapshot?.data())
            completion(.success(contacts))
        }
    }
    
    public func signOut(completion: (AuthResult) -> Void) {
        do {
            try auth.signOut()
            completion(.success)
        } catch {
            completion(.failure(.failedToSignOut))
        }
    }
    
    public func updateData(data: [Contact], completion: @escaping ((AuthResult) -> Void)) {
        
        guard let uid = uid else { return }
        let dataToUpdate = [FieldNames.recent: createModelToSave(data: data)]
        
        firestore.document(uid).updateData(dataToUpdate) { error in
            if let _ = error {
                completion(.failure(.failedToUpdateData))
                return
            }
            completion(.success)
        }
    }
    
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
    
    private func createContactsModel(some: DownloadData, data: [String : Any]?) -> [Contact] {
        let document = data?[some.rawValue] as? [[String : Any]]
        
        let contacts = document?.compactMap { data -> Contact? in
            guard let contact = Contact(data: data) else { return nil}
            return contact
        }
        return contacts!
    }
    
    
    public func some(name: String, favorite: Bool) {
        firestore.document(uid!).updateData([FieldNames.contacts : [FieldNames.name : name,
                                                                    FieldNames.isFavorite : favorite]]) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}
