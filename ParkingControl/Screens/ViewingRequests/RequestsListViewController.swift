//
//  ViewingRequestsTableViewController.swift
//  ParkingControl
//
//  Created by Mikalaj Shuhno on 13.12.20.
//

import UIKit
import CoreData

class RequestsListViewController: UITableViewController, UITextFieldDelegate {
    let persistentStore = PersistentStore()
    var cars: [VehicleEntry] = []
    var images: Any?
//    var photoList: [UIImage]?
    var photos: VehicleEntryImage! {
        didSet {
            photo = photos.value(forKeyPath: "VehicleEntry.VehicleEntryImage") as? Data
        }
    }
    var selectedCar: NSManagedObject?
    var photo: Data?
    
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
// TODO: вынести dateFormatter в отдельный класс
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
        
        let numberVehicle = car.value(forKey: "number") as? String
        let brandVehicle = car.value(forKey: "brand") as? String
        let modelVehicle = car.value(forKey: "model") as? String
        let fixingDate = car.value(forKey: "dateCreated") as? Date
        
        cell.vehicleInformation.text = "\(numberVehicle!)', \(brandVehicle!), \(modelVehicle!)"
        cell.dateAndLocation.text = "\(dateFormatter.string(from: fixingDate!))"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCar = cars[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "VehicleEntryViewController") as! VehicleEntryViewController
        navigationController?.pushViewController(controller, animated: true)
        
        controller.selectedCar = selectedCar
        controller.screenMode = .view
        
        
        let selectedCarImageSet = cars[indexPath.row].image
        let selectedCarImageArray = selectedCarImageSet?.allObjects
        
        for entityData in selectedCarImageArray! {
            guard let entityDataObject = entityData as? NSManagedObject
            else {
                return
            }
            guard let entityImage = entityDataObject.value(forKey: "data") as? Data
            else {
                return
            }
            guard let image = UIImage(data: entityImage)
            else {
                return
            }
            var photoList: [UIImage] = []
            photoList.append(image)
            controller.photoList = photoList
            
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
    
    
}


extension UIImage {

    // UIImage to Data (PNG Representation)
    var PNGData: Data? {
        return self.pngData()
    }
}
