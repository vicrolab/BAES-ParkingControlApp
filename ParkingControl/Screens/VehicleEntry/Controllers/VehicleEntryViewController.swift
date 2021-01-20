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

protocol VehicleEntryViewControllerDelegate {
    func tappedCamera()
    func displayAlert(title: String, message: String)
}

class VehicleEntryViewController: UITableViewController, UITextFieldDelegate {
    // MARK: Outlets
    @IBOutlet var numberVehicleTextField: UITextField!
    @IBOutlet weak var vehicleNumberIsAvailible: UISwitch!
    @IBOutlet weak var brandVehicleTextField: UITextField!
    @IBOutlet weak var modelVehicleTextField: UITextField!
    @IBOutlet var createRequestOutlet: UIBarButtonItem!
    
    // MARK: Actions
    @IBAction func createRequestAction(_ sender: UIBarButtonItem) {
        let title: String = "Не заполнены поля"
        var message: String = "Заявка не зафиксирована.\nВведите значения для:"
        
        var validationErrorCount = 0
        [("\nномер ТС", numberVehicleTextField.text),
         ("\nмарка ТС", brandVehicleTextField.text),
         ("\nмодель ТС", modelVehicleTextField.text)].forEach { (String, textFieldString) in
            if textFieldString?.isEmpty == true {
                message += String
                validationErrorCount += 1
            }
        }
        
        guard validationErrorCount == 0 else {
            displayAlert(title: title, message: message)
            return
        }
        
        guard
            let number = numberVehicleTextField.text,
            let brand = brandVehicleTextField.text,
            let model = modelVehicleTextField.text,
            let locationData = createVehicleLocationEntry(),
            let vehiclePhotoList = vehiclePhotoList
        else {
            return
        }
        
        persistentStore.createVehicleEntry(
            brandVehicle: brand,
            dateCreated: Date(),
            modelVehicle: model,
            numberVehicle: number,
            photoList: vehiclePhotoList,
            longitude: locationData.longtitude,
            latitude: locationData.latitude
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
    
    var screenMode: ScreenMode = .edit
    var vehiclePhotoList: [UIImage?]? = []
    var vehicle: VehicleEntry?
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupNumberVehicleTextField()
        setupPickerViews()
        loadVehicleEntry()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
    }
    
    // MARK: TableView
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let photoTableViewCell = cell as? VehicleEntryPhotoViewTableViewCell {
            photoTableViewCell.vehiclePhotoList = vehiclePhotoList
            photoTableViewCell.screenMode = screenMode
            photoTableViewCell.delegate = self            
        }
        
        if let mapViewCell = cell as? VehicleEntryMapViewTableViewCell {
            mapViewCell.delegate = self
            mapViewCell.screenMode = screenMode
            mapViewCell.vehicle = vehicle
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        setupHeightForRow(at: indexPath)
    }
    
    // MARK: Setup
    @objc func doneButtonTapped() {
        view.endEditing(true)
    }
}

// MARK: - Private interface
extension VehicleEntryViewController {
    private func setupUI() {
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView()
        
        switch screenMode {
        case .view:
            navigationItem.setRightBarButton(nil, animated: true)
            
            let font = UIFont(name: "Apple SD Gothic Neo SemiBold", size: 22.0)
            
            [numberVehicleTextField, brandVehicleTextField, modelVehicleTextField].forEach { (textField) in
                guard let textField = textField else {
                    return
                }
                
                textField.borderStyle = .none
                textField.placeholder = nil
                textField.font = font
                textField.textAlignment = .right
                textField.isUserInteractionEnabled = false
            }
        default:
            break
        }
    }
    
    private func setupPickerViews() {
        switch screenMode {
        case .edit:
            [brandVehicleTextField, modelVehicleTextField].forEach { (textField) in
                textField?.inputView = pickerViewToolbar.pickerView
                textField?.inputAccessoryView = pickerViewToolbar.toolbar
                textField?.delegate = self
            }

            pickerViewToolbar.pickerView.dataSource = self
            pickerViewToolbar.pickerView.delegate = self
            pickerViewToolbar.toolbarDelegate = self
            
            pickerViewToolbar.pickerView.reloadAllComponents()
        default:
            break
        }
    }
    
    private func setupNumberVehicleTextField() {
        switch screenMode {
        case .edit:
            let toolbar = UIToolbar()
            let flexSpace = UIBarButtonItem(
                barButtonSystemItem: .flexibleSpace,
                target: nil,
                action: nil
            )
            
            let doneButton = UIBarButtonItem(
                title: "Done",
                style: .done,
                target: self,
                action: #selector(doneButtonTapped)
            )
            
            toolbar.setItems([flexSpace, doneButton], animated: true)
            toolbar.sizeToFit()
            
            numberVehicleTextField.inputAccessoryView = toolbar
        default:
            break
        }
    }
    
    private func setupNumberVehicleSwitch(sender: UISwitch) {
        if sender.isOn {
            numberVehicleTextField.isEnabled = false
            numberVehicleTextField.text = "Номер не указан"
            numberVehicleTextField.placeholder = "Номер отсутствует"
        } else {
            numberVehicleTextField.isEnabled = true
            numberVehicleTextField.placeholder = "1234 AA 7"
            numberVehicleTextField.text = .none
        }
    }
    
    private func clearInputFields() {
        numberVehicleTextField.text?.removeAll()
        brandVehicleTextField.text?.removeAll()
        modelVehicleTextField.text?.removeAll()
        
        vehicleNumberIsAvailible.isOn = false
        
        setupNumberVehicleSwitch(sender: vehicleNumberIsAvailible)
        
        vehiclePhotoList?.removeAll()
        tableView.reloadData()
    }
    
    private func successCreateRequestAlert() {
        displayAlert(
            title: "Заявка зафиксировна",
            message: ""
        )
    }
    
    private func setupHeightForRow(at indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return indexPath.row == 1 && screenMode == .view ? 0.01 : 50.0
        case 1, 2:
            return 200.00
        default:
            return 50.00
        }
    }
    
    private func loadVehicleEntry() {
        if screenMode == .view {
            let numberVehicle = vehicle?.number
            navigationItem.title = numberVehicle
            numberVehicleTextField.text = numberVehicle
            brandVehicleTextField.text = vehicle?.brand
            modelVehicleTextField.text = vehicle?.model
        }
    }
}

// MARK: - UIPickerViewDelegate
extension VehicleEntryViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if brandVehicleTextField.isFirstResponder {
            return CarInfoStore.all.count
        } else {
            var modelVehicleValues: [String]?
            CarInfoStore.all.forEach { (brand, model) in
                if brandVehicleTextField.text == brand {
                    modelVehicleValues = model
                }
            }
            guard let values = modelVehicleValues else {
                return 0
            }
            
            return values.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if brandVehicleTextField.isFirstResponder {
            return CarInfoStore.all[row].brand
        } else {
            var vehicleModels: [String]?
            CarInfoStore.all.forEach { (brand, models) in
                if brandVehicleTextField.text == brand {
                    vehicleModels = models
                }
            }
            guard let models = vehicleModels else {
                return nil
            }
            
            return models[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if brandVehicleTextField.isFirstResponder {
            brandVehicleTextField.text = CarInfoStore.all[row].brand
        } else {
            CarInfoStore.all.forEach { (brand, models) in
                if brandVehicleTextField.text == brand {
                    modelVehicleTextField.text = models[row]
                }
            }
        }
    }
}

// MARK: - ToolbarPickerViewDelegate
extension VehicleEntryViewController: ToolbarPickerViewDelegate {
    func didTapDone() {
        
        let row = self.pickerViewToolbar.pickerView.selectedRow(inComponent: 0)
        self.pickerViewToolbar.pickerView.selectRow(row, inComponent: 0, animated: false)
        pickerViewToolbar.pickerView.selectRow(0, inComponent: 0, animated: true)
        
        if brandVehicleTextField.isFirstResponder {
            self.brandVehicleTextField.text = CarInfoStore.all[row].brand
            self.brandVehicleTextField.resignFirstResponder()
        } else {
            CarInfoStore.all.forEach { (brand, models) in
                if brandVehicleTextField.text == brand {
                    modelVehicleTextField.text = models[row]
                }
            }
            self.modelVehicleTextField.resignFirstResponder()
        }
    }
    
    func didTapCancel() {
        if brandVehicleTextField.isFirstResponder {
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
    private func createVehicleLocationEntry() -> (longtitude: Double, latitude: Double)? {
        let manager = CLLocationManager()
        manager.requestWhenInUseAuthorization()
        
        guard CLLocationManager.locationServicesEnabled() else {
            displayAlert(
                title: "Trouble with location services",
                message: "Please check you location settings."
            )
            
            return nil
        }
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
        
        guard let currentLocation = manager.location else {
            return nil
        }
        
        let longitude = Double(currentLocation.coordinate.longitude)
        let latitude = Double(currentLocation.coordinate.latitude)
        
        print("Fetched: latitude \(latitude), longitude \(longitude)")
        
        return (longtitude: longitude, latitude: latitude)
    }
}
// MARK: - UIImagePickerControllerDelegate
extension VehicleEntryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, VehicleEntryViewControllerDelegate {
    func tappedCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        vehiclePhotoList?.append(image)
        picker.dismiss(animated: true, completion: nil)
        
        let myCell = VehicleEntryPhotoViewTableViewCell()
        myCell.vehiclePhotoList = vehiclePhotoList
        
        tableView.reloadData()
    }
}

