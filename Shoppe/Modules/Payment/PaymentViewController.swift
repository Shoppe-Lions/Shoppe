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
    
    lazy var alertView = CustomAlertView(title: "Done!",
                                         message: "Your card has been successfully charged",
                                         buttonText: "Track My Order")
    
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
        totalView.button.addTarget(self, action: #selector(showAlert), for: .touchUpInside)
        alertView.button.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
        
    }
    
    @objc func didSelectDelivery() {
        presenter?.viewDidSelectDelivery()
    }
    
    //
    @objc func showAlert() {
        alertView.show()
    }
    
    //
    @objc func dismissAlert() {
        alertView.dismiss()
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
        titleLabel.font = UIFont(name: "Raleway-Bold", size: PFontSize.extraLarge)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setShippingDescription() {
        shippingDescription.translatesAutoresizingMaskIntoConstraints = false
        shippingDescription.font = UIFont(name: "NunitoSans10pt-Regular", size: PFontSize.small)
        shippingDescription.textAlignment = .left
        shippingDescription.textColor = .black
    }
    
    func setVaucherButton() {
        voucherButton.setTitle("Add voucher", for: .normal)
        voucherButton.setTitleColor(.customBlue, for: .normal)
        voucherButton.titleLabel?.font = UIFont(name: "NunitoSans10pt-Regular", size: PFontSize.normal)
            
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
            make.bottom.equalTo(shippingStackView.snp.bottom).offset(PLayout.contentBottomOffset)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(PLayout.horizontalPadding)
        }
        
        shippingDetails.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(PLayout.paddingM)
            make.leading.equalToSuperview().offset(PLayout.horizontalPadding)
            make.trailing.equalToSuperview().offset(-PLayout.horizontalPadding)
            make.height.equalTo(PLayout.detailsHeight)
        }
        
        deliveryDetails.snp.makeConstraints { make in
            make.top.equalTo(shippingDetails.snp.bottom).offset(PLayout.paddingS)
            make.leading.equalToSuperview().offset(PLayout.horizontalPadding)
            make.trailing.equalToSuperview().offset(-PLayout.horizontalPadding)
            make.height.equalTo(PLayout.detailsHeight)
        }
        
        itemTitle.snp.makeConstraints { make in
            make.top.equalTo(deliveryDetails.snp.bottom).offset(PLayout.horizontalPadding)
            make.leading.equalToSuperview().offset(PLayout.horizontalPadding)
        }
        
        itemsNumber.snp.makeConstraints { make in
            make.leading.equalTo(itemTitle.snp.trailing).offset(PLayout.horizontalPadding*3.5)
            make.top.equalTo(deliveryDetails.snp.bottom).offset(PLayout.paddingM)
        }
        
        itemsStackView.snp.makeConstraints { make in
            make.top.equalTo(itemTitle.snp.bottom).offset(PLayout.horizontalPadding)
            make.leading.equalToSuperview().offset(PLayout.horizontalPadding)
            make.trailing.equalToSuperview().offset(-PLayout.horizontalPadding)
        }
        
        voucherButton.snp.makeConstraints { make in
            make.centerY.equalTo(itemTitle.snp.centerY)
            make.trailing.equalToSuperview().offset(-PLayout.horizontalPadding)
            make.size.equalTo(PLayout.voucherButtonSize)
        }
        
        shippingStackView.snp.makeConstraints { make in
            make.top.equalTo(itemsStackView.snp.bottom).offset(PLayout.paddingL)
            make.leading.equalToSuperview().offset(PLayout.horizontalPadding)
            make.trailing.equalToSuperview().offset(-PLayout.horizontalPadding)
        }
        
        paymentTitle.snp.makeConstraints { make in
            make.top.equalTo(shippingStackView.snp.bottom).offset(PLayout.paddingL)
            make.leading.equalToSuperview().offset(PLayout.horizontalPadding)
        }
        
        paymentDetail.snp.makeConstraints { make in
            make.top.equalTo(paymentTitle.snp.bottom).offset(PLayout.paddingS)
            make.leading.equalToSuperview().offset(PLayout.horizontalPadding)
        }
        
        paymentEditButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-PLayout.horizontalPadding)
            make.centerY.equalTo(paymentTitle.snp.centerY)
        }
        
        totalView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.height.equalTo(PLayout.totalViewHeight)
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

