//
//  HistoryCell.swift
//  Shoppe
//
//  Created by ordoko on 09.03.2025.
//

import UIKit

class HistoryCell: UICollectionViewCell {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleLabel)
        contentView.layer.cornerRadius = 9
        contentView.backgroundColor =  UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)
        
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(-10)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with text: String) {
        titleLabel.text = text
    }
}
