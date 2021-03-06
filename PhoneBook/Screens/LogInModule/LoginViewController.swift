//
//  LoginViewController.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 03.09.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UITableViewController {
    
    // MARK: - Class instances
    
    /// View model
    public var viewModel: LoginViewModelProtocol?
    
    // MARK: - Outlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var appNameLabel: UILabel!
    
    // MARK: - Class life cycle
        
    override func viewDidLoad() {
        super.viewDidLoad()
        localization()
        showError()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Actions
    
    @IBAction func logInButtonTapped(_ sender: Any) {
        viewModel?.loginWithEmail(email: emailTextField.text, password: passwordTextField.text)
    }
    
    @IBAction func facebookButtonTapped(_ sender: Any) {
        viewModel?.loginWithFacebook()
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        viewModel?.signUp()
    }
    
    @IBAction func hideKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
    
    // MARK: - Class methods
    
    /// Localize screen
    private func localization() {
        title = "Authentication.Titile".localized
        appNameLabel.text = "Authentication.ApplicationName".localized
        emailTextField.placeholder = "Authentication.EmailTextField.Placeholder".localized
        passwordTextField.placeholder = "Authentication.PasswordTextField.Placeholder".localized
        logInButton.setTitle("Authentication.LogInButton".localized, for: .normal)
        facebookButton.setTitle("Authentication.FacebookButton".localized, for: .normal)
        signUpButton.setTitle("Authentication.SignUpButton".localized, for: .normal)
    }
    
    /// Displays an error if it appears
    private func showError() {
        viewModel?.error = { [weak self] message in
            self?.showError(message: message)
        }
    }
}

// MARK: - TextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
