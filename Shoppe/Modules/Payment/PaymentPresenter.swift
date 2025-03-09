//
//  PaymentPresenter.swift
//  Shoppe
//
//  Created by Dmitry Volkov on 05/03/2025.
//


import Foundation
import UIKit

protocol AnyPaymentPresenter: AnyObject {
    var view: AnyPaymentView? { get set }
    var router: AnyPaymentRouter? { get set }
    var interactor: AnyPaymentIntercator? { get set }
    func interactorDidFetchBasketItems(with result:[CartItem])
    func viewDidLoad()
    func viewDidSelectDelivery()
    func viewDidShowAlert()
    func viewDidDismissAlert()
    func viewDidShowEditAddressAlert()
    func viewDidDismissEditAddressAlert()
    func viewDidShowEditContactsAlert()
    func viewDidDismissEditContactsAlert()
    func viewDidShowVoucherAlert()
    func viewDidDismissVoucherAlert()
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
    
    func interactorDidFetchBasketItems(with result: [CartItem]) {
        view?.setupItems(with: result)
        getViewUpdateTotalPriceAndDelivery()
    }
    
    func viewDidSelectDelivery() {
        toggleShippingType()
        getViewUpdateTotalPriceAndDelivery()
    }
    
    func viewDidShowAlert() {
        view?.showAlert()
    }
    
    func viewDidDismissAlert() {
        view?.dismissAlert()
        guard let viewController = view as? UIViewController else { return }
        router?.navigateToCart(from: viewController)
    }
    
    func viewDidShowEditAddressAlert() {
        view?.showEditAddressAlert()
    }
    
    func viewDidDismissEditAddressAlert() {
        view?.dismissEditAddressAlert()
    }
    
    func viewDidShowEditContactsAlert() {
        view?.showEditContactsAlert()
    }
    
    func viewDidDismissEditContactsAlert() {
        view?.dismissEditContactsAlert()
    }
    
    func viewDidShowVoucherAlert() {
        view?.showVoucherAlert()
    }
    
    func viewDidDismissVoucherAlert() {
        view?.dismissVoucherAlert()
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
