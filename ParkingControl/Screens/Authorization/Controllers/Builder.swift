//
//  Builder.swift
//  ParkingControl
//
//  Created by Mikalaj Shuhno on 11.03.21.
//

import UIKit

//protocol StackViewPorotocol {
//    var commonStackView: UIStackView { get }
//    var loginStackView: UIStackView { get }
//    var passwordStackView: UIStackView { get }
//    var loginTextFeild: UITextField { get }
//    var loginLabel: UILabel { get }
//    var passwordTextFeild: UITextField { get }
//    var passwordLabel: UILabel { get }
//    var header: UILabel { get }
//    var button: UIButton { get }
//}
//
//class StackView: StackViewPorotocol {
//    var commonStackView: UIStackView
//    var loginStackView: UIStackView
//    var passwordStackView: UIStackView
//    var loginTextFeild: UITextField
//    var loginLabel: UILabel
//    var passwordTextFeild: UITextField
//    var passwordLabel: UILabel
//    var header: UILabel
//    var button: UIButton
//    
//    init (commonStackView: UIStackView,
//          loginStackView: UIStackView,
//          passwordStackView: UIStackView,
//          loginTextFeild: UITextField,
//          loginLabel: UILabel,
//          passwordTextFeild: UITextField,
//          passwordLabel: UILabel,
//          header: UILabel,
//          button: UIButton) {
//        self.commonStackView = commonStackView
//        self.loginStackView = loginStackView
//        self.passwordStackView = passwordStackView
//        self.loginTextFeild = loginTextFeild
//        self.loginLabel = loginLabel
//        self.passwordTextFeild = passwordTextFeild
//        self.passwordLabel = passwordLabel
//        self.header = header
//        self.button = button
//    }
//}

protocol BuilderProtocol {
    func createCommonStackView() -> UIStackView
    func createStackView() -> UIStackView
    func createTextField(placeholder: String) -> UITextField
    func createLabel(text: String) -> UILabel
    func createHeader() -> UILabel
    func createButton() -> UIButton
    func createSegmentedControl() -> UISegmentedControl
}

class Builder: BuilderProtocol {
    func createCommonStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 30
        stackView.alignment = .leading
        stackView.contentMode = .scaleToFill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }
    
    func createStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 4
        stackView.alignment = .leading
        stackView.contentMode = .scaleToFill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }
    
    func createTextField(placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no
        textField.keyboardType = .default
        textField.returnKeyType = .done
        textField.clearButtonMode = .whileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false

        return textField
    }
    
    func createLabel(text: String) -> UILabel {
        let label = UILabel()
        label.font = UIFont(name: "Apple Symbols", size: 14)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.text = text
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }
    
    func createHeader() -> UILabel {
        let label = UILabel()
        label.font = UIFont(name: "Apple SD Gothic Neo Regular", size: 30)
        label.text = "Parkouka.by"
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }
    
    func createButton() -> UIButton {
        let button = UIButton()
        button.setTitle("Войти", for: .normal)
        button.setTitleColor(.link, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }
    
    func createSegmentedControl() -> UISegmentedControl {
        let items = ["Storyboard", "AutoLayout", "PureLayout"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.layer.cornerRadius = 5.0
        segmentedControl.backgroundColor = #colorLiteral(red: 0.02135290019, green: 0.4575462937, blue: 1, alpha: 1)
        
        return segmentedControl
    }
}
