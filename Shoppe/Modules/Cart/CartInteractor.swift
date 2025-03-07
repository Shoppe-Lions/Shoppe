//
//  CartInteractor.swift
//  Shoppe
//
//  Created by Artem Kriukov on 04.03.2025.
//

import Foundation


protocol CartInteractorProtocol: AnyObject {
    func fetchCartProducts()
}

final class CartInteractor: CartInteractorProtocol {
    weak var presenter: CartPresenterProtocol?

    let sampleProducts = [
        Product(id: 1, title: "Lorem ipsum dolor sit amet consectetur", price: 199.99, description: "", category: "", image: "Cell", rating: Rating(rate: 5, count: 25), subcategory: "test", like: false),
        Product(id: 2, title: "Red dress", price: 199.99, description: "", category: "", image: "Cell", rating: Rating(rate: 5, count: 25), subcategory: "test", like: false)
    ]
    
    func fetchCartProducts() {
        print("Fetching cart products...")
        presenter?.didFetchCartProducts(sampleProducts)
    }
}
