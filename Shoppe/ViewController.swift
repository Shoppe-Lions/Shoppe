//
//  ViewController.swift
//  Shoppe
//
//  Created by Игорь Клевжиц on 02.03.2025.
//

import UIKit

class ViewController: UIViewController {
    
    private let apiService = APIService()

    func loadProducts(completion: @escaping ([Product]?) -> Void) {
        apiService.fetchProducts { result in
            switch result {
            case .success(let products):
                completion(products)
            case .failure:
                completion(nil)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadProducts { products in
            guard let products = products, !products.isEmpty else {
                return
            }
            
            // Печатаем лайки для всех продуктов
            for product in products {
                print(product.like)
            }
            if products.count > 1 {
                let product = products[1]
                self.apiService.toggleLike(for: product)
            }
        }
    }
}

