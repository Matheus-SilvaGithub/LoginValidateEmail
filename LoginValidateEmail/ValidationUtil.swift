import Foundation

enum ValidationUtil {
    static func validateEmail(_ email: String?) -> (isValid: Bool, message: String?) {
        let emailRegex = "[A-Z0-9a-z._%+-]+@gmail\\.com"
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        let ok = predicate.evaluate(with: email)
        let message = ok ? nil : "Digite um e-mail válido do Gmail (ex: usuario@gmail.com)."
        return (ok, message)
    }

    static func validatePassword(_ password: String?) -> (isValid: Bool, message: String?) {
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&#^._-])[A-Za-z\\d@$!%*?&#^._-]{8,}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        let ok = predicate.evaluate(with: password)
        let message = ok ? nil : "A senha deve ter pelo menos 8 caracteres, incluir letras maiúsculas e minúsculas, um número e um caractere especial."
        return (ok, message)
    }

    static func validateConfirmPassword(_ password: String?, _ confirm: String?) -> (isValid: Bool, message: String?) {
        guard let p = password, let c = confirm, !p.isEmpty, !c.isEmpty else {
            return (false, "Confirme sua senha.")
        }
        let ok = p == c
        let message = ok ? nil : "As senhas não conferem."
        return (ok, message)
    }
}
