//
//  Helpers.swift
//  ParkingControl
//
//  Created by Mikalaj Shuhno on 9.12.20.
//

import UIKit

func generateRandomData() -> [[UIColor]] {
    let numberOfRows = 1
    let numberOfItemsPerRow = 30

    return (0..<numberOfRows).map { _ in
        return (0..<numberOfItemsPerRow).map { _ in UIColor.randomColor() }
    }
}

extension UIColor {
    
    class func randomColor() -> UIColor {

        let hue = CGFloat(arc4random() % 100) / 100
        let saturation = CGFloat(arc4random() % 100) / 100
        let brightness = CGFloat(arc4random() % 100) / 100

        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
    }
}
