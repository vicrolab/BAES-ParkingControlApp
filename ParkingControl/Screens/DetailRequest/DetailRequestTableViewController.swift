//
//  DetailRequestTableViewController.swift
//  ParkingControl
//
//  Created by Mikalaj Shuhno on 13.12.20.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class DetailRequestTableViewController: UITableViewController {
    @IBOutlet weak var vehicleNumber: UILabel!
    @IBOutlet weak var vehicleBrand: UILabel!
    @IBOutlet weak var vehicleModel: UILabel!
    @IBOutlet weak var fixingDate: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var selectedCar: NSManagedObject? {
        didSet {
            navigationItem.title = selectedCar?.value(forKey: "numberVehicle") as? String
        }
    }
    
    var photoList: [UIImage]?
    
//    var car: [CarRequest!] {
//        didSet {
//            navigationItem.title = car.numberVehicle
//        }
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        mapView.delegate = self
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
    
    func imagesFromCoreData(object: Data?) -> [UIImage]? {
        var photoList = [UIImage]()
        guard let object = object else { return nil }
        if let dataArray = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSArray.self, from: object) {
            for data in dataArray {
                if let data = data as? Data, let image = UIImage(data: data) {
                    photoList.append(image)
                }
            }
        }
        print(photoList.count)
        print(photoList.count)
        return photoList
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let selectedCar = selectedCar else {
            return
        }
        vehicleNumber.text = selectedCar.value(forKey: "numberVehicle") as? String
        vehicleBrand.text = selectedCar.value(forKey: "brandVehicle") as? String
        vehicleModel.text = selectedCar.value(forKey: "modelVehicle") as? String
        fixingDate.text = dateFormatter.string(from: selectedCar.value(forKey: "dateTaken") as! Date)
        let imageArray = selectedCar.value(forKey: "photoVehicle") as? Data
        imagesFromCoreData(object: imageArray)
        print(photoList?.count as Any)
    }
    
//    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        guard let tableViewCell = cell as? DetailRequestTableViewCell else {
//            return
//        }
////        tableViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
//    }
    
    
// MARK: - setup mapview
    
    func showFixVehicleLocation() {
////        let locationManager = CLLocationManager()
//        let fixVehicleAnnotation = MKPointAnnotation()
//        fixVehicleAnnotation.title = vehicleNumber.text
//        if let coordVehicle = car.coordVehicle {
//            fixVehicleAnnotation.coordinate = coordVehicle
//            mapView.addAnnotation(fixVehicleAnnotation)
//        }
    }
    func changePosition() {
//        if let coordVehicle = car.coordVehicle {
//            let center: CLLocationCoordinate2D = coordVehicle
//            mapView.setCenter(center, animated: true)
//            let radius = 1000.00
//            let region = MKCoordinateRegion(center: coordVehicle, latitudinalMeters: radius, longitudinalMeters: radius)
//            mapView.setRegion(region, animated: true)
//        }
//
    }
    
    

}



//extension DetailRequestTableViewController: UICollectionViewDataSource, UICollectionViewDelegate {
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        guard let photos = car.photoVehicle else { return 0 }
//        return photos.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let identifier = "PhotoCell"
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! DetailRequestCollectionViewCell
//        guard let photos = car.photoVehicle else {
//            return cell
//        }
//        cell.imageView.image = photos[indexPath.item]
//        cell.layer.borderWidth = 0.5
//        cell.layer.borderColor = UIColor.lightGray.cgColor
//        return cell
//    }
//}
//
//extension DetailRequestTableViewController: MKMapViewDelegate {
//
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        guard annotation is MKPointAnnotation else { return nil }
//        let identifier = "Annotation"
//        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
//
//        if annotationView == nil {
//            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//            annotationView!.canShowCallout = true
//        } else {
//            annotationView!.annotation = annotation
//        }
//        return annotationView
//    }
//
//
//
//}
