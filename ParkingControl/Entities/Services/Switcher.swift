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
        
        print(status)
        
        guard let window = appWindow else {
            return
        }
        
        if (status == true) {
            rootViewController = UIStoryboard(name: "Main",
                                  bundle: nil).instantiateViewController(withIdentifier: "tabbarvc") as! TabBarViewController
            window.rootViewController = rootViewController
            window.makeKeyAndVisible()
            
        } else {
            rootViewController = UIStoryboard(name: "Main",
                                  bundle: nil).instantiateViewController(withIdentifier: "loginvc") as! LoginViewController
            window.rootViewController = rootViewController
            window.makeKeyAndVisible()
        }
    }
}
