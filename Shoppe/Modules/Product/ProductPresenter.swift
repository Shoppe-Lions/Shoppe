//
//  ProductPresenter.swift
//  Shoppe
//
//  Created by Игорь Клевжиц on 05.03.2025.
//
import Foundation
import UIKit

protocol ProductPresenterProtocol: AnyObject {
    func viewDidLoad(id: Int)
    func toggleLike(id: Int)
    func setLike(by like: Bool)
    func buyNow(by id: Int)
    func goToNextProduct(by id: Int, navigationController: UINavigationController?)
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
        interactor.toggleLike(id: id)
    }
    
    func setLike(by like: Bool) {
        view?.setLike(by: like)
    }
    
    func buyNow(by id: Int) {
        router.goToBuyNow(by: id)
    }
    
    func goToNextProduct(by id: Int, navigationController: UINavigationController?) {
        router.goToNextProduct(by: id, navigationController: navigationController)
    }
}
