//
//  ViewingRequestsTableViewController.swift
//  ParkingControl
//
//  Created by Mikalaj Shuhno on 13.12.20.
//

import UIKit
import CoreData

class ViewingRequestsTableViewController: UITableViewController {
    
    var carsStore = CarsStore()
    var cars: [NSManagedObject] = []
    var selectedCar: NSManagedObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 65
        loadFromCoreData()
        tableView.reloadData()
        
        
    }
    func loadFromCoreData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let entityName = "Cars"
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        do {
            cars = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
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
        return cars.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ViewRequestCell
        let car = cars[indexPath.row]
        let numberVehicle = car.value(forKey: "numberVehicle") as? String
        let brandVehicle = car.value(forKey: "brandVehicle") as? String
        let modelVehicle = car.value(forKey: "modelVehicle") as? String
        let fixingDate = car.value(forKey: "dateTaken") as? Date
        
        cell.vehicleInformation.text = "\(numberVehicle!)', \(brandVehicle!), \(modelVehicle!)"
        cell.dateAndLocation.text = "\(dateFormatter.string(from: fixingDate!))"
//        cell.selectionStyle = .none
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showDetail"?:
            if let row = tableView.indexPathForSelectedRow?.row {
                let selectedCar = cars[row]
                let detailVC = segue.destination as! DetailRequestTableViewController
                detailVC.selectedCar = selectedCar
            }
        default:
            preconditionFailure("Fail")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFromCoreData()
        tableView.reloadData()
    }

    
    
   
    
}
