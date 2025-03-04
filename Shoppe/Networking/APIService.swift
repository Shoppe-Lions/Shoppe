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
        NetworkManager.shared.fetchData(from: baseURL, completion: completion)
    }

    func fetchProduct(by id: Int, completion: @escaping (Result<Product, NetworkError>) -> Void) {
        let url = "\(baseURL)/\(id)"
        NetworkManager.shared.fetchData(from: url, completion: completion)
    }
}

//final class ProductListInteractor {
//    private let apiService = APIService()
//
//    func loadProducts(completion: @escaping ([Product]?) -> Void) {
//        apiService.fetchProducts { result in
//            switch result {
//            case .success(let products):
//                completion(products)
//            case .failure:
//                completion(nil)
//            }
//        }
//    }
//}
