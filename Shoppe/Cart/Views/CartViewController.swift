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
    
    private lazy var cartTableView: UITableView = {
        let element = UITableView()
        element.dataSource = self
        element.delegate = self
        element.separatorStyle = .none
        element.showsVerticalScrollIndicator = false
        element.register(CartTableViewCell.self, forCellReuseIdentifier: "CartTableViewCell")
        element.register(ShippingAdressTableViewCell.self, forCellReuseIdentifier: "ShippingAdressTableViewCell")
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

// MARK: - UITableViewDataSource and UITableViewDelegate

extension CartViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShippingAdressTableViewCell", for: indexPath) as! ShippingAdressTableViewCell
            
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableViewCell", for: indexPath) as! CartTableViewCell
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 80
        } else {
            return 120
        }
    }
}


// MARK: - Set Views and Setup Constraints
private extension CartViewController {
    func setupViews() {
        view.addSubview(topStackView)
        
        topStackView.addArrangedSubview(cartTitle)
        topStackView.addArrangedSubview(cartCountLabel)
        
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
        
        cartTableView.snp.makeConstraints { make in
            make.top.equalTo(topStackView.snp.bottom).inset(-15)
            make.trailing.leading.equalTo(view.safeAreaLayoutGuide).inset(15)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(15)
        }
    }
}
