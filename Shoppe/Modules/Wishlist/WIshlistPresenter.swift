//
//  WIshlistPresenter.swift
//  Shoppe
//
//  Created by ordoko on 04.03.2025.
//

import Foundation

protocol WishlistPresenterProtocol: AnyObject {
    var products: [Product] { get }
    func viewDidLoad()
    func didFetchWishlistProducts(_ products: [Product])
    func didSelectProduct(_ product: Product)
    func toggleWishlist(for product: Product)
}

final class WishlistPresenter: WishlistPresenterProtocol {
    var products: [Product] = []
    
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
        self.products = products
        view?.reloadData()
    }
    
    func didSelectProduct(_ product: Product) {
        print("open detail")
        guard let view = view else { print("no view"); return }
        router.openProductDetail(from: view, with: product)
    }
    
    func toggleWishlist(for product: Product) {
        interactor.toggleWishlistStatus(for: product)
        view?.reloadData()
    }
}
