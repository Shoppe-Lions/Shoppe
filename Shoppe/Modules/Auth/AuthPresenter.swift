//
//  AuthPresenter.swift
//  Shoppe
//
//  Created by Dmitry Volkov on 10/03/2025.
//

import Foundation
import UIKit

protocol AnyAuthPresenter: AnyObject {
    var view: AnyAuthView? { get set }
    var router: AnyAuthRouter? { get set }
    var interactor: AnyAuthIntercator? { get set }
    func viewDidGetStartedTapped()
    func viewDidHaveAccountTapped()
    func viewDidCancelTapped()
    func viewDidCreateAccountTapped(email: String, password: String)
    func viewDidLoginNextTapped(email: String, password: String)
    func updateViewAuthErrorMessage(message: String)
}

final class AuthPresenter: AnyAuthPresenter {
    func viewDidGetStartedTapped() {
        view?.authType = .register
        view?.setupViews()
    }
    
    func viewDidHaveAccountTapped() {
        view?.authType = .login
        view?.setupViews()
    }
    
    func viewDidCancelTapped() {
        view?.authType = .getStarted
        view?.setupViews()
    }
    
    func viewDidCreateAccountTapped(email: String, password: String) {
        let isEmailValid = interactor?.isEmailValid(email) ?? false
        let isPasswordValid = interactor?.isPasswordValid(password) ?? false

        if isEmailValid && isPasswordValid {
            interactor?.createFirebaseUser(email: email, password: password)
            router?.navigateToHome(from: view as! UIViewController)
        }
    }
    
    func viewDidLoginNextTapped(email: String, password: String) {
        let isEmailValid = interactor?.isEmailValid(email) ?? false
        let isPasswordValid = interactor?.isPasswordValid(password) ?? false

        if isEmailValid && isPasswordValid {
            interactor?.loginFirebaseUser(email: email, password: password)
            router?.navigateToHome(from: view as! UIViewController)
        }
    }
    
    func updateViewAuthErrorMessage(message: String) {
        view?.showAuthErrorMessage(error: message)
    }
    
    
    weak var view: AnyAuthView?
    var router: AnyAuthRouter?
    var interactor: AnyAuthIntercator?
    
    init(view: AnyAuthView? = nil, router: AnyAuthRouter? = nil, interactor: AnyAuthIntercator? = nil) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }
}


