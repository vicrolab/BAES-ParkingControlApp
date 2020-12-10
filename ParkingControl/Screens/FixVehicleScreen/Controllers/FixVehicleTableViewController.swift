//
//  FixVehicleTableViewController.swift
//  ParkingControl
//
//  Created by Mikalaj Shuhno on 30.11.20.
//

import UIKit
import MapKit
//import CoreData
import CoreLocation

class FixVehicleTableViewController: UITableViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var numberVehicleTF: UITextField!
    @IBOutlet weak var numberVehicleSwitch: UISwitch!
    @IBOutlet weak var brandVehicleTF: UITextField!
    @IBOutlet weak var modelVehicleTF: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
//    var photoList = PhotoCell.photos
    var photoList: [UIImage] = []
    let model: [[UIColor]] = generateRandomData()
    
    fileprivate let pickerViewToolbar = ToolbarPickerView()
    
    fileprivate let vehiclePickerViewValues = ["Test 1", "Test 2", "Test 3", "Test 4", "Test 5"]
    fileprivate let modelPickerViewValues = ["Model 1", "Model 2", "Model 3", "Model 4", "Model 5"]
    
    var activePickerViewTag = 0
    
    @IBAction func fixVehicleAction(_ sender: Any) {
    }
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func NVChangeState(_ sender: Any) {
        changeSwitchState(sender: numberVehicleSwitch)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNumberVehicleTextField()
        pickerViews()

        updateUserLocation()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // clear first responder after tap reognizer and dismiss keyboard
        view.endEditing(true)
    }

    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? TableViewCell else { return }
        tableViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
    }
    
    // MARK: - number vehicle text field setup
    private func setupNumberVehicleTextField() {
        let toolbar = UIToolbar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        toolbar.setItems([flexSpace, doneButton], animated: true)
        toolbar.sizeToFit()
        
        numberVehicleTF.inputAccessoryView = toolbar
        
    }
    
    @objc func doneButtonTapped() {
        view.endEditing(true)
    }
    
    private func changeSwitchState(sender: UISwitch) {
        if (sender.isOn) == false {
            numberVehicleTF.isEnabled = true
            numberVehicleTF.placeholder = "1234 AA 7"
        } else {
            numberVehicleTF.isEnabled = false
            numberVehicleTF.text = ""
            numberVehicleTF.placeholder = "Номер отсутствует"
        }
    }
    
    
    // MARK: - setup text fields  with model and brand vehicle, setup inputView (picker view)
    private func pickerViews() {
        pickerViewToolbar.pickerFirst.tag = 1
        pickerViewToolbar.pickerTwo.tag = 2
        brandVehicleTF.inputView = self.pickerViewToolbar.pickerFirst
        brandVehicleTF.inputAccessoryView = self.pickerViewToolbar.toolbar
        
        modelVehicleTF.inputView = self.pickerViewToolbar.pickerTwo
        modelVehicleTF.inputAccessoryView = self.pickerViewToolbar.toolbar
        
        self.pickerViewToolbar.pickerFirst.dataSource = self
        self.pickerViewToolbar.pickerTwo.dataSource = self
        self.pickerViewToolbar.pickerFirst.delegate = self
        self.pickerViewToolbar.pickerTwo.delegate = self
        self.pickerViewToolbar.toolbarDelegate = self
        
        self.pickerViewToolbar.pickerFirst.reloadAllComponents()
        self.pickerViewToolbar.pickerTwo.reloadAllComponents()
        self.brandVehicleTF.delegate = self
        self.modelVehicleTF.delegate = self
    }
 
    
    // MARK: - setup mapview
    
    var locationManager = CLLocationManager()
    
    func updateUserLocation() {
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        } else {
            print ("Enable location services for app")
        }
        
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        
        if let coor = mapView.userLocation.location?.coordinate {
            mapView.setCenter(coor, animated: true)
        }
    }
    
    // MARK: - collection view setup
    
    
    
    
    
}


extension FixVehicleTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView.tag == 1) {
            return self.vehiclePickerViewValues.count
        } else {
            return self.modelPickerViewValues.count
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView.tag == 1) {
            return self.vehiclePickerViewValues[row]
        } else {
            return self.modelPickerViewValues[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView.tag == 1) {
            self.brandVehicleTF.text = self.vehiclePickerViewValues[row]
        } else {
            self.modelVehicleTF.text = self.modelPickerViewValues[row]
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activePickerViewTag = textField.inputView!.tag
    }
}

extension FixVehicleTableViewController: ToolbarPickerViewDelegate {

    func didTapDone() {
        if activePickerViewTag == 1 {
            let row = self.pickerViewToolbar.pickerFirst.selectedRow(inComponent: 0)
            self.pickerViewToolbar.pickerFirst.selectRow(row, inComponent: 0, animated: false)
            self.brandVehicleTF.text = self.vehiclePickerViewValues[row]
            self.brandVehicleTF.resignFirstResponder()
        } else {
            let row = self.pickerViewToolbar.pickerTwo.selectedRow(inComponent: 0)
            self.pickerViewToolbar.pickerTwo.selectRow(row, inComponent: 0, animated: false)
            self.modelVehicleTF.text = self.modelPickerViewValues[row]
            self.modelVehicleTF.resignFirstResponder()
        }
    }
    
    func didTapCancel() {
        if activePickerViewTag == 1 {
            self.brandVehicleTF.text = nil
            self.brandVehicleTF.resignFirstResponder()
        } else {
            self.modelVehicleTF.text = nil
            self.modelVehicleTF.resignFirstResponder()
        }
    }
}

extension FixVehicleTableViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue: CLLocationCoordinate2D = manager.location!.coordinate
        mapView.mapType = MKMapType.standard
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: locValue, span: span)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = locValue
        annotation.title = numberVehicleTF.text
        annotation.subtitle = "current location"
        mapView.addAnnotation(annotation)
    }
    
}

extension FixVehicleTableViewController: UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoList.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "PhotoCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! PhotoCell
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedCamera))
        if indexPath.item == 0 {
            cell.backgroundColor = UIColor.gray
            cell.imageView.image = #imageLiteral(resourceName: "photo")
            cell.addGestureRecognizer(tapGesture)
            
            return cell
        }
            let photo = photoList[indexPath.item - 1]
            cell.imageView.image = photo
            cell.layer.borderWidth = 0.5
            cell.layer.borderColor = UIColor.lightGray.cgColor
            
            return cell
    }
    
    
    @objc func tappedCamera() {
        let imagePicker = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        photoList.append(image)
        picker.dismiss(animated: true, completion: nil)
        print(photoList.count)
        tableView.reloadData()
    }
    
}


