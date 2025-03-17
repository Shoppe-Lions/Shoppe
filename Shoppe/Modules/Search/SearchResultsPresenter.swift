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
    func getSearchHistory() -> [String]
    func didSaveSearchQuery(_ query: String)
    func didRemoveHistory()
    func toggleWishlist(for product: Product)
    func didSelectProduct(_ product: Product)
    func getTitle() -> String
}

final class SearchResultsPresenter: SearchResultsPresenterProtocol {
    var filteredProducts: [Product] = []
    private var products: [Product]?
    private var searchHistory: [String] = []
    private var viewModel: PresentingControllerViewModel
    
    weak var view: SearchResultsViewProtocol?
    var interactor: SearchResultsInteractorProtocol
    var router: SearchResultsRouterProtocol
    
    init(
        view: SearchResultsViewProtocol,
        interactor: SearchResultsInteractorProtocol,
        router: SearchResultsRouterProtocol,
        viewModel: PresentingControllerViewModel
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.products = viewModel.products
        self.viewModel = viewModel
    }
    
    func didFilterProducts(with query: String) {
        guard let products = products else {
            print("no products in searchResultController ")
            return
        }
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
    
    func getTitle() -> String {
        return viewModel.title
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
            view?.updateCell(at: index)
        }
    }
    
    func didSelectProduct(_ product: Product) {
        guard let view = view else { print("no view"); return }
        router.openProductDetail(from: view, with: product)
    }
}
