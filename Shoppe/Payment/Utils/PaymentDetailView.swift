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
        self.backgroundColor = .lightGray
        self.layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        self.layer.cornerRadius = 15
        
        label.text = "Card"
        label.font = .systemFont(ofSize: 15, weight: .bold)
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
