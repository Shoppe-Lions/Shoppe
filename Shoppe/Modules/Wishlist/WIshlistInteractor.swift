//
//  WIshlistInteractor.swift
//  Shoppe
//
//  Created by ordoko on 04.03.2025.
//

import Foundation

protocol WishlistInteractorProtocol {
    func fetchWishlistProducts()
}

final class WishlistInteractor: WishlistInteractorProtocol {
    weak var presenter: WishlistPresenterProtocol?
    
    func fetchWishlistProducts() {
        let sampleProducts = [
            Product(id: 1, title: "Lorem ipsum dolor sit amet consectetur", price: 199.99, description: "", category: "", image: "testPhotoImage", rating: Rating(rate: 5, count: 25), subcategory: "test", like: false),
            Product(id: 1, title: "Lorem ipsum dolor sit amet consectetur", price: 199.99, description: "", category: "", image: "testPhotoImage", rating: Rating(rate: 5, count: 25), subcategory: "test", like: false),
            Product(id: 1, title: "Red dress", price: 199.99, description: "", category: "", image: "testPhotoImage", rating: Rating(rate: 5, count: 25), subcategory: "test", like: false),
            Product(id: 1, title: "Red dress", price: 199.99, description: "", category: "", image: "testPhotoImage", rating: Rating(rate: 5, count: 25), subcategory: "test", like: false),
            Product(id: 1, title: "Red dress", price: 199.99, description: "", category: "", image: "testPhotoImage", rating: Rating(rate: 5, count: 25), subcategory: "test", like: false),
            Product(id: 1, title: "Red dress", price: 199.99, description: "", category: "", image: "testPhotoImage", rating: Rating(rate: 5, count: 25), subcategory: "test", like: false),
            Product(id: 1, title: "Red dress", price: 199.99, description: "", category: "", image: "testPhotoImage", rating: Rating(rate: 5, count: 25), subcategory: "test", like: false),
            Product(id: 1, title: "Red dress", price: 199.99, description: "", category: "", image: "testPhotoImage", rating: Rating(rate: 5, count: 25), subcategory: "test", like: false)
        ]
        presenter?.didFetchWishlistProducts(sampleProducts)
    }
}
