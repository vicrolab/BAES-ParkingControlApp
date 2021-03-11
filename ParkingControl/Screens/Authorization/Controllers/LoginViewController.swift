//
//  LoginViewController.swift
//  ParkingControl
//
//  Created by Mikalaj Shuhno on 11.12.20.
//

import UIKit

class LoginViewController: UIViewController, LoginViewControllerDelegate, UITextFieldDelegate {
    
    // MARK: Outlets
    private lazy var builder = Builder()
    private lazy var firstView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
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
    // MARK: Lifecycle
    override func loadView() {
        super.loadView()
        
        overlayFirstLayer()
        overlaySecondLayer()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: Setup
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
    }
    // MARK: - Private interface
    
    private func setupUI() {
        self.view.backgroundColor = .white
    }
    
    private func overlayFirstLayer() {
        self.view.addSubview(firstView)
        
        NSLayoutConstraint.activate([
            firstView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            firstView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            firstView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            firstView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func overlaySecondLayer() {
        overlayStackView()
        firstView.addSubview(header)
        firstView.addSubview(stackView)
        firstView.addSubview(button)
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: firstView.topAnchor, constant: 66),
            header.centerXAnchor.constraint(equalTo: firstView.centerXAnchor),
            stackView.centerXAnchor.constraint(equalTo: header.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 40),
            button.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 62),
            button.centerXAnchor.constraint(equalTo: firstView.centerXAnchor),
            button.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            button.widthAnchor.constraint(greaterThanOrEqualToConstant: Constants.buttonWidth)
        ])
    }
    
    private func overlayLoginStackView() {
        loginStackView.addArrangedSubview(loginLabel)
        loginStackView.addArrangedSubview(loginTextField)
        
        NSLayoutConstraint.activate([
            loginLabel.heightAnchor.constraint(equalToConstant: Constants.labelHeight),
            loginLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: Constants.labelWidth),
            loginTextField.heightAnchor.constraint(equalToConstant: Constants.textFieldHeight),
            loginTextField.widthAnchor.constraint(greaterThanOrEqualToConstant: Constants.textFieldWidth)
        ])
    }
    
    private func overlayPasswordStackView() {
        passwordStackView.addArrangedSubview(passwordLabel)
        passwordStackView.addArrangedSubview(passwordTextField)
        
        NSLayoutConstraint.activate([
            passwordLabel.heightAnchor.constraint(equalToConstant: Constants.labelHeight),
            passwordLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: Constants.labelWidth),
            passwordTextField.heightAnchor.constraint(equalToConstant: Constants.textFieldHeight),
            passwordTextField.widthAnchor.constraint(greaterThanOrEqualToConstant: Constants.textFieldWidth)
        ])
    }
    
    private func overlayStackView() {
        overlayLoginStackView()
        overlayPasswordStackView()
        
        stackView.addArrangedSubview(loginStackView)
        stackView.addArrangedSubview(passwordStackView)
    }
}

