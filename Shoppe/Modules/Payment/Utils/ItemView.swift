//
//  ItemView.swift
//  Shoppe
//
//  Created by Dmitry Volkov on 04/03/2025.
//

import UIKit
import SnapKit


class ItemView: UIView {
    let item: Product
        
    lazy var imageView = ShadowImageView(imageName: item.image)
    
    lazy var itemsNumber = CountCircleView(size: 12, radius: 9)

    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = item.description
        label.font = UIFont(name: "NunitoSans10pt-Regular", size: 12)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = String(format: "$%.2f", item.price)
        label.font = UIFont(name: "Raleway-Bold", size: 20)
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
    
    init(item: Product) {
        self.item = item
        super.init(frame: .zero)
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(stackView)
        addSubview(itemsNumber)
    }
    
    func setConstraints() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
                
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(60)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.width.equalTo(170)
        }
        
        itemsNumber.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(-15)
            make.top.equalTo(imageView.snp.top).offset(3)
        }
        
        
    }
}

