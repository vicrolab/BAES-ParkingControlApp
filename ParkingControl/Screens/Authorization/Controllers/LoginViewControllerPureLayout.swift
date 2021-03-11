//
//  LoginViewControllerPureLayout.swift
//  ParkingControl
//
//  Created by Mikalaj Shuhno on 11.03.21.
//

import UIKit
import PureLayout

class LoginViewControllerPureLayout: UIViewController, UITextFieldDelegate, LoginViewControllerDelegate {

    // MARK: Outlets
    private lazy var builder = Builder()
    private lazy var firstView: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var header: UILabel = {
        let label = builder.createHeader()
        return label
    }()
    
    private lazy var loginLabel: UILabel = {
        let label = builder.createLabel(text: "Логин")
        return label
    }()
    
    private lazy var loginTextField: UITextField = {
        let textfield = builder.createTextField(placeholder: "Введите логин")
        textfield.delegate = self
        return textfield
    }()
    
    private lazy var passwordLabel: UILabel = {
        let label = builder.createLabel(text: "Пароль")
        return label
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textfield = builder.createTextField(placeholder: "Введите пароль")
        textfield.delegate = self
        return textfield
    }()
    
    private lazy var loginStackView: UIStackView = {
        let stackView = builder.createStackView()
        return stackView
    }()
    
    private lazy var passwordStackView: UIStackView = {
        let stackView = builder.createStackView()
        return stackView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = builder.createCommonStackView()
        return stackView
    }()
    
    private lazy var button: UIButton = {
        let button = builder.createButton()
        return button
    }()
    
    // MARK: Actions
    @objc func logInButton(_ sender: UIButton!) {
        guard let login = loginTextField.text,
              let password = passwordTextField.text
        else {
            return
        }
        let manager = AuthorizationManager()
        manager.delegate = self
        manager.validateCredentials(loginValue: login, passwordValue: password)
    }
    
    // MARK: Properties
    // MARK: Lifecycle
    
    override func loadView() {
        super.loadView()
        
        overlayFirstLayer()
        overlaySecondLayer()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = .white
    }
    // MARK: TableView
    // MARK: Setup
    // MARK: - Public interface
    // MARK: - Private interface
    
    private func overlayFirstLayer() {
        self.view.addSubview(firstView)
        
        firstView.autoPinEdge(toSuperviewSafeArea: .top)
        firstView.autoPinEdge(toSuperviewSafeArea: .bottom)
        firstView.autoPinEdge(toSuperviewSafeArea: .leading)
        firstView.autoPinEdge(toSuperviewSafeArea: .trailing)
    }
    
    private func overlaySecondLayer() {
        firstView.addSubview(header)
        overlayStackView()
        firstView.addSubview(stackView)
        firstView.addSubview(button)
        
        
        header.autoAlignAxis(.vertical, toSameAxisOf: firstView)
        header.autoPinEdge(.top, to: .top, of: firstView, withOffset: 66)
        stackView.autoAlignAxis(.vertical, toSameAxisOf: firstView)
        stackView.autoPinEdge(.top, to: .bottom, of: header, withOffset: 40)
        button.autoPinEdge(.top, to: .bottom, of: stackView, withOffset: 62)
        button.autoAlignAxis(.vertical, toSameAxisOf: firstView)
        button.autoSetDimension(.height, toSize: Constants.buttonHeight)
        button.autoSetDimension(.width, toSize: Constants.buttonWidth)
    }
    
    private func overlayLoginStackView(){
        loginStackView.addArrangedSubview(loginLabel)
        loginStackView.addArrangedSubview(loginTextField)
        
        loginLabel.autoSetDimension(.height, toSize: Constants.labelHeight)
        loginLabel.autoSetDimension(.width, toSize: Constants.labelWidth)
        loginTextField.autoSetDimension(.height, toSize: Constants.textFieldHeight)
        loginTextField.autoSetDimension(.width, toSize: Constants.textFieldWidth)
    }
    
    private func overlayPasswordStackView() {
        passwordStackView.addArrangedSubview(passwordLabel)
        passwordStackView.addArrangedSubview(passwordTextField)
        
        passwordLabel.autoSetDimension(.height, toSize: Constants.labelHeight)
        passwordLabel.autoSetDimension(.width, toSize: Constants.labelWidth, relation: .greaterThanOrEqual)
        passwordTextField.autoSetDimension(.height, toSize: Constants.textFieldHeight)
        passwordTextField.autoSetDimension(.width, toSize: Constants.textFieldWidth)
    }
    
    private func overlayStackView() {
        overlayLoginStackView()
        overlayPasswordStackView()
        
        stackView.addArrangedSubview(loginStackView)
        stackView.addArrangedSubview(passwordStackView)
    }
}
