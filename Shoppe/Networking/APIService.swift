//
//  APIService.swift
//  Shoppe
//
//  Created by Игорь Клевжиц on 04.03.2025.
//

import Foundation

final class APIService {
    private let baseURL = "https://fakestoreapi.com/products"

    func fetchProducts(completion: @escaping (Result<[Product], NetworkError>) -> Void) {
            NetworkManager.shared.fetchData(from: baseURL) { (result: Result<[Product], NetworkError>) in
                switch result {
                case .success(var products):
                    
                    for (index, _) in products.enumerated() {
                        switch index {
                        case 0:
                            products[index].subcategory = "Backpacks"
                        case 1...3:
                            products[index].subcategory = "Clothing"
                        case 4, 7:
                            products[index].subcategory = "Cheap"
                        case 5...6:
                            products[index].subcategory = "Expensive"
                        case 8...11:
                            products[index].subcategory = "Hard Drives"
                        case 12...13:
                            products[index].subcategory = "Monitors"
                        case 14...16:
                            products[index].subcategory = "Warm Clothing"
                        case 17...19:
                            products[index].subcategory = "Light Clothing"
                        default:
                            products[index].subcategory = nil
                        }
                    }
                    
                    for index in products.indices {
                        products[index].like = false
                    }
                    completion(.success(products))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }

    func fetchProduct(by id: Int, completion: @escaping (Result<Product, NetworkError>) -> Void) {
        let url = "\(baseURL)/\(id)"
        NetworkManager.shared.fetchData(from: url, completion: completion)
    }
}
