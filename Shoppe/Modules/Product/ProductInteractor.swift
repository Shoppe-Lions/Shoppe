//
//  ProductInteractor.swift
//  Shoppe
//
//  Created by Игорь Клевжиц on 05.03.2025.
//

protocol ProductInteractorProtocol: AnyObject {
    func fetchProduct(completion: @escaping (Product?) -> Void)
}

final class ProductInteractor: ProductInteractorProtocol {
    weak var presenter: ProductPresenterProtocol?
    
    private let apiService = APIService()
    
    func fetchProduct(completion: @escaping (Product?) -> Void) {
        apiService.fetchProduct(by: 1) { result in
            switch result {
            case .success(let product):
                completion(product)
            case .failure:
                completion(nil)
            }
        }
    }
}
