//
//  LoginViewController.swift
//  ParkingControl
//
//  Created by Mikalaj Shuhno on 11.03.21.
//

import UIKit


class LoginViewController: UIViewController, LoginViewControllerDelegate {
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBAction func segmentedControlAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            Switcher.updateRootViewController(currentIndex: 0)
        case 1:
            Switcher.updateRootViewController(currentIndex: 1)
        case 2:
            Switcher.updateRootViewController(currentIndex: 2)
        default:
            break
        }
    }
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentedControl.selectedSegmentIndex = 0
    }
}
