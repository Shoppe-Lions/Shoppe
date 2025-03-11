//
//  AllCategoriesPresenter.swift
//  Shoppe
//
//  Created by Игорь Клевжиц on 11.03.2025.
//

import UIKit

protocol AllCategoriesPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didFetchCategories(_ categories: [Category])
}

class AllCategoriesPresenter: AllCategoriesPresenterProtocol {
    
    
    weak var view: AllCategoriesViewProtocol?
    var interactor: AllCategoriesInteractorProtocol
    var router: AllCategoriesRouterProtocol
    
    init(view: AllCategoriesViewProtocol, interactor: AllCategoriesInteractorProtocol, router: AllCategoriesRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoad() {
        interactor.fetchCategories()
    }
    
    func didFetchCategories(_ categories: [Category]) {
        view?.showCategories(categories)
    }
}
