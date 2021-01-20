//
//  LoginViewController.swift
//  ParkingControl
//
//  Created by Mikalaj Shuhno on 11.12.20.
//

import UIKit

protocol LoginViewControllerDelegate {
    func displayAlert(title: String, message: String)
}

class LoginViewController: UIViewController, LoginViewControllerDelegate {
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func logInAction(_ sender: UIButton) {
        guard let login = loginTextField.text,
              let password = passwordTextField.text
        else {
            return
        }
        let manager = AuthorizationManager()
        manager.delegate = self
        manager.validationUser(loginTextField: login, passwordTextField: password)
    }
}
