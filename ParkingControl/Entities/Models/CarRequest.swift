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
