//
//  WishlistProductCell.swift
//  Shoppe
//
//  Created by ordoko on 09.03.2025.
//

import UIKit
import SnapKit


protocol WishlistProductCellDelegate: AnyObject {
    func didTapWishlistButton(for product: Product)
}

class WishlistProductCell: UICollectionViewCell {
    
    weak var delegate: WishlistProductCellDelegate?
    var product: Product?
    
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
    }()
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView(image: .testPhoto)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 9
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = .label
        label.numberOfLines = 2
        label.lineBreakMode = .byCharWrapping
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 0.98
        label.attributedText = NSMutableAttributedString(string: "Lorem ipsum dolor sit amet consectetur", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        label.font = UIFont(name: "NunitoSans10pt-Regular", size: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .customBlack
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.05
        label.attributedText = NSMutableAttributedString(string: "$17,00", attributes: [NSAttributedString.Key.kern: -0.17, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        label.font = UIFont(name: Fonts.Raleway.bold, size: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let addToCartButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add to cart", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont(name: Fonts.Inter.regular, size: 10)
        button.backgroundColor = .customBlue
        button.layer.cornerRadius = 4
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let wishlistButton: UIButton = {
        let button = UIButton()
        button.setImage(wishlistOnImage, for: .normal)
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        wishlistButton.addTarget(self, action: #selector(handleWishlistButtonTapped), for: .touchUpInside)
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
        photoContainerView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.centerX.equalToSuperview()
            make.height.equalTo(181)
            make.width.equalTo(165)
        }

        photoImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(5)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(photoContainerView.snp.bottom).offset(8)
            make.leading.equalTo(photoContainerView)
            make.trailing.equalTo(photoContainerView)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(1)
            make.leading.equalTo(photoContainerView)
            make.trailing.equalTo(photoContainerView)
        }
        
        addToCartButton.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(5)
            make.height.equalTo(31)
            make.leading.equalTo(photoContainerView)
            make.bottom.equalToSuperview()
        }
        
        wishlistButton.snp.makeConstraints { make in
            make.centerY.equalTo(addToCartButton)
            make.leading.equalTo(addToCartButton.snp.trailing).offset(19)
            make.trailing.equalTo(photoContainerView)
            make.height.equalTo(22)
            make.width.equalTo(22)
        }
    }
    
    // MARK: Configure
    // Метод для обновления данных в ячейке
    func configure(with product: Product) {
        self.product = product
        if let img = UIImage(contentsOfFile: product.localImagePath) {
            photoImageView.image = img
        } else {
            print("no image")
        }
       
        nameLabel.text = product.title
        priceLabel.text = CurrencyManager.shared.convertToString(priceInUSD: product.price) //todo: в идеале форматирование строки с ценой должно быть во viewModel
        wishlistButton.setImage(product.like ? wishlistOnImage : wishlistOffImage, for: .normal)
    }
    
    @objc func handleWishlistButtonTapped() {
        guard let product = product else { print("no product"); return }
        delegate?.didTapWishlistButton(for: product)
    }
    
}
