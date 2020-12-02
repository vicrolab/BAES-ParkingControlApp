//
//  PickerView.swift
//  ParkingControl
//
//  Created by Mikalaj Shuhno on 2.12.20.
//

import Foundation
import UIKit


protocol ToolbarPickerViewDelegate: class {
    func didTapDone()
    func didTapCancel()
}

class ToolbarPickerView: UIPickerView {
    let pickerFirst = UIPickerView()
    let pickerTwo = UIPickerView()
//    func createPicker1() {
//        let pickerViewFirst = UIPickerView()
//        pickerViewFirst.tag = 1
//    }
//    
//    func createPicker2() {
//        let pickerViewSecond = UIPickerView()
//        pickerViewSecond.tag = 2
//    }
    
    
    
    public private(set) var toolbar: UIToolbar?
    public weak var toolbarDelegate: ToolbarPickerViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        let toolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.isTranslucent = true
        toolbar.tintColor = .black
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneTapped))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelTapped))
        
        toolbar.setItems([cancelButton, flexibleSpace, doneButton], animated: false)
        self.toolbar = toolbar
    }
    
    
    @objc func doneTapped() {
        self.toolbarDelegate?.didTapDone()
    }
    
    @objc func cancelTapped() {
        self.toolbarDelegate?.didTapCancel()
    }
    
}
