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
    
    func convert(priceInUSD: Double) -> Double {
        print(currentCurrency)
        return priceInUSD * (exchangeRates[currentCurrency] ?? 1.00)
    }
    
}

// Расширение для удобного доступа к уведомлению
extension Notification.Name {
    static let currencyDidChange = Notification.Name("currencyDidChange")
}
