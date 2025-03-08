//
//  ProductPresenter.swift
//  Shoppe
//
//  Created by Игорь Клевжиц on 05.03.2025.
//
import Foundation

protocol ProductPresenterProtocol: AnyObject {
    func viewDidLoad(id: Int)
    func toggleLike(id: Int)
    func setLike(by like: Bool)
}

class ProductPresenter: ProductPresenterProtocol {
    weak var view: ProductViewProtocol?
    var interactor: ProductInteractorProtocol
    var router: ProductRouterProtocol
    
    var products: [Product]?
    
    init(view: ProductViewProtocol, interactor: ProductInteractorProtocol, router: ProductRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoad(id: Int) {
        interactor.loadProducts { products in
            self.products = products
        }
        
        interactor.fetchProduct(id: id) { product in
            // Хочу удалить гвард
            guard let product = product else {
                self.view?.showError("Ошибка загрузки товара")
                return
            }
            
            self.view?.showProduct(product)
            
            if let products = self.products {
                let count = products.filter { $0.subcategory == product.subcategory }.count
                self.view?.showSubcategoryes(count: count - 1)
            }
        }
    }
    
    func toggleLike(id: Int) {
        interactor.toggleLike(id: id)
    }
    
    func setLike(by like: Bool) {
        view?.setLike(by: like)
    }
}
