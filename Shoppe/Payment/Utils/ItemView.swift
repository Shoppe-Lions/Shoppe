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
    
    lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "mockImage")
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "26, Duong So 2, Thao Dien Ward, An Phu, District 2, Ho Chi Minh city"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "$17,00"
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textAlignment = .right
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [imageView, descriptionLabel, priceLabel])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 12
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
    }
    
    func setConstraints() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
                
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(50)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.width.equalTo(230)
        }
        
        
    }
}

