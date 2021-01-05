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
    @IBOutlet var numberVehicleTextField: UITextField!
    @IBOutlet weak var vehicleNumberIsAvailible: UISwitch!
    @IBOutlet weak var brandVehicleTextField: UITextField!
    @IBOutlet weak var modelVehicleTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var createRequestOutlet: UIBarButtonItem!
    
    // MARK: Actions
    @IBAction func createRequestAction(_ sender: UIBarButtonItem) {
        guard
            let numberVehicle = numberVehicleTextField.text,
            !numberVehicle.isEmpty
        else {
            displayAlert(
                title: "Отсутствует гос номер ТС",
                message: "Введите гос номер или установите без номера")
            return
        }

        guard
            let brandVehicle = brandVehicleTextField.text,
            !brandVehicle.isEmpty
        else {
            displayAlert(
                title: "Отсутствует марка ТС",
                message: "Выберите марку из списка")
            return
        }

        guard
            let modelVehicle = modelVehicleTextField.text,
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
            photoList: vehiclePhotoList,
            longitude: vehicleCoordinateLongitude!,
            latitude: vehicleCoordinateLatitude!
        )
        
        successCreateRequestAlert()
        clearInputFields()
    }
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func numberVehicleSwitchAction(_ sender: Any) {
        setupNumberVehicleSwitch(sender: vehicleNumberIsAvailible)
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
    var vehiclePhotoList: [UIImage] = []
    var vehicleCoordinates: CLLocationCoordinate2D?
    var activePickerViewTag = 0
    var locationManager = CLLocationManager()
    var vehicleCoordinateLatitude: Double?
    var vehicleCoordinateLongitude: Double?
    var selectedVehicle: NSManagedObject?
    
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupNumberVehicleTextField()
        setupPickerViews()
        setupMapView()
        
        if screenMode == .view {
            let numberVehicle = selectedVehicle?.value(forKey: "number") as? String
            navigationItem.title = numberVehicle
            numberVehicleTextField.text = numberVehicle
            brandVehicleTextField.text = selectedVehicle!.value(forKey: "brand") as? String
            modelVehicleTextField.text = selectedVehicle!.value(forKey: "model") as? String
            vehicleCoordinates = CLLocationCoordinate2D(latitude: (selectedVehicle!.value(forKey: "latitude") as? Double)!,
                                                        longitude: (selectedVehicle!.value(forKey: "longitude") as? Double)!)
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
            numberVehicleTextField.borderStyle = .none
            numberVehicleTextField.placeholder = nil
            numberVehicleTextField.font = font
            numberVehicleTextField.textAlignment = .right
            
            brandVehicleTextField.borderStyle = .none
            brandVehicleTextField.placeholder = nil
            brandVehicleTextField.font = font
            brandVehicleTextField.textAlignment = .right
            
            modelVehicleTextField.borderStyle = .none
            modelVehicleTextField.placeholder = nil
            modelVehicleTextField.font = font
            modelVehicleTextField.textAlignment = .right
        }
    }
    
    private func setupPickerViews() {
        
        pickerViewToolbar.pickerFirst.tag = 1
        pickerViewToolbar.pickerTwo.tag = 2
        brandVehicleTextField.inputView = self.pickerViewToolbar.pickerFirst
        brandVehicleTextField.inputAccessoryView = self.pickerViewToolbar.toolbar

        modelVehicleTextField.inputView = self.pickerViewToolbar.pickerTwo
        modelVehicleTextField.inputAccessoryView = self.pickerViewToolbar.toolbar

        self.pickerViewToolbar.pickerFirst.dataSource = self
        self.pickerViewToolbar.pickerTwo.dataSource = self
        self.pickerViewToolbar.pickerFirst.delegate = self
        self.pickerViewToolbar.pickerTwo.delegate = self
        self.pickerViewToolbar.toolbarDelegate = self

        self.pickerViewToolbar.pickerFirst.reloadAllComponents()
        self.pickerViewToolbar.pickerTwo.reloadAllComponents()
        self.brandVehicleTextField.delegate = self
        self.modelVehicleTextField.delegate = self
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
                vehicleCoordinateLongitude = Double(currentLocation.coordinate.longitude)
                vehicleCoordinateLatitude = Double(currentLocation.coordinate.latitude)
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
                vehicleCoordinateLongitude = Double(currentLocation.coordinate.longitude)
                vehicleCoordinateLatitude = Double(currentLocation.coordinate.latitude)
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
        
        numberVehicleTextField.inputAccessoryView = toolbar
    }
    
    private func setupNumberVehicleSwitch(sender: UISwitch) {
        if (sender.isOn) == false {
            numberVehicleTextField.isEnabled = true
            numberVehicleTextField.placeholder = "1234 AA 7"
            numberVehicleTextField.text = .none
        } else {
            numberVehicleTextField.isEnabled = false
            numberVehicleTextField.text = "Номер не указан"
            numberVehicleTextField.placeholder = "Номер отсутствует"
        }
    }
    
    private func clearInputFields() {
        numberVehicleTextField.text?.removeAll()
        brandVehicleTextField.text?.removeAll()
        modelVehicleTextField.text?.removeAll()
        
        vehicleNumberIsAvailible.isOn = false
        
        setupNumberVehicleSwitch(sender: vehicleNumberIsAvailible)
        
        vehiclePhotoList.removeAll()
        tableView.reloadData()
    }
    
    private func successCreateRequestAlert() {
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
            self.brandVehicleTextField.text = self.vehiclePickerViewValues[row]
        } else {
            self.modelVehicleTextField.text = self.modelPickerViewValues[row]
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
            self.brandVehicleTextField.text = self.vehiclePickerViewValues[row]
            self.brandVehicleTextField.resignFirstResponder()
        } else {
            let row = self.pickerViewToolbar.pickerTwo.selectedRow(inComponent: 0)
            self.pickerViewToolbar.pickerTwo.selectRow(row, inComponent: 0, animated: false)
            self.modelVehicleTextField.text = self.modelPickerViewValues[row]
            self.modelVehicleTextField.resignFirstResponder()
        }
    }
    
    func didTapCancel() {
        if activePickerViewTag == 1 {
            self.brandVehicleTextField.text = nil
            self.brandVehicleTextField.resignFirstResponder()
        } else {
            self.modelVehicleTextField.text = nil
            self.modelVehicleTextField.resignFirstResponder()
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
            createVehicleLocationAnnotation()
        }
        
    }
    
    func createVehicleLocationAnnotation() {
        guard let coordinate = vehicleCoordinates else {
            return
        }
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.subtitle = numberVehicleTextField.text
        mapView.addAnnotation(annotation)
    }
}

// MARK: - UICollectionViewDataSource
extension VehicleEntryViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if screenMode == .view {
            return vehiclePhotoList.count
        }
        if screenMode == .edit {
            return vehiclePhotoList.count + 1
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "PhotoCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! VehicleEntryCollectionViewCell
        
        if screenMode == .view {
            let photo = vehiclePhotoList[indexPath.item]
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
            let photo = vehiclePhotoList[indexPath.item - 1]
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
        
        vehiclePhotoList.append(image)
        picker.dismiss(animated: true, completion: nil)
        tableView.reloadData()
        
        print(vehiclePhotoList.count)
    }
}
