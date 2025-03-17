//
//  SearchResultsController.swift
//  Shoppe
//
//  Created by ordoko on 11.03.2025.
//

import UIKit

// TODO:
    // 4. рефакторинг - константы, магические числа, вопросы с архитектурой для этого экрана (Viper, delegate)

protocol SearchResultsViewProtocol: AnyObject {
    func reloadData()
    func reloadHistory()
    func updateCell(at index: Int)
}

class SearchResultsController: UIViewController {
    
    // MARK: Properties
    var presenter: SearchResultsPresenterProtocol?
    private var searchView: SearchView =  SearchView()
    
    private let searchHistoryLabel: UILabel = {
        let label = UILabel()
        label.text = "Search history"
        label.textColor = .customBlack
        label.font = UIFont(name: Fonts.Raleway.medium, size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let deleteSearchHistoryButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(.trashBin, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let historyLabelContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let historyCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    // MARK: Actions
    @objc private func deleteSearchHistoryTapped() {
        presenter?.didRemoveHistory()
        searchHistoryLabel.textColor = .lightGray
        deleteSearchHistoryButton.isEnabled = false
    }
}

// MARK: LifeCycle
extension SearchResultsController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchView()
        setupUI()
        deleteSearchHistoryButton.addTarget(
            self,
            action: #selector(deleteSearchHistoryTapped),
            for: .touchUpInside
        )
        presenter?.loadHistory()
        historyCollectionView.reloadData()
        if let isEmpty = presenter?.getSearchHistory().isEmpty, isEmpty {
            searchHistoryLabel.textColor = .lightGray
            deleteSearchHistoryButton.isEnabled = false
        }
        searchView.setFirstResponder()
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
}

//MARK: Setup UI
private extension SearchResultsController {
    
    private func setupSearchView() {
        searchView = SearchView(title: presenter?.getTitle())
        searchView.delegate = self
        searchView.setupReal()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(searchView)
        
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.identifier)
        
        view.addSubview(historyLabelContainerView)
        historyLabelContainerView.addSubview(searchHistoryLabel)
        historyLabelContainerView.addSubview(deleteSearchHistoryButton)
        
        view.addSubview(historyCollectionView)
        historyCollectionView.dataSource = self
        historyCollectionView.delegate = self
        historyCollectionView.register(HistoryCell.self, forCellWithReuseIdentifier: HistoryCell.reuseIdentifier)
        
        searchView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(20)
            make.height.equalTo(36)
        }
        
        historyLabelContainerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(searchView.snp.bottom).inset(-20)
            make.height.equalTo(35)
        }
        
        searchHistoryLabel.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
        }
        
        deleteSearchHistoryButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(35)
            make.height.equalTo(35)
        }
        
        historyCollectionView.snp.makeConstraints { make in
            make.top.equalTo(historyLabelContainerView.snp.bottom).inset(-8)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(120)
        }
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(searchView.snp.bottom).inset(-8)
        }
    }
}

//MARK: Search Logic
private extension SearchResultsController {
    func updateSearchResults(for queryText: String?) {
        // todo: refactor this method
        // если текст не существует или он пустой, то показываем историю и выходим
        guard let query = queryText, !query.isEmpty else {
            hideProductsCollectionView()
            // если история поиска пустая, то не показываем историю
            if let searchHistoryIsEmpty = presenter?.getSearchHistory().isEmpty, searchHistoryIsEmpty {
                hideHistory()
            } else {
                showHistory()
                historyCollectionView.reloadData()
            }
            return
        }
        // а если что-то начали печатать, то начинаем искать, прячем историю и показываем товары
        presenter?.didFilterProducts(with: query)
        hideHistory()
        showProductsCollectionView()
        collectionView.reloadData()
    }
    
    func hideHistoryCollectionView() {
        historyCollectionView.isHidden = true
    }
    
    func showHistoryCollectionView() {
        historyCollectionView.isHidden = false
        searchHistoryLabel.textColor = .black
        deleteSearchHistoryButton.isEnabled = true
    }
    
    func hideProductsCollectionView() {
        collectionView.isHidden = true
    }
    
    func showProductsCollectionView() {
        collectionView.isHidden = false
    }
    
    func hideHistory() {
        historyCollectionView.isHidden = true
        historyLabelContainerView.isHidden = true
    }
    
    func showHistory() {
        historyCollectionView.isHidden = false
        historyLabelContainerView.isHidden = false
    }
}

extension SearchResultsController: SearchViewDelegate {
    func didChangeSearchText(_ text: String?) {
        updateSearchResults(for: text)
    }
    
    func searchButtonClicked(_ text: String?) {
        updateSearchResults(for: text)
        saveSearchQuery(text)
    }
    
    private func saveSearchQuery(_ text: String?) {
        guard let query = text, !query.isEmpty else { return }
        presenter?.didSaveSearchQuery(query)
    }
}

extension SearchResultsController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.historyCollectionView {
            let selectedQuery = presenter?.getSearchHistory()[indexPath.row] ?? "" //!
            searchView.updateSearchBar(with: selectedQuery)
        } else {
            guard let presenter = presenter,
                  indexPath.row < presenter.filteredProducts.count
            else {
                return
            }
            let product = presenter.filteredProducts[indexPath.row]
            presenter.didSelectProduct(product)
        }
    }
}

extension SearchResultsController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.historyCollectionView {
            return presenter?.getSearchHistory().count ?? 0
        } else {
            return presenter?.filteredProducts.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.historyCollectionView {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: HistoryCell.reuseIdentifier,
                for: indexPath
            ) as! HistoryCell // force
            let query = presenter?.getSearchHistory()[indexPath.row] ?? "" // !
            cell.configure(with: query)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.identifier, for: indexPath) as? ProductCell else {
                return UICollectionViewCell()
            }
            guard let presenter = presenter,
                  indexPath.row < presenter.filteredProducts.count
            else {
                return UICollectionViewCell()
            }
            let product = presenter.filteredProducts[indexPath.row]
            cell.configure(with: product)
            cell.delegate = self
            return cell
        }
    }
}

extension SearchResultsController: UICollectionViewDelegateFlowLayout {
    //todo magic numbers
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       if collectionView == historyCollectionView {
           let text = presenter?.getSearchHistory()[indexPath.row] ?? ""
           let font = UIFont.systemFont(ofSize: 14)
           let textSize = text.size(withAttributes: [.font: font])
            let textWidth = textSize.width + 20
            return CGSize(width: textWidth, height: 30)
        } else {
          let cellWidth = collectionView.bounds.width / 2 // Две колонки
           return CGSize(width: cellWidth, height: 282 + 15) // Высота фиксированная: высота по макету 282 + 15 - это отступ сверху в ячейке, для корректного отображения тени
        }
    }
}

extension SearchResultsController: SearchResultsViewProtocol {
    func reloadData() {
        collectionView.reloadData()
    }
    
    func updateCell(at index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        if let cell = collectionView.cellForItem(at: indexPath) as? ProductCell,
           let product = presenter?.filteredProducts[index] {
            cell.configure(with: product, isPopularSection: false)
        }
    }
    
    func reloadHistory() {
        historyCollectionView.reloadData()
    }
}

extension SearchResultsController: ProductCellDelegate {
    func didTapWishlistButton(for product: Product) {
        presenter?.toggleWishlist(for: product)
    }
}
