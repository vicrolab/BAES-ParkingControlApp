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
        let carsStore = CarsStore()
        let photoStore = PhotoStore()
        let status = UserDefaults.standard.bool(forKey: "status")
        let rootVC: UIViewController?
        let appWindow = UIApplication.shared.windows.first
        
        print(status)
        
        guard let window = appWindow else {
            return
        }
        
        if (status == true) {
            rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabbarvc") as! TabBarVC
            
            window.rootViewController = rootVC
            window.makeKeyAndVisible()
            
            let tabBarController = window.rootViewController as! UITabBarController
            let navController1 = tabBarController.viewControllers?[1] as! UINavigationController
            
            let navController2 = tabBarController.viewControllers?.first as! UINavigationController
            let fixVehicleController = navController1.topViewController as! FixVehicleTableViewController
            let viewingRequestsVC = navController2.topViewController as! ViewingRequestsTableViewController
            
            fixVehicleController.carsStore = carsStore
            fixVehicleController.photoStore = photoStore
            
            viewingRequestsVC.carsStore = carsStore
            viewingRequestsVC.photoStore = photoStore
        } else {
            rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginvc") as! LoginVC
            
            window.rootViewController = rootVC
            window.makeKeyAndVisible()
        }
    }
}
