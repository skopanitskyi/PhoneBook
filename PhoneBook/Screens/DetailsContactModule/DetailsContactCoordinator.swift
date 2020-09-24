//
//  DetailsContactCoordinator.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 21.09.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import UIKit

protocol UpdateData {
   func updateRecentData(contact: Contact)
}

class DetailsContactCoordinator: Coordinator {
    
    private let coordinator: UpdateData
    private let contact: Contact
    private let navigationController: UINavigationController
    private let firebaseService: FirebaseService
    
    
    init(coordinator: UpdateData, navigationController: UINavigationController, contact: Contact, firebaseService: FirebaseService) {
        self.coordinator = coordinator
        self.navigationController = navigationController
        self.contact = contact
        self.firebaseService = firebaseService
    }
    
    
   public func start() {
        let detailsViewController = ScreensFactory.makeDetailsContactScreen(coordinator: self,
                                                                            contact: contact,
                                                                            firebaseService: firebaseService)
        navigationController.present(detailsViewController, animated: true, completion: nil)
    }
    
   public func closeDetailsContact() {
        navigationController.dismiss(animated: true, completion: nil)
    }
    
    public func updateRecentData(contact: Contact) {
        coordinator.updateRecentData(contact: contact)
    }
}
