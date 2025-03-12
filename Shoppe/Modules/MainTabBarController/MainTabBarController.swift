//
//  MainTabBarController.swift
//  Shoppe
//
//  Created by Игорь Клевжиц on 12.03.2025.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
    }

    private func setupTabBar() {
        let homeViewController = HomeRouter.createModule()
        let wishlistViewController = UINavigationController(rootViewController: WishlistRouter.createModule())
        let unknownViewController = ProductRouter.createModule(
            by: 2,
            navigationController: UINavigationController()
        )
        let cartViewController = UINavigationController(rootViewController: CartRouter.createModule())
        let profileViewController = AllCategoriesRouter.createModule()

        viewControllers = [
            homeViewController,
            wishlistViewController,
            unknownViewController,
            cartViewController,
            profileViewController
        ]

        selectedViewController = homeViewController

        homeViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "house"), tag: 0)
        wishlistViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "heart"), tag: 1)
        unknownViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "list.bullet.rectangle"), tag: 2)
        cartViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "bag"), tag: 3)
        profileViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "person"), tag: 4)

        tabBar.isTranslucent = false
        tabBar.tintColor = .black
        tabBar.unselectedItemTintColor = .blue
    }
}
