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
}

final class PaymentInteractor: AnyPaymentIntercator {
    weak var presenter: AnyPaymentPresenter?
    
    func getBasketItems() {
        let data = mockData
        presenter?.interactorDidFetchBasketItems(with: data)
    }
}



