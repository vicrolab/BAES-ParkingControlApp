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
    private let persistentStore = PersistentStore()
    
    var vehicleEntities: [VehicleEntry]?
    var selectedVehicle: NSManagedObject?
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 65
        fetchVehicleEntries()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchVehicleEntries()
    }
    
    // MARK: TableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let vehicleEntries = vehicleEntities
        else {
            return 0
        }
        return vehicleEntries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RequestListCell
        guard let vehicle = vehicleEntities?[indexPath.row]
        else {
            return cell
        }
        let numberVehicle = vehicle.number
        let brandVehicle = vehicle.brand
        let modelVehicle = vehicle.model
        let dateCreated = vehicle.dateCreated
        
        cell.vehicleInformation.text = "\(numberVehicle ?? "Номер не указан"), \(brandVehicle ?? "Марка не указана"), \(modelVehicle ?? "Модель не указана")"
        cell.dateAndLocation.text = "\(DateFormatter.standard.string(from: dateCreated!))"
        
        return cell

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vehicle = vehicleEntities?[indexPath.row],
              let vehicleEntryImageSet = vehicle.images
        else {
            return
        }
        
        let vehicleEntryImages = Array(vehicleEntryImageSet)
            .map { (object) -> VehicleEntryImage in
                object as! VehicleEntryImage
            }
            .sorted(by: { $0.position < $1.position })
            .map { (image) -> UIImage? in
                guard let data = image.data else {
                    return nil
                }

                return orientImage(UIImage(data: data))
            }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "VehicleEntryViewController") as! VehicleEntryViewController
        
        controller.vehicle = vehicle
        controller.screenMode = .view
        controller.vehiclePhotoList = vehicleEntryImages
        
        navigationController?.pushViewController(controller, animated: true)
    }

    // MARK: - Private interface
    private func orientImage(_ image: UIImage?) -> UIImage? {
        guard let image = image else {
            return nil
        }
        let reverseImage = UIImage(cgImage: image.cgImage!, scale: 1.0, orientation: .right)
        
        return reverseImage
    }
}

extension RequestsListViewController {
    func fetchVehicleEntries() {
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
}

