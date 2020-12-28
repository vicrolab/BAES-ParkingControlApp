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

//let storyboard = UIStoryboard(name: "Main", bundle: nil)
//let controller = storyboard.instantiateViewController(withIdentifier: "FixVehicleTableViewController") as! FixVehicleTableViewController
//
//present(controller, animated: true, completion: nil)

// TODO: VehicleEntryViewController
class FixVehicleTableViewController: UITableViewController, UITextFieldDelegate {
    // MARK: Outlets
    @IBOutlet weak var numberVehicleTF: UITextField!
    @IBOutlet weak var numberVehicleSwitch: UISwitch!
    @IBOutlet weak var brandVehicleTF: UITextField!
    @IBOutlet weak var modelVehicleTF: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: Actions
    @IBAction func fixVehicleAction(_ sender: UIBarButtonItem) {
        guard
            let numberVehicle = numberVehicleTF.text,
            !numberVehicle.isEmpty
        else {
            let okAction = UIAlertAction(title: "ОК", style: .default)
            let alert = UIAlertController(title: "Отсутствует гос номер ТС", message: "Введите гос номер или установите без номера", preferredStyle: .alert)
            alert.addAction(okAction)
            
            self.present(alert, animated: true)
            
            return
        }

        guard
            let brandVehicle = brandVehicleTF.text,
            !brandVehicle.isEmpty
        else {
            let okAction = UIAlertAction(title: "ОК", style: .default)
            let alert = UIAlertController(title: "Отсутствует марка ТС", message: "Выберите марку из списка", preferredStyle: .alert)
            alert.addAction(okAction)
            
            self.present(alert, animated: true)
            
            return
        }

        // TODO: Отформатировать
        guard let modelVehicle = modelVehicleTF.text, !modelVehicle.isEmpty else {
            let alert = UIAlertController(title: "Отсутствует модель ТС", message: "Выберите модель из списка", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "ОК", style: .default)
            alert.addAction(OKAction)
            self.present(alert, animated: true)
            return
        }
        
        let dateTaken = Date()
        addNewVehicleInCoreData(brandVehicle: brandVehicle, dateTaken: dateTaken, modelVehicle: modelVehicle, numberVehicle: numberVehicle, photoVehicle: coreDataPhotos)
        successAddAlert()
        clearFields()
    }
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func NVChangeState(_ sender: Any) {
        changeSwitchState(sender: numberVehicleSwitch)
    }
    
    // MARK: Properties
    enum ScreenMode {
        case view, edit
    }
    
    private let pickerViewToolbar = ToolbarPickerView()
    private let vehiclePickerViewValues = ["Test 1", "Test 2", "Test 3", "Test 4", "Test 5"]
    private let modelPickerViewValues = ["Model 1", "Model 2", "Model 3", "Model 4", "Model 5"]
  
    var screenMode: ScreenMode = .edit
    var photoList: [UIImage] = []
    var coreDataPhotos = Data()
    var cars: [NSManagedObject] = []
    var carsStore: CarsStore?
    var vehicleCoordinates: CLLocationCoordinate2D?
    var activePickerViewTag = 0
    var locationManager = CLLocationManager()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupNumberVehicleTextField()
        setupPickerViews()
        
        setupMapView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        view.endEditing(true)
    }
    
    // MARK: TableView
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? TableViewCell
        else {
            return
        }

        tableViewCell.setCollectionViewDataSourceDelegate(
            dataSourceDelegate: self,
            forRow: indexPath.row
        )
    }
    
    // MARK: Setup
    func successAddAlert() {
        let alert = UIAlertController(title: "Заявка зафиксировна", message: "", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "ОК", style: .default)
        alert.addAction(OKAction)
        self.present(alert, animated: true)
    }
    
    func clearFields() {
        numberVehicleTF.text?.removeAll()
        brandVehicleTF.text?.removeAll()
        modelVehicleTF.text?.removeAll()
        
        numberVehicleSwitch.isOn = false
        
        changeSwitchState(sender: numberVehicleSwitch)
        
        photoList.removeAll()
        tableView.reloadData()
    }

    func addNewVehicleInCoreData(brandVehicle: String, dateTaken: Date, modelVehicle: String, numberVehicle: String, photoVehicle: Data) {
        
        setupMapView()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let entityName = "Cars"
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: managedContext)!
        
        let car = NSManagedObject(entity: entity, insertInto: managedContext) as! Cars
        car.brandVehicle = brandVehicle
        car.dateTaken = dateTaken
        car.modelVehicle = modelVehicle
        car.numberVehicle = numberVehicle
        
        car.setValue(brandVehicle, forKey: "brandVehicle")
        car.setValue(dateTaken, forKey: "dateTaken")
        car.setValue(modelVehicle, forKey: "modelVehicle")
        car.setValue(numberVehicle, forKey: "numberVehicle")

        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        print(coreDataPhotos.count)
    }
    
    @objc func doneButtonTapped() {
        view.endEditing(true)
    }
    
    private func changeSwitchState(sender: UISwitch) {
        if (sender.isOn) == false {
            numberVehicleTF.isEnabled = true
            numberVehicleTF.placeholder = "1234 AA 7"
            numberVehicleTF.text = .none
            addAnnotation()
        } else {
            numberVehicleTF.isEnabled = false
            numberVehicleTF.text = "Номер не указан"
            numberVehicleTF.placeholder = "Номер отсутствует"
            addAnnotation()
        }
    }
}

// MARK: - Setup
extension FixVehicleTableViewController {
    private func setupUI() {
        switch screenMode {
        case .edit: ()
        case .view: ()
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
    }
    
    private func setupNumberVehicleTextField() {
        let toolbar = UIToolbar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        toolbar.setItems([flexSpace, doneButton], animated: true)
        toolbar.sizeToFit()
        
        numberVehicleTF.inputAccessoryView = toolbar
    }
}

// MARK: - Public interface
extension FixVehicleTableViewController {
    
}

// MARK: - Private interface
extension FixVehicleTableViewController {
    
}

// MARK: - UIPickerViewDelegate
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

// MARK: - ToolbarPickerViewDelegate
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

// MARK: - MKMapViewDelegate
extension FixVehicleTableViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue: CLLocationCoordinate2D = manager.location!.coordinate
        mapView.mapType = MKMapType.standard
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: locValue, span: span)
        mapView.setRegion(region, animated: true)
        addAnnotation()
    }
    
    func addAnnotation() {
        let manager = CLLocationManager()
        
        guard let coordinate = manager.location?.coordinate else {
            return
        }
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        //        annotation.title = numberVehicleTF.text
        annotation.subtitle = "current location"
        
        mapView.addAnnotation(annotation)
        
        vehicleCoordinates = coordinate
    }
}

// MARK: - UICollectionViewDataSource
extension FixVehicleTableViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoList.count + 1
    }
    
    // TODO: переделать с didSelectItemAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "PhotoCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! PhotoCell
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedCamera))
        
        if indexPath.item == 0 {
            cell.backgroundColor = UIColor.gray
            cell.imageView.image = UIImage(systemName: "plus.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 50))
            cell.imageView.tintColor = UIColor.white
            cell.imageView.contentMode = .center
            cell.addGestureRecognizer(tapGesture)
            
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

// MARK: - UIImagePickerControllerDelegate
extension FixVehicleTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
