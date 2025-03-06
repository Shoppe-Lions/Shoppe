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
    }
    
    func interactorDidFetchBasketItems(with result: [Product]) {
        view?.setupItems(with: result)
    }
}
