//
//  DetailsContactCoordinator.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 21.09.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import UIKit

protocol UpdateDataFromDetailsContact {
   func updateRecentData(contact: Contact)
}

class DetailsContactCoordinator: Coordinator {
    
    // MARK: - Class instances
    
    /// Coordinator
    private let coordinator: UpdateDataFromDetailsContact
    
    /// Contact
    private let contact: Contact
    
    /// Navigation controller
    private let navigationController: UINavigationController
    
    /// Firebase service
    private let firebaseService: FirebaseService
    
    // MARK: - Class constructor
    
    /// Details contact coordinator class constructor
    init(coordinator: UpdateDataFromDetailsContact, navigationController: UINavigationController, contact: Contact, firebaseService: FirebaseService) {
        self.coordinator = coordinator
        self.navigationController = navigationController
        self.contact = contact
        self.firebaseService = firebaseService
    }
    
    // MARK: - Class methods
    
   /// Creates a details contact screen and displays it
   public func start() {
        guard let detailsViewController = ScreensFactory.makeDetailsContactScreen(coordinator: self,
                                                                            contact: contact,
                                                                            firebaseService: firebaseService) else { return }
        navigationController.present(detailsViewController, animated: true, completion: nil)
    }
    
    /// Close details contact screen
   public func closeDetailsContact() {
        navigationController.dismiss(animated: true, completion: nil)
    }
    
    /// Tells the coordinator that the contact data changed
    /// - Parameter contact: Contact whose data changed
    public func updateRecentData(contact: Contact) {
        coordinator.updateRecentData(contact: contact)
    }
}
