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
    func showImage(_ image: UIImage?)
    func showSubcategoryes(count: Int)
}

final class ProductViewController: UIViewController, ProductViewProtocol {
    
    var presenter: ProductPresenterProtocol!
    var spasingElements: CGFloat = 20
    
    // MARK: - UI Elements
    
    private lazy var scrollView: UIScrollView = {
        let element = UIScrollView()
        element.showsVerticalScrollIndicator = false
        return element
    }()
    
    private lazy var mainStackView: UIStackView = {
        let element = UIStackView()
        element.axis = .vertical
        element.spacing = spasingElements
        return element
    }()
    
    private lazy var productImageView: UIImageView = {
        let element = UIImageView()
        element.contentMode = .scaleAspectFit
        return element
    }()
    
    private lazy var nameProductLabel: UILabel = {
        let element = UILabel()
        element.font = UIFont(name: Fonts.Raleway.extraBold, size: 26)
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
        element.font = UIFont(name: Fonts.Raleway.extraBold, size: 26)
        element.textAlignment = .left
        return element
    }()
    
    private lazy var likeImageView: UIImageView = {
        let element = UIImageView(image: UIImage(named: "wishlist_off"))
        return element
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let element = UILabel()
        element.font = UIFont(name: Fonts.NunitoSans.regular, size: 15)
        element.numberOfLines = 0
        return element
    }()
    
    private lazy var variationsStackView: UIStackView = {
        let element = UIStackView()
        element.axis = .horizontal
        element.spacing = 10
        return element
    }()
    
    private lazy var variationsLabel: UILabel = {
        let element = UILabel()
        element.text = "Variations"
        element.font = UIFont(name: Fonts.Raleway.extraBold, size: 20)
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
        element.font = UIFont(name: Fonts.Raleway.medium, size: 14)
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
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let element = UIStackView()
        element.axis = .horizontal
        element.spacing = 10
        element.distribution = .fillProportionally
        return element
    }()
    
    private lazy var likeButton: UIButton = {
        let element = UIButton(type: .custom)
        element.layer.cornerRadius = 11
        element.backgroundColor = .customLightGray
        element.setImage(UIImage(named: "wishlist_off"), for: .normal)
        return element
    }()
    
    private lazy var addToCartButton: UIButton = {
        let element = UIButton(type: .system)
        element.setTitle("Add to cart", for: .normal)
        element.titleLabel?.font = UIFont(name: Fonts.NunitoSans.light, size: 16)
        element.backgroundColor = .black
        element.tintColor = .white
        element.layer.cornerRadius = 11
        return element
    }()
    
    private lazy var buyNowButton: UIButton = {
        let element = UIButton(type: .system)
        element.setTitle("Buy now", for: .normal)
        element.titleLabel?.font = UIFont(name: Fonts.NunitoSans.light, size: 16)
        element.backgroundColor = .blue
        element.tintColor = .white
        element.layer.cornerRadius = 11
        return element
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setupConstraints()
        presenter.viewDidLoad()
    }
    
    func showProduct(_ product: Product) {
        nameProductLabel.text = product.title
        priceLabel.text = "$\(product.price)"
        if product.like {
            likeImageView.image = UIImage(named: "wishlist_on")
            likeButton.setImage(UIImage(named: "wishlist_on"), for: .normal)
        }
        descriptionLabel.text = product.description
        subcategoryLabel.text = product.subcategory
        print(product)
    }
    
    func showImage(_ image: UIImage?) {
        productImageView.image = image
    }
    
    func showSubcategoryes(count: Int) {
        if count > 0 {
            for _ in 0...count {
                let imageView = UIImageView()
                imageView.contentMode = .scaleAspectFit
                imageView.image = UIImage(named: "testPhotoImage")
                imageView.snp.makeConstraints { make in
                    make.width.height.equalTo(80)
                }
                variationsImagesStackView.addArrangedSubview(imageView)
            }
        } else {
            variationsStackView.isHidden = true
        }
    }
    
    func showError(_ message: String) {
        print(message)
    }
}

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
        buttonStackView.addArrangedSubview(addToCartButton)
        buttonStackView.addArrangedSubview(buyNowButton)
    }
    
    func setupConstraints() {
        
        scrollView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(buttonStackView.snp.top).offset(-spasingElements)
        }
        
        mainStackView.snp.makeConstraints { make in
            make.top.bottom.equalTo(scrollView).inset(spasingElements)
            make.leading.trailing.equalTo(view).inset(spasingElements)
            make.width.equalTo(scrollView)
        }
        
        productImageView.snp.makeConstraints { make in
            make.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.5)
        }
        
        likeImageView.snp.makeConstraints { make in
            make.height.width.equalTo(30)
        }
        
        subcategoryLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        
        variationsScrollView.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.leading.trailing.equalToSuperview()
        }

        variationsImagesStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(spasingElements)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(spasingElements)
        }
        
        likeButton.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(40)
        }

        addToCartButton.snp.makeConstraints { make in
            make.height.equalTo(40)
        }

        buyNowButton.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
    }
}
