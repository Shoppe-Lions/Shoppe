//
//  CartInteractor.swift
//  Shoppe
//
//  Created by Artem Kriukov on 04.03.2025.
//

import Foundation


protocol CartInteractorProtocol: AnyObject {
    func fetchCartProducts()
    func increaseProductQuantity(at index: Int)
    func decreaseProductQuantity(at index: Int)
    func getQuantity(for productId: Int) -> Int
    func getTotalProductCount() -> Int
    func calculateTotalPrice() -> Double
    func deleteProduct(at index: Int)
}

final class CartInteractor: CartInteractorProtocol {
    weak var presenter: CartPresenterProtocol?

    private var productQuantities: [Int: Int] = [:]
    
    var products = [
        Product(id: 1, title: "Lorem ipsum dolor sit amet consectetur", price: 200, description: "", category: "", imageURL: "Cell", rating: Rating(rate: 5, count: 25), subcategory: "test", like: false),
        Product(id: 232, title: "Lorem ipsum dolor sit amet consectetur", price: 199.99, description: "", category: "", imageURL: "Cell", rating: Rating(rate: 5, count: 25), subcategory: "test", like: false),
        
    ]
    
    func fetchCartProducts() {
        products.forEach { product in
            productQuantities[product.id] = 1
        }
        presenter?.didFetchCartProducts(products)
    }
    
    func increaseProductQuantity(at index: Int) {
        guard index < products.count else { return }
        let productId = products[index].id
        productQuantities[productId] = (productQuantities[productId] ?? 0) + 1
        presenter?.didUpdateProduct(at: index, product: products[index], quantity: productQuantities[productId] ?? 1)
        print(productQuantities)
    }
    
    func decreaseProductQuantity(at index: Int) {
        guard index < products.count else { return }
        let productId = products[index].id
        if let quantity = productQuantities[productId], quantity > 1 {
            productQuantities[productId] = quantity - 1
            presenter?.didUpdateProduct(at: index, product: products[index], quantity: productQuantities[productId] ?? 1)
        }
        print(productQuantities)
    }
    
    func getQuantity(for productId: Int) -> Int {
        return productQuantities[productId] ?? 1
    }
    
    func getTotalProductCount() -> Int {
        products.count
    }
    
    func calculateTotalPrice() -> Double {
        var totalPrice = 0.0
        for product in products {
            let quantity = productQuantities[product.id] ?? 0
            totalPrice += Double(product.price) * Double(quantity)
        }
        return totalPrice
    }
    
    func deleteProduct(at index: Int) {
        guard index < products.count else { return }
        let productId = products[index].id
        products.remove(at: index)
        productQuantities.removeValue(forKey: productId)
    }
}
