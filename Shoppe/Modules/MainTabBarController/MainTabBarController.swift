//
//  MainTabBarController.swift
//  Shoppe
//
//  Created by Игорь Клевжиц on 12.03.2025.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    private lazy var underlineView: UIView = {
        let element = UIView()
        element.backgroundColor = .customBlack
        element.layer.cornerRadius = 2
        return element
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateUnderlinePosition()
    }

    override var selectedViewController: UIViewController? {
        didSet {
            updateUnderlinePosition()
        }
    }

    private func setupTabBar() {
        let homeViewController = UINavigationController(rootViewController: HomeRouter.createModule())
        let wishlistViewController = UINavigationController(rootViewController: WishlistRouter.createModule(viewModel: PresentingControllerViewModel(title: "Wishlist")))
        let unknownViewController = UINavigationController(rootViewController: ProductRouter.createModule(by: 9, navigationController: navigationController))
        let cartViewController = UINavigationController(rootViewController: CartRouter.createModule())
        let profileViewController = UINavigationController(rootViewController: ProfileViewController())

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
        
        let backImage = UIImage(systemName: "arrow.left")
        UINavigationBar.appearance().backIndicatorImage = backImage
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backImage
        UINavigationBar.appearance().tintColor = .customBlack
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -1000, vertical: 0), for: .default)

        tabBar.isTranslucent = false
        tabBar.tintColor = .customBlack
        tabBar.unselectedItemTintColor = .customBlue
        tabBar.addSubview(underlineView)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                self.updateUnderlinePosition()
            }
    }
    
    private func updateUnderlinePosition() {
        guard let items = tabBar.items, let selectedItem = selectedViewController?.tabBarItem,
              let index = items.firstIndex(of: selectedItem),
              let tabBarButton = tabBar.subviews.filter({ $0 is UIControl })[safe: index] else { return }
        
        let underlineHeight: CGFloat = 3
        let width = tabBarButton.frame.width / 4
        let x = tabBarButton.frame.origin.x + tabBarButton.frame.width / 2 - width / 2
        
        if let imageView = tabBarButton.subviews.first(where: { $0 is UIImageView }) {
            let y = imageView.frame.maxY + 5
            
            UIView.animate(withDuration: 0.3) {
                self.underlineView.frame = CGRect(x: x, y: y, width: width, height: underlineHeight)
            }
        }
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
