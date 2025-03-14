//
//  WIshlistPresenter.swift
//  Shoppe
//
//  Created by ordoko on 04.03.2025.
//

import Foundation

protocol WishlistPresenterProtocol: AnyObject {
    var products: [Product] { get }
    var viewModel: PresentingControllerViewModel { get set }
    
    func getTitle() -> String
    func viewDidLoad()
    func didPullToRefresh()
    func didFetchWishlistProducts(_ products: [Product])
    func didSelectProduct(_ product: Product)
    func toggleWishlist(for product: Product)
}

final class WishlistPresenter: WishlistPresenterProtocol {
    var products: [Product] = []
    var viewModel: PresentingControllerViewModel
    
    weak var view: WishlistViewProtocol?
    var interactor: WishlistInteractorProtocol
    var router: WishlistRouterProtocol
    
    init(
        view: WishlistViewProtocol,
        interactor: WishlistInteractorProtocol,
        router: WishlistRouterProtocol,
        viewModel: PresentingControllerViewModel
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.viewModel = viewModel
    }
    
    func viewDidLoad() {
        if let productsFromAnotherController = viewModel.products {
            didFetchWishlistProducts(productsFromAnotherController)
        } else {
            interactor.fetchWishlistProducts()
        }
    }
    
    func getTitle() -> String {
        return viewModel.title
    }
    
    func didFetchWishlistProducts(_ products: [Product]) {
        self.products = products
        view?.reloadData()
        view?.hideLoadingIndicator()
        view?.setupSearchController() //todo
    }
    
//    func didFailToFetchProducts(_ error: Error) {
//           view?.showError(error.localizedDescription)
//           view?.hideLoadingIndicator()
//       }
    
    func didSelectProduct(_ product: Product) {
        guard let view = view else { print("no view"); return }
        router.openProductDetail(from: view, with: product)
    }
    
    func toggleWishlist(for product: Product) {
        interactor.toggleWishlistStatus(for: product)
        if let index = products.firstIndex(where: { $0.id == product.id }) {
            products[index].like.toggle()
        }
        view?.reloadData()
    }
    
    func didPullToRefresh() {
        interactor.fetchWishlistProducts()
    }
}
