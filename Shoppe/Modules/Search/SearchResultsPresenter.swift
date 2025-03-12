//
//  SearchResultsPresenter.swift
//  Shoppe
//
//  Created by ordoko on 11.03.2025.
//

import Foundation

protocol SearchResultsPresenterProtocol: AnyObject {
    var filteredProducts: [Product] { get } //?
    func didFilterProducts(with query: String)
    func loadHistory()
    func didLoadHistory()
    func getSearchHistory() -> [String]
    func didSaveSearchQuery(_ query: String)
    func didRemoveHistory()
    func toggleWishlist(for product: Product)
    func didSelectProduct(_ product: Product)
}

final class SearchResultsPresenter: SearchResultsPresenterProtocol {
    var filteredProducts: [Product] = []
    private var products: [Product] = []
    private var searchHistory: [String] = []
    
    weak var view: SearchResultsViewProtocol?
    var interactor: SearchResultsInteractorProtocol
    var router: SearchResultsRouterProtocol
    
    init(
        view: SearchResultsViewProtocol,
        interactor: SearchResultsInteractorProtocol,
        router: SearchResultsRouterProtocol,
        products: [Product]
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.products = products
    }
    
    func didFilterProducts(with query: String) {
        filteredProducts = products.filter { $0.title.lowercased().contains(query.lowercased()) }
    }
    
    func loadHistory() {
        searchHistory = interactor.loadSearchHistory()
    }
    
    func getSearchHistory() -> [String] {
        return searchHistory
    }
    
    func didSaveSearchQuery(_ query: String) {
        if !searchHistory.contains(query) {
            searchHistory.insert(query, at: 0)
            if searchHistory.count > 10 {
                searchHistory.removeLast()
            }
            interactor.saveSearchHistory(searchHistory)
        }
    }
    
    //?
    func didLoadHistory() {
        view?.reloadData() //?
    }
    
    func didRemoveHistory() {
        interactor.removeSearchHistory()
        searchHistory = []
        view?.reloadHistory()
    }
    
    func toggleWishlist(for product: Product) {
        interactor.toggleWishlistStatus(for: product)
        if let index = filteredProducts.firstIndex(where: { $0.id == product.id }) {
            filteredProducts[index].like.toggle()
        }
        view?.reloadData()
    }
    
    func didSelectProduct(_ product: Product) {
        guard let view = view else { print("no view"); return }
        router.openProductDetail(from: view, with: product)
    }
}
