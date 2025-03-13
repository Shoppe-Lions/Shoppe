//
//  CartPresenter.swift
//  Shoppe
//
//  Created by Artem Kriukov on 04.03.2025.
//

import Foundation

protocol CartPresenterProtocol: AnyObject {
    func viewDidLoad()
    func fetchCartProducts()
    func didFetchCartProducts(_ products: [Product])
    func didUpdateProduct(at index: Int, product: Product, quantity: Int)
    func increaseProductQuantity(at index: Int)
    func decreaseProductQuantity(at index: Int)
    func getQuantity(for productId: Int) -> Int
    func updateCartCount()
    func updateTotalPrice()
    func didTapCheckoutButton()
    func deleteProduct(at index: Int)
    func didSelectProduct(_ product: Product)
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
    
    func fetchCartProducts() {
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
        updateTotalPrice()
    }
    
    func decreaseProductQuantity(at index: Int) {
        interactor.decreaseProductQuantity(at: index)
        updateTotalPrice()
    }
    
    func getQuantity(for productId: Int) -> Int {
        interactor.getQuantity(for: productId)
    }
    
    func updateCartCount() {
        let totalCount = interactor.getTotalProductCount()
        view?.updateCartCount(totalCount)
    }
    
    func updateTotalPrice() {
        let totalPrice = interactor.calculateTotalPrice()
        view?.updateTotalPrice(totalPrice)
    }
    
    func didTapCheckoutButton() {
        router.showPaymentViewController()
    }

    func deleteProduct(at index: Int) {
        interactor.deleteProduct(at: index)
        fetchCartProducts()
        updateCartCount()
        updateTotalPrice()
    }
    
    func didSelectProduct(_ product: Product) {
        guard let view else { return }
        router.showProductViewController(productId: product.id)
    }
}
