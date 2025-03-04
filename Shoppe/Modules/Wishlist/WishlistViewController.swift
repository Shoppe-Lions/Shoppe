//
//  WishlistViewController.swift
//  Shoppe
//
//  Created by ordoko on 04.03.2025.
//

import UIKit

protocol WishlistViewProtocol: AnyObject {
    func didTapWishListButton()
    func showWishListProducts(_ products: [Product])
}

final class WishlistViewController: UIViewController, WishlistViewProtocol {
    func didTapWishListButton() {
        //todo
    }
    
    func showWishListProducts(_ products: [Product]) {
        //todo
    }
    
    
}
