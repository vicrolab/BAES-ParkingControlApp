//
//  ViewingRequestsTableViewController.swift
//  ParkingControl
//
//  Created by Mikalaj Shuhno on 13.12.20.
//

import UIKit
import CoreData

class RequestsListViewController: UITableViewController, UITextFieldDelegate {
    
    // MARK: Properties
    let persistentStore = PersistentStore()
    
    var cars: [VehicleEntry] = []
    var images: Any?
    var selectedCar: NSManagedObject?
    var photo: Data?
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 65
        
        persistentStore.fetchVehicleEntries { (result) in
            switch result {
            case let .success(vehicleEntries):
                self.cars = vehicleEntries
                self.tableView.reloadData()
            case let .failure(error):
                print("Error occured: \(error.localizedDescription)")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        persistentStore.fetchVehicleEntries { (result) in
            switch result {
            case let .success(vehicleEntries):
                self.cars = vehicleEntries
                self.tableView.reloadData()
            case let .failure(error):
                print("Error occured: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: TableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cars.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RequestListCell
        let car = cars[indexPath.row]
        
        let numberVehicle = car.value(forKey: "number") as? String
        let brandVehicle = car.value(forKey: "brand") as? String
        let modelVehicle = car.value(forKey: "model") as? String
        let fixingDate = car.value(forKey: "dateCreated") as? Date
        
        cell.vehicleInformation.text = "\(numberVehicle!)', \(brandVehicle!), \(modelVehicle!)"
        cell.dateAndLocation.text = "\(DateFormatter.standard.string(from: fixingDate!))"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCar = cars[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "VehicleEntryViewController") as! VehicleEntryViewController
        navigationController?.pushViewController(controller, animated: true)
        
        var photoList: [UIImage] = []
        let selectedCarImageSet = cars[indexPath.row].image
        let selectedCarImageArray = selectedCarImageSet?.allObjects
        
        // TOOD: Make ordered fetch from core data
        for entityData in selectedCarImageArray! {
            guard let entityDataObject = entityData as? NSManagedObject,
                  let entityImage = entityDataObject.value(forKey: "data") as? Data,
                  let image = UIImage(data: entityImage)
            else {
                return
            }
//            guard let entityPosition = entityDataObject.value(forKey: "position") as? Int16
//            else {
//                return
//            }
//            let imageIndexInInt = Int(entityPosition)
//            photoList.insert(orientedImage, at: imageIndexInInt)
            
            let orientedImage = UIImage(cgImage: image.cgImage!, scale: 1.0, orientation: .right)
            photoList.append(orientedImage)
        }
        controller.selectedCar = selectedCar
        controller.screenMode = .view
        controller.photoList = photoList
    }
}

