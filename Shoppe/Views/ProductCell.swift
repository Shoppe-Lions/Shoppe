//
//  ProductCell.swift
//  Shoppe
//
//  Created by ordoko on 04.03.2025.
//

import UIKit
import SnapKit

class ProductCell: UICollectionViewCell {
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = .label
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 0.98
        label.attributedText = NSMutableAttributedString(string: "Lorem ipsum dolor sit amet consectetur", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        //TODO: добавить шрифт
        label.font = UIFont(name: "NunitoSans-Regular", size: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }() // CGRect(x: 0, y: 0, width: 138, height: 36)
    
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .customBlack
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.05
        label.attributedText = NSMutableAttributedString(string: "$17,00", attributes: [NSAttributedString.Key.kern: -0.17, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        //TODO: добавить шрифт
        label.font = UIFont(name: "Raleway-Bold", size: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    //CGRect(x: 0, y: 0, width: 52, height: 21)
    // Line height: 21 pt
    // (identical to box height)
    
    private let addToCartButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add to cart", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.textAlignment = .center // Line height: 12.1 pt
        //TODO: добавить шрифт
        button.titleLabel?.font = UIFont(name: "Inter-Regular", size: 10)
        button.backgroundColor = .customBlue
        button.layer.cornerRadius = 4
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    //button CGRect(x: 0, y: 0, width: 120, height: 31)
    //title CGRect(x: 0, y: 0, width: 118, height: 31)
    //title.widthAnchor.constraint(equalToConstant: 118).isActive = true
    //title.heightAnchor.constraint(equalToConstant: 31).isActive = true
    
    
    private let wishlistButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "wishlist_off"), for: .normal)
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    //heart CGRect(x: 0, y: 0, width: 22.02, height: 20.64)
    
    private let photoContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        view.layer.shadowRadius = 10
        view.layer.shadowOpacity = 1
        view.layer.cornerRadius = 9
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        return view
    }()//CGRect(x: 0, y: 0, width: 165, height: 181)
    
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView(image: .testPhoto)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 9
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()// CGRect(x: 0, y: 0, width: 165, height: 181)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(photoContainerView)
        photoContainerView.addSubview(photoImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(addToCartButton)
        contentView.addSubview(wishlistButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        photoContainerView.snp.makeConstraints { make in //CGRect(x: 0, y: 0, width: 165, height: 181)
            make.top.leading.trailing.equalToSuperview().inset(5)
            make.height.equalTo(contentView.frame.width - 10)
        }

        photoImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(5) 
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(photoContainerView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(5)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview().inset(5)
        }
        
        addToCartButton.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(8)
            make.leading.bottom.equalToSuperview().inset(5)
            make.height.equalTo(36)
        }
        
        wishlistButton.snp.makeConstraints { make in
            make.centerY.equalTo(addToCartButton)
            make.leading.equalTo(addToCartButton.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(5)
            make.width.height.equalTo(36)
        }
    }
    
    // Метод для обновления данных в ячейке
    func configure(with product: Product) {
        photoImageView.image = UIImage(named: product.image)
        nameLabel.text = product.title
        priceLabel.text = "$\(product.price)"
    }
    
}
