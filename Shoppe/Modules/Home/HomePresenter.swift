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
        interactor.fetchJustForYouProducts()
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
}
