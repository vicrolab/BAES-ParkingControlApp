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
    var locationManager: CLLocationManager?
    weak var delegate: VehicleEntryViewControllerDelegate?
    var vehicle: VehicleEntry? {
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
    
    // MARK: - Private interface
    private func setupMapViewRegion(location: CLLocationCoordinate2D, mapView: MKMapView, showUserLocation: Bool) {
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: location, span: span)
        
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = showUserLocation
    }
}

// MARK: - MKMapViewDelegate
extension VehicleEntryMapViewTableViewCell: MKMapViewDelegate, CLLocationManagerDelegate {
    
    private func setupMapView() {
        locationManager = CLLocationManager()
        guard let locationManager = locationManager else {
            return
        }
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
            
            switch screenMode {
            case .edit:
                guard let location = locationManager.location?.coordinate else {
                    return
                }
                setupMapViewRegion(location: location,
                                   mapView: mapView,
                                   showUserLocation: true)
            case .view:
                guard let vehicle = vehicle else {
                    return
                }
                let vehicleCoordinates = CLLocationCoordinate2D(latitude: vehicle.latitude, longitude: vehicle.longitude)
                setupMapViewRegion(location: vehicleCoordinates, mapView: mapView, showUserLocation: false)
                createVehicleLocationAnnotation()
            default:
                break
            }
        }
    }
    
    private func createVehicleLocationAnnotation() {
        guard let vehicle = vehicle else {
            return
        }
        let vehicleCoordinates = CLLocationCoordinate2D(latitude: vehicle.latitude, longitude: vehicle.longitude)
        let annotation = MKPointAnnotation()
        annotation.coordinate = vehicleCoordinates
        annotation.title = vehicle.number
        
        mapView.addAnnotation(annotation)
    }
    
    private func checkAuthorizationStatus() {
        guard let locationManager = locationManager else {
            return
        }
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
        case .authorizedAlways:
            break
        case .denied:
            delegate?.displayAlert(title: "Check location services",
                                   message: "The user denied the use of location services for the app or they are disabled globally in Settings")
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            mapView.showsUserLocation = true
        case .restricted:
            delegate?.displayAlert(
                title: "Check location services",
                message: "The app is not authorized to use location services"
            )
        default:
            break
        }
    }
}
