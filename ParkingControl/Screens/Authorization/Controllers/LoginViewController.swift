//
//  LoginViewController.swift
//  ParkingControl
//
//  Created by Mikalaj Shuhno on 11.12.20.
//

import UIKit
import AMPopTip

protocol LoginViewControllerDelegate {
    func displayAlert(title: String, message: String)
    func showPopTip(with text: String, frame: CGRect)
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
        manager.validateCredentials(loginValue: login, passwordValue: password)
    }
}

extension LoginViewController {
    func showPopTip(with text: String, frame: CGRect) {
        let popTip = PopTip()
        
        popTip.shouldDismissOnTap = true
        popTip.actionAnimation = .bounce(10)
        
        popTip.show(text: text, direction: .none, maxWidth: 200, in: view, from: frame)
    }
}
