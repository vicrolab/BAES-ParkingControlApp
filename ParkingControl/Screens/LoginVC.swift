//
//  LoginVC.swift
//  ParkingControl
//
//  Created by Mikalaj Shuhno on 11.12.20.
//

import UIKit

class LoginVC: UIViewController {
    @IBOutlet weak var loginTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!

    
    @IBAction func buttonLogIn(_ sender: UIButton) {
        
        if loginTF.text == "test" && passwordTF.text == "test" {
            UserDefaults.standard.setValue(true, forKey: "status")
            Switcher.updateRootVC()
        } else {
            UserDefaults.standard.setValue(false, forKey: "status")
            let alert = UIAlertController(title: "Ошибка авторизации", message: "Неверное имя или пароль", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "ОК", style: .default)
            alert.addAction(OKAction)
            self.present(alert, animated: true)
            print("Invalid credentials")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
