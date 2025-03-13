//
//  PaymentInteractor.swift
//  Shoppe
//
//  Created by Dmitry Volkov on 05/03/2025.
//

import Foundation

protocol AnyPaymentIntercator: AnyObject {
    var presenter: AnyPaymentPresenter? { get set }
    var items: [CartItem] { get set }
    func getCartItems()
    func getOneItemCart(product: CartItem)
    func getFutureDates() -> (String, String)
    func calculateTotalPrice(shippingType: shippingType) -> String
}

final class PaymentInteractor: AnyPaymentIntercator {
    weak var presenter: AnyPaymentPresenter?
    var items: [CartItem] = []
    
    func getCartItems() {
        let data = StorageCartManager.shared.loadCart()
        items = data
        presenter?.interactorDidFetchBasketItems(with: data)
    }
    
    func getOneItemCart(product: CartItem) {
        items = [product]
        presenter?.interactorDidFetchBasketItems(with: items)
    }
    
    func getFutureDates() -> (String, String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, d MMMM yyyy"
        
        let currentDate = Date()
        let calendar = Calendar.current
        
        let twoDaysLater = calendar.date(byAdding: .day, value: 2, to: currentDate)!
        let sevenDaysLater = calendar.date(byAdding: .day, value: 7, to: currentDate)!
        
        let twoDaysString = dateFormatter.string(from: twoDaysLater)
        let sevenDaysString = dateFormatter.string(from: sevenDaysLater)
        
        return (twoDaysString, sevenDaysString)
    }
    
    func calculateTotalPrice(shippingType: shippingType) -> String {
        let currency = CurrencyManager.shared.currentCurrency
        let itemsTotal = items.reduce(0) { $0 + ($1.product.price * Double($1.quantity))}
        let shippingPrice = CurrencyManager.shared.convert(priceInUSD: 12)
        var itemsTotalConverted = CurrencyManager.shared.convert(priceInUSD: itemsTotal)
        if shippingType == .express { itemsTotalConverted += shippingPrice }
        let itemsTotalString = String(format: "%.2f", itemsTotalConverted)
        return "\(currency)\(itemsTotalString)"
    }
}



