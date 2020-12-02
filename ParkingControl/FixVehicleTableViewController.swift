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
