//
//  Switcher.swift
//  ParkingControl
//
//  Created by Mikalaj Shuhno on 11.12.20.
//

import Foundation
import UIKit

class Switcher {
    static func updateRootViewController() {
        let isUserAuthorized = UserDefaults.standard.bool(forKey: AppSettings.isUserAuthorized.rawValue)
        let rootViewController: UIViewController?
        let appWindow = UIApplication.shared.windows.first
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        print(isUserAuthorized)

        guard let window = appWindow else {
            return
        }
        if isUserAuthorized {
            rootViewController = storyboard.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
        } else {
            rootViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        }
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
    
    static func updateRootViewController(currentIndex: Int) {
        let isUserAuthorized = UserDefaults.standard.bool(forKey: AppSettings.isUserAuthorized.rawValue)
        let rootViewController: UIViewController?
        let appWindow = UIApplication.shared.windows.first
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewControllerPureLayout = LoginViewControllerPureLayout()
        let loginViewController = LoginViewControllerAutoLayout()
        
        print(isUserAuthorized)

        guard let window = appWindow else {
            return
        }
        if isUserAuthorized {
            rootViewController = storyboard.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
        } else {
            switch currentIndex {
            case 0:
                rootViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            case 1:
                rootViewController = loginViewController
            case 2:
                rootViewController = loginViewControllerPureLayout
            default:
                rootViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            }
        }
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
}
