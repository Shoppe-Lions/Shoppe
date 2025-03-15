//
//  CategoryProductCell.swift
//  Shoppe
//
//  Created by Игорь Клевжиц on 10.03.2025.
//
import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    // MARK: - UI
    
    private let containerView: UIView = {
        let element = UIView()
        element.backgroundColor = .white
        element.layer.cornerRadius = 10
        element.layer.shadowColor = UIColor.black.cgColor
        element.layer.shadowOpacity = 0.1
        element.layer.shadowOffset = CGSize(width: 0, height: 4)
        element.layer.shadowRadius = 6
        element.layer.masksToBounds = false
        return element
    }()
    
    private lazy var mainStackView: UIStackView = {
        let element = UIStackView()
        element.axis = .horizontal
        element.distribution = .fill
        element.spacing = ACLayout.CategoryTableViewCell.spacing
        return element
    }()
    
    private lazy var iconImageView: UIImageView = {
        let element = UIImageView()
        element.contentMode = .scaleAspectFit
        element.layer.cornerRadius = ACLayout.cornerRadius
        return element
    }()
    
    private lazy var titleLabel: UILabel = {
        let element = UILabel()
        element.textColor = .customBlack
        element.font = UIFont(name: Fonts.Raleway.bold, size: ACFontSize.category)
        return element
    }()
    
    private lazy var arrowButton: UIButton = {
        let element = UIButton(type: .system)
        element.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        element.addTarget(self, action: #selector(arrowTapped), for: .touchUpInside)
        return element
    }()
    
    // MARK: - Properties
    
    static let reuseIdentifier = "CategoryTableViewCell"
    var arrowButtonTapped: (() -> Void)?
    
    // MARK: - Methods
    
    @objc private func arrowTapped() {
        arrowButtonTapped?()
    }
    
    func configure(with category: Category) {
        titleLabel.text = category.title
        iconImageView.image = UIImage(contentsOfFile: category.imagePath)
        
        let arrowImage = category.isExpanded ? "chevron.up" : "chevron.down"
        arrowButton.setImage(UIImage(systemName: arrowImage), for: .normal)
        
        let arrowColor: UIColor = category.isExpanded ? .systemBlue : .black
        arrowButton.tintColor = arrowColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setViews()
        setConstraints()
        addTapGestureToCell()
    }
    
    // MARK: - Set UI
    
    private func setViews() {
        contentView.addSubview(containerView)
        containerView.addSubview(mainStackView)
        mainStackView.addArrangedSubview(iconImageView)
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(arrowButton)
    }
    
    private func setConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(ACLayout.CategoryTableViewCell.containerInset)
        }
        
        mainStackView.snp.makeConstraints { make in
            make.height.equalTo(ACLayout.CategoryTableViewCell.itemHeight)
            make.edges.equalToSuperview().inset(ACLayout.CategoryTableViewCell.containerInset)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.width.equalTo(mainStackView.snp.height)
        }
        
        arrowButton.snp.makeConstraints { make in
            make.width.equalTo(mainStackView.snp.height)
        }
    }
    private func addTapGestureToCell() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        containerView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func cellTapped() {
        arrowTapped()
    }
}
