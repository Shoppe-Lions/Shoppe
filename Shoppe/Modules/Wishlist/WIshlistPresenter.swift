//
//  WIshlistPresenter.swift
//  Shoppe
//
//  Created by ordoko on 04.03.2025.
//

import Foundation

protocol WishlistPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didFetchWishlistProducts(_ products: [Product])
    func didSelectProduct(_ product: Product)
}

final class WishlistPresenter: WishlistPresenterProtocol {
    weak var view: WishlistViewProtocol?
    var interactor: WishlistInteractorProtocol
    var router: WishlistRouterProtocol
    
    init(
        view: WishlistViewProtocol,
        interactor: WishlistInteractorProtocol,
        router: WishlistRouterProtocol
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoad() {
        interactor.fetchWishlistProducts()
    }
    
    func didFetchWishlistProducts(_ products: [Product]) {
        view?.showWishListProducts(products)
    }
    
    func didSelectProduct(_ product: Product) {
        print("open detail")
        guard let view = view else { print("no view"); return }
        router.openProductDetail(from: view, with: product)
    }
}
