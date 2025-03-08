//
//  ProductInteractor.swift
//  Shoppe
//
//  Created by Игорь Клевжиц on 05.03.2025.
//

protocol ProductInteractorProtocol: AnyObject {
    func fetchProduct(id: Int, completion: @escaping (Product?) -> Void)
    func loadProducts(completion: @escaping ([Product]?) -> Void)
    func toggleLike(id: Int)
}

final class ProductInteractor: ProductInteractorProtocol {
    weak var presenter: ProductPresenterProtocol?
    
    private let apiService = APIService()
    
    func fetchProduct(id: Int, completion: @escaping (Product?) -> Void) {
        apiService.fetchProduct(by: id) { result in
            switch result {
            case .success(let product):
                completion(product)
            case .failure:
                completion(nil)
            }
        }
    }
    
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
    
    func toggleLike(id: Int) {
        apiService.fetchProduct(by: id) { result in
            switch result {
            case .success(let product):
                self.apiService.toggleLike(for: product)
                self.presenter?.setLike(by: product.like)
            case .failure:
                print("Не удалось загрузить продукт для изменения лайка")
            }
        }
    }
}
