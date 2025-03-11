//
//  AuthRouter.swift
//  Shoppe
//
//  Created by Dmitry Volkov on 10/03/2025.
//

import UIKit


protocol AnyAuthRouter: AnyObject {
    static func createModule() -> UIViewController
    func navigateToHome(from view: UIViewController)
}

final class AuthRouter: AnyAuthRouter {
    static func createModule() -> UIViewController {
        let router = AuthRouter()
        
        let view = AuthViewController()
        let interactor = AuthInteractor()
        let presenter = AuthPresenter(view: view, router: router, interactor: interactor)
        
        view.presenter = presenter
        interactor.presenter = presenter
     
        return view
    }
    
    func navigateToHome(from view: UIViewController) {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
            return
        }
        let tabBarController = UITabBarController() // Заменить на наш TabBarController после вынесения его в отдельный модуль
        sceneDelegate.window?.rootViewController = tabBarController
        sceneDelegate.window?.makeKeyAndVisible()
    }
}
