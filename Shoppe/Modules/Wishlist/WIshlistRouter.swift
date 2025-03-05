//
//  WIshlistRouter.swift
//  Shoppe
//
//  Created by ordoko on 04.03.2025.
//

import UIKit

protocol WishlistRouterProtocol {
    static func createModule() -> UIViewController
    func openProductDetail(from view: WishlistViewProtocol, with product: Product)
}

final class WishlistRouter: WishlistRouterProtocol {

    static func createModule() -> UIViewController {
        let view = WishlistViewController()
        let router = WishlistRouter()
        let interactor = WishlistInteractor()
        let presenter = WishlistPresenter(view: view, interactor: interactor, router: router)
        
        view.presenter = presenter
        interactor.presenter = presenter

        return view
    }
    
    func openProductDetail(from view: any WishlistViewProtocol, with product: Product) {
        //TODO: разкомментировать когда будет готов детальный экран
//        let detailVC = ProductDetailRouter.createModule(with: product)
//        
//        if let sourceVC = view as? UIViewController {
//            sourceVC.navigationController?.pushViewController(detailVC, animated: true)
//        }
    }
    
}

