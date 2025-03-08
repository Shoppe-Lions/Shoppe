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
    
    private let imageViews: [UIImageView] = (0..<4).map { _ in
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 4
        return imageView
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.Raleway.bold, size: 17)
        label.textAlignment = .left
        label.textColor = .black
        return label
    }()
    
    private let countContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 223/255, green: 233/255, blue: 255/255, alpha: 1.0) // #DFE9FF
        view.layer.cornerRadius = 6
        return view
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.Raleway.bold, size: 12)
        label.textAlignment = .center
        label.textColor = UIColor(red: 74/255, green: 110/255, blue: 169/255, alpha: 1.0) // #4A6EA9
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
        contentView.addSubview(photoContainerView)
        photoContainerView.addSubview(imagesContainerView)
        photoContainerView.addSubview(titleLabel)
        photoContainerView.addSubview(countContainer)
        countContainer.addSubview(countLabel)
        imageViews.forEach { imagesContainerView.addSubview($0) }
        
        photoContainerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
        }
        
        imagesContainerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(4)
            make.height.equalTo(imagesContainerView.snp.width)
        }
        
        let spacing: CGFloat = 4
        let imageSize = (contentView.bounds.width - spacing * 3 - 16) / 2
        
        imageViews[0].snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(spacing)
            make.width.height.equalTo(imageSize)
        }
        
        imageViews[1].snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(spacing)
            make.width.height.equalTo(imageSize)
        }
        
        imageViews[2].snp.makeConstraints { make in
            make.top.equalTo(imageViews[0].snp.bottom).offset(spacing)
            make.leading.equalToSuperview().inset(spacing)
            make.width.height.equalTo(imageSize)
        }
        
        imageViews[3].snp.makeConstraints { make in
            make.top.equalTo(imageViews[1].snp.bottom).offset(spacing)
            make.trailing.equalToSuperview().inset(spacing)
            make.width.height.equalTo(imageSize)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imagesContainerView.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(4)
            make.bottom.equalToSuperview().offset(-4)
        }
        
        countContainer.snp.makeConstraints { make in
            make.top.equalTo(imagesContainerView.snp.bottom).offset(4)
            make.trailing.equalToSuperview().offset(-4)
            make.width.equalTo(38)
            make.height.equalTo(20)
            make.bottom.equalToSuperview().offset(-4)
        }
        
        countLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageViews.forEach { $0.layer.cornerRadius = 4 }
    }
    
    func configure(with category: ShopCategory) {
        imageViews.forEach { $0.image = UIImage(named: "testPhotoImage") }
        titleLabel.text = category.title
        countLabel.text = "\(category.itemCount)"
    }
}
