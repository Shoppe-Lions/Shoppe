//
//  PaymentViewController.swift
//  Shoppe
//
//  Created by Dmitry Volkov on 03/03/2025.
//

import UIKit
import SnapKit

let mockData: [Product] = [
    Product(id: 1, title: "", price: 17.00, description: "26, Duong So 2, Thao Dien Ward, An Phu, District 2, Ho Chi Minh city", category: "", image: "mockImage", rating: Rating(rate: 22.00, count: 1)),
    Product(id: 1, title: "", price: 15.00, description: "60, Duong So 2, Thao Dien Ward, An Phu, District 2, Ho Chi Minh city", category: "", image: "mockImage", rating: Rating(rate: 22.00, count: 1)),
    Product(id: 1, title: "", price: 15.00, description: "60, Duong So 2, Thao Dien Ward, An Phu, District 2, Ho Chi Minh city", category: "", image: "mockImage", rating: Rating(rate: 22.00, count: 1))
]

class PaymentViewController: UIViewController {
    
    lazy var scrollView = UIScrollView()
    lazy var contentView = UIView()
    
    lazy var shippingDetails = DetailsView(type: .shipping)
    lazy var deliveryDetails = DetailsView(type: .contacts)
    lazy var itemTitle = HeadingLabel(title: "Items")
    lazy var itemsStackView = SH_VerticalStackView()
    
    // Shipping Options
    lazy var shippingStackView = SH_VerticalStackView()
    lazy var shippingTitle = HeadingLabel(title: "Shipping Options")
    lazy var shippingStandard = ShippingDetailView()
    lazy var shippingExpress = ShippingDetailView()
    lazy var shippingDescription = UILabel()
    
    lazy var paymentTitle = HeadingLabel(title: "Payment Method")
    lazy var paymentDetail = PaymentDetailView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setConstraints()
        setScrollView()
        setupItems()
        setShippingDescription()
    }
    
    func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(shippingDetails)
        contentView.addSubview(deliveryDetails)
        contentView.addSubview(itemTitle)
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
    }
    
    func setupItems() {
        for item in mockData {
            let itemView = ItemView(item: item)
            itemsStackView.addArrangedSubview(itemView)
        }
    }
    
    func setScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
    }
    
    func setShippingDescription() {
        shippingDescription.text = "Delivered on or before Thursday, 23 April 2020"
        shippingDescription.translatesAutoresizingMaskIntoConstraints = false
        shippingDescription.font = .systemFont(ofSize: 12, weight: .thin)
        shippingDescription.textAlignment = .left
        shippingDescription.textColor = .black
    }
    
    
    
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
    }
}
