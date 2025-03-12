//
//  HomeRouterProtocol.swift
//  Shoppe
//
//  Created by Victor Garitskyu on 11.03.2025.
//

import UIKit

protocol HomeRouterProtocol: AnyObject {
    static func createModule() -> UIViewController
    func openCart()
    func openProductDetail(from view: HomeViewProtocol, with product: Product)
    func openAllCategories()
}

final class HomeRouter: HomeRouterProtocol {
    weak var view: UIViewController?
    
    static func createModule() -> UIViewController {
        let view = HomeViewController()
        let router = HomeRouter()
        let interactor = HomeInteractor()
        let presenter = HomePresenter(view: view, interactor: interactor, router: router)
        
        view.presenter = presenter
        interactor.presenter = presenter
        router.view = view
        
        return view
    }
    
    func openCart() {
        // Реализация перехода в корзину
    }
    
    func openProductDetail(from view: HomeViewProtocol, with product: Product) {
        if let sourceVC = view as? UIViewController {
            // TODO: раскомментировать когда будет готов детальный экран
            // let detailVC = ProductDetailRouter.createModule(with: product)
            // sourceVC.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    func openAllCategories() {
        if let sourceVC = view as? UIViewController {
            let allCategoriesVC = AllCategoriesRouter.createModule()
            // Настраиваем полноэкранное представление
            allCategoriesVC.modalPresentationStyle = .fullScreen
            sourceVC.present(allCategoriesVC, animated: true)
        }
    }
    
}
