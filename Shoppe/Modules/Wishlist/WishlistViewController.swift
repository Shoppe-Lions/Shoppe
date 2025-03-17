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
    
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupActivityIndicator()
        showLoadingIndicator()
        presenter?.viewDidLoad()
        setupSearchView()
        setupCollectionView()
        setupPullToRefresh()
        setupNavBar()
        navigationController?.navigationBar.isHidden = false
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: .currencyDidChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
    
    func setupSearchView() {
        view.addSubview(searchView)
        searchView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
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
            make.top.equalTo(searchView.snp.bottom).inset(-8)
        }
    }
    
    func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func setupPullToRefresh() {
        if title == "Wishlist" { // перенести проверку в презентер
            refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
            collectionView.refreshControl = refreshControl
        }
    }
    
    func setupNavBar() {
        let customFont = UIFont(name: Fonts.Raleway.bold, size: PFontSize.extraLarge)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: customFont ?? UIFont.systemFont(ofSize: PFontSize.extraLarge),
            .foregroundColor: UIColor.black // Цвет текста
        ]
            
        self.navigationController?.navigationBar.titleTextAttributes = attributes
    }
}

// MARK: CollectionView delegates
extension WishlistViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let presenter = presenter else { return 0 }
        return presenter.products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.identifier, for: indexPath) as? ProductCell,
              let presenter = presenter,
              indexPath.row < presenter.products.count
        else {
            return UICollectionViewCell()
        }
        
        let product = presenter.products[indexPath.row]
        cell.configure(with: product, isPopularSection: false)
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
