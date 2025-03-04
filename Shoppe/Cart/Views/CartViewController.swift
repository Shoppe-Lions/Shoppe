//
//  CartViewController.swift
//  Shoppe
//
//  Created by Artem Kriukov on 04.03.2025.
//

import UIKit
import SnapKit

final class CartViewController: UIViewController {

    // MARK: - UI
    private lazy var topStackView: UIStackView = {
        let element = UIStackView()
        element.axis = .horizontal
        element.spacing = 8
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var cartTitle: UILabel = {
        let element = UILabel()
        element.text = "Cart"
        element.font = .systemFont(ofSize: 28, weight: .bold)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var cartCountLabel: UILabel = {
        let element = UILabel()
        element.text = "1"
        element.font = .systemFont(ofSize: 18, weight: .bold)
        element.textAlignment = .center
        element.backgroundColor = UIColor(red: 229/255, green: 235/255, blue: 252/255, alpha: 1)
        element.layer.masksToBounds = true
        element.layer.cornerRadius = 15
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var mainAdressStackView: UIStackView = {
        let element = UIStackView()
        element.axis = .horizontal
        element.backgroundColor = UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 1)
        element.layer.cornerRadius = 10
        element.spacing = 40
        element.isLayoutMarginsRelativeArrangement = true
        element.layoutMargins = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var adressStackView: UIStackView = {
        let element = UIStackView()
        element.axis = .vertical
        element.spacing = 4
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var titleAdressLabel: UILabel = {
        let element = UILabel()
        element.text = "Shipping Address"
        element.font = .systemFont(ofSize: 14, weight: .bold)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var detailAdressLabel: UILabel = {
        let element = UILabel()
        element.text = "26, Duong So 2, Thao Dien Ward, An Phu, District 2, Ho Chi Minh city"
        element.numberOfLines = 0
        element.font = .systemFont(ofSize: 10, weight: .regular)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var editButton: UIButton = {
        let element = UIButton(type: .system)
        element.setImage(UIImage(systemName: "pencil"), for: .normal)
        element.tintColor = .white
        element.backgroundColor = UIColor(red: 0, green: 75/255, blue: 254/255, alpha: 1)
        element.layer.cornerRadius = 15
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var cartTableView: UITableView = {
        let element = UITableView()
        element.dataSource = self
        element.register(CartTableViewCell.self, forCellReuseIdentifier: CartTableViewCell.reuseIdentifier)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    // MARK: - Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
    }
}

// MARK: - Data Source

extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CartTableViewCell.reuseIdentifier, for: indexPath) as! CartTableViewCell
        
        return cell
    }
    
    
}

// MARK: - Set Views and Setup Constraints
private extension CartViewController {
    func setupViews() {
        view.addSubview(topStackView)
        
        topStackView.addArrangedSubview(cartTitle)
        topStackView.addArrangedSubview(cartCountLabel)
        
        view.addSubview(mainAdressStackView)
        mainAdressStackView.addArrangedSubview(adressStackView)
        
        adressStackView.addArrangedSubview(titleAdressLabel)
        adressStackView.addArrangedSubview(detailAdressLabel)
        
        mainAdressStackView.addArrangedSubview(editButton)
        
        view.addSubview(cartTableView)
    }
    
    func setupConstraints() {
        topStackView.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(5)
        }
        
        cartCountLabel.snp.makeConstraints { make in
            make.width.height.equalTo(30)
        }
        
        mainAdressStackView.snp.makeConstraints { make in
            make.top.equalTo(topStackView.snp.bottom).inset(-10)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        editButton.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.bottom.equalTo(mainAdressStackView.snp.bottom).inset(10)
            make.trailing.equalTo(mainAdressStackView.snp.trailing).inset(15)
        }
        
        cartTableView.snp.makeConstraints { make in
            make.top.equalTo(mainAdressStackView.snp.bottom).inset(-15)
            make.trailing.leading.equalTo(view.safeAreaLayoutGuide).inset(15)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(15)
        }
    }
}
