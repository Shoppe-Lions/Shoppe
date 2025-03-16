//
//  HomeRouterProtocol.swift
//  Shoppe
//
//  Created by Victor Garitskyu on 11.03.2025.
//

import UIKit

protocol HomeRouterProtocol: AnyObject {
    static func createModule() -> UIViewController
    func openCart()
    func openProductDetail(from view: HomeViewProtocol, with product: Product)
    func openAllCategories()
    func openProductDetail(with productId: Int, navigationController: HomeViewController?)
    func openCart(from viewController: HomeViewController)
    func openWishlistViewController(with viewModel: PresentingControllerViewModel)
}

final class HomeRouter: HomeRouterProtocol {
    weak var view: UIViewController?
    
    static func createModule() -> UIViewController {
        let view = HomeViewController()
        let router = HomeRouter()
        let interactor = HomeInteractor()
        let presenter = HomePresenter(view: view, interactor: interactor, router: router)
        
        view.presenter = presenter
        interactor.presenter = presenter
        router.view = view
        
        return view
    }
    
    func openCart() {
        // Реализация перехода в корзину
    }
    
    func openProductDetail(from view: HomeViewProtocol, with product: Product) {
        if let sourceVC = view as? UIViewController {
            // TODO: раскомментировать когда будет готов детальный экран
            // let detailVC = ProductDetailRouter.createModule(with: product)
            // sourceVC.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    func openAllCategories() {
        if let sourceVC = view as? UIViewController {
            let allCategoriesVC = AllCategoriesRouter.createModule()
            
            // Используем push вместо present
            sourceVC.navigationController?.pushViewController(allCategoriesVC, animated: true)
        }
    }
    
    func openProductDetail(with productId: Int, navigationController: HomeViewController?) {
        guard let tabBarController = navigationController?.tabBarController else { return }
        
        // Переключаемся на вкладку Product (индекс 2) и обновляем underline
        if let mainTabBar = tabBarController as? MainTabBarController {
            mainTabBar.selectTab(at: 2)
        }
        
        // Получаем ProductViewController из таббара
        if let productNavController = tabBarController.viewControllers?[2] as? UINavigationController,
           let productVC = productNavController.viewControllers.first as? ProductViewController {
            
            // Обновляем данные в существующем ProductViewController
            productVC.updateProduct(id: productId)
            
            // Анимируем переход
            UIView.animate(withDuration: 0.3, animations: {
                navigationController?.view.alpha = 0.5
            }) { _ in
                UIView.animate(withDuration: 0.3) {
                    navigationController?.view.alpha = 1.0
                }
            }
        }
    }
    
    func openCart(from viewController: HomeViewController) {
        guard let tabBarController = viewController.tabBarController else { return }
        
        // Переключаемся на вкладку Cart (индекс 3) и обновляем underline
        if let mainTabBar = tabBarController as? MainTabBarController {
            mainTabBar.selectTab(at: 3)
        }
        
        // Анимируем переход с затуханием
        UIView.animate(withDuration: 0.3, animations: {
            viewController.view.alpha = 0.5
        }) { _ in
            UIView.animate(withDuration: 0.3) {
                viewController.view.alpha = 1.0
            }
        }
    }
    
    func openWishlistViewController(with viewModel: PresentingControllerViewModel) {
        if let sourceVC = view as? UIViewController {
            let wishlistVC = WishlistRouter.createModule(viewModel: viewModel)
            sourceVC.navigationController?.pushViewController(wishlistVC, animated: true)
        }
    }
}
