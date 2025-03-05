//
//  DetailsViews.swift
//  Shoppe
//
//  Created by Dmitry Volkov on 04/03/2025.
//

import UIKit
import SnapKit

enum DetailsViewType {
    case shipping, contacts
}


class DetailsView: UIView {
    
    let type: DetailsViewType
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "26, Duong So 2, Thao Dien Ward, An Phu, District 2, Ho Chi Minh city"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    lazy var phoneLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "+84932000000"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "amandamorgan@example.com"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    lazy var editButton = EditButton()
    
    init(type: DetailsViewType) {
        self.type = type
        super.init(frame: .zero)
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        titleLabel.text = type == .shipping ? "Shipping Address" : "Contact Information"
        self.layer.cornerRadius = 15
        self.backgroundColor = .gray
        self.addSubview(titleLabel)
        self.addSubview(addressLabel)
        self.addSubview(phoneLabel)
        self.addSubview(emailLabel)
        self.addSubview(editButton)
        
        addressLabel.isHidden = type != .shipping
        phoneLabel.isHidden = type != .contacts
        emailLabel.isHidden = type != .contacts
    }
    
    func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(20)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-50)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
        
        phoneLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(phoneLabel.snp.bottom).offset(10)
        }
        
        editButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-10)
        }
        
    }
}
