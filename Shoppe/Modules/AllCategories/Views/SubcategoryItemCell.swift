//
//  SubcategoryItemCell.swift
//  Shoppe
//
//  Created by Игорь Клевжиц on 10.03.2025.
//
import UIKit
import SnapKit

final class SubcategoryItemCell: UICollectionViewCell {
    
    // MARK: - UI
    
    private lazy var subcategoryLabel: UILabel = {
        let element = UILabel()
        element.textAlignment = .center
        element.font = UIFont(name: Fonts.Raleway.bold, size: ACFontSize.subcategory)
        element.textColor = .customBlack
        return element
    }()
    
    // MARK: - Properties
    
    static let subItemReuseId = "SubItem"
    
    // MARK: - Methods
    
    func configure(with text: String) {
        subcategoryLabel.text = text
    }
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
        setConstraints()
    }
    
    // MARK: - Set UI
    
    private func configureContentView() {
        contentView.layer.borderColor = UIColor.customPink.cgColor
        contentView.layer.borderWidth = ACLayout.borderSubcategory
        contentView.layer.cornerRadius = ACLayout.cornerRadius
    }
    
    private func setViews() {
        configureContentView()
        contentView.addSubview(subcategoryLabel)
    }
    
    private func setConstraints() {
        subcategoryLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
