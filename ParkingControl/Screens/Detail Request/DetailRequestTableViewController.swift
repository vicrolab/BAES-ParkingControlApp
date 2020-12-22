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
        mapView.delegate = self
        showFixVehicleLocation()
        changePosition()
        
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
    
    func showFixVehicleLocation() {
//        let locationManager = CLLocationManager()
        let fixVehicleAnnotation = MKPointAnnotation()
        fixVehicleAnnotation.title = vehicleNumber.text
        if let coordVehicle = car.coordVehicle {
            fixVehicleAnnotation.coordinate = coordVehicle
            mapView.addAnnotation(fixVehicleAnnotation)
        }
    }
    func changePosition() {
        if let coordVehicle = car.coordVehicle {
            let center: CLLocationCoordinate2D = coordVehicle
            mapView.setCenter(center, animated: true)
            let radius = 1000.00
            let region = MKCoordinateRegion(center: coordVehicle, latitudinalMeters: radius, longitudinalMeters: radius)
            mapView.setRegion(region, animated: true)
        }
        
    }
    
}

extension DetailRequestTableViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let photos = car.photoVehicle else { return 0 }
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "PhotoCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! DetailRequestCollectionViewCell
        guard let photos = car.photoVehicle else {
            return cell
        }
        cell.imageView.image = photos[indexPath.item]
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor.lightGray.cgColor
        return cell
    }
}

extension DetailRequestTableViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        return annotationView
    }
    
    
    
}
