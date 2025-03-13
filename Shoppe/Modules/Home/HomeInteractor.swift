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
}

class HomeInteractor: HomeInteractorProtocol {
    private let cities = [
        "🇺🇸  America → $",
        "🇷🇺  Russia → ₽",
        "🇪🇺  Europe → €",
        "🌍  Other world → $"
    ]
    
    private var selectedCity = "🇺🇸  America → $"
    
    private let apiService = APIService()
    
    weak var presenter: HomePresenterProtocol?
    
    func fetchCategories() {
        apiService.fetchProducts { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let products):
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
        return selectedCity
    }
    
    func updateSelectedLocation(_ location: String) {
        selectedCity = location
    }
    
    func updateSelectedCurrency(_ row: Int) {
        switch row {
            case 0: CurrencyManager.shared.currentCurrency = "USD"
            case 1: CurrencyManager.shared.currentCurrency = "RUBL"
            case 2: CurrencyManager.shared.currentCurrency = "EUR"
            case 3: CurrencyManager.shared.currentCurrency = "USD"
            default: CurrencyManager.shared.currentCurrency = "USD"
        }
        print("NEW CURRENCY")
        print(CurrencyManager.shared.currentCurrency)
    }
    
    func toggleWishlistStatus(for product: Product) {
        apiService.toggleLike(for: product)
    }
}
