//
//  PaymentRouter.swift
//  Shoppe
//
//  Created by Dmitry Volkov on 05/03/2025.
//

import UIKit


protocol AnyPaymentRouter: AnyObject {
    static func createModule() -> UIViewController
}

final class PaymentRouter: AnyPaymentRouter {
    static func createModule() -> UIViewController {
        let router = PaymentRouter()
        
        let view = PaymentViewController()
        let interactor = PaymentInteractor()
        let presenter = PaymentPresenter(view: view, router: router, interactor: interactor)
        
        view.presenter = presenter
        interactor.presenter = presenter
     
        return view
    }
}
