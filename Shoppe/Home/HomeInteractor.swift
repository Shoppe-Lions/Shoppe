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
        let popularProducts = [
            Product(id: 1,
                   title: "Blue Sport Shoes",
                   price: 17.00,
                   description: "Comfortable sport shoes",
                   category: "Shoes",
                   imageURL: "testPhotoImage",
                   rating: Rating(rate: 4.5, count: 120),
                   subcategory: "Sport",
                   like: false),
            Product(id: 2,
                   title: "Red Running Shoes",
                   price: 32.00,
                   description: "Professional running shoes",
                   category: "Shoes",
                   imageURL: "testPhotoImage",
                   rating: Rating(rate: 4.8, count: 230),
                   subcategory: "Running",
                   like: false),
            Product(id: 3,
                   title: "White Sneakers",
                   price: 21.00,
                   description: "Casual sneakers",
                   category: "Shoes",
                   imageURL: "testPhotoImage",
                   rating: Rating(rate: 4.3, count: 180),
                   subcategory: "Casual",
                   like: false)
        ]
        presenter?.view?.displayPopularProducts(popularProducts)
    }
    
    func fetchJustForYouProducts() {
        let justForYouProducts = [
            Product(id: 4,
                   title: "Sunglasses",
                   price: 17.00,
                   description: "Stylish sunglasses",
                   category: "Accessories",
                   imageURL: "testPhotoImage",
                   rating: Rating(rate: 4.2, count: 95),
                   subcategory: "Eyewear",
                   like: false),
            Product(id: 5,
                   title: "Summer Hat",
                   price: 17.00,
                   description: "Beach hat",
                   category: "Accessories",
                   imageURL: "testPhotoImage",
                   rating: Rating(rate: 4.0, count: 150),
                   subcategory: "Hats",
                   like: false),
            Product(id: 6,
                   title: "Beach Bag",
                   price: 17.00,
                   description: "Large beach bag",
                   category: "Bags",
                   imageURL: "testPhotoImage",
                   rating: Rating(rate: 4.6, count: 210),
                   subcategory: "Beach",
                   like: false),
            Product(id: 7,
                   title: "Sandals",
                   price: 17.00,
                   description: "Summer sandals",
                   category: "Shoes",
                   imageURL: "testPhotoImage",
                   rating: Rating(rate: 4.4, count: 175),
                   subcategory: "Summer",
                   like: false)
        ]
        presenter?.view?.displayJustForYouProducts(justForYouProducts)
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
} 
