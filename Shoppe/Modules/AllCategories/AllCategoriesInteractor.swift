//
//  AllCategoriesInteractor.swift
//  Shoppe
//
//  Created by Игорь Клевжиц on 11.03.2025.
//

protocol AllCategoriesInteractorProtocol: AnyObject {
    func fetchCategories()
    func fetchSelectedSubcategory(_ subcategory: String)
}

final class AllCategoriesInteractor: AllCategoriesInteractorProtocol {
    weak var presenter: AllCategoriesPresenterProtocol?
    
    private let apiService = APIService.shared
    
    func fetchCategories() {
        apiService.fetchProducts { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let products):
                var categoryDict: [String: Set<String>] = [:]
                var categoryImages: [String: String] = [:]
                
                for product in products {
                    let category = product.category
                    let subcategory = product.subcategory
                    
                    if categoryDict[category] != nil {
                        categoryDict[category]?.insert(subcategory)
                    } else {
                        categoryDict[category] = [subcategory]
                        categoryImages[category] = product.localImagePath
                    }
                }
                
                var categories = categoryDict.map { (category, subcategoriesSet) in
                    Category(
                        title: category,
                        imagePath: categoryImages[category] ?? "",
                        subcategories: Array(subcategoriesSet),
                        isExpanded: false
                    )
                }
                
                categories.sort { $0.title.lowercased() < $1.title.lowercased() }
                
                self.presenter?.didFetchCategories(categories)
                
            case .failure(let error):
                print("Failed to fetch products: \(error)")
            }
        }
    }
    
    func fetchSelectedSubcategory(_ subcategory: String) {
        apiService.fetchProducts { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let products):
                let subProducts = products.filter { $0.subcategory == subcategory }
                self.presenter?.goToShop(subProducts)
            case .failure(let error):
                print("Failed to fetch products: \(error)")
            }
        }
    }
}
