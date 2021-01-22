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
    func showLoginPopTip(with text: String, frame: CGRect)
    func showPasswordPopTip(with text: String, frame: CGRect)
}

class LoginViewController: UIViewController, LoginViewControllerDelegate {
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func logInAction(_ sender: UIButton) {
        let manager = AuthorizationManager()
        manager.delegate = self
        let loginIsAvailable = manager.checkLoginValue(in: loginTextField)
        let passwordIsAvailable = manager.checkPasswordValue(in: passwordTextField)
        if loginIsAvailable && passwordIsAvailable {
            guard let login = loginTextField.text,
                  let password = passwordTextField.text
            else {
                return
            }
            manager.validateCredentials(loginValue: login, passwordValue: password)
        }
    }
    
    let loginPopTip = PopTip()
    let passwordPopTip = PopTip()

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginTextField.addTarget(self, action: #selector(dismissPopTips), for: .touchDown)
        passwordTextField.addTarget(self, action: #selector(dismissPopTips), for: .touchDown)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismissPopTips()
    }
}

extension LoginViewController {
    func showLoginPopTip(with text: String, frame: CGRect) {
        loginPopTip.actionAnimation = .bounce(10)
        loginPopTip.textAlignment = .left
        loginPopTip.arrowOffset = 120
        loginPopTip.show(text: text, direction: .auto, maxWidth: 300, in: view, from: frame)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1 ) {
            self.loginPopTip.stopActionAnimation()
        }
    }
    
    func showPasswordPopTip(with text: String, frame: CGRect) {
        passwordPopTip.actionAnimation = .bounce(5)
        passwordPopTip.textAlignment = .left
        passwordPopTip.arrowOffset = 120
        passwordPopTip.show(text: text, direction: .auto, maxWidth: 300, in: view, from: frame)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.passwordPopTip.stopActionAnimation()
        }
    }
    
    @objc private func dismissPopTips() {
        loginPopTip.hide()
        passwordPopTip.hide()
    }
}

