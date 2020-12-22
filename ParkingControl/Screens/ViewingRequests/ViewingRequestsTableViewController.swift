//
//  ViewingRequestsTableViewController.swift
//  ParkingControl
//
//  Created by Mikalaj Shuhno on 13.12.20.
//

import UIKit

class ViewingRequestsTableViewController: UITableViewController {
    
    var carsStore = CarsStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 65
        
    }
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return carsStore.allCars.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ViewRequestCell
        let car = carsStore.allCars[indexPath.row]
        cell.vehicleInformation.text = "\(car.numberVehicle!), \(car.brandVehicle!), \(car.modelVehicle!)"
        cell.dateAndLocation.text = "\(dateFormatter.string(from: car.fixingDate))"
//        cell.selectionStyle = .none
        

        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showDetail"?:
            if let row = tableView.indexPathForSelectedRow?.row {
                let car = carsStore.allCars[row]
                let detailVC = segue.destination as! DetailRequestTableViewController
                detailVC.car = car
            }
        default:
            preconditionFailure("Fail")
        }
    }
    
    
    
}
