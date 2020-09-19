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

class FirebaseService {
    
    private let auth = Auth.auth()
    private let loginManager = LoginManager()
    private let firestore = Firestore.firestore().collection("users")
    
    public func signUp(model: SignUpModel, completion: @escaping (AuthResult) -> Void) {
        
        auth.createUser(withEmail: model.email!, password: model.password!) { (result, error) in
            
            if let _ = error {
                completion(.failure(.failedToCreateUser))
                return
            }
            let data = self.getData(model: model, uid: result!.user.uid)
            self.addData(data: data) { completio in
                completion(completio)
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
            
            if result!.additionalUserInfo!.isNewUser {
                let model = SignUpModel(email: nil, password: nil, name: result!.user.displayName, surname: nil,
                                        city: nil, street: nil)
                let data = self.getData(model: model, uid: result!.user.uid)
                self.addData(data: data) { complet in
                    completion(complet)
                }
            } else {
                completion(.success)
            }
        }
    }
    
    private func addData(data: [String : Any], completion: @escaping (AuthResult) -> Void) {
        firestore.addDocument(data: data) { error in
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
            "name": model.name!,
            "surname": model.surname!,
            "city": model.city!,
            "street": model.street!,
            "uid": uid,
            "contacts": contacts,
            "recent" : [[String : Any]](),
        ]
        return docData
    }
    
    private func getContacts(completion: @escaping ([[String : Any]]) -> Void) {
        var contacts = [[String : Any]]()
        
        ContactsService().fetchContactsData { result in
            result.forEach { contact in
                contacts.append(["name" : contact.fullName,
                                 "phone" : contact.phoneNumber,
                                 "city" : contact.city,
                                 "isFavorite" : contact.isFavorite,
                                 "street": contact.street])
            }
            completion(contacts)
        }
    }
    
    public func g(completion: @escaping (Result<[Contact], Error>) -> Void) {
        firestore.getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            let document = querySnapshot?.documents.first?.data()["contacts"] as! [[String : String]]
            let contacts = document.compactMap { documet -> Contact in
                Contact(fullName: documet["name"]!, phoneNumber: documet["phone"]!, city: documet["city"]! , street: documet["street"]!)
            }
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
}
