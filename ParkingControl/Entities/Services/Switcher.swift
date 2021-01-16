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
        let status = UserDefaults.standard.bool(forKey: "status")
        let rootViewController: UIViewController?
        let appWindow = UIApplication.shared.windows.first
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        print(status)
        guard let window = appWindow else {
            return
        }
        if (status == true) {
            rootViewController = storyboard.instantiateViewController(withIdentifier: "tabbarvc") as! TabBarViewController
            window.rootViewController = rootViewController
            window.makeKeyAndVisible()
            
        } else {
            rootViewController = storyboard.instantiateViewController(withIdentifier: "loginvc") as! LoginViewController
            window.rootViewController = rootViewController
            window.makeKeyAndVisible()
        }
    }
}
