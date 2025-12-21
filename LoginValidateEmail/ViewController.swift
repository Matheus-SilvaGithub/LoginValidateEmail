//
//  ViewController.swift
//  LoginValidateEmail
//
//  Created by Matheus Silva on 28/04/25.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var loginLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.text = "Acesse sua conta"
        label.textColor = .systemGray
        return label
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Digite seu e-mail"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Digite sua senha"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Entrar", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let formStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private func setBorder(for textField: UITextField, valid: Bool?) {
        textField.layer.cornerRadius = 5
        textField.layer.masksToBounds = true
        textField.layer.borderWidth = 1
        if let valid = valid {
            textField.layer.borderColor = (valid ? UIColor.systemGreen : UIColor.systemRed).cgColor
        } else {
            textField.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    private func configureTextFieldAppearance(_ textField: UITextField, systemImageName: String?) {
        textField.backgroundColor = UIColor.secondarySystemBackground
        textField.textColor = .label
        textField.tintColor = .systemBlue
        textField.layer.cornerRadius = 8
        textField.layer.masksToBounds = true
        textField.borderStyle = .none

        let container = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        if let name = systemImageName, let image = UIImage(systemName: name) {
            let imageView = UIImageView(image: image)
            imageView.tintColor = .secondaryLabel
            imageView.contentMode = .scaleAspectFit
            imageView.frame = CGRect(x: 12, y: 10, width: 20, height: 20)
            container.addSubview(imageView)
        }
        textField.leftView = container
        textField.leftViewMode = .always
    }
    
    private func styleLoginButton() {
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        loginButton.layer.cornerRadius = 10
        loginButton.layer.shadowColor = UIColor.black.cgColor
        loginButton.layer.shadowOpacity = 0.15
        loginButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        loginButton.layer.shadowRadius = 6
    }

    private func validatePasswordWithMessage(_ password: String?) -> (isValid: Bool, message: String?) {
        // Require at least 8 chars, at least one lowercase, one uppercase, one digit, and one special character
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&#^._-])[A-Za-z\\d@$!%*?&#^._-]{8,}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        let ok = predicate.evaluate(with: password)
        let message = ok ? nil : "A senha deve ter pelo menos 8 caracteres, incluir letras maiúsculas e minúsculas, um número e um caractere especial."
        return (ok, message)
    }

    private func validateEmailWithMessage(_ email: String?) -> (isValid: Bool, message: String?) {
        let emailRegex = "[A-Z0-9a-z._%+-]+@gmail\\.com"
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        let ok = predicate.evaluate(with: email)
        let message = ok ? nil : "Digite um e-mail válido do Gmail (ex: usuario@gmail.com)."
        return (ok, message)
    }
    
    private func updateLoginButtonState() {
        let emailValid = validateEmailWithMessage(emailTextField.text).isValid
        let passwordValid = validatePasswordWithMessage(passwordTextField.text).isValid
        let enabled = emailValid && passwordValid
        loginButton.isEnabled = enabled
        loginButton.alpha = enabled ? 1.0 : 0.5
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGroupedBackground
      
        view.addSubview(loginLabel)
        view.addSubview(formStack)
        formStack.addArrangedSubview(emailTextField)
        formStack.addArrangedSubview(passwordTextField)
        formStack.addArrangedSubview(loginButton)
        
        loginButton.addTarget(self, action: #selector(tappedLoginButton), for: .touchUpInside)
        
        emailTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        
        configureTextFieldAppearance(emailTextField, systemImageName: "envelope")
        configureTextFieldAppearance(passwordTextField, systemImageName: "lock")
        styleLoginButton()
        
        // Start with neutral borders
        setBorder(for: emailTextField, valid: nil)
        setBorder(for: passwordTextField, valid: nil)
        updateLoginButtonState()
        
        NSLayoutConstraint.activate([
            loginLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 200),
            loginLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),
            loginLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            loginLabel.heightAnchor.constraint(equalToConstant: 40),

            formStack.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 6),
            formStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            formStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    @objc private func textFieldEditingChanged(_ textField: UITextField) {
        if textField === emailTextField {
            let result = validateEmailWithMessage(textField.text)
            setBorder(for: textField, valid: textField.text?.isEmpty == false ? result.isValid : nil)
        } else if textField === passwordTextField {
            let result = validatePasswordWithMessage(textField.text)
            setBorder(for: textField, valid: textField.text?.isEmpty == false ? result.isValid : nil)
        }
        updateLoginButtonState()
    }
    
    @objc func tappedLoginButton(_ sender: UIButton) {
        let emailResult = validateEmailWithMessage(emailTextField.text)
        let passwordResult = validatePasswordWithMessage(passwordTextField.text)

        setBorder(for: emailTextField, valid: emailResult.isValid)
        setBorder(for: passwordTextField, valid: passwordResult.isValid)

        if emailResult.isValid && passwordResult.isValid {
            self.showAlert(title: "Sucesso ao logar")
        } else {
            let message = passwordResult.message ?? emailResult.message ?? "Erro ao logar"
            self.showAlert(title: message)
        }
    }
    
    func showAlert(title: String) {
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okButton)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension UITextField {
    
    func validateEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@gmail\\.com"
        let validateRegex = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return validateRegex.evaluate(with: self.text)
    }
    
    func validatePassword() -> Bool {
        // At least 8 chars, at least one lowercase, one uppercase, one digit, and one special character
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&#^._-])[A-Za-z\\d@$!%*?&#^._-]{8,}$"
        let validateRegex = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return validateRegex.evaluate(with: self.text)
    }
}

