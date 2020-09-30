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
    
    private let auth = Auth.auth()
    
    private let loginManager = LoginManager()
    
    private let firestore = Firestore.firestore().collection(FieldNames.collection)
    
    private var uid: String? {
        return auth.currentUser?.uid
    }
    
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
    
    public func logIn(email: String, password: String, completion: @escaping (AuthResult) -> Void) {
        auth.signIn(withEmail: email, password: password) { (result, error) in
            if let _ = error {
                completion(.failure(.failedToLogin))
                return
            }
            completion(.success)
        }
    }
    
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
    
    private func addData(uid: String, data: [String : Any], completion: @escaping (AuthResult) -> Void) {
        firestore.document(uid).setData(data) { error in
            if let _ = error {
                completion(.failure(.failedToAddData))
                return
            }
            completion(.success)
        }
    }
    
    private func getData(model: Profile, uid: String, completion: @escaping (([String:Any]) -> Void)){
        
        
        getContacts { contacts in
            let favorites = contacts.filter { $0[FieldNames.isFavorite] as! Bool }
            
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
    
    private func getContacts(completion: @escaping ([[String : Any]]) -> Void) {
        
        ContactsService().fetchFromMocks { result in
            completion(self.createModelToSave(data: result))
            print(Thread.current)
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
    
    public func updateData(fors: DownloadData, data: [Contact], completion: @escaping ((AuthResult) -> Void)) {
        
        guard let uid = uid else { return }
        let dataToUpdate = [fors.rawValue : createModelToSave(data: data)]
        
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
        firestore.document(uid!).getDocument { (querySnapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let document = querySnapshot?.data() else { return }
            
            guard var contacts = document["contacts"] as? [[String: Any]] else { return }
            
            guard var recent = document["recent"] as? [[String: Any]] else { return }
            
            guard var favorites = document["favorites"] as? [[String: Any]] else { return }
            
            
            
            for i in 0..<contacts.count {
                if contacts[i]["name"] as! String == name {
                    contacts[i]["isFavorite"] = favorite
                    break
                }
            }
            
            for i in 0..<recent.count {
                if recent[i]["name"] as! String == name {
                    recent[i]["isFavorite"] = favorite
                }
            }
            
            if !favorite {
                if let index = favorites.firstIndex(where: { $0["name"] as! String == name }) {
                    favorites.remove(at: index)
                }
            }
            
            querySnapshot?.reference.updateData([FieldNames.contacts : contacts,
                                                 FieldNames.recent : recent,
                                                 FieldNames.favorites : favorites]) { error in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    public func getUserData(completion: @escaping ((Profile?) -> Void)) {
        firestore.document(uid!).getDocument { (querySnapshot, error) in
            if let error = error {
                print(error.localizedDescription)
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
