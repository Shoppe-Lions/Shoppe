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
    func updateSelectedCurrency(_ row: Int)
    func fetchProductsByCategory(_ category: String, completion: @escaping (Result<[Product], NetworkError>) -> Void)
    func refreshRandomizedProducts()
    func toggleWishlistStatus(for product: Product)
}

class HomeInteractor: HomeInteractorProtocol {
    private let cities = [
        "🇺🇸  America → $",
        "🇷🇺  Russia → ₽",
        "🇪🇺  Europe → €",
        "🌍  Other world → $"
    ]
    
    private var selectedCity = "🇺🇸  America → $"
    
    private let apiService = APIService.shared
    
    weak var presenter: HomePresenterProtocol?
    
    func fetchCategories() {
        apiService.fetchProducts { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let products):
                presenter?.products = products
                var categoryDict: [String: (Set<String>, [String], Int)] = [:] // [Category: (Products, Images, Count)]
                
                // Собираем все категории и их изображения
                for product in products {
                    let category = product.category
                    if categoryDict[category] == nil {
                        categoryDict[category] = (Set([product.title]), [product.localImagePath], 1)
                    } else {
                        categoryDict[category]?.0.insert(product.title)
                        // Добавляем путь к изображению, если оно еще не добавлено и есть место
                        if categoryDict[category]?.1.count ?? 0 < 4 {
                            categoryDict[category]?.1.append(product.localImagePath)
                        }
                        // Увеличиваем счетчик элементов
                        categoryDict[category]?.2 += 1
                    }
                }
                
                // Преобразуем в ShopCategory
                let categories = categoryDict.map { (category, value) in
                    ShopCategory(
                        title: category,
                        image: value.1.first ?? "testPhotoImage",
                        itemCount: value.2, // Используем реальное количество элементов
                        subcategoryImages: Array(value.1.prefix(4))
                    )
                }.sorted { $0.title.lowercased() < $1.title.lowercased() }
                
                // Берем только первые 6 категорий для главного экрана
                let limitedCategories = Array(categories.prefix(6))
                
                DispatchQueue.main.async {
                    self.presenter?.view?.displayCategories(limitedCategories)
                }
                
            case .failure(let error):
                print("Error fetching categories: \(error)")
            }
        }
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
//        let currentCurrency = CurrencyManager.shared.currentCurrency
//        switch currentCurrency {
//            case "$": selectedCity = cities[0]
//            case "₽": selectedCity = cities[1]
//            case "€": selectedCity = cities[2]
//            default: selectedCity = cities[3]
//        }
        let currentLocation = CurrencyManager.shared.currentLocation
        switch currentLocation {
            case "USA": selectedCity = cities[0]
            case "Russia": selectedCity = cities[1]
            case "Europe": selectedCity = cities[2]
            default: selectedCity = cities[3]
        }
        return selectedCity
    }
    
    func updateSelectedLocation(_ location: String) {
        selectedCity = location
    }
    
    func updateSelectedCurrency(_ row: Int) {
        switch row {
        case 0:
            CurrencyManager.shared.currentCurrency = "$"
            CurrencyManager.shared.currentLocation = "USA"
            
        case 1:
            CurrencyManager.shared.currentCurrency = "₽"
            CurrencyManager.shared.currentLocation = "Russia"
            
        case 2:
            CurrencyManager.shared.currentCurrency = "€"
            CurrencyManager.shared.currentLocation = "Europe"
            
        case 3:
            CurrencyManager.shared.currentCurrency = "$"
            CurrencyManager.shared.currentLocation = "Other"
            
        default:
            CurrencyManager.shared.currentCurrency = "$"
            CurrencyManager.shared.currentLocation = "Other"
        }
    }
    
    func toggleWishlistStatus(for product: Product) {
        apiService.toggleLike(for: product)
    }
    
    func fetchProductsByCategory(_ category: String, completion: @escaping (Result<[Product], NetworkError>) -> Void) {
        apiService.fetchProductsByCategory(category, completion: completion)
    }
    
    func refreshRandomizedProducts() {
        apiService.fetchProducts { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let products):
                // Перемешиваем продукты
                let shuffledProducts = products.shuffled()
                
                // Берем первые 6 для Popular секции
                let popularProducts = Array(shuffledProducts.prefix(6))
                
                // Берем следующие 8 для Just For You секции
                let startIndex = 6
                let endIndex = min(startIndex + 8, shuffledProducts.count)
                let justForYouProducts = Array(shuffledProducts[startIndex..<endIndex])
                
                DispatchQueue.main.async {
                    self.presenter?.view?.displayPopularProducts(popularProducts)
                    self.presenter?.view?.displayJustForYouProducts(justForYouProducts)
                    self.presenter?.view?.endRefreshing()
                }
                
            case .failure(let error):
                print("Error refreshing products: \(error)")
                DispatchQueue.main.async {
                    self.presenter?.view?.endRefreshing()
                }
            }
        }
    }
}
