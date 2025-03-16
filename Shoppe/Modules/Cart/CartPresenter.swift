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
    func didFetchCartProducts(_ products: [Product], quantities: [Int])
    func didUpdateProduct(at index: Int, product: Product, quantity: Int)
    func increaseProductQuantity(at index: Int)
    func decreaseProductQuantity(at index: Int)
    func getQuantity(for productId: Int) -> Int
    func updateCartCount()
    func updateTotalPrice()
    func updateCartCount(_ count: Int)
    func updateTotalPrice(_ price: String)
    func didTapCheckoutButton()
    func deleteProduct(at index: Int)
    func didSelectProduct(_ product: Product)
    func clearCart()
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

    func didFetchCartProducts(_ products: [Product], quantities: [Int]) {
        view?.showCartProducts(products, quantities: quantities)
    }

    func didUpdateProduct(at index: Int, product: Product, quantity: Int) {
        view?.updateProduct(at: index, product: product, quantity: quantity)
    }

    func increaseProductQuantity(at index: Int) {
        interactor.increaseProductQuantity(at: index)
        interactor.loadTotalAmount()
    }

    func decreaseProductQuantity(at index: Int) {
        interactor.decreaseProductQuantity(at: index)
        interactor.loadTotalAmount()
    }

    func getQuantity(for productId: Int) -> Int {
        return 0 // Пока что не используется, можно потом переделать в async-стиль
    }

    func updateCartCount() {
        interactor.loadTotalItems()
    }

    func updateTotalPrice() {
        interactor.loadTotalAmount()
    }

    func updateCartCount(_ count: Int) {
        view?.updateCartCount(count)
    }

    func updateTotalPrice(_ price: String) {
        view?.updateTotalPrice(price)
    }

    func didTapCheckoutButton() {
        router.showPaymentViewController()
    }

    func deleteProduct(at index: Int) {
        interactor.deleteProduct(at: index)
    }

    func didSelectProduct(_ product: Product) {
        router.showProductViewController(productId: product.id)
    }
    
    func clearCart() {
        interactor.clearCart()
    }
}

