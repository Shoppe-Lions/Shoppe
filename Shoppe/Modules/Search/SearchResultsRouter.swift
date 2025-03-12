//
//  SearchResultsRouter.swift
//  Shoppe
//
//  Created by ordoko on 11.03.2025.
//

import Foundation
import UIKit

protocol SearchResultsRouterProtocol {
    func openProductDetail(from view: SearchResultsViewProtocol, with product: Product)
}

final class SearchResultsRouter: SearchResultsRouterProtocol {
   
    static func createModule(products: [Product]) -> UIViewController {
        
        let view = SearchResultsController()
        let router = SearchResultsRouter()
        let interactor = SearchResultsInteractor()
        let presenter = SearchResultsPresenter(view: view, interactor: interactor, router: router, products: products)
        
        view.presenter = presenter
        interactor.presenter = presenter

        return view
    }
    
    func openProductDetail(from view: any SearchResultsViewProtocol, with product: Product) {
        guard let sourceVC = view as? SearchResultsController else { return }
        let detailVC = ProductRouter.createModule(by: product.id, navigationController: nil)
        sourceVC.present(detailVC, animated: true)
    }
}
