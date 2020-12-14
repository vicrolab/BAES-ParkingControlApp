//
//  DetailRequestTableViewController.swift
//  ParkingControl
//
//  Created by Mikalaj Shuhno on 13.12.20.
//

import UIKit
import MapKit
import CoreLocation

class DetailRequestTableViewController: UITableViewController {
    @IBOutlet weak var vehicleNumber: UILabel!
    @IBOutlet weak var vehicleBrand: UILabel!
    @IBOutlet weak var vehicleModel: UILabel!
    @IBOutlet weak var fixingDate: UILabel!
    
    

    var car: CarRequest! {
        didSet {
            navigationItem.title = car.numberVehicle
        }
    }
    
    var photoStore: PhotoStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        vehicleNumber.text = car.numberVehicle
        vehicleBrand.text = car.brandVehicle
        vehicleModel.text = car.modelVehicle
        fixingDate.text = dateFormatter.string(from: car.fixingDate)
    }


    

}
