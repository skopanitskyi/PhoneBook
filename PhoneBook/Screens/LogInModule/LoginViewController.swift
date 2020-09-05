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
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    public var viewModel: LoginViewModelProtocol?
    
    override func viewDidLoad() {
        title = "Log in"
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
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
