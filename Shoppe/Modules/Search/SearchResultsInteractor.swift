//
//  SearchResultsInteractor.swift
//  Shoppe
//
//  Created by ordoko on 11.03.2025.
//

import Foundation


protocol SearchResultsInteractorProtocol {
    func loadSearchHistory() -> [String]
    func saveSearchHistory(_ searchHistory: [String])
    func removeSearchHistory()
    func toggleWishlistStatus(for product: Product)
}

final class SearchResultsInteractor: SearchResultsInteractorProtocol {

    weak var presenter: SearchResultsPresenterProtocol?
   
    private let apiService = APIService.shared

    func loadSearchHistory() -> [String] {
        return UserDefaults.standard.stringArray(forKey: "SearchHistory") ?? []
    }
    
    func saveSearchHistory(_ searchHistory: [String]) {
        UserDefaults.standard.set(searchHistory, forKey: "SearchHistory")
    }
    
    func removeSearchHistory() {
        UserDefaults.standard.removeObject(forKey: "SearchHistory")
    }
    
    func toggleWishlistStatus(for product: Product) {
        apiService.toggleLike(for: product)
    }

}
