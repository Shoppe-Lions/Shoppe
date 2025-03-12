//
//  ProductPresenter.swift
//  Shoppe
//
//  Created by Игорь Клевжиц on 05.03.2025.
//
import UIKit

protocol ProductPresenterProtocol: AnyObject {
    func viewDidLoad(id: Int)
    func toggleLike(id: Int)
    func setLike(by like: Bool)
    func buyNow(by id: Int)
    func goToNextProduct(by id: Int, navigationController: UINavigationController?)
    func addToCart(by id: Int)
    func deleteFromCart(for id: Int)
    func setCartCount(by count: Int)
}

class ProductPresenter: ProductPresenterProtocol {
    weak var view: ProductViewProtocol?
    var interactor: ProductInteractorProtocol
    var router: ProductRouterProtocol
    
    init(view: ProductViewProtocol, interactor: ProductInteractorProtocol, router: ProductRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoad(id: Int) {        
        interactor.fetchProductWithSubcategories(by: id) { product, subcategoryProsucts in
            if let product = product {
                self.view?.showProduct(product)
            }
            self.view?.showSubcategoryes(by: subcategoryProsucts)
        }
    }
    
    func toggleLike(id: Int) {
        interactor.toggleLike(by: id)
    }
    
    func setLike(by like: Bool) {
        view?.setLike(by: like)
    }
    
    func addToCart(by id: Int) {
        interactor.addToCart(by: id)
    }
    func deleteFromCart(for id: Int) {
        interactor.deleteFromCart(for: id)
    }
    
    func buyNow(by id: Int) {
        interactor.fetchProductWithSubcategories(by: id) { product, _ in
            if let product = product {
                self.router.goToBuyNow(by: product)
            }
        }
    }
    
    func goToNextProduct(by id: Int, navigationController: UINavigationController?) {
        router.goToNextProduct(by: id, navigationController: navigationController)
    }
    
    func setCartCount(by count: Int) {
        view?.setCartCount(by: count)
    }
}
