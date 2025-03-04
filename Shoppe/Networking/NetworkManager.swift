//
//  NetworkManager.swift
//  Shoppe
//
//  Created by Игорь Клевжиц on 04.03.2025.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case decodingError(Error)
    case serverError(statusCode: Int)
    case noData
    case networkError(Error)
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
            
            if let error = error {
                completion(.failure(.networkError(error)))
                print ("Can't connect to the server. Check your internet connection")
                return
            }
            
            guard response is HTTPURLResponse else {
                let error = NSError(domain: "Not a http response", code: 0, userInfo: nil)
                completion(.failure(.serverError(statusCode: error.code)))
                return
            }
            
            guard let data = data else {
                _ = NSError (domain: "No data", code: 0, userInfo: nil)
                completion(.failure(.noData))
                return
            }

            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedData))
                }
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }.resume()
    }
}
