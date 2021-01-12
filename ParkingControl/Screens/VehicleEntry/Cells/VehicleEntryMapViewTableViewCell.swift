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
            } else {
                print ("Enable location services for app")
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
            } else {
                print ("Enable location services for app")
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
            displayAlert(title: "Check location services",
                         message: "The user denied the use of location services for the app or they are disabled globally in Settings",
                         controller: VehicleEntryViewController())
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            mapView.showsUserLocation = true
        case .restricted:
            displayAlert(title: "Check location services",
                         message: "The app is not authorized to use location services",
                         controller: VehicleEntryViewController())
        default:
            break
        }
    }
}
