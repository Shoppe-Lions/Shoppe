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
}

final class CartInteractor: CartInteractorProtocol {
    weak var presenter: CartPresenterProtocol?

    private var productQuantities: [Int: Int] = [:]
    
    var sampleProducts = [
        Product(id: 1, title: "Lorem ipsum dolor sit amet consectetur", price: 200, description: "", category: "", image: "testPhotoImage", rating: Rating(rate: 5, count: 25), subcategory: "test", like: false),
        Product(id: 232, title: "Lorem ipsum dolor sit amet consectetur", price: 199.99, description: "", category: "", image: "testPhotoImage", rating: Rating(rate: 5, count: 25), subcategory: "test", like: false),
    ]
    
    func fetchCartProducts() {
        sampleProducts.forEach { product in
            productQuantities[product.id] = 1
        }
        presenter?.didFetchCartProducts(sampleProducts)
    }
    
    func increaseProductQuantity(at index: Int) {
        guard index < sampleProducts.count else { return }
        let productId = sampleProducts[index].id
        productQuantities[productId] = (productQuantities[productId] ?? 0) + 1
        presenter?.didUpdateProduct(at: index, product: sampleProducts[index], quantity: productQuantities[productId] ?? 1)
        print(productQuantities)
    }
    
    func decreaseProductQuantity(at index: Int) {
        guard index < sampleProducts.count else { return }
        let productId = sampleProducts[index].id
        if let quantity = productQuantities[productId], quantity > 1 {
            productQuantities[productId] = quantity - 1
            presenter?.didUpdateProduct(at: index, product: sampleProducts[index], quantity: productQuantities[productId] ?? 1)
        }
        print(productQuantities)
    }
    
    func getQuantity(for productId: Int) -> Int {
        return productQuantities[productId] ?? 1
    }
}
