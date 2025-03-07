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
}
