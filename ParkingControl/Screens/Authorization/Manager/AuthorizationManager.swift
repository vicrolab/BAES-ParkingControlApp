//
//  AutharizationManager.swift
//  ParkingControl
//
//  Created by Mikalaj Shuhno on 18.01.21.
//

import UIKit
import AMPopTip

class AuthorizationManager {
    let key = AppSettings.isUserAuthorized.rawValue
    var delegate: LoginViewControllerDelegate?
    
    func validateCredentials(loginValue: String, passwordValue: String) {
        if loginValue == Credentials.username.rawValue && passwordValue == Credentials.password.rawValue {
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

    func checkLoginValue(in textField: UITextField) -> Bool {
        guard let loginValue = textField.text else {
            delegate?.displayAlert(title: "found nil", message: "")
            return false
        }

        let messageIfWhitespace = "Логин не должен содержать пробел."
        let messageIfLessThanFiveChar = "Логин должен быть более 5 символов."
        
        var message = ""
        var conditions: (loginValueCount: Int, loginValueHasSpace: Bool) = (0, false)

        for char in loginValue {
            if char.isWhitespace {
                conditions.loginValueHasSpace = true
            }
            conditions.loginValueCount += 1
        }
        
        switch conditions {
        case (0...4, false):
            message = messageIfLessThanFiveChar
            delegate?.showLoginPopTip(with: message, frame: CGRect(x: 100, y: 220, width: 200, height: 20))
            return false
        case (0...4, true):
            message = messageIfLessThanFiveChar + "\n" + messageIfWhitespace
            delegate?.showLoginPopTip(with: message, frame: CGRect(x: 100, y: 220, width: 200, height: 20))
            return false
        case (5...20, false):
            return true
        case (5...20, true):
            message = messageIfWhitespace
            delegate?.showLoginPopTip(with: message, frame: CGRect(x: 100, y: 220, width: 200, height: 20))
            return false
        default:
            return false
        }
    }
    
    func checkPasswordValue(in textField: UITextField) -> Bool {
        guard let passwordValue = textField.text else {
            delegate?.displayAlert(title: "found nil", message: "")
            return false
        }

        let messageIfHasSymbol = "Пароль должен содержать символы A-Z, a-z или 0-9."
        let messageIfLessThanEightChar = "Пароль должен быть более 8 символов."
        
        var message = ""
        var conditions: (passwordValueCount: Int, passwordValueHasSymbol: Bool) = (0, false)

        for char in passwordValue {
            if char.isWhitespace || char.isSymbol {
                conditions.passwordValueHasSymbol = true
            }
            conditions.passwordValueCount += 1
        }
        
        switch conditions {
        case (0...7, false):
            message = messageIfLessThanEightChar
            delegate?.showPasswordPopTip(with: message, frame: CGRect(x: 100, y: 300, width: 200, height: 20))
            return false
        case (0...7, true):
            message = messageIfLessThanEightChar + "\n" + messageIfHasSymbol
            delegate?.showPasswordPopTip(with: message, frame: CGRect(x: 100, y: 300, width: 200, height: 20))
            return false
        case (8...20, false):
            return true
        case (8...20, true):
            message = messageIfHasSymbol
            delegate?.showPasswordPopTip(with: message, frame: CGRect(x: 100, y: 300, width: 200, height: 20))
            return false
        default:
            return false
        }
    }
}
