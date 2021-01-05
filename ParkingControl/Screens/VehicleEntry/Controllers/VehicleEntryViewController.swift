//
//  FixVehicleTableViewController.swift
//  ParkingControl
//
//  Created by Mikalaj Shuhno on 30.11.20.
//

import UIKit
import MapKit
import CoreData
import CoreLocation

class VehicleEntryViewController: UITableViewController, UITextFieldDelegate {
    // MARK: Outlets
    @IBOutlet var numberVehicleTF: UITextField!
    @IBOutlet weak var numberVehicleSwitch: UISwitch!
    @IBOutlet weak var brandVehicleTF: UITextField!
    @IBOutlet weak var modelVehicleTF: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var fixVehicleOutlet: UIBarButtonItem!
    
    // MARK: Actions
    @IBAction func fixVehicleAction(_ sender: UIBarButtonItem) {
        guard
            let numberVehicle = numberVehicleTF.text,
            !numberVehicle.isEmpty
        else {
            displayAlert(
                title: "Отсутствует гос номер ТС",
                message: "Введите гос номер или установите без номера")
            return
        }

        guard
            let brandVehicle = brandVehicleTF.text,
            !brandVehicle.isEmpty
        else {
            displayAlert(
                title: "Отсутствует марка ТС",
                message: "Выберите марку из списка")
            return
        }

        guard
            let modelVehicle = modelVehicleTF.text,
            !modelVehicle.isEmpty
        else {
            displayAlert(
                title: "Отсутствует модель ТС",
                message: "Выберите модель из списка")
            return
        }

        setupMapView()

        persistentStore.createVehicleEntry(
            brandVehicle: brandVehicle,
            dateCreated: Date(),
            modelVehicle: modelVehicle,
            numberVehicle: numberVehicle,
            photoList: photoList,
            longitude: vehicleLongitude!,
            latitude: vehicleLatitude!
        )
        
        successAddAlert()
        clearFields()
    }
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func NVChangeState(_ sender: Any) {
        setupSwitchState(sender: numberVehicleSwitch)
    }
    
    // MARK: Properties
    enum ScreenMode {
        case view, edit
    }
    
    private let persistentStore = PersistentStore()
    private let pickerViewToolbar = ToolbarPickerView()
    private let vehiclePickerViewValues = ["Test 1", "Test 2", "Test 3", "Test 4", "Test 5"]
    private let modelPickerViewValues = ["Model 1", "Model 2", "Model 3", "Model 4", "Model 5"]
  
    var screenMode: ScreenMode = .edit
    var photoList: [UIImage] = []
    var cars: [NSManagedObject] = []
    var vehicleCoordinates: CLLocationCoordinate2D?
    var activePickerViewTag = 0
    var locationManager = CLLocationManager()
    var vehicleLatitude: Double?
    var vehicleLongitude: Double?
    var selectedCar: NSManagedObject?
    
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupNumberVehicleTextField()
        setupPickerViews()
        setupMapView()
        
        if screenMode == .view {
            let numberVehicle = selectedCar?.value(forKey: "number") as? String
            navigationItem.title = numberVehicle
            numberVehicleTF.text = numberVehicle
            brandVehicleTF.text = selectedCar!.value(forKey: "brand") as? String
            modelVehicleTF.text = selectedCar!.value(forKey: "model") as? String
            vehicleCoordinates = CLLocationCoordinate2D(latitude: (selectedCar!.value(forKey: "latitude") as? Double)!,
                                                        longitude: (selectedCar!.value(forKey: "longitude") as? Double)!)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        view.endEditing(true)
    }
    
    // MARK: TableView
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? VehicleEntryTableViewCell
        else {
            return
        }

        tableViewCell.setCollectionViewDataSourceDelegate(
            dataSourceDelegate: self,
            forRow: indexPath.row
        )
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if screenMode == .view {
            if indexPath.section == 0 && indexPath.row == 0 {
                return 50.00
            }
            if indexPath.section == 0 && indexPath.row == 1 {
                return 0.01
            }
            if indexPath.section == 0 && indexPath.row == 2 {
                return 50.00
            }
            if indexPath.section == 0 && indexPath.row == 3 {
                return 50.00
            }
            if indexPath.section == 1 {
                return 200.00
            }
            if indexPath.section == 2 {
                return 200.00
            }
        }
        else if screenMode == .edit {
            if indexPath.section == 0 {
                return 50.00
            }
            if indexPath.section == 1 {
                return 200.00
            }
            if indexPath.section == 2 {
                return 200.00
            }
        }
        return 50.00
    }
    
    
    // MARK: Setup
    @objc func doneButtonTapped() {
        view.endEditing(true)
    }
    
    
}

// MARK: - Public interface
extension VehicleEntryViewController {
    
}

// MARK: - Private interface
extension VehicleEntryViewController {
    private func setupUI() {
        switch screenMode {
        case .edit: (
        
        )
        case .view: ()
            navigationItem.setRightBarButton(nil, animated: true)
            let font = UIFont(name: "Apple SD Gothic Neo SemiBold", size: 22.0)
            numberVehicleTF.borderStyle = .none
            numberVehicleTF.placeholder = nil
            numberVehicleTF.font = font
            numberVehicleTF.textAlignment = .right
            
            brandVehicleTF.borderStyle = .none
            brandVehicleTF.placeholder = nil
            brandVehicleTF.font = font
            brandVehicleTF.textAlignment = .right
            
            modelVehicleTF.borderStyle = .none
            modelVehicleTF.placeholder = nil
            modelVehicleTF.font = font
            modelVehicleTF.textAlignment = .right
        }
    }
    
    private func setupPickerViews() {
        
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
    
    private func setupMapView() {
        if screenMode == .edit {
            self.locationManager.requestWhenInUseAuthorization()
            
            if CLLocationManager.locationServicesEnabled() {
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.startUpdatingLocation()
                guard let currentLocation = locationManager.location
                else {
                    return
                }
                vehicleLongitude = Double(currentLocation.coordinate.longitude)
                vehicleLatitude = Double(currentLocation.coordinate.latitude)
            } else {
                print ("Enable location services for app")
            }
            
            mapView.delegate = self
            mapView.mapType = .standard
            mapView.isZoomEnabled = true
            mapView.isScrollEnabled = true
        }
        if screenMode == .view {
            self.locationManager.requestWhenInUseAuthorization()
            
            if CLLocationManager.locationServicesEnabled() {
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.startUpdatingLocation()
                guard let currentLocation = locationManager.location
                else {
                    return
                }
                vehicleLongitude = Double(currentLocation.coordinate.longitude)
                vehicleLatitude = Double(currentLocation.coordinate.latitude)
            } else {
                print ("Enable location services for app")
            }
            
            mapView.delegate = self
            mapView.mapType = .standard
            mapView.isZoomEnabled = true
            mapView.isScrollEnabled = true
        }
    }
    
    private func setupNumberVehicleTextField() {
        let toolbar = UIToolbar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        toolbar.setItems([flexSpace, doneButton], animated: true)
        toolbar.sizeToFit()
        
        numberVehicleTF.inputAccessoryView = toolbar
    }
    
    private func setupSwitchState(sender: UISwitch) {
        if (sender.isOn) == false {
            numberVehicleTF.isEnabled = true
            numberVehicleTF.placeholder = "1234 AA 7"
            numberVehicleTF.text = .none
        } else {
            numberVehicleTF.isEnabled = false
            numberVehicleTF.text = "Номер не указан"
            numberVehicleTF.placeholder = "Номер отсутствует"
        }
    }
    
    private func clearFields() {
        numberVehicleTF.text?.removeAll()
        brandVehicleTF.text?.removeAll()
        modelVehicleTF.text?.removeAll()
        
        numberVehicleSwitch.isOn = false
        
        setupSwitchState(sender: numberVehicleSwitch)
        
        photoList.removeAll()
        tableView.reloadData()
    }
    
    private func successAddAlert() {
        displayAlert(
            title: "Заявка зафиксировна",
            message: "")
    }
}

// MARK: - UIPickerViewDelegate
extension VehicleEntryViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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

// MARK: - ToolbarPickerViewDelegate
extension VehicleEntryViewController: ToolbarPickerViewDelegate {
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

// MARK: - MKMapViewDelegate
extension VehicleEntryViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if screenMode == .edit {
            let locationValue: CLLocationCoordinate2D = manager.location!.coordinate
            mapView.mapType = MKMapType.standard
            mapView.isZoomEnabled = true
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let region = MKCoordinateRegion(center: locationValue, span: span)
            mapView.setRegion(region, animated: true)
            mapView.showsUserLocation = true
        } else if screenMode == .view {
            mapView.mapType = MKMapType.standard
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let region = MKCoordinateRegion(center: vehicleCoordinates!, span: span)
            mapView.setRegion(region, animated: true)
            addVehicleLocationAnnotation()
        }
        
    }
    
    func addVehicleLocationAnnotation() {
        guard let coordinate = vehicleCoordinates else {
            return
        }
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.subtitle = numberVehicleTF.text
        mapView.addAnnotation(annotation)
    }
}

// MARK: - UICollectionViewDataSource
extension VehicleEntryViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if screenMode == .view {
            return photoList.count
        }
        if screenMode == .edit {
            return photoList.count + 1
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "PhotoCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! VehicleEntryCollectionViewCell
        
        if screenMode == .view {
            let photo = photoList[indexPath.item]
            cell.imageView.image = photo
            cell.imageView.contentMode = .scaleToFill
            
            return cell
        } else {
            if indexPath.item == 0 {
                cell.backgroundColor = UIColor.gray
                cell.imageView.image = UIImage(systemName: "plus.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 50))
                cell.imageView.tintColor = UIColor.white
                cell.imageView.contentMode = .center
                
                return cell
            }
            let photo = photoList[indexPath.item - 1]
            cell.imageView.image = photo
            cell.imageView.contentMode = .scaleToFill
            cell.layer.borderWidth = 0.5
            cell.layer.borderColor = UIColor.lightGray.cgColor
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if screenMode == .edit {
            let cell = collectionView.cellForItem(at: indexPath) as! VehicleEntryCollectionViewCell
            cell.isSelected = true
            tappedCamera()
            
            print("pressed")
        }
    }
}

// MARK: - UIImagePickerControllerDelegate
extension VehicleEntryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
        tableView.reloadData()
        
        print(photoList.count)
    }
}
