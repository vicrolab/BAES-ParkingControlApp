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
        } else {
            UserDefaults.standard.setValue(false, forKey: "status")
            // alert controller
            print("Invalid credentials")
        }
        Switcher.updateRootVC()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
