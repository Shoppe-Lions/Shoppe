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
    func updateDeliveryDate(date: String)
}

final class PaymentViewController: UIViewController, AnyPaymentView {
    // MARK: - Properties
    var presenter: AnyPaymentPresenter?
    var shippingType: shippingType = .standard {
        didSet {
            updateShippingUI()
        }
    }
    
    lazy var scrollView = UIScrollView()
    lazy var contentView = UIView()
    
    lazy var titleLabel = UILabel()
    lazy var shippingDetails = DetailsView(type: .shipping)
    lazy var deliveryDetails = DetailsView(type: .contacts)
    lazy var itemTitle = HeadingLabel(title: "Items")
    lazy var itemsNumber = CountCircleView(size: 16, radius: 13)
    lazy var itemsStackView = SH_VerticalStackView()
    lazy var voucherButton = UIButton()
    
    lazy var shippingStackView = SH_VerticalStackView()
    lazy var shippingTitle = HeadingLabel(title: "Shipping Options")
    lazy var shippingStandard = ShippingDetailView(type: .standard)
    lazy var shippingExpress = ShippingDetailView(type: .express)
    lazy var shippingDescription = UILabel()
    
    lazy var paymentTitle = HeadingLabel(title: "Payment Method")
    lazy var paymentDetail = PaymentDetailView()
    lazy var paymentEditButton = EditButton()
    
    lazy var totalView = TotalView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setConstraints()
        setScrollView()
        setTitleLabel()
        setVaucherButton()
        setShippingDescription()
        updateShippingUI()
        
        presenter?.viewDidLoad()
    }
    
    // MARK: - UI Setup
    func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(titleLabel)
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

// MARK: - Update UI
extension PaymentViewController {
    func setupItems(with items:[Product]) {
        for item in items {
            let itemView = ItemView(item: item)
            itemsStackView.addArrangedSubview(itemView)
        }
        
        itemsNumber.number = items.count
    }
    
    func updateShippingUI() {
        let isStandardSelected = (shippingType == .standard)
        updateShippingOption(view: shippingStandard, isSelected: isStandardSelected)
        updateShippingOption(view: shippingExpress, isSelected: !isStandardSelected)
    }
    
    func updateTotalPrice(with total: Double) {
        totalView.totalPrice.text = String(format: "Total $%.2f", total)
    }
    
    func updateDeliveryDate(date: String) {
        shippingDescription.text = "Delivered on or before \(date)"
    }
}


// MARK: - Setting Views
extension PaymentViewController {
    func setScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = false
        scrollView.contentInsetAdjustmentBehavior = .never
    }
    
    func setTitleLabel() {
        titleLabel.textColor = .customBlack
        titleLabel.textAlignment = .left
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.1
        paragraphStyle.alignment = .center
        titleLabel.attributedText = NSMutableAttributedString(string: "Payment", attributes: [NSAttributedString.Key.kern: -0.28, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        titleLabel.font = UIFont(name: "Raleway-Bold", size: 28)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setShippingDescription() {
        shippingDescription.translatesAutoresizingMaskIntoConstraints = false
        shippingDescription.font = UIFont(name: "NunitoSans10pt-Regular", size: 13)
        shippingDescription.textAlignment = .left
        shippingDescription.textColor = .black
    }
    
    func setVaucherButton() {
        voucherButton.setTitle("Add voucher", for: .normal)
        voucherButton.setTitleColor(.customBlue, for: .normal)
        voucherButton.titleLabel?.font = UIFont(name: "NunitoSans10pt-Regular", size: 15)
            
        voucherButton.layer.borderWidth = 1
        voucherButton.layer.borderColor = UIColor.customBlue.cgColor
        voucherButton.layer.cornerRadius = 10
            
        voucherButton.backgroundColor = .clear
        voucherButton.translatesAutoresizingMaskIntoConstraints = false
    }
}

// MARK: - Setting constraints
extension PaymentViewController {
    func setConstraints() {
        scrollView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalTo(shippingStackView.snp.bottom).offset(200)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
        }
        
        shippingDetails.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(85)
        }
        
        deliveryDetails.snp.makeConstraints { make in
            make.top.equalTo(shippingDetails.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(85)
        }
        
        itemTitle.snp.makeConstraints { make in
            make.top.equalTo(deliveryDetails.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
        }
        
        itemsNumber.snp.makeConstraints { make in
            make.leading.equalTo(itemTitle.snp.trailing).offset(70)
            make.top.equalTo(deliveryDetails.snp.bottom).offset(15)
        }
        
        itemsStackView.snp.makeConstraints { make in
            make.top.equalTo(itemTitle.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        voucherButton.snp.makeConstraints { make in
            make.centerY.equalTo(itemTitle.snp.centerY)
            make.trailing.equalToSuperview().offset(-20)
            make.width.equalTo(120)
            make.height.equalTo(35)
        }
        
        shippingStackView.snp.makeConstraints { make in
            make.top.equalTo(itemsStackView.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        paymentTitle.snp.makeConstraints { make in
            make.top.equalTo(shippingStackView.snp.bottom).offset(30)
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

// MARK: - Helper Method
extension PaymentViewController {
    private func updateShippingOption(view: ShippingDetailView, isSelected: Bool) {
        view.backgroundColor = isSelected ? .customLightGray : .customGray
        let imageName = isSelected ? "Check" : "CheckEmpty"
        view.button.setImage(UIImage(named: imageName), for: .normal)
    }
}

