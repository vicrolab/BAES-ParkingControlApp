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
    
    

    var car: CarRequest! {
        didSet {
            navigationItem.title = car.numberVehicle
        }
    }
    
    var photoStore: PhotoStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }

    // MARK: - Table view data source



    

}
