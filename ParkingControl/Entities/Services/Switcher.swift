//
//  Switcher.swift
//  ParkingControl
//
//  Created by Mikalaj Shuhno on 11.12.20.
//

import Foundation
import UIKit

class Switcher {
    static func updateRootVC() {

        let status = UserDefaults.standard.bool(forKey: "status")
        let rootVC: UIViewController?
        let appWindow = UIApplication.shared.windows.first
        
        print(status)
        
        guard let window = appWindow else {
            return
        }
        
        if (status == true) {
            rootVC = UIStoryboard(name: "Main",
                                  bundle: nil).instantiateViewController(withIdentifier: "tabbarvc") as! TabBarViewController
            window.rootViewController = rootVC
            window.makeKeyAndVisible()
            
        } else {
            rootVC = UIStoryboard(name: "Main",
                                  bundle: nil).instantiateViewController(withIdentifier: "loginvc") as! LoginViewController
            window.rootViewController = rootVC
            window.makeKeyAndVisible()
        }
    }
}
