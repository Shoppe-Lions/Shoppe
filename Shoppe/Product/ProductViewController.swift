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
}

final class ProductViewController: UIViewController, ProductViewProtocol {
    
    var presenter: ProductPresenterProtocol!
    var spasingElements: CGFloat = 20
    
    // MARK: - UI Elements
    
    private lazy var mainStackView: UIStackView = {
        let element = UIStackView()
        element.axis = .vertical
        element.spacing = spasingElements
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var productImageView: UIImageView = {
        let element = UIImageView()
        element.contentMode = .scaleAspectFit
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var nameProductLabel: UILabel = {
        let element = UILabel()
        element.font = UIFont(name: Fonts.Raleway.extraBold, size: 26)
        element.numberOfLines = 0
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var priceStackView: UIStackView = {
        let element = UIStackView()
        element.axis = .horizontal
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var priceLabel: UILabel = {
        let element = UILabel()
        element.font = UIFont(name: Fonts.Raleway.extraBold, size: 26)
        element.textAlignment = .left
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var likeImageView: UIImageView = {
        let element = UIImageView()
        element.backgroundColor = .red
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let element = UILabel()
        element.font = UIFont(name: Fonts.NunitoSans.regular, size: 15)
        element.numberOfLines = 0
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var likeButton: UIButton = {
        let element = UIButton(type: .system)
        element.backgroundColor = .red
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var addToCartButton: UIButton = {
        let element = UIButton(type: .system)
        element.setTitle("Add to cart", for: .normal)
        element.titleLabel?.font = UIFont(name: Fonts.NunitoSans.light, size: 16)
        element.backgroundColor = .black
        element.tintColor = .white
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var buyNowButton: UIButton = {
        let element = UIButton(type: .system)
        element.setTitle("Buy now", for: .normal)
        element.titleLabel?.font = UIFont(name: Fonts.NunitoSans.light, size: 16)
        element.backgroundColor = .blue
        element.tintColor = .white
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        setViews()
        setupConstraints()
    }
    
    func showProduct(_ product: Product) {
        nameProductLabel.text = product.title
        priceLabel.text = "$\(product.price)"
        descriptionLabel.text = product.description
        print(product)
    }
    
    func showImage(_ image: UIImage?) {
        productImageView.image = image
    }
    
    func showError(_ message: String) {
        print(message)
    }
}

private extension ProductViewController {
    
    func setViews() {
        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(productImageView)
        mainStackView.addArrangedSubview(nameProductLabel)
        
        mainStackView.addArrangedSubview(priceStackView)
        priceStackView.addArrangedSubview(priceLabel)
        priceStackView.addArrangedSubview(likeImageView)
        
        mainStackView.addArrangedSubview(descriptionLabel)
    }
    
    func setupConstraints() {
        
        mainStackView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide).inset(spasingElements)
        }
        
        productImageView.snp.makeConstraints { make in
            make.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.5)
        }
        
        likeImageView.snp.makeConstraints { make in
            make.height.width.equalTo(30)
        }
        
        
        
    }
}
