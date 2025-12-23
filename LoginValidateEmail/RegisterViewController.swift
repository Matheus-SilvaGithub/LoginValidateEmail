import UIKit

class RegisterViewController: UIViewController {
    private let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Digite seu e-mail"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.keyboardType = .emailAddress
        tf.autocapitalizationType = .none
        tf.heightAnchor.constraint(equalToConstant: 50).isActive = true
        tf.contentVerticalAlignment = .center
        tf.layer.cornerRadius = 8
        tf.layer.masksToBounds = true
        tf.borderStyle = .none
        tf.backgroundColor = .secondarySystemBackground
        return tf
    }()

    private let emailErrorLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = .systemFont(ofSize: 12)
        lb.textColor = .systemRed
        lb.numberOfLines = 0
        lb.isHidden = true
        return lb
    }()

    private let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Digite sua senha"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        tf.heightAnchor.constraint(equalToConstant: 50).isActive = true
        tf.contentVerticalAlignment = .center
        tf.layer.cornerRadius = 8
        tf.layer.masksToBounds = true
        tf.borderStyle = .none
        tf.backgroundColor = .secondarySystemBackground
        return tf
    }()

    private let passwordErrorLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = .systemFont(ofSize: 12)
        lb.textColor = .systemRed
        lb.numberOfLines = 0
        lb.isHidden = true
        return lb
    }()

    private let confirmTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Confirme sua senha"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        tf.heightAnchor.constraint(equalToConstant: 50).isActive = true
        tf.contentVerticalAlignment = .center
        tf.layer.cornerRadius = 8
        tf.layer.masksToBounds = true
        tf.borderStyle = .none
        tf.backgroundColor = .secondarySystemBackground
        return tf
    }()

    private let confirmErrorLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = .systemFont(ofSize: 12)
        lb.textColor = .systemRed
        lb.numberOfLines = 0
        lb.isHidden = true
        return lb
    }()

    private let registerButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setTitle("Registrar", for: .normal)
        bt.setTitleColor(.white, for: .normal)
        bt.backgroundColor = .systemGreen
        bt.layer.cornerRadius = 10
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.heightAnchor.constraint(equalToConstant: 50).isActive = true
        bt.isEnabled = false
        bt.alpha = 0.5
        return bt
    }()

    private let formStack: UIStackView = {
        let st = UIStackView()
        st.axis = .vertical
        st.alignment = .fill
        st.distribution = .fill
        st.spacing = 8
        st.translatesAutoresizingMaskIntoConstraints = false
        return st
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.title = "Registrar"

        // Configure left icons
        configureTextFieldAppearance(emailTextField, systemImageName: "envelope")
        configureTextFieldAppearance(passwordTextField, systemImageName: "lock")
        configureTextFieldAppearance(confirmTextField, systemImageName: "lock.fill")

        view.addSubview(formStack)

        // Group each field with its error label in a vertical stack
        let emailGroup = UIStackView(arrangedSubviews: [emailTextField, emailErrorLabel])
        emailGroup.axis = .vertical
        emailGroup.spacing = 4

        let passGroup = UIStackView(arrangedSubviews: [passwordTextField, passwordErrorLabel])
        passGroup.axis = .vertical
        passGroup.spacing = 4

        let confirmGroup = UIStackView(arrangedSubviews: [confirmTextField, confirmErrorLabel])
        confirmGroup.axis = .vertical
        confirmGroup.spacing = 4

        formStack.addArrangedSubview(emailGroup)
        formStack.addArrangedSubview(passGroup)
        formStack.addArrangedSubview(confirmGroup)
        formStack.addArrangedSubview(registerButton)

        NSLayoutConstraint.activate([
            formStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            formStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            formStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40)
        ])

        // Targets
        emailTextField.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
        confirmTextField.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
        registerButton.addTarget(self, action: #selector(tappedRegister), for: .touchUpInside)

        // Initial validation state
        validateAll()
    }

    private func configureTextFieldAppearance(_ textField: UITextField, systemImageName: String?) {
        textField.textColor = .label
        textField.tintColor = .systemBlue
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

    @objc private func textChanged(_ sender: UITextField) {
        validateAll()
    }

    private func validateAll() {
        let emailResult = validateEmailWithMessage(emailTextField.text)
        let passResult = validatePasswordWithMessage(passwordTextField.text)
        let confirmResult = validateConfirmPassword(passwordTextField.text, confirmTextField.text)

        // Email
        if let msg = emailResult.message {
            emailErrorLabel.text = msg
            emailErrorLabel.isHidden = false
        } else {
            emailErrorLabel.isHidden = true
            emailErrorLabel.text = nil
        }

        // Password
        if let msg = passResult.message {
            passwordErrorLabel.text = msg
            passwordErrorLabel.isHidden = false
        } else {
            passwordErrorLabel.isHidden = true
            passwordErrorLabel.text = nil
        }

        // Confirm
        if let msg = confirmResult.message {
            confirmErrorLabel.text = msg
            confirmErrorLabel.isHidden = false
        } else {
            confirmErrorLabel.isHidden = true
            confirmErrorLabel.text = nil
        }

        let enabled = emailResult.isValid && passResult.isValid && confirmResult.isValid
        registerButton.isEnabled = enabled
        registerButton.alpha = enabled ? 1.0 : 0.5
    }

    private func validateEmailWithMessage(_ email: String?) -> (isValid: Bool, message: String?) {
        let emailRegex = "[A-Z0-9a-z._%+-]+@gmail\\.com"
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        let ok = predicate.evaluate(with: email)
        let message = ok ? nil : "Digite um e-mail válido do Gmail (ex: usuario@gmail.com)."
        return (ok, message)
    }

    private func validatePasswordWithMessage(_ password: String?) -> (isValid: Bool, message: String?) {
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&#^._-])[A-Za-z\\d@$!%*?&#^._-]{8,}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        let ok = predicate.evaluate(with: password)
        let message = ok ? nil : "A senha deve ter pelo menos 8 caracteres, incluir letras maiúsculas e minúsculas, um número e um caractere especial."
        return (ok, message)
    }

    private func validateConfirmPassword(_ password: String?, _ confirm: String?) -> (isValid: Bool, message: String?) {
        guard let p = password, let c = confirm, !p.isEmpty, !c.isEmpty else {
            return (false, "Confirme sua senha.")
        }
        let ok = p == c
        let message = ok ? nil : "As senhas não conferem."
        return (ok, message)
    }

    @objc private func tappedRegister() {
        // Simular persistência local simples
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        LocalUserService.shared.saveUser(email: email, password: password)

        let alert = UIAlertController(title: "Usuário criado com sucesso!", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        })
        present(alert, animated: true)
    }
}
// MARK: - Persistência local simples
final class LocalUserService {
    static let shared = LocalUserService()
    private let defaults = UserDefaults.standard
    private let usersKey = "registeredUsers"

    struct User: Codable {
        let email: String
        let password: String
    }

    func saveUser(email: String, password: String) {
        var users = loadUsers()
        users.append(User(email: email, password: password))
        if let data = try? JSONEncoder().encode(users) {
            defaults.set(data, forKey: usersKey)
        }
    }

    func loadUsers() -> [User] {
        guard let data = defaults.data(forKey: usersKey),
              let users = try? JSONDecoder().decode([User].self, from: data) else {
            return []
        }
        return users
    }
}

