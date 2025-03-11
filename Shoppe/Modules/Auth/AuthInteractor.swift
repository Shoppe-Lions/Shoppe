//
//  AuthInteractor.swift
//  Shoppe
//
//  Created by Dmitry Volkov on 10/03/2025.
//

import Foundation

protocol AnyAuthIntercator: AnyObject {
    var presenter: AnyAuthPresenter? { get set }
    func validateEmail()
    func validatePassword()
    func createFirebaseUser()
    func loginFirebaseUser()
    
}

final class AuthInteractor: AnyAuthIntercator {
    weak var presenter: AnyAuthPresenter?
    
    func validateEmail() {
        print("DEBUG: Email Validated")
    }
    
    func validatePassword() {
        print("DEBUG: Password Validated")
    }
    
    func createFirebaseUser() {
        print("DEBUG: New user created")
    }
    
    func loginFirebaseUser() {
        print("DEBUG: Logged in")
    }
    
    
    
}
