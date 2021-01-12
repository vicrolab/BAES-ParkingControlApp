//
//  UIViewController+Extensions.swift
//  ParkingControl
//
//  Created by Mikalaj Shuhno on 28.12.20.
//

import UIKit
import MapKit

extension UIViewController {
    func displayAlert(title: String, message: String) {
        let okAction = UIAlertAction(title: "ОК", style: .default)
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
}

extension DateFormatter {
    static let standard: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
}

extension VehicleEntryMapViewTableViewCell {
    func setupMapViewRegion(location: CLLocationCoordinate2D, mapView: MKMapView, showUserLocation: Bool) {
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: location, span: span)
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
