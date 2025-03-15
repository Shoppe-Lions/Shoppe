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
    func updateTotalPrice(with total: String)
    func updateDeliveryDate(date: String)
    func updateShippingAddress(address: String)
    func showAlert()
    func dismissAlert()
    func showEditAddressAlert()
    func dismissEditAddressAlert()
    func showEditContactsAlert()
    func dismissEditContactsAlert()
    func showVoucherAlert()
    func dismissVoucherAlert()
    func updateItems(with items: [CartItem])
    func updatedShippingCurrency()
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
    lazy var itemsNumber = CountCircleView(size: 16, radius: 13, number: 0)
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
                                         buttonText: "Track My Order",
                                         secondButtonText: nil)
    
    lazy var editAddressView = TextFieldAlertView(title: "Change address", message: "Your shipping address", buttonText: "Change")
    
    lazy var editContactsView = TextFieldAlertView(title: "Change contacts", message: "Your contact information", buttonText: "Change")
    
    lazy var addVoucherView = TextFieldAlertView(title: "Add Voucher", message: "Your voucher details", buttonText: "Apply")
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        setupViews()
        setConstraints()
        setupNavBar()
        setScrollView()
        setTitleLabel()
        setVaucherButton()
        setShippingDescription()
        updateShippingUI()
        
        presenter?.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(currencyUpdated), name: .currencyDidChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .currencyDidChange, object: nil)
    }
    
    // MARK: - UI Setup
    func setupViews() {
        view.backgroundColor = .white
    
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
        totalView.button.addTarget(self, action: #selector(didShowPaymentAlert), for: .touchUpInside)
        alertView.button.addTarget(self, action: #selector(didDismissPaymentAlert), for: .touchUpInside)
        shippingDetails.editButton.addTarget(self, action: #selector(didEditAddressTapped), for: .touchUpInside)
        editAddressView.button.addTarget(self, action: #selector(didDismissEditAddressAlert), for: .touchUpInside)
        deliveryDetails.editButton.addTarget(self, action: #selector(didShowEditContacts), for: .touchUpInside)
        editContactsView.button.addTarget(self, action: #selector(didDismissEditContactsAlert), for: .touchUpInside)
        voucherButton.addTarget(self, action: #selector(didShowVoucher), for: .touchUpInside)
        addVoucherView.button.addTarget(self, action: #selector(didDismissVoucherAlert), for: .touchUpInside)
        
    }
    
    @objc func didSelectDelivery() {
        presenter?.viewDidSelectDelivery()
    }
    

    @objc func didShowPaymentAlert() {
        presenter?.viewDidShowAlert()
    }
    
    @objc func didDismissPaymentAlert() {
        StorageCartManager.shared.clearCart()
        presenter?.viewDidDismissAlert()
    }
    
    @objc func didShowEditAddress() {
        presenter?.viewDidShowEditAddressAlert()
    }
    
    @objc func didDismissEditAddressAlert() {
        presenter?.viewDidDismissEditAddressAlert()
    }
    
    @objc func didShowEditContacts() {
        presenter?.viewDidShowEditContactsAlert()
    }
    
    @objc func didDismissEditContactsAlert() {
        presenter?.viewDidDismissEditContactsAlert()
    }
    
    @objc func didShowVoucher() {
        presenter?.viewDidShowVoucherAlert()
    }
    
    @objc func didDismissVoucherAlert() {
        presenter?.viewDidDismissVoucherAlert()
    }
    
    @objc func didEditAddressTapped() {
        presenter?.viewDidEditAddressTapped()
    }
    
    @objc func currencyUpdated() {
        presenter?.viewDidLoad()
    }
    
    
}

// MARK: - Update UI
extension PaymentViewController {
    func setupNavBar() {
        self.title = "Payment"
        let customFont = UIFont(name: "Raleway-Bold", size: PFontSize.extraLarge)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: customFont,
            .foregroundColor: UIColor.black // Цвет текста
        ]
            
        self.navigationController?.navigationBar.titleTextAttributes = attributes
    }
    
    func updateItems(with items: [CartItem]) {
        if !itemsStackView.arrangedSubviews.isEmpty {
            for subview in itemsStackView.arrangedSubviews {
                itemsStackView.removeArrangedSubview(subview)
                subview.removeFromSuperview()
            }
        }

        for item in items {
            let itemView = ItemView(item: item)
            itemsStackView.addArrangedSubview(itemView)
        }
        
        itemsNumber.number = items.count
        view.layoutIfNeeded()
    }
    
    func updateShippingUI() {
        let isStandardSelected = (shippingType == .standard)
        updateShippingOption(view: shippingStandard, isSelected: isStandardSelected)
        updateShippingOption(view: shippingExpress, isSelected: !isStandardSelected)
    }
    
    func updateTotalPrice(with total: String) {
        totalView.totalPrice.text = total
    }
    
    func updateDeliveryDate(date: String) {
        shippingDescription.text = "Delivered on or before \(date)"
    }
    
    func updateShippingAddress(address: String) {
        shippingDetails.addressLabel.text = address
    }
    
    func showAlert() {
        alertView.show()
    }
    
    func dismissAlert() {
        alertView.dismiss()
    }
    
    func showEditAddressAlert() {
        editAddressView.show()
    }
    
    func dismissEditAddressAlert() {
        editAddressView.dismiss()
    }
    
    func showEditContactsAlert() {
        editContactsView.show()
    }
    
    func dismissEditContactsAlert() {
        editContactsView.dismiss()
    }
    
    func showVoucherAlert() {
        addVoucherView.show()
    }
    
    func dismissVoucherAlert() {
        addVoucherView.dismiss()
    }
    
    func updatedShippingCurrency() {
        shippingExpress.setPrice()
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
        
//        titleLabel.snp.makeConstraints { make in
//            make.top.equalToSuperview().offset(-PLayout.horizontalPadding)
//            make.leading.equalToSuperview().offset(PLayout.horizontalPadding)
//        }
        
        shippingDetails.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(PLayout.paddingS)
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

