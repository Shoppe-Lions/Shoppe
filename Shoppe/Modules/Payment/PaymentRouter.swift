//
//  PaymentRouter.swift
//  Shoppe
//
//  Created by Dmitry Volkov on 05/03/2025.
//

import UIKit


protocol AnyPaymentRouter: AnyObject {
    static func createModule(product: CartItem?) -> UIViewController
    func navigateToCart(from view: UIViewController)
}

final class PaymentRouter: AnyPaymentRouter {
    static func createModule(product: CartItem? = nil) -> UIViewController {
        let router = PaymentRouter()
        
        let view = PaymentViewController()
        let interactor = PaymentInteractor()
        let presenter = PaymentPresenter(view: view, router: router, interactor: interactor, product: product)
        
        view.presenter = presenter
        interactor.presenter = presenter
     
        return view
    }
    
    func navigateToCart(from view: UIViewController) {
        if let navigationController = view.navigationController {
                navigationController.popViewController(animated: true)
        }
        
        if let tabBarController = view.tabBarController {
            tabBarController.selectedIndex = 3
        }
    }
}
