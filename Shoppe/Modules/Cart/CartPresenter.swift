//
//  CartPresenter.swift
//  Shoppe
//
//  Created by Artem Kriukov on 04.03.2025.
//

import Foundation

protocol CartPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didFetchCartProducts(_ products: [Product])
    func didUpdateProduct(at index: Int, product: Product, quantity: Int)
    func increaseProductQuantity(at index: Int)
    func decreaseProductQuantity(at index: Int)
    func getQuantity(for productId: Int) -> Int
    func updateCartCount()
}

final class CartPresenter: CartPresenterProtocol {
    weak var view: CartViewProtocol?
    var interactor: CartInteractorProtocol
    var router: CartRouterProtocol
    
    init(view: CartViewProtocol, interactor: CartInteractorProtocol, router: CartRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoad() {
        interactor.fetchCartProducts()
    }
    
    func didFetchCartProducts(_ products: [Product]) {
        print("Products fetched: \(products.count)")
        view?.showCartProducts(products)
    }
    
    func didUpdateProduct(at index: Int, product: Product, quantity: Int) {
        view?.updateProduct(at: index, product: product, quantity: quantity)
    }
    
    func increaseProductQuantity(at index: Int) {
        interactor.increaseProductQuantity(at: index)
    }
    
    func decreaseProductQuantity(at index: Int) {
        interactor.decreaseProductQuantity(at: index)
    }
    
    func getQuantity(for productId: Int) -> Int {
        interactor.getQuantity(for: productId)
    }
    
    func updateCartCount() {
        let totalCount = interactor.getTotalProductCount()
        view?.updateCartCount(totalCount)
    }
}
