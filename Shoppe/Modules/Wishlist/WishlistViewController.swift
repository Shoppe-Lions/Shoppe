//
//  WishlistViewController.swift
//  Shoppe
//
//  Created by ordoko on 04.03.2025.
//

import UIKit

protocol WishlistViewProtocol: AnyObject {
    func didTapWishListButton()
    func showWishListProducts(_ products: [Product])
}

final class WishlistViewController: UIViewController, WishlistViewProtocol {
    
    private var products: [Product] = [
        Product(id: 1, title: "Lorem ipsum dolor sit amet consectetur", price: 199.99, description: "", category: "", image: "testPhotoImage", rating: Rating(rate: 5, count: 25)),
        Product(id: 1, title: "Lorem ipsum dolor sit amet consectetur", price: 199.99, description: "", category: "", image: "testPhotoImage", rating: Rating(rate: 5, count: 25)),
        Product(id: 1, title: "Red dress", price: 199.99, description: "", category: "", image: "testPhotoImage", rating: Rating(rate: 5, count: 25)),
        Product(id: 1, title: "Red dress", price: 199.99, description: "", category: "", image: "testPhotoImage", rating: Rating(rate: 5, count: 25)),
        Product(id: 1, title: "Red dress", price: 199.99, description: "", category: "", image: "testPhotoImage", rating: Rating(rate: 5, count: 25)),
        Product(id: 1, title: "Red dress", price: 199.99, description: "", category: "", image: "testPhotoImage", rating: Rating(rate: 5, count: 25)),
        Product(id: 1, title: "Red dress", price: 199.99, description: "", category: "", image: "testPhotoImage", rating: Rating(rate: 5, count: 25)),
        Product(id: 1, title: "Red dress", price: 199.99, description: "", category: "", image: "testPhotoImage", rating: Rating(rate: 5, count: 25))
    ]
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20 // Расстояние между строками
        layout.minimumInteritemSpacing = 0 // Расстояние между ячейками в строке
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.largeContentTitle = "Wishlist"
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .customBlack
        label.textAlignment = .center
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.1
        paragraphStyle.alignment = .center
        label.attributedText = NSMutableAttributedString(string: "Wishlist", attributes: [NSAttributedString.Key.kern: -0.28, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        label.font = UIFont(name: "Raleway-Bold", size: 28)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    

    func didTapWishListButton() {
        //todo
    }
    
    func showWishListProducts(_ products: [Product]) {
        //todo
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        view.addSubview(titleLabel)
       
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(36)
        }
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).inset(-11)
        }
        
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: "ProductCell")
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}


extension WishlistViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as? ProductCell else {
            return UICollectionViewCell()
        }
        let product = products[indexPath.row]
        cell.configure(with: product)
        return cell
    }
    
    // Размер ячейки
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let totalPadding: CGFloat = 0//19 + 19 + 15 // Левые и правые отступы + отступ между ячейками
            let availableWidth = collectionView.bounds.width - totalPadding
            let cellWidth = availableWidth / 2 // Две колонки
            return CGSize(width: cellWidth, height: 282 + 15) // Высота фиксированная
        }
    
}
