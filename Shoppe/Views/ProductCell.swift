//
//  ProductCell.swift
//  Shoppe
//
//  Created by ordoko on 04.03.2025.
//

import UIKit
import SnapKit


protocol ProductCellDelegate: AnyObject {
    func didTapWishlistButton(for product: Product)
}

class ProductCell: UICollectionViewCell {
    static let identifier = ProductCell.description()
    
    weak var delegate: ProductCellDelegate?
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
        label.attributedText = NSMutableAttributedString(
            string: "Lorem ipsum dolor sit amet consectetur",
            attributes: [
                .paragraphStyle: paragraphStyle,
                .baselineOffset: 1
            ]
        )
        label.font = UIFont(name: Fonts.NunitoSans.regular, size: 12)
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
    
    private lazy var buttonStackView: UIStackView = {
        let element = UIStackView()
        element.axis = .horizontal
        element.spacing = ProductConstants.spacing
        element.distribution = .fillProportionally
        return element
    }()
    
    private lazy var addToCartButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add to cart", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont(name: Fonts.Inter.regular, size: ProductFontSize.normal)
        button.backgroundColor = .customBlue
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(addToCartButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var quantityStackView: UIStackView = {
        let element = UIStackView()
        element.axis = .horizontal
        element.distribution = .fillEqually
        element.layer.cornerRadius = ProductConstants.cornerRadius
        element.clipsToBounds = true
        element.isHidden = true
        return element
    }()

    private lazy var minusButton: UIButton = {
        let element = UIButton(type: .system)
        element.setTitle("-", for: .normal)
        element.titleLabel?.font = UIFont(name: Fonts.NunitoSans.light, size: ProductFontSize.buttonSymbolSize)
        element.backgroundColor = .customLightGray
        element.addTarget(self, action: #selector(minusButtonTapped), for: .touchUpInside)
        return element
    }()

    private lazy var quantityLabel: UILabel = {
        let element = UILabel()
        element.textAlignment = .center
        element.font = UIFont(name: Fonts.NunitoSans.light, size: ProductFontSize.normal)
        element.backgroundColor = .customLightGray
        return element
    }()

    private lazy var plusButton: UIButton = {
        let element = UIButton(type: .system)
        element.setTitle("+", for: .normal)
        element.titleLabel?.font = UIFont(name: Fonts.NunitoSans.light, size: ProductFontSize.buttonSymbolSize)
        element.backgroundColor = .customLightGray
        element.addTarget(self, action: #selector(addToCartButtonTapped), for: .touchUpInside)
        return element
    }()

    private let wishlistButton: UIButton = {
        let button = UIButton()
        button.setImage(.wishlistOn, for: .normal)
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let imageLoader = ImageLoader.shared
    
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
        contentView.addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(addToCartButton)
        buttonStackView.addArrangedSubview(quantityStackView)
        quantityStackView.addArrangedSubview(minusButton)
        quantityStackView.addArrangedSubview(quantityLabel)
        quantityStackView.addArrangedSubview(plusButton)
        buttonStackView.addArrangedSubview(wishlistButton)
        
    }
    
    private func setupConstraints(isPopular: Bool) {
        if isPopular {
            // Констрейнты для popular секции
            photoContainerView.snp.remakeConstraints { make in
                make.top.equalToSuperview()
                make.centerX.equalToSuperview()
                make.width.height.equalTo(160)
            }
            
            photoImageView.snp.remakeConstraints { make in
                make.center.equalToSuperview()
                make.width.height.equalTo(145)
            }
        } else {
            // Стандартные констрейнты
            photoContainerView.snp.remakeConstraints { make in
                make.top.equalToSuperview().inset(15)
                make.centerX.equalToSuperview()
                make.height.equalTo(181)
                make.width.equalTo(165)
            }

            photoImageView.snp.remakeConstraints { make in
                make.center.equalToSuperview()
                make.width.height.equalToSuperview().multipliedBy(0.9)
            }
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(photoContainerView.snp.bottom).offset(8)
            make.leading.equalTo(photoContainerView)
            make.trailing.equalTo(photoContainerView)
            make.height.lessThanOrEqualTo(36)
        }
        
        if isPopular {
            // Для Popular секции - priceLabel ближе к nameLabel
            priceLabel.snp.remakeConstraints { make in
                make.top.equalTo(nameLabel.snp.bottom).offset(4) // уменьшаем отступ
                make.leading.trailing.equalToSuperview().inset(8)
            }
        } else {
            // Стандартные констрейнты для priceLabel
            priceLabel.snp.remakeConstraints { make in
                make.top.equalTo(nameLabel.snp.bottom).offset(8)
                make.leading.trailing.equalToSuperview().inset(8)
            }
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(5)
            make.height.equalTo(31)
            make.leading.trailing.equalTo(photoContainerView)
            make.bottom.equalToSuperview()
        }
        
        wishlistButton.snp.makeConstraints { make in
            make.height.equalTo(22)
            make.width.equalTo(22)
        }
    }
    
    // MARK: - Нужно перенести логику
    
    private func fetchProduct(id: Int, completion: @escaping (Product?) -> Void) {
        APIService.shared.fetchProduct(by: id) { result in
            switch result {
            case .success(let product):
                self.setCartCount(by: product.id)
                completion(product)
            case .failure:
                completion(nil)
            }
        }
    }
    
    @objc private func addToCartButtonTapped() {
        guard let product = product else { return }
        
        fetchProduct(id: product.id, completion: { product in
            if let product = product {
                StorageCartManager.shared.addProduct(product) {
                    self.setCartCount(by: product.id)
                }
            }
        })
    }
    
    @objc private func minusButtonTapped() {
        guard let product = product else { return }
        
        StorageCartManager.shared.loadCart { cartItems in
            guard let item = cartItems.first(where: { $0.id == product.id }) else { return }

            if item.quantity > 1 {
                var updatedItem = item
                updatedItem.quantity -= 1
                StorageCartManager.shared.updateProduct(updatedItem) {
                    self.setCartCount(by: product.id)
                }
            } else {
                APIService.shared.fetchProduct(by: product.id) { result in
                    switch result {
                    case .success(let product):
                        StorageCartManager.shared.removeProduct(product) {
                            self.setCartCount(by: product.id)
                        }
                    case .failure:
                        break
                    }
                }
            }
        }
    }
    
    func setCartCount(by id: Int) {
        StorageCartManager.shared.loadCart { cart in
            if let productInCart = cart.first(where: { $0.id == id }) {
                self.addToCartButton.isHidden = true
                self.quantityStackView.isHidden = false
                self.wishlistButton.isHidden = false
                self.quantityLabel.text = "\(productInCart.quantity)"
            } else {
                self.addToCartButton.isHidden = false
                self.quantityStackView.isHidden = true
                self.wishlistButton.isHidden = false
            }
        }
    }
    
    // MARK: Configure
    // Метод для обновления данных в ячейке
    func configure(with product: Product, isPopularSection: Bool = false) {
        self.product = product
        nameLabel.text = product.title
        priceLabel.text = CurrencyManager.shared.convertToString(priceInUSD: product.price)
        wishlistButton.setImage(product.like ? .wishlistOn : .wishlistOff, for: .normal)
        
        // Настраиваем видимость элементов для Popular секции
        addToCartButton.isHidden = isPopularSection
        quantityStackView.isHidden = isPopularSection
        wishlistButton.isHidden = isPopularSection
        
        if !isPopularSection {
            setCartCount(by: product.id)
        }
        
        // Загрузка изображения
        if product.localImagePath != "Path",
           let image = UIImage(contentsOfFile: product.localImagePath) {
            photoImageView.image = image
        } else {
            photoImageView.image = UIImage(named: "placeholderImage")
            imageLoader.loadImage(from: product.imageURL) { [weak self] image, localPath in
                DispatchQueue.main.async {
                    if let image = image {
                        self?.photoImageView.image = image
                    }
                }
            }
        }
        
        setupConstraints(isPopular: isPopularSection)
    }
    
    @objc func handleWishlistButtonTapped() {
        guard let product = product else { print("no product"); return }
        delegate?.didTapWishlistButton(for: product)
    }
    
}
