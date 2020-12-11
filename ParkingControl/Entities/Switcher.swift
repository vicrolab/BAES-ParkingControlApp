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
        
        print(status)
        
        if (status == true) {
            rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabbarvc") as! TabBarVC
        } else {
            rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginvc") as! LoginVC
        }
        
        let window = UIApplication.shared.windows.first
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
    }
}
