//
//  NetworkManager.swift
//  Shoppe
//
//  Created by Игорь Клевжиц on 04.03.2025.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case decodingError(error: Error)
    case serverError(statusCode: Int)
    case noData
    case networkError(error: Error)
    
    var customDescription: String {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .decodingError: return "Data decoding error"
        case .serverError(let statusCode): return "Server error, code: \(statusCode)"
        case .noData: return "No data from server"
        case .networkError(let error): return "Ошибка сети: \(error.localizedDescription)"
        }
    }
}

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}

    func fetchData<T: Decodable>(from urlString: String, completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error {
                completion(.failure(.networkError(error: error)))
                print ("Can't connect to the server. Check your internet connection")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.serverError(statusCode: 0)))
                return
            }
            
            guard httpResponse.statusCode == 200 else {
                completion(.failure(.serverError(statusCode: httpResponse.statusCode)))
                return
            }
                        
            guard let data else {
                completion(.failure(.noData))
                return
            }

            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedData))
                }
            } catch {
                completion(.failure(.decodingError(error: error)))
            }
        }.resume()
    }
}
