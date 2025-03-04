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
        loadProducts { Products in
            print(Products?[0].image)
        }
    }


}

