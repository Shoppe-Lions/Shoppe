//
//  CartRouter.swift
//  Shoppe
//
//  Created by Artem Kriukov on 04.03.2025.
//

import UIKit

protocol CartRouterProtocol {
    static func createModule() -> UIViewController
    func showPaymentViewController()
}

final class CartRouter: CartRouterProtocol {
    
    weak var view: UIViewController?
    
    static func createModule() -> UIViewController {
        let view = CartViewController()
        let router = CartRouter()
        let interactor = CartInteractor()
        let presenter = CartPresenter(view: view, interactor: interactor, router: router)

        view.presenter = presenter
        interactor.presenter = presenter
        router.view = view
        
        return view
    }
    
    func showPaymentViewController() {
        let paymentVC = PaymentRouter.createModule()
        view?.navigationController?.pushViewController(paymentVC, animated: true)
    }
}
