//
//  PaymentDetailView.swift
//  Shoppe
//
//  Created by Dmitry Volkov on 04/03/2025.
//

import UIKit
import SnapKit


class PaymentDetailView: UIView {
    let label = UILabel()
    
    init() {
        super.init(frame: .zero)
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        self.backgroundColor = .customLightGray
        self.layoutMargins = UIEdgeInsets(top: 8, left: 22, bottom: 8, right: 22)
        self.layer.cornerRadius = 17
        
        label.text = "Card"
        label.font = UIFont(name: "Raleway-Bold", size: PFontSize.normal)
        label.textColor = .customBlue
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(label)
    }
    
    func setConstraints() {
        label.snp.makeConstraints { make in
            make.edges.equalTo(self.layoutMarginsGuide)
        }
    }
}
