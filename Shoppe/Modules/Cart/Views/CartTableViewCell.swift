//
//  CartTableViewCell.swift
//  Shoppe
//
//  Created by Artem Kriukov on 04.03.2025.
//

import UIKit
import SnapKit

final class CartTableViewCell: UITableViewCell {
    
    private var product: Product?
    private var index: Int?
    weak var presenter: CartPresenterProtocol?
    
    lazy var alertView = CustomAlertView(
        title: "Delete Item?",
        message: "Are you shure?",
        buttonText: "Delete",
        secondButtonText: "Cancel"
    )
    // MARK: - UI
    private lazy var cellStackView: UIStackView = {
        let element = UIStackView()
        element.axis = .horizontal
        element.spacing = 10
        return element
    }()
    
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
    
    private lazy var cellImageView: UIImageView = {
        let element = UIImageView()
        element.image = UIImage(named: "Cell")
        element.contentMode = .scaleAspectFit
        element.isUserInteractionEnabled = true
        return element
    }()
    
    private lazy var deleteProductButton: UIButton = {
        let element = UIButton(type: .custom)
        element.setImage(UIImage(named: "DeleteProduct"), for: .normal)
        element.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
        return element
    }()
    
    private lazy var productStackView: UIStackView = {
        let element = UIStackView()
        element.axis = .vertical
        element.spacing = 23
        return element
    }()
    
    private lazy var topInfoProductStacView: UIStackView = {
        let element = UIStackView()
        element.axis = .vertical
        element.spacing = 13
        return element
    }()
    private lazy var nameProductLabel: UILabel = {
        let element = UILabel()
        element.text = "Product name"
        element.font = UIFont(name: Fonts.NunitoSans.regular, size: 12)
        return element
    }()
    
    private lazy var infoLabel: UILabel = {
        let element = UILabel()
        element.text = "Pink, Size M"
        element.font = UIFont(name: Fonts.Raleway.medium, size: 14)
        return element
    }()
    
    private lazy var bottomInfoStackView: UIStackView = {
        let element = UIStackView()
        element.axis = .horizontal
        return element
    }()
    
    private lazy var priceLabel: UILabel = {
        let element = UILabel()
        element.text = "$17,00"
        element.font = UIFont(name: Fonts.Raleway.bold, size: 18)
        element.textColor = UIColor(named: "CustomBlack")
        return element
    }()
    
    private lazy var counterStackView: UIStackView = {
        let element = UIStackView()
        element.axis = .horizontal
        element.spacing = 6
        return element
    }()
    
    private lazy var lessButton: UIButton = {
        let element = UIButton(type: .custom)
        element.setImage(UIImage(named: "Less"), for: .normal)
        element.addTarget(self, action: #selector(decreaseQuantity), for: .touchUpInside)
        return element
    }()
    
    private lazy var counterLabel: UILabel = {
        let element = UILabel()
        element.text = "1"
        element.backgroundColor = UIColor(named: "CustomLightGray")
        element.font = UIFont(name: Fonts.Raleway.medium, size: 16)
        element.layer.masksToBounds = true
        element.layer.cornerRadius = 8
        element.textAlignment = .center
        return element
    }()
    
    private lazy var moreButton: UIButton = {
        let element = UIButton(type: .custom)
        element.setImage(UIImage(named: "More"), for: .normal)
        element.addTarget(self, action: #selector(increaseQuantity), for: .touchUpInside)
        return element
    }()
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with product: Product, at index: Int, quantity: Int, presenter: CartPresenterProtocol) {
        self.product = product
        self.index = index
        self.presenter = presenter
        
        let convertedPrice = CurrencyManager.shared.convert(priceInUSD: product.price)
        let totalPrice = convertedPrice * Double(quantity)
        priceLabel.text = CurrencyManager.shared.makeToString(priceInUSD: totalPrice)
        counterLabel.text = "\(quantity)"
        
        cellImageView.image = UIImage(contentsOfFile: product.localImagePath)
        nameProductLabel.text = product.title
    }
    
    // MARK: - Action
    func updateQuantity(_ quantity: Int) {
        guard let product else { return }
        counterLabel.text = "\(quantity)"
        
        let convertedPrice = CurrencyManager.shared.convert(priceInUSD: product.price)
        let totalPrice = convertedPrice * Double(quantity)
        priceLabel.text = CurrencyManager.shared.makeToString(priceInUSD: totalPrice)
        
    }
    
    @objc private func increaseQuantity() {
        guard let index else { return }
        presenter?.increaseProductQuantity(at: index)
    }
    
    @objc private func decreaseQuantity() {
        guard let index else { return }
        presenter?.decreaseProductQuantity(at: index)
    }
    
    @objc private func didTapDeleteButton() {
        alertView.show()
        alertView.button.addTarget(self, action: #selector(confirmDelete), for: .touchUpInside)
        alertView.secondButton.addTarget(self, action: #selector(cancelDelete), for: .touchUpInside)
        alertView.secondButton.isHidden = false
    }
    
    @objc func confirmDelete() {
        alertView.dismiss()
        guard let index else { return }
        presenter?.deleteProduct(at: index)
    }
    
    @objc func cancelDelete() {
        alertView.dismiss()
    }
}

private extension CartTableViewCell {
    func setupViews() {
        contentView.addSubview(cellStackView)
        
        cellStackView.addArrangedSubview(photoContainerView)
        
        photoContainerView.addSubview(cellImageView)
        cellImageView.addSubview(deleteProductButton)
        
        cellStackView.addArrangedSubview(productStackView)
        productStackView.addArrangedSubview(topInfoProductStacView)
        topInfoProductStacView.addArrangedSubview(nameProductLabel)
        topInfoProductStacView.addArrangedSubview(infoLabel)
        productStackView.addArrangedSubview(bottomInfoStackView)
        bottomInfoStackView.addArrangedSubview(priceLabel)
        bottomInfoStackView.addArrangedSubview(counterStackView)
        counterStackView.addArrangedSubview(lessButton)
        counterStackView.addArrangedSubview(counterLabel)
        counterStackView.addArrangedSubview(moreButton)
        
    }
    
    func setupConstraints() {
        cellStackView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(contentView)
        }
        
        
        photoContainerView.snp.makeConstraints { make in
            
            make.height.equalTo(109)
            make.width.equalTo(129)
        }

        cellImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(5)
        }
        
        deleteProductButton.snp.makeConstraints { make in
            make.bottom.equalTo(cellImageView.snp.bottom).inset(6)
            make.leading.equalTo(cellImageView.snp.leading).inset(6)
            make.width.height.equalTo(35)
        }
        
        counterLabel.snp.makeConstraints { make in
            make.width.equalTo(37)
            make.height.equalTo(30)
        }
        
        lessButton.snp.makeConstraints { make in
            make.width.height.equalTo(30)
        }
        
        moreButton.snp.makeConstraints { make in
            make.width.height.equalTo(30)
        }
    }
}

