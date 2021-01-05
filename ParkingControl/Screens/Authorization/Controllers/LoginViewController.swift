//
//  LoginViewController.swift
//  ParkingControl
//
//  Created by Mikalaj Shuhno on 11.12.20.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextFeild: UITextField!
    
    @IBAction func buttonLogIn(_ sender: UIButton) {
        if loginTextField.text == "test" && passwordTextFeild.text == "test" {
            UserDefaults.standard.setValue(true, forKey: "status")
            
            Switcher.updateRootVC()
        } else {
            UserDefaults.standard.setValue(false, forKey: "status")
            displayAlert(title: "Ошибка авторизации",
                         message: "Неверное имя или пароль")
            
            print("Invalid credentials")
        }
    }
}
