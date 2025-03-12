//
//  WishlistViewController.swift
//  Shoppe
//
//  Created by ordoko on 04.03.2025.
//

import UIKit

protocol WishlistViewProtocol: AnyObject {
    func reloadData()
    func hideLoadingIndicator() //?
    func setupSearchController() // !
}

final class WishlistViewController: UIViewController {
    
    //MARK: Properties
    
    var presenter: WishlistPresenterProtocol?
    private let refreshControl = UIRefreshControl()
    
    private var searchResultsController: SearchResultsController?
    private var searchController: UISearchController?
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20 // Расстояние между строками коллекции
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
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.1
        paragraphStyle.alignment = .center
        label.attributedText = NSMutableAttributedString(string: "Wishlist", attributes: [NSAttributedString.Key.kern: -0.28, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        label.font = UIFont(name: "Raleway-Bold", size: 28)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupActivityIndicator()
        showLoadingIndicator()
        presenter?.viewDidLoad()
        setupCollectionView()
        setupPullToRefresh()
    }
    
    private func setupNavigationBar() {
        title = "Wishlist"
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.1
        paragraphStyle.alignment = .center
         
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: Fonts.Raleway.bold, size: 28)!,
            .kern: -0.28,
            .paragraphStyle: paragraphStyle
        ]
        navigationController?.navigationBar.titleTextAttributes = attributes
    }
    
    private func setupCollectionView() {
        collectionView.register(WishlistProductCell.self, forCellWithReuseIdentifier: wishlistProductCellId)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
    }
    
    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func showLoadingIndicator() {
           activityIndicator.startAnimating()
           collectionView.isHidden = true
       }
    
    private func setupPullToRefresh() {
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    @objc private func refreshData() {
        presenter?.didPullToRefresh()
    }
   
}

// MARK: CollectionView delegates
extension WishlistViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let presenter = presenter else { return 0 }
        return presenter.products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: wishlistProductCellId, for: indexPath) as? WishlistProductCell else {
            return UICollectionViewCell()
        }
        guard let presenter = presenter,
                indexPath.row < presenter.products.count
        else {
            return UICollectionViewCell()
        }
        let product = presenter.products[indexPath.row]
        cell.configure(with: product)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let presenter = presenter,
              indexPath.row < presenter.products.count
        else {
            return
        }
        let product = presenter.products[indexPath.row]
        presenter.didSelectProduct(product)
    }
    
    // Размер ячейки
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.bounds.width / 2 // Две колонки
        return CGSize(width: cellWidth, height: 282 + 15) // Высота фиксированная: высота по макету 282 + 15 - это отступ сверху в ячейке, для корректного отображения тени
    }
}

extension WishlistViewController: WishlistViewProtocol {
    func reloadData() {
        self.refreshControl.endRefreshing()
        collectionView.reloadData()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
        collectionView.isHidden = false
    }
    
    // setup search controller
    func setupSearchController() {
       guard let presenter = presenter else {
           print("presenter is nil")
           return
       }
       searchResultsController = SearchResultsRouter.createModule(products: presenter.products) as? SearchResultsController
       searchResultsController!.delegate = self //!
       searchController = UISearchController(searchResultsController: searchResultsController)
       searchController?.searchResultsUpdater = searchResultsController
       searchController?.searchBar.placeholder = "Search"
       searchController?.searchBar.delegate = searchResultsController
       searchController?.showsSearchResultsController = true
       navigationItem.hidesSearchBarWhenScrolling = false
       navigationItem.searchController = searchController
   }
}

extension WishlistViewController: WishlistProductCellDelegate {
    func didTapWishlistButton(for product: Product) {
        presenter?.toggleWishlist(for: product)
    }
}

extension WishlistViewController: SearchResultsControllerDelegate {
    func updateSearchBar(with text: String) {
        searchController?.searchBar.text = text
    }
  
//    func updateData() {
//        presenter?.viewDidLoad()
//    }
}
