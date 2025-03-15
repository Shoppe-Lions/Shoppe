//
//  WIshlistInteractor.swift
//  Shoppe
//
//  Created by ordoko on 04.03.2025.
//

import Foundation

protocol WishlistInteractorProtocol {
    func fetchWishlistProducts()
    func toggleWishlistStatus(for product: Product)
}

final class WishlistInteractor: WishlistInteractorProtocol {
  
    weak var presenter: WishlistPresenterProtocol?
    private let apiService = APIService.shared
    
    func fetchWishlistProducts() {
        apiService.fetchLikedProducts {  [weak self] result in
            switch result {
            case .success(let products):
                self?.presenter?.didFetchWishlistProducts(products)          
            case .failure(let error):
                //TODO: обработка ошибок
                print("Error fetching wishlist products: \(error)")
            }
        }
    }
    
    func toggleWishlistStatus(for product: Product) {
        apiService.toggleLike(for: product)
    }
}
