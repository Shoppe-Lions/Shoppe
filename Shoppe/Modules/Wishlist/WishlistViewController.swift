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
    
    private var products: [Product] = []

    func didTapWishListButton() {
        //todo
    }
    
    func showWishListProducts(_ products: [Product]) {
        //todo
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cell = ProductCell(frame: CGRect(x: 20, y: 100, width: 300, height: 600))
        view.addSubview(cell)
        
      
        
    }
}
