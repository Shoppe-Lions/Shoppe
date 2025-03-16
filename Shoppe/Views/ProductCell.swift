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
        label.font = UIFont(name: Fonts.NunitoSans.regular, size: 12)
        label.textColor = .label
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .left
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
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
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
        
        nameLabel.snp.remakeConstraints { make in
            make.top.equalTo(photoContainerView.snp.bottom).offset(4)
            make.leading.equalTo(photoContainerView.snp.leading).offset(4)
            make.trailing.equalTo(photoContainerView.snp.trailing).offset(8)
            make.height.equalTo(36)
        }
        
        if isPopular {
            // Для Popular секции - только priceLabel
            priceLabel.snp.remakeConstraints { make in
                make.top.equalTo(nameLabel.snp.bottom).offset(4)
                make.leading.trailing.equalToSuperview().inset(4)
                make.height.equalTo(24)
            }
            
            buttonStackView.isHidden = true
        } else {
            // Стандартные констрейнты для обычной ячейки
            priceLabel.snp.remakeConstraints { make in
                make.top.equalTo(nameLabel.snp.bottom).offset(4)
                make.leading.equalTo(photoContainerView.snp.leading).offset(4)
                make.trailing.equalTo(photoContainerView.snp.trailing).offset(8)
                make.height.equalTo(24)
            }
            
            // Показываем и настраиваем buttonStackView
            buttonStackView.isHidden = false
            
            // Настраиваем фиксированные размеры для всех кнопок
            addToCartButton.snp.remakeConstraints { make in
                make.width.equalTo(100)
                make.height.equalTo(35)
            }
            
            quantityStackView.snp.remakeConstraints { make in
                make.width.equalTo(100)
                make.height.equalTo(35)
            }
            
            wishlistButton.snp.remakeConstraints { make in
                make.width.height.equalTo(26)
            }
            
            // Увеличиваем отступ от priceLabel до buttonStackView
            buttonStackView.snp.remakeConstraints { make in
                make.top.equalTo(priceLabel.snp.bottom).offset(8)
                make.leading.equalTo(photoContainerView.snp.leading).offset(4)
                make.trailing.equalTo(photoContainerView.snp.trailing).offset(8)
                make.bottom.equalToSuperview().offset(-4)
                make.height.equalTo(35)
            }
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
        StorageCartManager.shared.loadCart { [weak self] cart in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if let productInCart = cart.first(where: { $0.id == id }) {
                    self.addToCartButton.isHidden = true
                    self.quantityStackView.isHidden = false
                    self.quantityLabel.text = "\(productInCart.quantity)"
                } else {
                    self.addToCartButton.isHidden = false
                    self.quantityStackView.isHidden = true
                }
                // Не меняем видимость wishlistButton здесь
            }
        }
    }
    
    // MARK: Configure
    // Метод для начальной настройки ячейки
    private func setupInitialState(with product: Product, isPopularSection: Bool) {
        self.product = product
        
        // Настраиваем nameLabel с правильным форматированием
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 0.98
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.alignment = .left
        
        let attributedString = NSMutableAttributedString(
            string: product.title,
            attributes: [
                .paragraphStyle: paragraphStyle,
                .baselineOffset: 1,
                .font: UIFont(name: Fonts.NunitoSans.regular, size: 12) ?? .systemFont(ofSize: 12),
                .foregroundColor: UIColor.label
            ]
        )
        
        nameLabel.attributedText = attributedString
        nameLabel.numberOfLines = 2 // Явно устанавливаем количество строк
        
        priceLabel.text = CurrencyManager.shared.convertToString(priceInUSD: product.price)
        
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
    
    // Метод для обновления только состояния кнопок
    private func updateButtonsState(isLiked: Bool, isPopularSection: Bool) {
        wishlistButton.setImage(isLiked ? .wishlistOn : .wishlistOff, for: .normal)
        
        if isPopularSection {
            buttonStackView.isHidden = true
        } else {
            buttonStackView.isHidden = false
            if let product = product {
                setCartCount(by: product.id)
            }
        }
    }
    
    func configure(with product: Product, isPopularSection: Bool = false) {
        if self.product?.id != product.id {
            // Если это новый продукт, настраиваем всю ячейку
            setupInitialState(with: product, isPopularSection: isPopularSection)
        } else {
            // Обновляем существующий продукт
            self.product = product
        }
        // Обновляем только состояние кнопок
        updateButtonsState(isLiked: product.like, isPopularSection: isPopularSection)
    }
    
    @objc func handleWishlistButtonTapped() {
        guard let product = product else { print("no product"); return }
        // Обновляем состояние продукта локально перед вызовом делегата
        var updatedProduct = product
        updatedProduct.like.toggle()
        self.product = updatedProduct
        delegate?.didTapWishlistButton(for: product)
    }
    
}
