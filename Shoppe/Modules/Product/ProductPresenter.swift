//
//  ProductPresenter.swift
//  Shoppe
//
//  Created by Игорь Клевжиц on 05.03.2025.
//
import Foundation

protocol ProductPresenterProtocol: AnyObject {
    func viewDidLoad()
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
    
    func viewDidLoad() {
        interactor.loadProducts { products in
            self.products = products
        }
        
        interactor.fetchProduct { product in
            guard let product = product else {
                self.view?.showError("Ошибка загрузки товара")
                return
            }
            
            self.view?.showProduct(product)
            
            if let products = self.products {
                let count = products.filter { $0.subcategory == product.subcategory }.count
                self.view?.showSubcategoryes(count: count - 1)
            }
            
            ImageLoader.shared.loadImage(from: product.image) { [weak self] image in
                DispatchQueue.main.async {
                    self?.view?.showImage(image)
                }
            }
        }
    }
}
