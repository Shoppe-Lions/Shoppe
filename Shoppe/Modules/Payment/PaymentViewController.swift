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
    var shippingType: shippingType { get set }
    func setupItems(with items:[Product])
    func updateTotalPrice(with total: Double)
}

final class PaymentViewController: UIViewController, AnyPaymentView {
    var presenter: AnyPaymentPresenter?
    var shippingType: shippingType = .standard {
        didSet {
            updateShippingUI()
        }
    }
    
    lazy var scrollView = UIScrollView()
    lazy var contentView = UIView()
    
    lazy var shippingDetails = DetailsView(type: .shipping)
    lazy var deliveryDetails = DetailsView(type: .contacts)
    lazy var itemTitle = HeadingLabel(title: "Items")
    lazy var itemsNumber = CountCircleView(size: 15)
    lazy var itemsStackView = SH_VerticalStackView()
    lazy var voucherButton = UIButton()
    
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
        setVaucherButton()
        setShippingDescription()
        updateShippingUI()
        
        presenter?.viewDidLoad()
    }
    
    func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(shippingDetails)
        contentView.addSubview(deliveryDetails)
        contentView.addSubview(itemTitle)
        contentView.addSubview(voucherButton)
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
        
        shippingStandard.button.addTarget(self, action: #selector(didSelectDelivery), for: .touchUpInside)
        shippingExpress.button.addTarget(self, action: #selector(didSelectDelivery), for: .touchUpInside)
        
    }
    
    @objc func didSelectDelivery() {
        presenter?.viewDidSelectDelivery()
    }
}

// UPDATE UI
extension PaymentViewController {
    func setupItems(with items:[Product]) {
        for item in items {
            let itemView = ItemView(item: item)
            itemsStackView.addArrangedSubview(itemView)
        }
        
        itemsNumber.number = items.count
    }
    
    func updateShippingUI() {
        if shippingType == .standard {
            shippingStandard.backgroundColor = .customLightGray
            let imageChecked = UIImage(named: "Check")
            shippingStandard.button.setImage(imageChecked, for: .normal)
            
            shippingExpress.backgroundColor = .customGray
            let imageUnchecked = UIImage(named: "CheckEmpty")
            shippingExpress.button.setImage(imageUnchecked, for: .normal)
        } else {
            shippingStandard.backgroundColor = .customGray
            let imageUnchecked = UIImage(named: "CheckEmpty")
            shippingStandard.button.setImage(imageUnchecked, for: .normal)
            
            shippingExpress.backgroundColor = .customLightGray
            let imageChecked = UIImage(named: "Check")
            shippingExpress.button.setImage(imageChecked, for: .normal)
        }
    }
    
    func updateTotalPrice(with total: Double) {
        totalView.totalPrice.text = String(format: "Total $%.2f", total)
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
    
    func setVaucherButton() {
        voucherButton.setTitle("Add voucher", for: .normal)
        voucherButton.setTitleColor(.customBlue, for: .normal)
        voucherButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .regular)
            
        voucherButton.layer.borderWidth = 2
        voucherButton.layer.borderColor = UIColor.customBlue.cgColor
        voucherButton.layer.cornerRadius = 10
            
        voucherButton.backgroundColor = .clear
        voucherButton.translatesAutoresizingMaskIntoConstraints = false
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
        
        voucherButton.snp.makeConstraints { make in
            make.centerY.equalTo(itemTitle.snp.centerY)
            make.trailing.equalToSuperview().offset(-20)
            make.width.equalTo(120)
            make.height.equalTo(30)
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
