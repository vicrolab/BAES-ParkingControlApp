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
    @IBOutlet weak var mapView: MKMapView!
    
    var car: CarRequest! {
        didSet {
            navigationItem.title = car.numberVehicle
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.allowsSelection = false
        
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
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? DetailRequestTableViewCell else {
            return
        }
        tableViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
    }
    
    
// MARK: - setup mapview
    
    var locationManager = CLLocationManager()

}

extension DetailRequestTableViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        guard let photos = car.photoVehicle else { return 0 }
//        return photos.count
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "PhotoCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! DetailRequestCollectionViewCell
//        guard let photos = car.photoVehicle else {
//            return cell
//        }
//        cell.imageView.image = photos[indexPath.item]
//        cell.layer.borderWidth = 0.5
//        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.backgroundColor = .black
        cell.imageView.backgroundColor = .black
        return cell
    }
    
    
    
}
