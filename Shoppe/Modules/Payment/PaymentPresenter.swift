//
//  PaymentPresenter.swift
//  Shoppe
//
//  Created by Dmitry Volkov on 05/03/2025.
//


import Foundation

protocol AnyPaymentPresenter: AnyObject {
    var view: AnyPaymentView? { get set }
    var router: AnyPaymentRouter? { get set }
    var interactor: AnyPaymentIntercator? { get set }
    func interactorDidFetchBasketItems(with result:[Product])
    func viewDidLoad()
    func viewDidSelectDelivery()
}

final class PaymentPresenter: AnyPaymentPresenter {
    weak var view: AnyPaymentView?
    var items: [Product] = []
    var router: AnyPaymentRouter?
    var interactor: AnyPaymentIntercator?
    
    init(view: AnyPaymentView? = nil, router: AnyPaymentRouter? = nil, interactor: AnyPaymentIntercator? = nil) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }
    
    func viewDidLoad() {
        interactor?.getBasketItems()
    }
    
    func interactorDidFetchBasketItems(with result: [Product]) {
        view?.setupItems(with: result)
        items = result
        calculateTotalPrice()
    }
    
    func viewDidSelectDelivery() {
        if view?.shippingType == .standard {
            view?.shippingType = .express
        } else {
            view?.shippingType = .standard
        }
        calculateTotalPrice()
    }
    
    func calculateTotalPrice() {
        var itemsTotal = items.reduce(0) { $0 + $1.price }
        if view?.shippingType == .express { itemsTotal += 12 }
        view?.updateTotalPrice(with: itemsTotal)
    }
}
