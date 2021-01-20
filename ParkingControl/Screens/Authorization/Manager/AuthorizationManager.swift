//
//  AutharizationManager.swift
//  ParkingControl
//
//  Created by Mikalaj Shuhno on 18.01.21.
//

import UIKit

class AuthorizationManager {
    let key = AppSettings.isUserAuthorized.rawValue
    var delegate: LoginViewControllerDelegate?
    
    enum credentials: String {
        case username, password
    }
    
    func validateCredentials(loginValue: String, passwordValue: String) {
        if loginValue == credentials.username.rawValue && passwordValue == credentials.password.rawValue {
            logIn()
        } else {
            UserDefaults.standard.setValue(false, forKey: key)
            delegate?.displayAlert(title: "Ошибка авторизации", message: "Неверное имя или пароль")
            print("Invalid credentials")
        }
    }
    
    private func logIn() {
        UserDefaults.standard.setValue(true, forKey: key)
        Switcher.updateRootViewController()
    }
    
    func logOut() {
        UserDefaults.standard.setValue(false, forKey: key)
        Switcher.updateRootViewController()
    }
}
