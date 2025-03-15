//
//  ProductInteractor.swift
//  Shoppe
//
//  Created by Игорь Клевжиц on 05.03.2025.
//

protocol ProductInteractorProtocol: AnyObject {
    func fetchProductWithSubcategories(by id: Int, completion: @escaping (Product?, [Product]?) -> Void)
    func fetchProduct(id: Int, completion: @escaping (Product?) -> Void)
    func toggleLike(by id: Int)
    func addToCart(by id: Int)
    func deleteFromCart(for id: Int)
}

final class ProductInteractor: ProductInteractorProtocol {
    weak var presenter: ProductPresenterProtocol?
    
    private let apiService = APIService.shared
    
    internal func fetchProduct(id: Int, completion: @escaping (Product?) -> Void) {
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
            
            self.apiService.fetchProductsBySubcategory(product.subcategory) { result in
                switch result {
                case .success(let products):
                    let relatedProducts = products.filter { $0.id != product.id }
                    completion(product, relatedProducts.isEmpty ? nil : relatedProducts)
                    
                case .failure(let error):
                    print("Ошибка: \(error)")
                    completion(product, nil)
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
        StorageCartManager.shared.loadCart { cartItems in
            guard let item = cartItems.first(where: { $0.id == id }) else { return }

            if item.quantity > 1 {
                var updatedItem = item
                updatedItem.quantity -= 1
                StorageCartManager.shared.updateProduct(updatedItem) {
                    self.setCartCount(by: id)
                }
            } else {
                APIService.shared.fetchProduct(by: id) { result in
                    switch result {
                    case .success(let product):
                        StorageCartManager.shared.removeProduct(product) {
                            self.setCartCount(by: id)
                        }
                    case .failure:
                        break
                    }
                }
            }
        }
    }
    
    func addToCart(by id: Int) {
        fetchProduct(id: id, completion: { product in
            if let product = product {
                StorageCartManager.shared.addProduct(product) {
                    self.setCartCount(by: product.id)
                }
            }
        })
    }
    
    func setCartCount(by id: Int) {
        StorageCartManager.shared.loadCart { cart in
            if let productInCart = cart.first(where: { $0.id == id }) {
                self.presenter?.setCartCount(by: productInCart.quantity)
            } else {
                self.presenter?.setCartCount(by: 0)
            }
        }
    }
}
