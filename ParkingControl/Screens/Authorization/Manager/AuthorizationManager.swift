//
//  AutharizationManager.swift
//  ParkingControl
//
//  Created by Mikalaj Shuhno on 18.01.21.
//

import UIKit

class AuthorizationManager {
    var delegate: LoginViewControllerDelegate?
    let key = AppSettings.isUserAuthorized.rawValue
    let credentials = "test"
    
    func validationUser(loginTextField: String, passwordTextField: String) {
        if loginTextField == credentials && passwordTextField == credentials {
            UserDefaults.standard.setValue(true, forKey: key)
            Switcher.updateRootViewController()
        } else {
            UserDefaults.standard.setValue(false, forKey: key)
            guard let delegate = delegate else {
                print("Invalid delegate method")
                return
            }
            delegate.displayAlert(
                title: "Ошибка авторизации",
                message: "Неверное имя или пароль"
            )
            print("Invalid credentials")
        }
    }
    
    func logOutUser() {
        UserDefaults.standard.setValue(false, forKey: key)
        Switcher.updateRootViewController()
    }
}
