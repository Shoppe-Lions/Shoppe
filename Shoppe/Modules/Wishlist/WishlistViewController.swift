//
//  WishlistViewController.swift
//  Shoppe
//
//  Created by ordoko on 04.03.2025.
//

import UIKit

// Todo:  при открытии этого контроллера другими не должен работать pull to  refresh 
protocol WishlistViewProtocol: AnyObject {
    func reloadData()
    func hideLoadingIndicator() //?
    func updateCell(at index: Int) // Добавляем новый метод
}

final class WishlistViewController: UIViewController {
    
    //MARK: Properties
    var presenter: WishlistPresenterProtocol?
    
    private let refreshControl = UIRefreshControl()
    private var searchResultsController: SearchResultsController?
    
    private lazy var searchView: SearchView = {
        let searchView = SearchView()
        searchView.fakeSearchViewDelegate = self
        return searchView
    }()

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
        label.font = UIFont(name: Fonts.Raleway.bold, size: 28)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActivityIndicator()
        showLoadingIndicator()
        presenter?.viewDidLoad()
        setupTitle()
        setupSearchView()
        setupCollectionView()
        setupPullToRefresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    func showLoadingIndicator() {
        activityIndicator.startAnimating()
        collectionView.isHidden = true
    }
    
    @objc private func refreshData() {
        presenter?.didPullToRefresh()
    }
}

//MARK: Private
private extension WishlistViewController {
    
    func setupTitle() {
        titleLabel.text = presenter?.getTitle()
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(44)
        }
    }
    
    func setupSearchView() {
        view.addSubview(searchView)
        searchView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(titleLabel.snp.bottom)
            make.height.equalTo(36)
        }
    }
    
    func setupCollectionView() {
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(searchView.snp.bottom)
        }
    }
    
    func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func setupPullToRefresh() {
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
}

// MARK: CollectionView delegates
extension WishlistViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let presenter = presenter else { return 0 }
        return presenter.products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.identifier, for: indexPath) as? ProductCell else {
            return UICollectionViewCell()
        }
        guard let presenter = presenter,
              indexPath.row < presenter.products.count
        else {
            return UICollectionViewCell()
        }
        let product = presenter.products[indexPath.row] //[safe: indexPath.row]
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
        collectionView.reloadData() //reload item at indexpath
    }
    
    func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
        collectionView.isHidden = false
    }
    func updateCell(at index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        if let cell = collectionView.cellForItem(at: indexPath) as? ProductCell,
           let product = presenter?.products[index] {
            cell.configure(with: product, isPopularSection: false)
        }
    }
}

extension WishlistViewController: ProductCellDelegate {
    func didTapWishlistButton(for product: Product) {
        presenter?.toggleWishlist(for: product)
    }
}


extension WishlistViewController: FakeSearchViewDelegate {
    func didTapSearch() { //это роутер должен сделать
        let vc = SearchResultsRouter.createModule(viewModel: PresentingControllerViewModel(title: presenter?.getTitle() ?? "Wishlist", products: presenter?.products))
        navigationController?.pushViewController(vc, animated: true)
    }
}
