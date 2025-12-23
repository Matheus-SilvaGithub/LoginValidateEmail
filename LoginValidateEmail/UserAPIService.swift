import Foundation

enum APIError: Error, LocalizedError {
    case invalidURL
    case network(Error)
    case server(statusCode: Int)
    case decoding
    case custom(String)

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "URL inválida."
        case .network(let err): return "Erro de rede: \(err.localizedDescription)"
        case .server(let code): return "Erro do servidor (\(code))."
        case .decoding: return "Erro ao interpretar resposta."
        case .custom(let msg): return msg
        }
    }
}

struct RegisterRequest: Codable {
    let email: String
    let password: String
}

struct RegisterResponse: Codable {
    let success: Bool
    let message: String?
}

final class UserAPIService {
    static let shared = UserAPIService()

    // Base URL fictícia; ajuste conforme seu backend
    private let baseURL = URL(string: "https://example.com/api")

    func register(email: String, password: String, completion: @escaping (Result<RegisterResponse, APIError>) -> Void) {
        guard let base = baseURL else { completion(.failure(.invalidURL)); return }
        let url = base.appendingPathComponent("register")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let payload = RegisterRequest(email: email, password: password)
        do {
            request.httpBody = try JSONEncoder().encode(payload)
        } catch {
            completion(.failure(.custom("Falha ao codificar requisição.")))
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.network(error)))
                return
            }
            guard let http = response as? HTTPURLResponse else {
                completion(.failure(.custom("Resposta inválida.")))
                return
            }
            guard (200..<300).contains(http.statusCode) else {
                completion(.failure(.server(statusCode: http.statusCode)))
                return
            }
            guard let data = data else {
                completion(.failure(.custom("Resposta vazia.")))
                return
            }
            do {
                let decoded = try JSONDecoder().decode(RegisterResponse.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(.decoding))
            }
        }
        task.resume()
    }
}
