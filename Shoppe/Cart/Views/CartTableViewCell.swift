//
//  CartTableViewCell.swift
//  Shoppe
//
//  Created by Artem Kriukov on 04.03.2025.
//

import UIKit
import SnapKit

final class CartTableViewCell: UITableViewCell {

    // MARK: - UI
    private lazy var cellStackView: UIStackView = {
        let element = UIStackView()
        element.axis = .horizontal
        element.spacing = 10
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var cellImageView: UIImageView = {
        let element = UIImageView()
        element.image = UIImage(named: "Cell")
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var deleteProductImageView: UIButton = {
        let element = UIButton(type: .custom)
        element.setImage(UIImage(named: "DeleteProduct"), for: .normal)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var productStackView: UIStackView = {
        let element = UIStackView()
        element.axis = .vertical
        element.spacing = 23
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var topInfoProductStacView: UIStackView = {
        let element = UIStackView()
        element.axis = .vertical
        element.spacing = 13
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    private lazy var nameProductLabel: UILabel = {
        let element = UILabel()
        element.text = "Product name"
        element.font = .systemFont(ofSize: 12, weight: .regular)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var infoLabel: UILabel = {
        let element = UILabel()
        element.text = "Pink, Size M"
        element.font = .systemFont(ofSize: 14, weight: .medium)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var bottomInfoStackView: UIStackView = {
        let element = UIStackView()
        element.axis = .horizontal
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var priceLabel: UILabel = {
        let element = UILabel()
        element.text = "$17,00"
        element.font = .systemFont(ofSize: 18, weight: .bold)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var counterStackView: UIStackView = {
        let element = UIStackView()
        element.axis = .horizontal
        element.spacing = 6
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var lessButton: UIButton = {
        let element = UIButton(type: .custom)
        element.setImage(UIImage(named: "Less"), for: .normal)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var counterLabel: UILabel = {
        let element = UILabel()
        element.text = "1"
        element.backgroundColor = UIColor(red: 229/255, green: 235/255, blue: 252/255, alpha: 1)
        element.layer.masksToBounds = true
        element.layer.cornerRadius = 8
        element.textAlignment = .center
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var moreButton: UIButton = {
        let element = UIButton(type: .custom)
        element.setImage(UIImage(named: "More"), for: .normal)
        element.translatesAutoresizingMaskIntoConstraints = false
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
    
}

private extension CartTableViewCell {
    func setupViews() {
        contentView.addSubview(cellStackView)

        cellStackView.addArrangedSubview(cellImageView)
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
        
        cellImageView.addSubview(deleteProductImageView)
    }
    
    func setupConstraints() {
        cellStackView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(contentView)
            make.height.equalTo(101)
        }
        
        cellImageView.snp.makeConstraints { make in
            make.width.equalTo(121)
            make.height.equalTo(101)
        }
        
        deleteProductImageView.snp.makeConstraints { make in
            make.bottom.equalTo(cellImageView.snp.bottom).inset(6)
            make.leading.equalTo(cellImageView.snp.leading).inset(6)
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

