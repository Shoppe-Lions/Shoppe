//
//  CurrencyManager.swift
//  Shoppe
//
//  Created by Dmitry Volkov on 11/03/2025.
//


import Foundation


class CurrencyManager {
    static let shared = CurrencyManager()
    
    private var exchangeRates: [String: Double] = ["$": 1.0, "€": 1.50, "₽": 100.00]
    
    var currentCurrency: String {
        get {
            UserDefaults.standard.string(forKey: "selectedCurrency") ?? "$"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "selectedCurrency")
            NotificationCenter.default.post(name: .currencyDidChange, object: nil)
        }
    }
    
    var currentLocation: String {
        get {
            UserDefaults.standard.string(forKey: "currentLocation") ?? "USA"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "currentLocation")
        }
    }
    
    func convert(priceInUSD: Double) -> Double {
        return priceInUSD * (exchangeRates[currentCurrency] ?? 1.00)
    }
    
    func makeToString(priceInUSD: Double) -> String {
        let price = currentCurrency == "₽" ? String(format: "%.0f", priceInUSD) : String(format: "%.2f", priceInUSD)
        return "\(currentCurrency)\(price)"
    }
    
    func convertToString(priceInUSD: Double) -> String {
        let convertedPrice = priceInUSD * (exchangeRates[currentCurrency] ?? 1.00)
        let price = currentCurrency == "₽" ? String(format: "%.0f", convertedPrice) : String(format: "%.2f", convertedPrice)
        return "\(currentCurrency)\(price)"
    }
}

// Расширение для удобного доступа к уведомлению
extension Notification.Name {
    static let currencyDidChange = Notification.Name("currencyDidChange")
}
