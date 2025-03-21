//
//  ItemView.swift
//  Shoppe
//
//  Created by Dmitry Volkov on 04/03/2025.
//

import UIKit
import SnapKit


class ItemView: UIView {
    let item: CartItem
        
    lazy var imageView = ShadowImageView(imageName: item.product.localImagePath)
    
    lazy var itemsNumber = CountCircleView(size: 12, radius: 9, number: item.quantity)

    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = item.product.title
        label.font = UIFont(name: "NunitoSans10pt-Regular", size: PFontSize.small)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        //label.text = String(format: "$%.2f", item.product.price)
        label.font = UIFont(name: "Raleway-Bold", size: PFontSize.medium)
        label.textAlignment = .right
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [imageView, descriptionLabel, priceLabel])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 20
        stack.distribution = .fill
        return stack
    }()
    
    init(item: CartItem) {
        self.item = item
        super.init(frame: .zero)
        setupViews()
        setConstraints()
        setPrice()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(stackView)
        addSubview(itemsNumber)
    }
    
    func setPrice() {
        let convertedPrice = CurrencyManager.shared.convertToString(priceInUSD: item.product.price)
        priceLabel.text =  "\(convertedPrice) x \(item.quantity)"
    }
    
    func setConstraints() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
                
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(PLayout.totalViewHeight)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.width.equalTo(PLayout.descriptionLabel)
        }
        
        itemsNumber.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(-PLayout.paddingM)
            make.top.equalTo(imageView.snp.top).offset(PLayout.paddingXS)
        }
        
        
    }
}

