//
//  ViewController.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 01.10.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import UIKit

extension UIViewController {
    
    /// Displays an alert controller with the given parameters
    /// - Parameters:
    ///   - title: Alert controller title
    ///   - message: Alert controller message
    ///   - leftButton: Left button title
    ///   - rightButton: Right button title
    ///   - cancel: Is cancel button will be displayed
    ///   - style: Alert controller style
    ///   - completion: Returns the value of which of the buttons was pressed
    public func showAlert(title: String?,
                          message: String?,
                          leftButton: String,
                          rightButton: String?,
                          cancel: Bool,
                          style: UIAlertController.Style,
                          completion: ((Bool) -> Void)?) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        
        if cancel {
            let cancel = UIAlertAction(title: "Common.Cancel".localized, style: .cancel, handler: nil)
            alertController.addAction(cancel)
        }
        
        let button = UIAlertAction(title: leftButton, style: .default) { _ in
            completion?(true)
        }
        
        alertController.addAction(button)
        
        if let rightButton = rightButton {
            let buttonRight = UIAlertAction(title: rightButton, style: .default) { _ in
                completion?(false)
            }
            alertController.addAction(buttonRight)
        }
        present(alertController, animated: true, completion: nil)
    }
    
    /// Displays an alert controller with an error
    /// - Parameters:
    ///   - message: Error description
    public func showError(message: String?) {
        let alertController = UIAlertController(title: "Common.Error".localized, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Common.Cancel".localized, style: .cancel, handler: nil)
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
    }
}
