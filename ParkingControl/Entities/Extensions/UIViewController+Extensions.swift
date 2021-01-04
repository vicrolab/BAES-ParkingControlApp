//
//  UIViewController+Extensions.swift
//  ParkingControl
//
//  Created by Mikalaj Shuhno on 28.12.20.
//

import UIKit

extension UIViewController {
    func displayAlert(title: String, message: String) {
        let okAction = UIAlertAction(title: "ОК", style: .default)
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
}

extension DateFormatter {
    static let standard: DateFormatter = {
        let formatter = DateFormatter()
        
        return formatter
    }()
}
