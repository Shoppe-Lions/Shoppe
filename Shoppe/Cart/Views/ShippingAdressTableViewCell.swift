//
//  ShippingAdressTableViewCell.swift
//  Shoppe
//
//  Created by Artem Kriukov on 04.03.2025.
//

import UIKit
import SnapKit

final class ShippingAdressTableViewCell: UITableViewCell {
    // MARK: - UI
    private lazy var shippingAdressSV: UIStackView = {
        let element = UIStackView()
        element.axis = .vertical
        element.backgroundColor = UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 1)
        element.isLayoutMarginsRelativeArrangement = true
        element.layoutMargins = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        element.layer.cornerRadius = 10
        return element
    }()
    
    private lazy var titleAdressLabel: UILabel = {
        let element = UILabel()
        element.text = "Shipping Address"
        element.font = .systemFont(ofSize: 14, weight: .bold)
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
        element.text = "26, Duong So 2, Thao Dien Ward, An Phu, District 2, Ho Chi Minh city"
        element.numberOfLines = 0
        element.font = .systemFont(ofSize: 10, weight: .regular)
        return element
    }()
    
    private lazy var editButton: UIButton = {
        let element = UIButton(type: .custom)
        element.setImage(UIImage(named: "EditButton"), for: .normal)
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


