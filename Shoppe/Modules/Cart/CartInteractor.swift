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
    
    func fetchCartProducts() {
        let cart = StorageCartManager.shared.loadCart()
        let products = cart.map{ $0.product }
        presenter?.didFetchCartProducts(products)
    }
    
    func increaseProductQuantity(at index: Int) {
        let cart = StorageCartManager.shared.loadCart()
        guard index < cart.count else { return }
        let product = cart[index].product
        
        StorageCartManager.shared.addProduct(product)
        
        presenter?.didUpdateProduct(at: index, product: product, quantity: cart[index].quantity + 1)
    }
    
    func decreaseProductQuantity(at index: Int) {
        let cart = StorageCartManager.shared.loadCart()
        guard index < cart.count else { return }
        
        let product = cart[index].product
        StorageCartManager.shared.removeProduct(product)
        
        presenter?.didUpdateProduct(at: index, product: product, quantity: cart[index].quantity - 1)
    }
    
    func getQuantity(for productId: Int) -> Int {
        let cart = StorageCartManager.shared.loadCart()
        for item in cart {
            if item.product.id == productId {
                return item.quantity
            }
        }
        return 0
    }
    
    func getTotalProductCount() -> Int {
        StorageCartManager.shared.loadCart().count
    }
    
    func calculateTotalPrice() -> Double {
        let cart = StorageCartManager.shared.loadCart()
        
        var totalPrice = 0.0
        for item in cart {
            totalPrice += Double(item.product.price) * Double(item.quantity)
        }
        return totalPrice
    }
    
    func deleteProduct(at index: Int) {
        var cart = StorageCartManager.shared.loadCart()
        guard index < cart.count else { return }
        
        let productId = cart[index].product.id
        StorageCartManager.shared.removeAllOfProduct(by: productId)
        
        cart = StorageCartManager.shared.loadCart()
        presenter?.didFetchCartProducts(cart.map { $0.product })
    }
}
