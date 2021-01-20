//
//  CarInfoStore.swift
//  ParkingControl
//
//  Created by Mikalaj Shuhno on 14.01.21.
//

import UIKit

struct CarInfoStore {
    static let all: [(brand: String, models: [String])] = [
        ("Audi", ["A1", "A2", "A3", "A4", "A5", "A6", "A7", "A8", "Q2", "Q3", "Q5", "Q7"]),
        ("BWM", ["1 series", "2 series", "3 series", "4 series", "5 series", "6 series", "7 series", "X1", "X2", "X3", "X4", "X5", "X6", "X7"]),
        ("Mazda", ["2", "3", "5", "6", "CX-3", "CX-5", "CX-7", "CX-9"])
    ]
}
