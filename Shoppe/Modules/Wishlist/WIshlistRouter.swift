//
//  WIshlistRouter.swift
//  Shoppe
//
//  Created by ordoko on 04.03.2025.
//

import UIKit

protocol WishlistRouterProtocol {
    static func createModule() -> UIViewController
}

final class WishlistRouter: WishlistRouterProtocol {
    static func createModule() -> UIViewController {
        let view = WishlistViewController()
        let router = WishlistRouter()
        let interactor = WishlistInteractor()
        let presenter = WishlistPresenter()
        

        return view
    }
    
    
}
