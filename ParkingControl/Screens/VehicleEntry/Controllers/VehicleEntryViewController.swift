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

class VehicleEntryViewController: UITableViewController, UITextFieldDelegate, VehicleEntryViewControllerDelegate {
    // MARK: Outlets
    @IBOutlet var numberVehicleTextField: UITextField!
    @IBOutlet weak var vehicleNumberIsAvailible: UISwitch!
    @IBOutlet weak var brandVehicleTextField: UITextField!
    @IBOutlet weak var modelVehicleTextField: UITextField!
    @IBOutlet var createRequestOutlet: UIBarButtonItem!
    
    
    // MARK: Actions
    @IBAction func createRequestAction(_ sender: UIBarButtonItem) {
        guard
            let numberVehicle = numberVehicleTextField.text,
            !numberVehicle.isEmpty
        else {
            displayAlert(
                title: "Отсутствует гос номер ТС",
                message: "Введите гос номер или установите без номера"
            )
            return
        }
        
        guard
            let brandVehicle = brandVehicleTextField.text,
            !brandVehicle.isEmpty
        else {
            displayAlert(
                title: "Отсутствует марка ТС",
                message: "Выберите марку из списка"
            )
            return
        }
        
        guard
            let modelVehicle = modelVehicleTextField.text,
            !modelVehicle.isEmpty
        else {
            displayAlert(
                title: "Отсутствует модель ТС",
                message: "Выберите модель из списка"
            )
            return
        }
        createVehicleLocationEntry()
        guard let vehicleCoordinateLongitude = vehicleCoordinateLongitude,
              let vehicleCoordinateLatitude = vehicleCoordinateLatitude
        else {
            print("Doesn't create location vehicle entry")
            displayAlert(
                title: "Trouble with location services",
                message: "Check you location settings"
            )
            return
        }
        guard let vehiclePhotoList = vehiclePhotoList else {
            return
        }
        persistentStore.createVehicleEntry(
            brandVehicle: brandVehicle,
            dateCreated: Date(),
            modelVehicle: modelVehicle,
            numberVehicle: numberVehicle,
            photoList: vehiclePhotoList,
            longitude: vehicleCoordinateLongitude,
            latitude: vehicleCoordinateLatitude
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
    
    //     MARK: Properties
    enum ScreenMode {
        case view, edit
    }
    
    private let persistentStore = PersistentStore()
    private let pickerViewToolbar = ToolbarPickerView()
    
    var screenMode: ScreenMode = .edit
    var vehiclePhotoList: [UIImage?]? = []
    var vehicleCoordinates: CLLocationCoordinate2D?
    var vehicleCoordinateLatitude: Double?
    var vehicleCoordinateLongitude: Double?
    var selectedVehicle: NSManagedObject?
    var brandPickerViewValues: [String]?
    var modelPickerViewValues: [String]?
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupNumberVehicleTextField()
        setupPickerViews()
        setupInputPickerViews()
        
        if screenMode == .view {
            let numberVehicle = selectedVehicle?.value(forKey: "number") as? String
            navigationItem.title = numberVehicle
            numberVehicleTextField.text = numberVehicle
            brandVehicleTextField.text = selectedVehicle!.value(forKey: "brand") as? String
            modelVehicleTextField.text = selectedVehicle!.value(forKey: "model") as? String
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
    }
    
    //     MARK: TableView
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let photoTableViewCell = cell as? VehicleEntryPhotoViewTableViewCell {
            photoTableViewCell.vehiclePhotoList = vehiclePhotoList
            photoTableViewCell.screenMode = screenMode
            photoTableViewCell.selectedVehicle = selectedVehicle
            photoTableViewCell.delegate = self            
        }
        
        if let mapViewCell = cell as? VehicleEntryMapViewTableViewCell {
            mapViewCell.delegate = self
            mapViewCell.screenMode = screenMode
            mapViewCell.selectedVehicle = selectedVehicle
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

// MARK: - Public interface
// MARK: - Private interface
extension VehicleEntryViewController {
    private func setupUI() {
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView()
        switch screenMode {
        case .edit: ()
        case .view: ()
            navigationItem.setRightBarButton(nil, animated: true)
            let font = UIFont(name: "Apple SD Gothic Neo SemiBold", size: 22.0)
            let textFields = [numberVehicleTextField,
                              brandVehicleTextField,
                              modelVehicleTextField]
            for textField in textFields {
                textField?.borderStyle = .none
                textField?.placeholder = nil
                textField?.font = font
                textField?.textAlignment = .right
                textField?.isUserInteractionEnabled = false
            }
        }
    }
    
    private func setupPickerViews() {
        switch screenMode {
        case .edit:
            let textFields = [brandVehicleTextField, modelVehicleTextField]
            for textField in textFields {
                textField?.inputView = pickerViewToolbar.pickerView
                textField?.inputAccessoryView = pickerViewToolbar.toolbar
                textField?.delegate = self
            }
            
            pickerViewToolbar.pickerView.dataSource = self
            pickerViewToolbar.pickerView.delegate = self
            pickerViewToolbar.toolbarDelegate = self
            
            pickerViewToolbar.pickerView.reloadAllComponents()
        case .view: (
        )
        }
    }

    private func setupNumberVehicleTextField() {
        switch screenMode {
        case .edit:
            let toolbar = UIToolbar()
            let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil,
                                            action: nil)
            let doneButton = UIBarButtonItem(title: "Done",
                                             style: .done,
                                             target: self,
                                             action: #selector(doneButtonTapped))
            toolbar.setItems([flexSpace, doneButton], animated: true)
            toolbar.sizeToFit()
            
            numberVehicleTextField.inputAccessoryView = toolbar
        case .view: (
        )
        }
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
        
        vehiclePhotoList?.removeAll()
        tableView.reloadData()
    }
    
    private func successCreateRequestAlert() {
        displayAlert(
            title: "Заявка зафиксировна",
            message: ""
        )
    }
    
    private func setupInputPickerViews() {
        brandPickerViewValues = CarInfoStore.brand
        modelPickerViewValues = CarInfoStore.model
        
    }
    
    private func setupHeightForRow(at indexPath: IndexPath) -> CGFloat {
        if screenMode == .view {
            switch indexPath.section {
            case 0:
                switch indexPath.row {
                case 0:
                    return 50.00
                case 1:
                    return 0.01
                case 2:
                    return 50.00
                case 3:
                    return 50.00
                default:
                    return 50.00
                }
            case 1:
                return 200.00
            case 2:
                return 200.00
            default:
                return 50.00
            }
        }
        else if screenMode == .edit {
            switch indexPath.section {
            case 0:
                return 50.00
            case 1:
                return 200.00
            case 2:
                return 200.00
            default:
                return 50.00
            }
        }
        return 50.00
    }
}

// MARK: - UIPickerViewDelegate
extension VehicleEntryViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let modelPickerViewValues = modelPickerViewValues, let brandPickerViewValues = brandPickerViewValues
        else {
            return 0
        }
        if brandVehicleTextField.isFirstResponder == true {
            return brandPickerViewValues.count
        } else {
            return modelPickerViewValues.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let modelPickerViewValues = modelPickerViewValues, let brandPickerViewValues = brandPickerViewValues
        else {
            return "Erorr \(Error.self)"
        }
        if brandVehicleTextField.isFirstResponder == true {
            return brandPickerViewValues[row]
        } else {
            return modelPickerViewValues[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let modelPickerViewValues = modelPickerViewValues, let brandPickerViewValues = brandPickerViewValues
        else {
            return
        }
        if brandVehicleTextField.isFirstResponder == true {
            brandVehicleTextField.text = brandPickerViewValues[row]
        } else {
            modelVehicleTextField.text = modelPickerViewValues[row]
        }
    }
}

// MARK: - ToolbarPickerViewDelegate
extension VehicleEntryViewController: ToolbarPickerViewDelegate {
    
    func didTapDone() {
        guard let modelPickerViewValues = modelPickerViewValues, let brandPickerViewValues = brandPickerViewValues
        else {
            return
        }
        if brandVehicleTextField.isFirstResponder == true {
            let row = self.pickerViewToolbar.pickerView.selectedRow(inComponent: 0)
            self.pickerViewToolbar.pickerView.selectRow(row, inComponent: 0, animated: false)
            self.brandVehicleTextField.text = brandPickerViewValues[row]
            self.brandVehicleTextField.resignFirstResponder()
            pickerViewToolbar.pickerView.selectRow(0, inComponent: 0, animated: true)
        } else {
            let row = self.pickerViewToolbar.pickerView.selectedRow(inComponent: 0)
            self.pickerViewToolbar.pickerView.selectRow(row, inComponent: 0, animated: false)
            self.modelVehicleTextField.text = modelPickerViewValues[row]
            self.modelVehicleTextField.resignFirstResponder()
            pickerViewToolbar.pickerView.selectRow(0, inComponent: 0, animated: true)
        }
    }
    
    func didTapCancel() {
        if brandVehicleTextField.isFirstResponder == true {
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
    func createVehicleLocationEntry() {
        if screenMode == .edit {
            let manager = CLLocationManager()
            manager.requestWhenInUseAuthorization()
            if CLLocationManager.locationServicesEnabled() {
                manager.delegate = self
                manager.desiredAccuracy = kCLLocationAccuracyBest
                manager.startUpdatingLocation()
                guard let currentLocation = manager.location
                else {
                    return
                }
                vehicleCoordinateLongitude = Double(currentLocation.coordinate.longitude)
                vehicleCoordinateLatitude = Double(currentLocation.coordinate.latitude)
                print("Successfully created vehicle location entry at latitude \(String(describing: vehicleCoordinateLatitude)), longitude \(String(describing: vehicleCoordinateLongitude))")
            }
        }
    }
}
// MARK: - UIImagePickerControllerDelegate
extension VehicleEntryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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

protocol VehicleEntryViewControllerDelegate {
    func tappedCamera()
}
