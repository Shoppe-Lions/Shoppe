//
//  PaymentViewController.swift
//  Shoppe
//
//  Created by Dmitry Volkov on 03/03/2025.
//

import UIKit
import SnapKit


protocol AnyPaymentView: AnyObject {
    var presenter: AnyPaymentPresenter? { get set }
    func setupItems(with items:[Product])
    //func didSelectDelivery()
}

final class PaymentViewController: UIViewController, AnyPaymentView {
    var presenter: AnyPaymentPresenter?
    
    lazy var scrollView = UIScrollView()
    lazy var contentView = UIView()
    
    lazy var shippingDetails = DetailsView(type: .shipping)
    lazy var deliveryDetails = DetailsView(type: .contacts)
    lazy var itemTitle = HeadingLabel(title: "Items")
    lazy var itemsNumber = CountCircleView(number: 2, size: 15)
    lazy var itemsStackView = SH_VerticalStackView()
    
    // Shipping Options
    lazy var shippingStackView = SH_VerticalStackView()
    lazy var shippingTitle = HeadingLabel(title: "Shipping Options")
    lazy var shippingStandard = ShippingDetailView(type: .standard)
    lazy var shippingExpress = ShippingDetailView(type: .express)
    lazy var shippingDescription = UILabel()
    
    lazy var paymentTitle = HeadingLabel(title: "Payment Method")
    lazy var paymentDetail = PaymentDetailView()
    lazy var paymentEditButton = EditButton()
    
    lazy var totalView = TotalView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setConstraints()
        setScrollView()
        setShippingDescription()
        
        presenter?.viewDidLoad()
    }
    
    func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(shippingDetails)
        contentView.addSubview(deliveryDetails)
        contentView.addSubview(itemTitle)
        contentView.addSubview(itemsNumber)
        contentView.addSubview(shippingTitle)
        contentView.addSubview(itemsStackView)
        contentView.addSubview(shippingStackView)
        contentView.addSubview(shippingDescription)
        shippingStackView.addArrangedSubview(shippingTitle)
        shippingStackView.addArrangedSubview(shippingStandard)
        shippingStackView.addArrangedSubview(shippingExpress)
        shippingStackView.addArrangedSubview(shippingDescription)
        contentView.addSubview(paymentTitle)
        contentView.addSubview(paymentDetail)
        contentView.addSubview(paymentEditButton)
        view.addSubview(totalView)
    }
}

// UPDATE UI
extension PaymentViewController {
    func setupItems(with items:[Product]) {
        for item in items {
            let itemView = ItemView(item: item)
            itemsStackView.addArrangedSubview(itemView)
        }
    }
}


// SETTING THE VIEWS
extension PaymentViewController {
    func setScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = false
        scrollView.contentInsetAdjustmentBehavior = .never
    }
    
    func setShippingDescription() {
        shippingDescription.text = "Delivered on or before Thursday, 23 April 2020"
        shippingDescription.translatesAutoresizingMaskIntoConstraints = false
        shippingDescription.font = .systemFont(ofSize: 12, weight: .thin)
        shippingDescription.textAlignment = .left
        shippingDescription.textColor = .black
    }
}

// SETTING CONSTRAINTS
extension PaymentViewController {
    func setConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalTo(shippingStackView.snp.bottom).offset(200)
        }
        
        shippingDetails.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(80)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(100)
        }
        
        deliveryDetails.snp.makeConstraints { make in
            make.top.equalTo(shippingDetails.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(100)
        }
        
        itemTitle.snp.makeConstraints { make in
            make.top.equalTo(deliveryDetails.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
        }
        
        itemsNumber.snp.makeConstraints { make in
            make.trailing.equalTo(itemTitle.snp.trailing).offset(90)
            make.top.equalTo(deliveryDetails.snp.bottom).offset(15)
        }
        
        itemsStackView.snp.makeConstraints { make in
            make.top.equalTo(itemTitle.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        shippingStackView.snp.makeConstraints { make in
            make.top.equalTo(itemsStackView.snp.bottom).offset(40)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        paymentTitle.snp.makeConstraints { make in
            make.top.equalTo(shippingStackView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
        }
        
        paymentDetail.snp.makeConstraints { make in
            make.top.equalTo(paymentTitle.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
        }
        
        paymentEditButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalTo(paymentTitle.snp.centerY)
        }
        
        totalView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.height.equalTo(60)
        }
    }
}
