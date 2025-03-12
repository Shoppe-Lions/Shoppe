//
//  ProductInteractor.swift
//  Shoppe
//
//  Created by Игорь Клевжиц on 05.03.2025.
//

protocol ProductInteractorProtocol: AnyObject {
    func fetchProductWithSubcategories(by id: Int, completion: @escaping (Product?, [Product]?) -> Void)
    func toggleLike(by id: Int)
    func addToCart(by id: Int)
    func deleteFromCart(for id: Int)
}

final class ProductInteractor: ProductInteractorProtocol {
    weak var presenter: ProductPresenterProtocol?
    
    private let apiService = APIService()
    
    private func fetchProduct(id: Int, completion: @escaping (Product?) -> Void) {
        apiService.fetchProduct(by: id) { result in
            switch result {
            case .success(let product):
                self.setCartCount(by: product.id)
                completion(product)
            case .failure:
                completion(nil)
            }
        }
    }
    
    private func loadProducts(completion: @escaping ([Product]?) -> Void) {
        apiService.fetchProducts { result in
            switch result {
            case .success(let products):
                completion(products)
            case .failure:
                completion(nil)
            }
        }
    }
    
    func fetchProductWithSubcategories(by id: Int, completion: @escaping (Product?, [Product]?) -> Void) {
        fetchProduct(id: id) { product in
            guard let product = product else {
                completion(nil, nil)
                return
            }
            
            self.loadProducts { products in
                let subcategoryProducts = products?.filter { $0.subcategory == product.subcategory && $0.id != product.id }
                if subcategoryProducts?.isEmpty ?? true {
                    completion(product, nil)
                } else {
                    completion(product, subcategoryProducts)
                }
            }
        }
    }
    
    func toggleLike(by id: Int) {
        apiService.fetchProduct(by: id) { result in
            switch result {
            case .success(let product):
                self.presenter?.setLike(by: !product.like)
                self.apiService.toggleLike(for: product)
            case .failure:
                print("Не удалось загрузить продукт для изменения лайка")
            }
        }
    }
    
    func deleteFromCart(for id: Int) {
        fetchProduct(id: id, completion: { product in
            if let product = product {
                StorageCartManager.shared.removeProduct(product)
                self.setCartCount(by: product.id)
            }
        })
    }
    
    func addToCart(by id: Int) {
        fetchProduct(id: id, completion: { product in
            if let product = product {
                StorageCartManager.shared.addProduct(product)
                self.setCartCount(by: product.id)
            }
        })
    }
    
    func setCartCount(by id: Int) {
        if let productInCart = StorageCartManager.shared.loadCart().first(where: { $0.id == id }) {
            presenter?.setCartCount(by: productInCart.quantity)
        } else {
            presenter?.setCartCount(by: 0)
        }
    }
}
