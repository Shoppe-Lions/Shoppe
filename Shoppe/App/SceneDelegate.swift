//
//  SceneDelegate.swift
//  Shoppe
//
//  Created by Игорь Клевжиц on 02.03.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        window?.overrideUserInterfaceStyle = .light
        
        let onboardingCompleted = UserDefaults.standard.bool(forKey: "onboardingCompleted")
        
        let onboardingViewController = OnboardingViewController()
        
        let tabBarController = UITabBarController()
        
        let homeViewController = HomeViewController()
        let wishlistViewController = WishlistRouter.createModule()


        let unknownViewController = ProductRouter.createModule(
            by: 1,
            navigationController: UINavigationController()
        ) // Что это за экран??)
        let cartViewController = UINavigationController(rootViewController: CartRouter.createModule())
        let profileViewController = ProfileViewController()

       // let profileViewController = PaymentRouter.createModule()
        
        tabBarController.viewControllers = [
            homeViewController,
            wishlistViewController,
            unknownViewController,
            cartViewController,
            profileViewController
        ]
        
        tabBarController.selectedViewController = homeViewController
        
        homeViewController.tabBarItem = UITabBarItem(
            title: "",
            image: .init(systemName: "house"),
            tag: 0)
        
        wishlistViewController.tabBarItem = UITabBarItem(
            title: "",
            image: .init(systemName: "heart"),
            tag: 1)
        
        unknownViewController.tabBarItem = UITabBarItem(
            title: "",
            image: .init(systemName: "list.bullet.rectangle"),
            tag: 2)
        
        cartViewController.tabBarItem = UITabBarItem(
            title: "",
            image: .init(systemName: "bag"),
            tag: 3)
        
        profileViewController.tabBarItem = UITabBarItem(
            title: "",
            image: .init(systemName: "person"),
            tag: 4)
        
        tabBarController.tabBar.isTranslucent = false
        
        tabBarController.tabBar.tintColor = .black
        
        tabBarController.tabBar.unselectedItemTintColor = .blue
        
        onboardingViewController.didFinishOnboarding = {
            UserDefaults.standard.set(true, forKey: "onboardingCompleted")
            
            UIWindow.transition(with: self.window!, duration: 0.5) {
                self.window?.rootViewController = tabBarController
            }
        }
        
        if onboardingCompleted {
            window?.rootViewController = tabBarController
        } else {
            window?.rootViewController = onboardingViewController
        }
        
        window?.makeKeyAndVisible()
    }
    
    
}

