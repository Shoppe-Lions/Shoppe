//
//  File.swift
//  Shoppe
//
//  Created by Dmitry Volkov on 04/03/2025.
//

import UIKit

enum shippingType {
    case standard, express
}

class ShippingDetailView: UIView {
    var type: shippingType
    
    lazy var button: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "checkmark.circle.fill")?
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 30))
        button.setImage(image, for: .normal)
        button.tintColor = .blue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var typeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = type == .standard ? "Standard" : "Express"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .left
        return label
    }()
    
    lazy var durationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = type == .standard ? "5-7 days" : "1-2 days"
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textAlignment = .right
        return label
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = type == .standard ? "FREE" : "$12,00"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .right
        return label
    }()
    

    init(type: shippingType) {
        self.type = type
        super.init(frame: .zero)
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        self.backgroundColor = .lightGray
        self.layer.cornerRadius = 12
        addSubview(button)
        addSubview(typeLabel)
        addSubview(durationLabel)
        addSubview(priceLabel)
    }
    
    func setConstraints() {
        button.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.leading.equalToSuperview().offset(5)
            make.leading.equalToSuperview().offset(20)
            make.width.height.equalTo(40)
        }
        
        typeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(button.snp.trailing).offset(20)
            make.centerY.equalTo(button)
        }
        
        durationLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(typeLabel.snp.trailing).offset(20)
            make.centerY.equalTo(button)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalTo(button)
        }
        
        self.snp.makeConstraints { make in
            make.bottom.equalTo(button.snp.bottom).offset(5) // Устанавливаем высоту по нижнему краю последнего элемента
        }
    }
}

