//
//  HomePresenterProtocol.swift
//  Shoppe
//
//  Created by Victor Garitskyu on 11.03.2025.
//

import Foundation

protocol HomePresenterProtocol: AnyObject {
    var view: HomeViewProtocol? { get }
    var interactor: HomeInteractorProtocol { get }
    func viewDidLoad()
    func didSelectLocation(_ location: String)
    func didTapLocationButton()
    func didTapCartButton()
    func didTapSeeAllCategories()
    func didCurrencyUpdated()
    func refreshData()
    func didTapSeeAllPopular()
    func didTapSeeAllJustForYou()
}

class HomePresenter: HomePresenterProtocol {
    weak var view: HomeViewProtocol?
    let interactor: HomeInteractorProtocol
    let router: HomeRouterProtocol
    
    init(view: HomeViewProtocol, interactor: HomeInteractorProtocol, router: HomeRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: - HomePresenterProtocol
    func viewDidLoad() {
        interactor.fetchCategories()
        interactor.fetchPopularProducts()
    }
    
    func didSelectLocation(_ location: String) {
        interactor.updateSelectedLocation(location)
        view?.updateLocationLabel(location)
        view?.hideLocationMenu()
    }
    
    func didTapLocationButton() {
        let cities = interactor.getAvailableCities()
        let selectedCity = interactor.getSelectedCity()
        view?.displayLocationMenu(with: cities, selectedCity: selectedCity)
    }
    
    func didTapCartButton() {
        router.openCart()
    }
    
    func didTapSeeAllCategories() {
        router.openAllCategories()
    }
    
    func didCurrencyUpdated() {
        view?.updateCollectionView()
    }
    
    func refreshData() {
        interactor.refreshRandomizedProducts()
    }
    
    func didTapSeeAllPopular() {
        let viewModel = PresentingControllerViewModel(
            title: "Popular",
            products: interactor.getPopularProducts()
        )
        router.openWishlistViewController(with: viewModel)
    }
    
    func didTapSeeAllJustForYou() {
        let viewModel = PresentingControllerViewModel(
            title: "Just For You",
            products: interactor.getJustForYouProducts()
        )
        router.openWishlistViewController(with: viewModel)
    }
}
