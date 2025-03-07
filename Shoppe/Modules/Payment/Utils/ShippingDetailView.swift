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
        let image = UIImage(named: "Check")
        button.setImage(image, for: .normal)
        button.tintColor = .blue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var typeLabel: UIView = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = type == .standard ? "Standard" : "Express"
        label.font = UIFont(name: "Raleway-SemiBold", size: PFontSize.normal)
        label.textAlignment = .left
        return label
    }()
    
    lazy var durationLabel: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .customGray
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var durationLabeltext: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = type == .standard ? "5-7 days" : "1-2 days"
        label.font = UIFont(name: "Raleway-Regular", size: PFontSize.small)
        label.textColor = .customBlue
        label.textAlignment = .right
        return label
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = type == .standard ? "FREE" : "$12,00"
        label.font = UIFont(name: "Raleway-Bold", size: PFontSize.normal)
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
        self.layer.cornerRadius = 12
        addSubview(button)
        addSubview(typeLabel)
        addSubview(durationLabel)
        durationLabel.addSubview(durationLabeltext)
        addSubview(priceLabel)
    }
        
    func setConstraints() {
        button.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(PLayout.paddingS)
            make.leading.equalToSuperview().offset(PLayout.paddingM)
            make.width.height.equalTo(PLayout.paddingL)
        }
        
        typeLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(button.snp.trailing).offset(PLayout.paddingS)
        }
        
        durationLabel.snp.makeConstraints { make in
            make.leading.equalTo(typeLabel.snp.trailing).offset(PLayout.horizontalPadding)
            make.centerY.equalToSuperview()
            make.size.equalTo(PLayout.deliveryDurationSize)
        }
        
        durationLabeltext.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview().offset(-PLayout.horizontalPadding)
            make.centerY.equalTo(button)
        }
        
        self.snp.makeConstraints { make in
            make.bottom.equalTo(button.snp.bottom).offset(PLayout.paddingS)
        }
    }
}

