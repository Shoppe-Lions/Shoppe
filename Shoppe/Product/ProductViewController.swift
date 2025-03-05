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
    
    // MARK: - UI Elements
    
    private lazy var productImageView: UIImageView = {
        let element = UIImageView()
        element.contentMode = .scaleAspectFit
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var nameProductLabel: UILabel = {
        let element = UILabel()
        
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var priceLabel: UILabel = {
        let element = UILabel()
        
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
        element.backgroundColor = .black
        element.tintColor = .white
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var buyNowButton: UIButton = {
        let element = UIButton(type: .system)
        element.setTitle("Buy now", for: .normal)
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
        view.addSubview(productImageView)
    }
    
    func setupConstraints() {
        productImageView.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.5)
        }
    }
}
