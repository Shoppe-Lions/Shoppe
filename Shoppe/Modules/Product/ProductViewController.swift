//
//  ProductViewController.swift
//  Shoppe
//
//  Created by Игорь Клевжиц on 05.03.2025.
//

import UIKit
import SnapKit

protocol ProductViewProtocol: AnyObject {
    func showProduct(_ product: Product)
    func showError(_ message: String)
    func showSubcategoryes(by products: [Product]?)
    func setLike(by like: Bool)
    func setCartCount(by count: Int)
}

final class ProductViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private lazy var scrollView: UIScrollView = {
        let element = UIScrollView()
        element.showsVerticalScrollIndicator = false
        return element
    }()
    
    private lazy var mainStackView: UIStackView = {
        let element = UIStackView()
        element.axis = .vertical
        element.spacing = ProductConstants.spacing
        return element
    }()
    
    private lazy var productImageView: UIImageView = {
        let element = UIImageView()
        element.contentMode = .scaleAspectFit
        return element
    }()
    
    private lazy var nameProductLabel: UILabel = {
        let element = UILabel()
        element.font = UIFont(name: Fonts.Raleway.extraBold, size: ProductFontSize.large)
        element.numberOfLines = 0
        return element
    }()
    
    private lazy var priceStackView: UIStackView = {
        let element = UIStackView()
        element.axis = .horizontal
        return element
    }()
    
    private lazy var priceLabel: UILabel = {
        let element = UILabel()
        element.font = UIFont(name: Fonts.Raleway.extraBold, size: ProductFontSize.large)
        element.textAlignment = .left
        return element
    }()
    
    private lazy var likeImageView: UIImageView = {
        let element = UIImageView(image: UIImage(named: "wishlist_off"))
        return element
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let element = UILabel()
        element.font = UIFont(name: Fonts.NunitoSans.regular, size: ProductFontSize.small)
        element.numberOfLines = 0
        return element
    }()
    
    private lazy var variationsStackView: UIStackView = {
        let element = UIStackView()
        element.axis = .horizontal
        element.spacing = ProductConstants.spacing
        return element
    }()
    
    private lazy var variationsLabel: UILabel = {
        let element = UILabel()
        element.text = "Variations"
        element.font = UIFont(name: Fonts.Raleway.extraBold, size: ProductFontSize.medium)
        return element
    }()
    
    private lazy var subcategoryContainerView: UIView = {
        let element = UIView()
        element.backgroundColor = .customLightGray
        element.layer.cornerRadius = 4
        return element
    }()
    
    private lazy var subcategoryLabel: UILabel = {
        let element = UILabel()
        element.text = "Subcategory"
        element.backgroundColor = .customLightGray
        element.layer.cornerRadius = 4
        element.textAlignment = .center
        element.font = UIFont(name: Fonts.Raleway.medium, size: ProductFontSize.small)
        return element
    }()
    
    private lazy var variationsFakeView: UIView = {
        let element = UIView()
        return element
    }()
    
    private lazy var variationsScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceHorizontal = true
        return scrollView
    }()

    private lazy var variationsImagesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = ProductConstants.spacing
        return stackView
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let element = UIStackView()
        element.axis = .horizontal
        element.spacing = ProductConstants.spacing
        element.distribution = .fillProportionally
        return element
    }()
    
    private lazy var likeButton: UIButton = {
        let element = UIButton(type: .custom)
        element.layer.cornerRadius = ProductConstants.cornerRadius
        element.backgroundColor = .customLightGray
        element.setImage(UIImage(named: "wishlist_off"), for: .normal)
        element.addTarget(self, action: #selector(likeButtonPressed), for: .touchUpInside)
        return element
    }()
    
    private lazy var addToCartButton: UIButton = {
        let element = UIButton(type: .system)
        element.setTitle("Add to cart", for: .normal)
        element.titleLabel?.font = UIFont(name: Fonts.NunitoSans.light, size: ProductFontSize.normal)
        element.backgroundColor = .black
        element.tintColor = .white
        element.layer.cornerRadius = ProductConstants.cornerRadius
        element.addTarget(self, action: #selector(addToCartButtonTapped), for: .touchUpInside)
        return element
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
    
    private lazy var buyNowButton: UIButton = {
        let element = UIButton(type: .system)
        element.setTitle("Buy now", for: .normal)
        element.titleLabel?.font = UIFont(name: Fonts.NunitoSans.light, size: ProductFontSize.normal)
        element.backgroundColor = .blue
        element.tintColor = .white
        element.layer.cornerRadius = ProductConstants.cornerRadius
        element.addTarget(self, action: #selector(buyNowButtonTapped), for: .touchUpInside)
        return element
    }()
    
    // MARK: - Properties
    
    var presenter: ProductPresenterProtocol!
    var id = 1
    
    // MARK: - Methods
    
    @objc private func likeButtonPressed() {
        presenter.toggleLike(id: id)
    }
    
    @objc private func buyNowButtonTapped() {
        presenter.buyNow(by: id)
    }
    
    @objc private func minusButtonTapped() {
        presenter.deleteFromCart(for: id)
    }
    
    @objc private func addToCartButtonTapped() {
        presenter.addToCart(by: id)
    }
    
    @objc private func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func productImageTapped(_ sender: UITapGestureRecognizer) {
        if let id = sender.view?.tag {
            presenter.goToNextProduct(by: id, navigationController: navigationController)
        }
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        setViews()
        setupConstraints()
        presenter.viewDidLoad(id: id)
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "arrow.left"),
            style: .plain,
            target: self,
            action: #selector(backTapped)
        )
        navigationItem.leftBarButtonItem?.tintColor = .black
    }
}

// MARK: - Set UI

private extension ProductViewController {
    
    func setViews() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(mainStackView)
        mainStackView.addArrangedSubview(productImageView)
        mainStackView.addArrangedSubview(nameProductLabel)
        
        mainStackView.addArrangedSubview(priceStackView)
        priceStackView.addArrangedSubview(priceLabel)
        priceStackView.addArrangedSubview(likeImageView)
        
        mainStackView.addArrangedSubview(descriptionLabel)
        
        mainStackView.addArrangedSubview(variationsStackView)
        variationsStackView.addArrangedSubview(variationsLabel)
        variationsStackView.addArrangedSubview(subcategoryContainerView)
        subcategoryContainerView.addSubview(subcategoryLabel)
        variationsStackView.addArrangedSubview(variationsFakeView)
        
        mainStackView.addArrangedSubview(variationsScrollView)
        variationsScrollView.addSubview(variationsImagesStackView)
        
        view.addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(likeButton)
        quantityStackView.addArrangedSubview(minusButton)
        quantityStackView.addArrangedSubview(quantityLabel)
        quantityStackView.addArrangedSubview(plusButton)
        buttonStackView.addArrangedSubview(quantityStackView)
        buttonStackView.addArrangedSubview(addToCartButton)
        buttonStackView.addArrangedSubview(buyNowButton)
    }
    
    func setupConstraints() {
        
        scrollView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(ProductConstants.spacing)
            make.bottom.equalTo(buttonStackView.snp.top).offset(-ProductConstants.spacing)
        }
        
        mainStackView.snp.makeConstraints { make in
            make.top.bottom.equalTo(scrollView).inset(ProductConstants.spacing)
            make.width.equalTo(scrollView)
        }
        
        productImageView.snp.makeConstraints { make in
            make.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(ProductConstants.productImageHeightMultiplier)
        }
        
        likeImageView.snp.makeConstraints { make in
            make.height.width.equalTo(ProductConstants.likeImageSize)
        }
        
        subcategoryLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(ProductConstants.subcategoryLabelInset)
        }
        
        variationsScrollView.snp.makeConstraints { make in
            make.height.equalTo(ProductConstants.variationsScrollHeight)
            make.leading.trailing.equalToSuperview()
        }

        variationsImagesStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(ProductConstants.spacing)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(ProductConstants.spacing)
        }
        
        likeButton.snp.makeConstraints { make in
            make.height.equalTo(ProductConstants.buttonHeight)
            make.width.equalTo(ProductConstants.buttonHeight)
        }
        
        quantityStackView.snp.makeConstraints { make in
            make.height.equalTo(ProductConstants.buttonHeight)
        }

        addToCartButton.snp.makeConstraints { make in
            make.height.equalTo(ProductConstants.buttonHeight)
        }

        buyNowButton.snp.makeConstraints { make in
            make.height.equalTo(ProductConstants.buttonHeight)
        }
    }
}

// MARK: - Protocol Methods

extension ProductViewController: ProductViewProtocol {
    
    func showProduct(_ product: Product) {
        nameProductLabel.text = product.title
        priceLabel.text = "$\(product.price)"
        setLike(by: product.like)
        print(product.like)
        descriptionLabel.text = product.description
        subcategoryLabel.text = product.subcategory
        productImageView.image = UIImage(contentsOfFile: product.localImagePath)
    }
    
    func setLike(by like: Bool) {
        if like {
            likeImageView.image = UIImage(named: "wishlist_on")
            likeButton.setImage(UIImage(named: "wishlist_on"), for: .normal)
        } else {
            likeImageView.image = UIImage(named: "wishlist_off")
            likeButton.setImage(UIImage(named: "wishlist_off"), for: .normal)
        }
    }
    
    func showSubcategoryes(by products: [Product]?) {
        if let subcategoryProducts = products {
            for product in subcategoryProducts {
                let imageView = UIImageView()
                imageView.contentMode = .scaleAspectFit
                imageView.image = UIImage(contentsOfFile: product.localImagePath)
                imageView.tag = product.id
                
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(productImageTapped(_:)))
                imageView.addGestureRecognizer(tapGesture)
                imageView.isUserInteractionEnabled = true
                
                imageView.snp.makeConstraints { make in
                    make.width.height.equalTo(ProductConstants.variationImageSize)
                }
                variationsImagesStackView.addArrangedSubview(imageView)
            }
        } else {
            variationsStackView.isHidden = true
        }
    }
    
    func setCartCount(by count: Int) {
        if count == 0 {
            addToCartButton.isHidden = false
            quantityStackView.isHidden = true
        } else {
            addToCartButton.isHidden = true
            quantityStackView.isHidden = false
            quantityLabel.text = "\(count)"
        }
    }
    
    func showError(_ message: String) {
        print(message)
    }
}
