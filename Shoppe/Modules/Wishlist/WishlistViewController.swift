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
        Product(id: 1, title: " Платьишко красное", price: 199.99, description: "", category: "", image: "testPhotoImage", rating: Rating(rate: 5, count: 25)),
        Product(id: 1, title: " Платьишко желтое", price: 199.99, description: "", category: "", image: "testPhotoImage", rating: Rating(rate: 5, count: 25)),
        Product(id: 1, title: " Платьишко голубое", price: 199.99, description: "", category: "", image: "testPhotoImage", rating: Rating(rate: 5, count: 25)),
        Product(id: 1, title: " Платьишко синее", price: 199.99, description: "", category: "", image: "testPhotoImage", rating: Rating(rate: 5, count: 25)),
        Product(id: 1, title: " Платьишко зеленое", price: 199.99, description: "", category: "", image: "testPhotoImage", rating: Rating(rate: 5, count: 25)),
        Product(id: 1, title: " Платьишко оранжевое", price: 199.99, description: "", category: "", image: "testPhotoImage", rating: Rating(rate: 5, count: 25)),
        Product(id: 1, title: " Платьишко белое", price: 199.99, description: "", category: "", image: "testPhotoImage", rating: Rating(rate: 5, count: 25)),
        Product(id: 1, title: " Платьишко черное", price: 199.99, description: "", category: "", image: "testPhotoImage", rating: Rating(rate: 5, count: 25))
    ]
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.largeContentTitle = "Wishlist"
        collectionView.backgroundColor = .white
        return collectionView
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
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
        let width = (collectionView.frame.width - 30) / 2 // Две ячейки в ряд, с отступами
        return CGSize(width: width, height: width + 80)
    }
    
    
}
