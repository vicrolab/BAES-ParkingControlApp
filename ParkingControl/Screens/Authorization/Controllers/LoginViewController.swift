//
//  LoginViewController.swift
//  ParkingControl
//
//  Created by Mikalaj Shuhno on 11.12.20.
//

import UIKit

protocol LoginViewControllerDelegate {
    func displayAlert(title: String, message: String)
}

struct Constants {
    static let labelHeight: CGFloat = 13
    static let labelWidth: CGFloat = 39
    static let textFieldHeight: CGFloat = 34
}

class LoginViewController: UIViewController, LoginViewControllerDelegate, UITextFieldDelegate {
    
    // MARK: Outlets
    private lazy var firstView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var stackView: UIStackView! = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 20
        stackView.alignment = .leading
        stackView.contentMode = .scaleToFill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var loginStackView: UIStackView! = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 4
        stackView.alignment = .leading
        stackView.contentMode = .scaleToFill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var passwordStackView: UIStackView! = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 4
        stackView.alignment = .leading
        stackView.contentMode = .scaleToFill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var loginTextField: UITextField! = {
        let textField = UITextField()
        textField.placeholder = "Введите логин"
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no
        textField.keyboardType = .default
        textField.returnKeyType = .done
        textField.clearButtonMode = .whileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self

        return textField
    }()

    private lazy var loginLabel: UILabel! = {
        let label = UILabel()
        label.font = UIFont(name: "Apple Symbols", size: 14)
        label.numberOfLines = 0
        label.text = "Логин"
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private lazy var passwordTextField: UITextField! = {
        let textField = UITextField()
        textField.placeholder = "Введите пароль"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .default
        textField.isSecureTextEntry = true
        textField.returnKeyType = .done
        textField.clearButtonMode = .whileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self

        return textField
    }()

    private lazy var passwordLabel: UILabel! = {
        let label = UILabel()
        label.font = UIFont(name: "Apple Symbols", size: 14)
        label.text = "Пароль"
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private lazy var header: UILabel! = {
        let label = UILabel()
        label.font = UIFont(name: "Apple SD Gothic Neo Regular", size: 30)
        label.text = "Parkouka.by"
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private lazy var button: UIButton! = {
        let button = UIButton()
        button.setTitle("Войти", for: .normal)
        button.setTitleColor(.link, for: .normal)
        button.addTarget(self, action: #selector(LoginViewController.logInButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overlayFirstLayer()
        overlaySecondLayer()
    }
    
    // MARK: Setup
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
    }
    // MARK: - Public interface
    // MARK: - Private interface
    
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
            button.heightAnchor.constraint(equalToConstant: 44),
            button.widthAnchor.constraint(greaterThanOrEqualToConstant: 254)
        ])
    }
    
    private func overlayLoginStackView() {
        loginStackView.addArrangedSubview(loginLabel)
        loginStackView.addArrangedSubview(loginTextField)
        
        NSLayoutConstraint.activate([
            loginLabel.heightAnchor.constraint(equalToConstant: Constants.labelHeight),
            loginLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: Constants.labelWidth),
            loginTextField.heightAnchor.constraint(equalToConstant: Constants.textFieldHeight),
            loginTextField.widthAnchor.constraint(greaterThanOrEqualToConstant: 300)
        ])
        
        
    }
    
    private func overlayPasswordStackView() {
        passwordStackView.addArrangedSubview(passwordLabel)
        passwordStackView.addArrangedSubview(passwordTextField)
        
        NSLayoutConstraint.activate([
            passwordLabel.heightAnchor.constraint(equalToConstant: Constants.labelHeight),
            passwordLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: Constants.labelWidth),
            passwordTextField.heightAnchor.constraint(equalToConstant: Constants.textFieldHeight),
            passwordTextField.widthAnchor.constraint(greaterThanOrEqualToConstant: 300)
        ])
    }
    
    private func overlayStackView() {
        overlayLoginStackView()
        overlayPasswordStackView()
        
        stackView.addArrangedSubview(loginStackView)
        stackView.addArrangedSubview(passwordStackView)
    }
    
    
    

    
    
    
    
//    @IBOutlet weak var loginTextField: UITextField!
//    @IBOutlet weak var passwordTextField: UITextField!
//
//    @IBAction func logInAction(_ sender: UIButton) {
//        guard let login = loginTextField.text,
//              let password = passwordTextField.text
//        else {
//            return
//        }
//        let manager = AuthorizationManager()
//        manager.delegate = self
//        manager.validateCredentials(loginValue: login, passwordValue: password)
//    }
}

