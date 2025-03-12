//
//  LocationCell.swift
//  Shoppe
//
//  Created by Victor Garitskyu on 08.03.2025.
//

import UIKit
import SnapKit

class LocationCell: UITableViewCell {
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        // Добавляем тень
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        view.layer.shadowRadius = 10
        view.layer.shadowOpacity = 1
        view.layer.cornerRadius = 9
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        return view
    }()
    
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
        
        // Добавляем containerView
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8))
        }
        
        // Создаем label для текста
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        label.tag = 102
        containerView.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
        }
        
        let checkmarkImage = UIImageView()
        checkmarkImage.image = UIImage(systemName: "checkmark")
        checkmarkImage.tintColor = .systemBlue
        checkmarkImage.tag = 101
        checkmarkImage.isHidden = true
        
        containerView.addSubview(checkmarkImage)
        checkmarkImage.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-12)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(16)
        }
    }
    
    func configure(with city: String, isSelected: Bool) {
        // Настраиваем атрибутный текст для правильного отображения эмодзи
        let attributedString = NSMutableAttributedString(string: city)
        attributedString.addAttribute(.font, 
                                    value: UIFont.systemFont(ofSize: 16),
                                    range: NSRange(location: 0, length: 0))
        
        if let label = containerView.viewWithTag(102) as? UILabel {
            label.attributedText = attributedString
        }
        
        if let checkmark = containerView.viewWithTag(101) {
            checkmark.isHidden = !isSelected
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Обновляем тень при изменении размеров
        containerView.layer.shadowPath = UIBezierPath(roundedRect: containerView.bounds, cornerRadius: containerView.layer.cornerRadius).cgPath
    }
}
