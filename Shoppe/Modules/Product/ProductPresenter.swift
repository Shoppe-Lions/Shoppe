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
    
    init(view: ProductViewProtocol, interactor: ProductInteractorProtocol, router: ProductRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoad() {
        interactor.fetchProduct { product in
            if let product = product {
                self.view?.showProduct(product)
                ImageLoader.shared.loadImage(from: product.image) { [weak self] image in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        self.view?.showImage(image)
                    }
                }
            } else {
                self.view?.showError("Ошибка загрузки товара")
            }
        }
    }
}
