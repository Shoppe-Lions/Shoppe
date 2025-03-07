//
//  CartRouter.swift
//  Shoppe
//
//  Created by Artem Kriukov on 04.03.2025.
//

import UIKit

protocol CartRouterProtocol {
    static func createModule() -> UIViewController
    
}

final class CartRouter: CartRouterProtocol {
    static func createModule() -> UIViewController {
        let view = CartViewController()
        let router = CartRouter()
        let interactor = CartInteractor()
        let presenter = CartPresenter(view: view, interactor: interactor, router: router)

        view.presenter = presenter
        interactor.presenter = presenter

        return view
    }
}
