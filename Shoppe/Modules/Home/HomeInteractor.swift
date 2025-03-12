//
//  HomeInteractorProtocol.swift
//  Shoppe
//
//  Created by Victor Garitskyu on 11.03.2025.
//

import Foundation

protocol HomeInteractorProtocol: AnyObject {
    func fetchCategories()
    func fetchPopularProducts()
    func fetchJustForYouProducts()
    func getAvailableCities() -> [String]
    func getSelectedCity() -> String
    func updateSelectedLocation(_ location: String)
}

class HomeInteractor: HomeInteractorProtocol {
    private let cities = ["Salatiga City, Central Java", "Jakarta", "Surabaya", "Bandung", "Yogyakarta"]
    private var selectedCity = "Salatiga City, Central Java"
    
    private let apiService = APIService()
    
    weak var presenter: HomePresenterProtocol?
    
    func fetchCategories() {
        let categories = [
            ShopCategory(title: "Clothing", image: "testPhotoImage", itemCount: 109),
            ShopCategory(title: "Shoes", image: "testPhotoImage", itemCount: 530),
            ShopCategory(title: "Bags", image: "testPhotoImage", itemCount: 87),
            ShopCategory(title: "Lingerie", image: "testPhotoImage", itemCount: 218),
            ShopCategory(title: "Watch", image: "testPhotoImage", itemCount: 218),
            ShopCategory(title: "Hoodies", image: "testPhotoImage", itemCount: 218)
        ]
        presenter?.view?.displayCategories(categories)
    }
    
    func fetchPopularProducts() {
        apiService.fetchProducts { [weak self] result in
            switch result {
            case .success(let products):
                // Берем первые 6 продуктов для Popular секции
                let popularProducts = Array(products.prefix(6))
                DispatchQueue.main.async {
                    self?.presenter?.view?.displayPopularProducts(popularProducts)
                }
            case .failure(let error):
                print("Error fetching popular products: \(error)")
            }
        }
    }
    
    func fetchJustForYouProducts() {
        apiService.fetchProducts { [weak self] result in
            switch result {
            case .success(let products):
                // Берем следующие 8 продуктов для Just For You секции
                let startIndex = min(6, products.count)
                let endIndex = min(startIndex + 8, products.count)
                let justForYouProducts = Array(products[startIndex..<endIndex])
                DispatchQueue.main.async {
                    self?.presenter?.view?.displayJustForYouProducts(justForYouProducts)
                }
            case .failure(let error):
                print("Error fetching just for you products: \(error)")
                // Можно добавить обработку ошибок через presenter
            }
        }
    }
    func getAvailableCities() -> [String] {
        return cities
    }
    
    func getSelectedCity() -> String {
        return selectedCity
    }
    
    func updateSelectedLocation(_ location: String) {
        selectedCity = location
    }
    
    func toggleWishlistStatus(for product: Product) {
        apiService.toggleLike(for: product)
    }
}
