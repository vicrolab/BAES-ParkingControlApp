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
    var selectedVehicle: NSManagedObject? {
        didSet {
            setupMapView()
        }
    }
    var delegate: VehicleEntryViewControllerDelegate?
    
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
        
        if screenMode == .edit {
            self.locationManager.requestWhenInUseAuthorization()
            checkAuthorizationStatus()
            if CLLocationManager.locationServicesEnabled() {
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.startUpdatingLocation()
                
                let userLocation: CLLocationCoordinate2D = locationManager.location!.coordinate
                mapView.mapType = MKMapType.standard
                mapView.isZoomEnabled = true
                let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                let region = MKCoordinateRegion(center: userLocation, span: span)
                mapView.setRegion(region, animated: true)
                mapView.showsUserLocation = true
            } else {
                print ("Enable location services for app")
            }
        }
        if screenMode == .view {
            self.locationManager.requestWhenInUseAuthorization()
            checkAuthorizationStatus()
            if CLLocationManager.locationServicesEnabled() {
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.startUpdatingLocation()
                guard let selectedVehicle = selectedVehicle
                else {
                    return
                }
                guard let latitude = selectedVehicle.value(forKey: "latitude") as? Double, let longitude = selectedVehicle.value(forKey: "longitude") as? Double
                else {
                    return
                }
                let vehicleCoordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                mapView.mapType = MKMapType.standard
                let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                let region = MKCoordinateRegion(center: vehicleCoordinates, span: span)
                mapView.setRegion(region, animated: true)
                mapView.showsUserLocation = false
                createVehicleLocationAnnotation()
            } else {
                print ("Enable location services for app")
            }
        }
    }
    
    func createVehicleLocationAnnotation() {
        guard let latitude = selectedVehicle?.value(forKey: "latitude") as? Double, let longitude = selectedVehicle?.value(forKey: "longitude") as? Double
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
        // TODO ALERT
        case .denied:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            mapView.showsUserLocation = true
        // TODO ALERT
        case .restricted:
            break
        default:
            break
        }
    }
}
