//
//  AllCategoriesRouter.swift
//  Shoppe
//
//  Created by Игорь Клевжиц on 11.03.2025.
//

import UIKit

protocol AllCategoriesRouterProtocol {
    static func createModule() -> UIViewController
    func showShopViewController(_ products: [Product])
}

final class AllCategoriesRouter: AllCategoriesRouterProtocol {
    
    weak var view: UIViewController?
    
    static func createModule() -> UIViewController {
        let view = AllCategoriesViewController()
        let router = AllCategoriesRouter()
        let interactor = AllCategoriesInteractor()
        let presenter = AllCategoriesPresenter(view: view, interactor: interactor, router: router)
        
        view.presenter = presenter
        interactor.presenter = presenter
        router.view = view
        
        return view
    }
    
    func showShopViewController(_ products: [Product]) {
//        let viewModel = PresentingControllerViewModel(title: "Shop", products: products)
//        let vc = WishlistRouter.createModule(viewModel: viewModel)
//        navigationController?.pushViewController(vc, animated: false)
    }
}
