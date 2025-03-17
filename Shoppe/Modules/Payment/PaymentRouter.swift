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
    func showEditAddress(from view: UIViewController)
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
    
    func showEditAddress(from view: UIViewController) {
        let addressesVC = AddressesViewController()
        addressesVC.onAddressSelected = { [weak self] selectedAddress in
            //self?.updateAddress(with: selectedAddress)
        }
            
        let nav = UINavigationController(rootViewController: addressesVC)
        nav.modalPresentationStyle = .pageSheet
            
        if let sheet = nav.sheetPresentationController {
            let customDetent = UISheetPresentationController.Detent.custom { context in
                return context.maximumDetentValue * 0.3
            }
            sheet.detents = [customDetent]
        }
            
        view.present(nav, animated: true)
    }
}
