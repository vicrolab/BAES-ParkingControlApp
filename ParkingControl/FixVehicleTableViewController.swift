//
//  FixVehicleTableViewController.swift
//  ParkingControl
//
//  Created by Mikalaj Shuhno on 30.11.20.
//

import UIKit
import MapKit
import CoreData

class FixVehicleTableViewController: UITableViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var numberVehicleTF: UITextField!
    @IBOutlet weak var numberVehicleSwitch: UISwitch!
    @IBOutlet weak var brandVehicleTF: UITextField!
    @IBOutlet weak var modelVehicleTF: UITextField!
    @IBOutlet weak var placeOfInspection: MKMapView!
    
    var vehiclePickerView: UIPickerView!
    
    fileprivate let pickerViewToolbar = ToolbarPickerView()
    fileprivate let vehiclePickerViewValues = ["Test 1", "Test 2", "Test 3", "Test 4", "Test 5"]
    
    
    @IBAction func fixVehicleAction(_ sender: Any) {
    }
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func NVChangeState(_ sender: Any) {
        changeSwitchState(sender: numberVehicleSwitch)
    }
    
    private func changeSwitchState(sender: UISwitch) {
        if (sender.isOn) == false {
            numberVehicleTF.isEnabled = true
        } else {
            numberVehicleTF.isEnabled = false
            numberVehicleTF.placeholder = "Номер отсутствует"
        }
    }
    
    private func setupTextFields() {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextFields()
        
        vehiclePickerView = UIPickerView()
        
        
        
        brandVehicleTF.inputView = vehiclePickerView
        brandVehicleTF.inputAccessoryView = self.pickerViewToolbar.toolbar
        
        self.vehiclePickerView.dataSource = self
        self.vehiclePickerView.delegate = self
        self.pickerViewToolbar.toolbarDelegate = self
        
        self.pickerViewToolbar.reloadAllComponents()
        
        brandVehicleTF.text = vehiclePickerViewValues [0]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // clear first responder after tap reognizer and dismiss keyboard
        view.endEditing(true)
    }
    
   
    
    
}

extension FixVehicleTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.vehiclePickerViewValues.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.vehiclePickerViewValues[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        brandVehicleTF.text = self.vehiclePickerViewValues[row]
//        self.view.endEditing(true)
    }
}

extension FixVehicleTableViewController: ToolbarPickerViewDelegate {

    func didTapDone() {
        let row = self.pickerViewToolbar.selectedRow(inComponent: 0)
        self.pickerViewToolbar.selectRow(row, inComponent: 0, animated: false)
        self.brandVehicleTF.text = self.vehiclePickerViewValues[row]
        self.brandVehicleTF.resignFirstResponder()
    }
    
    func didTapCancel() {
        self.brandVehicleTF.text = nil
        self.brandVehicleTF.resignFirstResponder()
    }
}
