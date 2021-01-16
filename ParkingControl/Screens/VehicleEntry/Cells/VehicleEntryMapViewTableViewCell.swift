//
//  VehicleEntryMapViewTableViewCell.swift
//  ParkingControl
//
//  Created by Mikalaj Shuhno on 11.01.21.
//

import UIKit
import CoreLocation
import MapKit
import CoreData

class VehicleEntryMapViewTableViewCell: UITableViewCell {
    // MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: Properties
    var screenMode: VehicleEntryViewController.ScreenMode?
    var locationManager = CLLocationManager()
    var vehicleCoordinateLatitude: Double?
    var vehicleCoordinateLongitude: Double?
    var delegate: VehicleEntryViewControllerDelegate?
    var selectedVehicle: NSManagedObject? {
        didSet {
            setupMapView()
        }
    }
    
    // MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        screenMode = .edit
        mapView.delegate = self
        setupMapView()
    }
    
    // MARK: Setup
    // MARK: - Public interface
    // MARK: - Private interface
}

// MARK: - MKMapViewDelegate
extension VehicleEntryMapViewTableViewCell: MKMapViewDelegate, CLLocationManagerDelegate {
    
    func setupMapView() {
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        locationManager.requestWhenInUseAuthorization()
        checkAuthorizationStatus()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            
            if screenMode == .edit {
                setupMapViewRegion(location: locationManager.location!.coordinate,
                                   mapView: mapView,
                                   showUserLocation: true)
            }
            if screenMode == .view {
                guard let selectedVehicle = selectedVehicle,
                      let latitude = selectedVehicle.value(forKey: "latitude") as? Double,
                      let longitude = selectedVehicle.value(forKey: "longitude") as? Double
                else {
                    return
                }
                let vehicleCoordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                setupMapViewRegion(location: vehicleCoordinates, mapView: mapView, showUserLocation: false)
                createVehicleLocationAnnotation()
            }
        }
    }
    
    func createVehicleLocationAnnotation() {
        guard let latitude = selectedVehicle?.value(forKey: "latitude") as? Double,
              let longitude = selectedVehicle?.value(forKey: "longitude") as? Double
        else {
            return
        }
        let vehicleCoordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let annotation = MKPointAnnotation()
        annotation.coordinate = vehicleCoordinates
        // TODO add annotation
        
        mapView.addAnnotation(annotation)
    }
    
    func checkAuthorizationStatus() {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
        case .authorizedAlways:
            break
        case .denied:
            let controller = VehicleEntryViewController()
            controller.displayAlert(title: "Check location services",
                                    message: "The user denied the use of location services for the app or they are disabled globally in Settings")
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            mapView.showsUserLocation = true
        case .restricted:
            let controller = VehicleEntryViewController()
            controller.displayAlert(title: "Check location services",
                                    message: "The app is not authorized to use location services")
        default:
            break
        }
    }
}

extension VehicleEntryMapViewTableViewCell {
    func setupMapViewRegion(location: CLLocationCoordinate2D, mapView: MKMapView, showUserLocation: Bool) {
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: location, span: span)
        
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = showUserLocation
    }
    
    func displayAlert(title: String, message: String, controller: UIViewController) {
        let okAction = UIAlertAction(title: "ОК", style: .default)
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(okAction)
        controller.present(alert, animated: true)
    }
}
