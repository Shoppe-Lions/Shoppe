//
//  PaymentInteractor.swift
//  Shoppe
//
//  Created by Dmitry Volkov on 05/03/2025.
//

import Foundation

let mockData: [Product] = [
    Product(id: 1, title: "", price: 17.00, description: "26, Duong So 2, Thao Dien Ward, An Phu, District 2, Ho Chi Minh city", category: "", image: "mockImage", rating: Rating(rate: 22.00, count: 1)),
    Product(id: 1, title: "", price: 15.00, description: "60, Duong So 2, Thao Dien Ward, An Phu, District 2, Ho Chi Minh city", category: "", image: "mockImage", rating: Rating(rate: 22.00, count: 1)),
    Product(id: 1, title: "", price: 15.00, description: "60, Duong So 2, Thao Dien Ward, An Phu, District 2, Ho Chi Minh city", category: "", image: "mockImage", rating: Rating(rate: 22.00, count: 1))
]

protocol AnyPaymentIntercator: AnyObject {
    var presenter: AnyPaymentPresenter? { get set }
    func getBasketItems()
    func getFutureDates() -> (String, String)
    func calculateTotalPrice(shippingType: shippingType) -> Double
}

final class PaymentInteractor: AnyPaymentIntercator {
    weak var presenter: AnyPaymentPresenter?
    var items: [Product] = []
    
    func getBasketItems() {
        let data = mockData
        items = data
        presenter?.interactorDidFetchBasketItems(with: data)
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
    
    func calculateTotalPrice(shippingType: shippingType) -> Double {
        var itemsTotal = items.reduce(0) { $0 + $1.price }
        if shippingType == .express { itemsTotal += 12 }
        return itemsTotal
    }
}



