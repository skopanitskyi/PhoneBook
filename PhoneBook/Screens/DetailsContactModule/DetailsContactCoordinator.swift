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
    
    /// Service manager
    private let serviceManager: ServiceManager
    
    // MARK: - Class constructor
    
    /// Details contact coordinator class constructor
    init(coordinator: UpdateDataFromDetailsContact, navigationController: UINavigationController, contact: Contact, serviceManager: ServiceManager) {
        self.coordinator = coordinator
        self.navigationController = navigationController
        self.contact = contact
        self.serviceManager = serviceManager
    }
    
    // MARK: - Class methods
    
   /// Creates a details contact screen and displays it
   public func start() {
        guard let detailsViewController = ScreensFactory.makeDetailsContactScreen(coordinator: self,
                                                                                  contact: contact,
                                                                                  serviceManager: serviceManager)
                                                                                  else { return }
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
