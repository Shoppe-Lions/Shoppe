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
    var router: AnyPaymentRouter?
    var interactor: AnyPaymentIntercator?
    
    init(view: AnyPaymentView? = nil, router: AnyPaymentRouter? = nil, interactor: AnyPaymentIntercator? = nil) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }
    
    func viewDidLoad() {
        interactor?.getBasketItems()
        getViewUpdateTotalPriceAndDelivery()
    }
    
    func interactorDidFetchBasketItems(with result: [Product]) {
        view?.setupItems(with: result)
        getViewUpdateTotalPriceAndDelivery()
    }
    
    func viewDidSelectDelivery() {
        toggleShippingType()
        getViewUpdateTotalPriceAndDelivery()
        
    }
}

// MARK: - Helper Methods
private extension PaymentPresenter {
    
    func getViewUpdateTotalPriceAndDelivery() {
        guard let shippingType = view?.shippingType else { return }
        
        let itemsTotal = interactor?.calculateTotalPrice(shippingType: shippingType) ?? 0.0
        view?.updateTotalPrice(with: itemsTotal)
        
        let deliveryDates = interactor?.getFutureDates()
        let deliveryDate = (shippingType == .express) ? deliveryDates?.0 : deliveryDates?.1
        view?.updateDeliveryDate(date: deliveryDate ?? "soon")
    }
    
    func toggleShippingType() {
        view?.shippingType = (view?.shippingType == .standard) ? .express : .standard
    }
}
