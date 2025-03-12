//
//  CategoryCell.swift
//  Shoppe
//
//  Created by Victor Garitskyu on 08.03.2025.
//

import UIKit
import SnapKit

class CategoryCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: CategoryCell.self)
    
    private let photoContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        view.layer.shadowRadius = 10
        view.layer.shadowOpacity = 1
        view.layer.cornerRadius = 9
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        return view
    }()
    
    private let imagesContainerView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private var imageViews: [UIImageView] = []
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.Raleway.bold, size: 17)
        label.textAlignment = .left
        label.textColor = .black
        label.numberOfLines = 2
        return label
    }()
    
    private let countContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 223/255, green: 233/255, blue: 255/255, alpha: 1.0)
        view.layer.cornerRadius = 6
        return view
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.Raleway.bold, size: 12)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        // Создаем 4 imageView сначала
        for _ in 0..<4 {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 4
            imageViews.append(imageView)
        }
        
        contentView.addSubview(photoContainerView)
        photoContainerView.addSubview(imagesContainerView)
        photoContainerView.addSubview(titleLabel)
        photoContainerView.addSubview(countContainer)
        countContainer.addSubview(countLabel)
        
        // Добавляем imageViews в imagesContainerView
        imageViews.forEach { imagesContainerView.addSubview($0) }
        
        let spacing: CGFloat = 5
        let imageSize = (contentView.bounds.width - spacing * 5) / 2
        
        photoContainerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(spacing)
        }
        
        imagesContainerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(spacing)
            make.height.equalTo(imagesContainerView.snp.width)
        }
        
        // Верхние изображения
        imageViews[0].snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(spacing)
            make.width.height.equalTo(imageSize)
        }
        
        imageViews[1].snp.makeConstraints { make in
            make.top.equalToSuperview().inset(spacing)
            make.leading.equalTo(imageViews[0].snp.trailing).offset(spacing)
            make.width.height.equalTo(imageSize)
        }
        
        // Нижние изображения
        imageViews[2].snp.makeConstraints { make in
            make.top.equalTo(imageViews[0].snp.bottom).offset(spacing)
            make.leading.equalToSuperview().inset(spacing)
            make.width.height.equalTo(imageSize)
        }
        
        imageViews[3].snp.makeConstraints { make in
            make.top.equalTo(imageViews[1].snp.bottom).offset(spacing)
            make.leading.equalTo(imageViews[2].snp.trailing).offset(spacing)
            make.width.height.equalTo(imageSize)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imagesContainerView.snp.bottom).offset(spacing)
            make.leading.equalTo(imagesContainerView.snp.leading).offset(spacing)
            make.bottom.equalToSuperview().offset(-spacing)
        }
        
        countContainer.snp.makeConstraints { make in
            make.top.equalTo(imagesContainerView.snp.bottom).offset(spacing)
            make.trailing.equalToSuperview().offset(-spacing)
            make.width.equalTo(38)
            make.height.equalTo(20)
            make.bottom.equalToSuperview().offset(-spacing)
        }
        
        countLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageViews.forEach { $0.layer.cornerRadius = 4 }
    }
    
    private func capitalizeFirstLetter(_ text: String) -> String {
        guard !text.isEmpty else { return text }
        return text.prefix(1).uppercased() + text.dropFirst().lowercased()
    }
    
    func configure(with category: ShopCategory) {
        titleLabel.text = capitalizeFirstLetter(category.title)
        countLabel.text = "\(category.itemCount)"
        
        titleLabel.snp.remakeConstraints { make in
            make.top.equalTo(imagesContainerView.snp.bottom).offset(5)
            make.leading.equalTo(imagesContainerView.snp.leading).offset(5)
            make.trailing.lessThanOrEqualTo(countContainer.snp.leading).offset(-5)
            make.bottom.equalToSuperview().offset(-5)
        }
        
        imageViews.forEach { $0.image = nil }
        
        for (index, imagePath) in category.subcategoryImages.enumerated() {
            if index < imageViews.count {
                if let image = UIImage(contentsOfFile: imagePath) {
                    imageViews[index].image = image
                } else {
                    imageViews[index].image = UIImage(named: "testPhotoImage")
                }
            }
        }
    }
}
