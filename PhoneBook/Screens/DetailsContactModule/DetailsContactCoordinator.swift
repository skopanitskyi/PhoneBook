//
//  DetailsContactCoordinator.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 21.09.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import UIKit

class DetailsContactCoordinator: Coordinator {
    
    private let contact: Contact
    private let navigationController: UINavigationController
    private let firebaseService: FirebaseService
    
    
    init(navigationController: UINavigationController, contact: Contact, firebaseService: FirebaseService) {
        self.navigationController = navigationController
        self.contact = contact
        self.firebaseService = firebaseService
    }
    
    
    func start() {
        let detailsViewController = ScreensFactory.makeDetailsContactScreen(contact: contact,
                                                                            firebaseService: firebaseService)
        navigationController.present(detailsViewController, animated: true, completion: nil)
    }
    
    
}
