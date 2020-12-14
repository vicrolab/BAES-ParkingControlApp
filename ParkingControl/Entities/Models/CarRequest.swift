//
//  CarsModel.swift
//  ParkingControl
//
//  Created by Mikalaj Shuhno on 2.12.20.
//

import Foundation
import UIKit
import MapKit

class CarRequest: NSObject {
    var numberVehicle: String?
    var brandVehicle: String?
    var modelVehicle: String?
    var coordVehicle: CLLocationCoordinate2D?
    var photoVehicle: [UIImage]?
    var fixingDate: Date
//    var vehicleKey: String?

    init(numberVehicle: String?, brandVehicle: String?, modelVehicle: String?, coordVehicle: CLLocationCoordinate2D?, photoVehicle: [UIImage]?, fixingDate: Date) {
        self.numberVehicle = numberVehicle
        self.brandVehicle = brandVehicle
        self.modelVehicle = modelVehicle
        self.coordVehicle = coordVehicle
        self.photoVehicle = photoVehicle
        self.fixingDate = Date()
        
        super.init()
    }
}


//struct CarModels {
//    var CarModel = ["Audi": ["A1","A2", "A3", "A4", "A5", "A6"],
//                    "BMW": ["1 series", "2 series", "3 series", "4 series", "5 series", "6 series", "7 series", "8 series"],
//                    "Tesla": ["Model 3", "Model S", "Model X", "Model Y"]
//    ]
//
//}
