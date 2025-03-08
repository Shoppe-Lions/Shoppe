//
//  ProductRouter.swift
//  Shoppe
//
//  Created by Игорь Клевжиц on 05.03.2025.
//
import UIKit

protocol ProductRouterProtocol: AnyObject {
    static func createModule() -> UIViewController
    func goToBuyNow(by id: Int)
}

class ProductRouter: ProductRouterProtocol {
    static func createModule() -> UIViewController {
        let view = ProductViewController()
        let interactor = ProductInteractor()
        let router = ProductRouter()
        let presenter = ProductPresenter(view: view, interactor: interactor, router: router)

        view.presenter = presenter
        interactor.presenter = presenter

        return view
    }
    
    func goToBuyNow(by id: Int) {
        
    }
}
