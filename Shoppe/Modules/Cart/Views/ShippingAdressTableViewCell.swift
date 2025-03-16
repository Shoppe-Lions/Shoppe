//
//  ShippingAdressTableViewCell.swift
//  Shoppe
//
//  Created by Artem Kriukov on 04.03.2025.
//

import UIKit
import SnapKit
import FirebaseAuth

final class ShippingAdressTableViewCell: UITableViewCell {
  
    weak var parentViewController: UIViewController?
    // MARK: - UI
    private lazy var shippingAdressSV: UIStackView = {
        let element = UIStackView()
        element.axis = .vertical
        element.backgroundColor = UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 1.0)
        element.isLayoutMarginsRelativeArrangement = true
        element.layoutMargins = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        element.layer.cornerRadius = 10
        return element
    }()
    
    private lazy var titleAdressLabel: UILabel = {
        let element = UILabel()
        element.text = "Shipping Address"
        element.textColor = UIColor(named: "CustomBlack")
        element.font = UIFont(name: Fonts.Raleway.bold, size: 14)
        return element
    }()
    
    private lazy var adressInfoStackView: UIStackView = {
        let element = UIStackView()
        element.axis = .horizontal
        element.spacing = 40
        element.alignment = .center
        return element
    }()
    
    private lazy var detailsAdressLabel: UILabel = {
        let element = UILabel()
        element.text = "26, Duong So 2, Thao Dien Ward, An Phu"
        element.font = UIFont(name: Fonts.NunitoSans.regular, size: 14)
        element.numberOfLines = 0
        return element
    }()
    
    private lazy var editButton: UIButton = {
        let element = UIButton(type: .custom)
        element.setImage(UIImage(named: "EditButton"), for: .normal)
        element.addTarget(self, action: #selector(editAddressButtonTapped), for: .touchUpInside)
        return element
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    // MARK: - Action
    @objc private func editAddressButtonTapped() {
        guard let parentVC = parentViewController else {
            print("UIViewController не найден")
            return
        }
        
        let addressesVC = AddressesViewController()
        addressesVC.onAddressSelected = { [weak self] selectedAddress in
            self?.updateAddress(with: selectedAddress)
        }
        
        let nav = UINavigationController(rootViewController: addressesVC)
        nav.modalPresentationStyle = .pageSheet
        
        if let sheet = nav.sheetPresentationController {
            let customDetent = UISheetPresentationController.Detent.custom { context in
                return context.maximumDetentValue * 0.3
            }
            sheet.detents = [customDetent]
        }
        
        parentVC.present(nav, animated: true)
    }
    
    func updateAddress(with address: AddressModel?) {
        if let address = address {
            detailsAdressLabel.text = "\(address.zipCode), \(address.city), \(address.street), \(address.houseNumber)"
        } else {
            detailsAdressLabel.text = "No shipping address added"
        }
    }
}


private extension ShippingAdressTableViewCell {
    func setupViews() {
        contentView.addSubview(shippingAdressSV)
        shippingAdressSV.addArrangedSubview(titleAdressLabel)
        shippingAdressSV.addArrangedSubview(adressInfoStackView)
        
        adressInfoStackView.addArrangedSubview(detailsAdressLabel)
        adressInfoStackView.addArrangedSubview(editButton)
    }
    
    func setupConstraints() {
        shippingAdressSV.snp.makeConstraints { make in
            make.leading.trailing.equalTo(contentView)
            make.top.bottom.equalTo(contentView).inset(8)
        }
        
        editButton.snp.makeConstraints { make in
            make.width.height.equalTo(30)
        }
    }
}


