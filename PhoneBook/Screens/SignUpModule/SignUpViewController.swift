//
//  SignUpViewController.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 04.09.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import UIKit

class SignUpViewController: UITableViewController {
    
    public var viewModel: SignUpViewModelProtocol?
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var streetTextField: UITextField!
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var surnameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var registrationButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localization()
    }
    
    @IBAction func registrationTapped(_ sender: Any) {
        let email = emailTextField.text
        let password = passwordTextField.text
        let name = nameTextField.text
        let surname = surnameTextField.text
        let city = cityTextField.text
        let street = streetTextField.text
        
        viewModel?.signUp(email: email,
                          password: password,
                          name: name,
                          surname: surname,
                          city: city,
                          street: street)
    }
    
    @IBAction func hideKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
    
    private func localization() {
        title = "Registration.Title".localized
        emailLabel.text = "Registration.EmailLabel".localized
        passwordLabel.text = "Registration.PasswordLabel".localized
        nameLabel.text = "Registration.NameLabel".localized
        surnameLabel.text = "Registration.SurnameLabel".localized
        cityLabel.text = "Registration.CityLabel".localized
        streetLabel.text = "Registration.StreetLabel".localized
        registrationButton.setTitle("Registration.RegistrationButton".localized, for: .normal)
    }
}

// MARK: - TextFieldDelegate

extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == streetTextField {
            textField.resignFirstResponder()
        } else {
            guard let nextTextField = view.viewWithTag(textField.tag + 1) as? UITextField else { return true }
            nextTextField.becomeFirstResponder()
        }
        return true
    }
}
