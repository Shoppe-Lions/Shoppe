//
//  LocationCell.swift
//  Shoppe
//
//  Created by Victor Garitskyu on 08.03.2025.
//

import UIKit
import SnapKit

class LocationCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        backgroundColor = .clear
        selectionStyle = .none
        
        textLabel?.font = .systemFont(ofSize: 14)
        textLabel?.textColor = .black
        
        let checkmarkImage = UIImageView()
        checkmarkImage.image = UIImage(systemName: "checkmark")
        checkmarkImage.tintColor = .systemBlue
        checkmarkImage.tag = 101
        checkmarkImage.isHidden = true
        
        contentView.addSubview(checkmarkImage)
        checkmarkImage.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-8)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(16)
        }
    }
    
    func configure(with city: String, isSelected: Bool) {
        textLabel?.text = city
        if let checkmark = viewWithTag(101) {
            checkmark.isHidden = !isSelected
        }
    }
}

