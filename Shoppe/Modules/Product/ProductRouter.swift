//
//  ProductRouter.swift
//  Shoppe
//
//  Created by Игорь Клевжиц on 05.03.2025.
//
import UIKit

protocol ProductRouterProtocol: AnyObject {
    static func createModule(by id: Int, navigationController: UINavigationController?) -> UIViewController
    func goToBuyNow(by product: CartItem)
    func goToNextProduct(by id: Int, navigationController: UINavigationController?)
}

class ProductRouter: ProductRouterProtocol {
    
    weak var navigationController: UINavigationController?
    
    static func createModule(by id: Int, navigationController: UINavigationController?) -> UIViewController {
        let view = ProductViewController()
        let interactor = ProductInteractor()
        let router = ProductRouter()
        let presenter = ProductPresenter(view: view, interactor: interactor, router: router)
        
        view.id = id
        view.presenter = presenter
        interactor.presenter = presenter
        router.navigationController = navigationController

        return view
    }
    
    func goToBuyNow(by product: CartItem) {
        let payVC = PaymentRouter.createModule(product: product)
        navigationController?.pushViewController(payVC, animated: true)
    }
    
    func goToNextProduct(by id: Int, navigationController: UINavigationController?) {
        let newVC = ProductRouter.createModule(by: id, navigationController: navigationController)
        navigationController?.pushViewController(newVC, animated: true)
    }
}
