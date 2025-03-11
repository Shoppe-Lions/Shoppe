//
//  AuthInteractor.swift
//  Shoppe
//
//  Created by Dmitry Volkov on 10/03/2025.
//

import Foundation

protocol AnyAuthIntercator: AnyObject {
    var presenter: AnyAuthPresenter? { get set }
    func isEmailValid(_ email: String) -> Bool
    func isPasswordValid(_ email: String) -> Bool
    func createFirebaseUser(email: String, password: String)
    func loginFirebaseUser(email: String, password: String)
    
}

final class AuthInteractor: AnyAuthIntercator {
    weak var presenter: AnyAuthPresenter?
    
    func isEmailValid(_ email: String) -> Bool{
        let emailRegex = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES[c] %@", emailRegex)
            
        if !emailPredicate.evaluate(with: email) {
            presenter?.updateViewAuthErrorMessage(message: "Email is not valid")
            return false
        }
        
        return true
    }
    
    func isPasswordValid(_ password: String) -> Bool {
        // Проверка на 8 символов
        if password.count < 8 {
            presenter?.updateViewAuthErrorMessage(message: "Password must contain 8 characters")
            return false
        }
            
        // Проверка на заглавную букву
        if !password.contains(where: { $0.isUppercase }) {
            presenter?.updateViewAuthErrorMessage(message: "Password must have one capital letter")
            return false
        }
        
        return true
    }
    
    func createFirebaseUser(email: String, password: String) {
        print("DEBUG: New user created")
    }
    
    func loginFirebaseUser(email: String, password: String) {
        print("DEBUG: Logged in")
    }
    
    
    
}
