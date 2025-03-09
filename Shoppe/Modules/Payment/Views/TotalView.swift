//
//  TotalView.swift
//  Shoppe
//
//  Created by Dmitry Volkov on 04/03/2025.
//

import UIKit
import SnapKit

class TotalView: UIView {
    
    lazy var totalPrice: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Raleway-Bold", size: PFontSize.medium)
        label.textAlignment = .left
        return label
    }()
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Pay", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "NunitoSans10pt-Regular", size: PFontSize.medium)
        button.backgroundColor = .black
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        self.backgroundColor = .customGray
        self.addSubview(totalPrice)
        self.addSubview(button)
        
    }
    
    func setConstraints() {
        totalPrice.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(PLayout.horizontalPadding)
            make.centerY.equalToSuperview()
        }
        
        button.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-PLayout.horizontalPadding)
            make.size.equalTo(PLayout.payButtonSize)
            make.centerY.equalToSuperview()
        }
    }
}
