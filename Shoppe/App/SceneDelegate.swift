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
        let mainTabBarController = MainTabBarController()
        
        onboardingViewController.didFinishOnboarding = {
            UserDefaults.standard.set(true, forKey: "onboardingCompleted")
            
            UIWindow.transition(with: self.window!, duration: 0.5) {
                self.window?.rootViewController = mainTabBarController
            }
        }
        
        if onboardingCompleted {
            window?.rootViewController = mainTabBarController
            //window?.rootViewController = AuthRouter.createModule()
        } else {
            window?.rootViewController = onboardingViewController
        }
        
        window?.makeKeyAndVisible()
    }
}

