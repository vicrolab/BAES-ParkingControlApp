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
    
    var vehicleEntities: [VehicleEntry] = []
    var selectedVehicle: NSManagedObject?
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 65
        
        persistentStore.fetchVehicleEntries { (result) in
            switch result {
            case let .success(vehicleEntries):
                self.vehicleEntities = vehicleEntries
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
                self.vehicleEntities = vehicleEntries
                self.tableView.reloadData()
            case let .failure(error):
                print("Error occured: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: TableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vehicleEntities.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RequestListCell
        let vehicle = vehicleEntities[indexPath.row]
        
        let numberVehicle = vehicle.value(forKey: "number") as? String
        let brandVehicle = vehicle.value(forKey: "brand") as? String
        let modelVehicle = vehicle.value(forKey: "model") as? String
        let dateCreated = vehicle.value(forKey: "dateCreated") as? Date
        
        cell.vehicleInformation.text = "\(numberVehicle!)', \(brandVehicle!), \(modelVehicle!)"
        cell.dateAndLocation.text = "\(DateFormatter.standard.string(from: dateCreated!))"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedVehicle = vehicleEntities[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "VehicleEntryViewController") as! VehicleEntryViewController
        navigationController?.pushViewController(controller, animated: true)
        
        var vehiclePhotoList: [UIImage] = []
        let selectedCarImageSet = vehicleEntities[indexPath.row].image
        var selectedCarImageArray = selectedCarImageSet?.allObjects
        selectedCarImageArray!.sort {
            guard let firstObject = $0 as? NSManagedObject,
                  let secondObject = $1 as? NSManagedObject,
                  let firstPosition = firstObject.value(forKey: "position") as? Int16,
                  let secondPosition = secondObject.value(forKey: "position") as? Int16
            else {
                return false
            }
            return firstPosition < secondPosition
        }
        
        for entityData in selectedCarImageArray! {
            guard let entityDataObject = entityData as? NSManagedObject,
                  let entityImageData = entityDataObject.value(forKey: "data") as? Data,
                  let image = UIImage(data: entityImageData)
            else {
                return
            }
            let orientedImage = UIImage(cgImage: image.cgImage!, scale: 1.0, orientation: .right)
            vehiclePhotoList.append(orientedImage)
        }
        controller.selectedVehicle = selectedVehicle
        controller.screenMode = .view
        controller.vehiclePhotoList = vehiclePhotoList
    }
}

