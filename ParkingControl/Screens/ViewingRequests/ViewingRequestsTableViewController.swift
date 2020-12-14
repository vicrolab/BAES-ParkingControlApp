//
//  ViewingRequestsTableViewController.swift
//  ParkingControl
//
//  Created by Mikalaj Shuhno on 13.12.20.
//

import UIKit

class ViewingRequestsTableViewController: UITableViewController {
    
    var carsStore = CarsStore()
    var photoStore = PhotoStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 65
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return carsStore.allCars.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ViewRequestCell
        let car = carsStore.allCars[indexPath.row]
//        let defaultNumber = "Гос номер не указан"
//        let defaultBrand = "Марка не указана"
//        let defaultModel = "Модель не указана"
//        cell.vehicleInformation.text = "\(car.brandVehicle ?? defaultBrand)  \(car.modelVehicle ?? defaultModel)  \(car.numberVehicle ?? defaultNumber)"
        cell.vehicleInformation.text = "\(car.brandVehicle)  \(car.modelVehicle)  \(car.numberVehicle)"
        cell.dateAndLocation.text = car.brandVehicle
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
                detailVC.photoStore = photoStore
            }
        default:
            preconditionFailure("Fail")
        }
    }
    
    
    
}
