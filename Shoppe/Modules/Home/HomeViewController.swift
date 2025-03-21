//
//  HomeViewController.swift
//  Shoppe
//
//  Created by Victor Garitskyu on 05.03.2025.
//


import UIKit
import SnapKit

protocol HomeViewProtocol: AnyObject {
    func displayCategories(_ categories: [ShopCategory])
    func displayPopularProducts(_ products: [Product])
    func displayJustForYouProducts(_ products: [Product])
    func displayLocationMenu(with cities: [String], selectedCity: String)
    func hideLocationMenu()
    func updateLocationLabel(_ location: String)
    func updateCollectionView()
    func endRefreshing()
}

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FakeSearchViewDelegate {
   
    func didTapSearch() { //это роутер должен сделать
        let vc = SearchResultsRouter.createModule(viewModel: PresentingControllerViewModel(title: "Shop", products: presenter?.products))
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - VIPER
    var presenter: HomePresenterProtocol!

    // MARK: - Properties
    private let customNavigationBar: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        // Добавляем тень
//        view.layer.shadowColor = UIColor.black.cgColor
//        view.layer.shadowOffset = CGSize(width: 0, height: 2)
//        view.layer.shadowOpacity = 0.1
//        view.layer.shadowRadius = 4
        return view
    }()
    
    private let addressStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 0
        return stack
    }()
    
    private let deliveryAddressLabel: UILabel = {
        let label = UILabel()
        label.text = "Delivery address"
        label.font = UIFont(name: Fonts.Inter.regular, size: 10)
        label.textColor = .gray
        return label
    }()
    
    private let locationButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.isUserInteractionEnabled = true
        
        let locationLabel = UILabel()
        locationLabel.font = UIFont(name: Fonts.Inter.regular, size: 12)
        locationLabel.textColor = .black
        locationLabel.tag = 100
        locationLabel.isUserInteractionEnabled = false
        
        let iconImageView = UIImageView(image: UIImage(systemName: "chevron.down")?.withConfiguration(
            UIImage.SymbolConfiguration(pointSize: 10, weight: .medium)
        ))
        iconImageView.tintColor = .black
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.isUserInteractionEnabled = false
        
        button.addSubview(locationLabel)
        button.addSubview(iconImageView)
        
        locationLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints { make in
            make.left.equalTo(locationLabel.snp.right).offset(2)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(10)
        }
        
        return button
    }()
    
    private let cartButton: UIButton = {
        let button = UIButton(type: .system)
        if let buyImage = UIImage(named: "button_buy") {
            button.setImage(buyImage, for: .normal)
        }
        button.tintColor = .black
        
        button.snp.makeConstraints { make in
            make.width.equalTo(23)
            make.height.equalTo(21)
        }
        return button
    }()
    
    private let cartBadgeLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = .systemFont(ofSize: 10)
        label.textColor = .white
        label.backgroundColor = .systemRed
        label.textAlignment = .center
        label.layer.cornerRadius = 7
        label.clipsToBounds = true
        return label
    }()
    
    private var searchView: SearchView =  SearchView()
    
    private var collectionView: UICollectionView!
    
    private enum Section: Int, CaseIterable {
        case categories
        case popular
        case justForYou
    }
    
    private enum ItemType: Hashable {
        case category(ShopCategory)
        case product(HashableProduct)
    }
    
    // MARK: - Models
    private var dataSource: UICollectionViewDiffableDataSource<Section, ItemType>!
    
    // Обновим topStackView
    private let topStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.spacing = 16
        return stack
    }()
    
    // Обновим bottomStackView
    private let bottomStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.spacing = 16
        return stack
    }()
    
    // Добавим свойство refreshControl
    private let refreshControl = UIRefreshControl()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.viewDidLoad()
        
        // Добавляем наблюдателя за изменениями корзины
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateCartBadge(_:)),
            name: .cartDidUpdate,
            object: nil
        )
        
        // Загружаем начальное состояние корзины
        StorageCartManager.shared.loadCart { _ in }
        
        if let locationLabel = locationButton.viewWithTag(100) as? UILabel {
            locationLabel.text = presenter.interactor.getSelectedCity()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(currencyUpdated), name: .currencyDidChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        navigationController?.navigationBar.shadowImage = UIImage()
//        navigationController?.navigationBar.isTranslucent = true
//        navigationController?.navigationBar.backgroundColor = .clear
//        
//        // Делаем navigationBar полностью прозрачным
//        navigationController?.navigationBar.alpha = 0
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.alpha = 1
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        view.backgroundColor = .systemBackground
        setupSearchView()
        setupCustomNavigationBar()
        setupCollectionView()
        configureDataSource()
    }
    
    // MARK: - Setup
    private func setupSearchView() {
        searchView = SearchView(title: "Shop")
        searchView.fakeSearchViewDelegate = self
    }
    
    private func setupCustomNavigationBar() {
        // Сначала добавляем все views в иерархию
        view.addSubview(customNavigationBar)
    
        // Настраиваем адресный стек
        addressStackView.addArrangedSubview(deliveryAddressLabel)
        addressStackView.addArrangedSubview(locationButton)
        
        // Убираем отступ между Delivery address и locationButton
        addressStackView.spacing = 0
        
        // Добавляем обработчик нажатия для locationButton
        locationButton.addTarget(self, action: #selector(locationTapped), for: .touchUpInside)
        
        // Убедимся, что все родительские view принимают касания
        addressStackView.isUserInteractionEnabled = true
        customNavigationBar.isUserInteractionEnabled = true
        
        // Настраиваем верхний стек
        customNavigationBar.addSubview(topStackView)
        customNavigationBar.addSubview(searchView)
        
        topStackView.addArrangedSubview(addressStackView)
        topStackView.addArrangedSubview(cartButton)
        cartButton.addSubview(cartBadgeLabel)
        
        // Настраиваем констрейнты для customNavigationBar
        customNavigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(100)
        }
        
        // Настраиваем констрейнты для topStackView
        topStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.trailing.equalToSuperview().inset(16)

            make.height.equalTo(36)
        }
        
        // Настраиваем констрейнты для locationButton
        locationButton.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.width.greaterThanOrEqualTo(200)
        }
        
        // Настраиваем констрейнты для searchView
        searchView.snp.makeConstraints { make in
            make.top.equalTo(topStackView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-8)
        }
        
        // Настраиваем констрейнты для cartBadgeLabel
        cartBadgeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-5)
            make.trailing.equalToSuperview().offset(5)
            make.width.height.equalTo(14)
        }
        
        // Настраиваем внешний вид
        locationButton.backgroundColor = .clear
        addressStackView.backgroundColor = .clear
        topStackView.backgroundColor = .clear
        customNavigationBar.backgroundColor = .white
        
        cartButton.addTarget(self, action: #selector(cartButtonTapped), for: .touchUpInside)
    }
    
    
    
    
    private func setupCollectionView() {
        let layout = createCompositionalLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        
        // Регистрируем ячейки с правильными идентификаторами
        collectionView.register(
            CategoryCell.self,
            forCellWithReuseIdentifier: String(describing: CategoryCell.self)
        )
        collectionView.register(
            ProductCell.self,
            forCellWithReuseIdentifier: String(describing: ProductCell.self)
        )
        collectionView.register(
            SectionHeaderView.self,
                              forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: String(describing: SectionHeaderView.self)
        )
        
        // Добавляем refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(customNavigationBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    
    
    
    // MARK: - Layout
    private func createCompositionalLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [weak self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            guard let section = Section(rawValue: sectionIndex) else { return nil }
            
            switch section {
            case .categories:
                return self?.createCategoriesSection()
            case .popular:
                return self?.createPopularSection()
            case .justForYou:
                return self?.createJustForYouSection()
            }
        }
    }
    
    private func createCategoriesSection() -> NSCollectionLayoutSection {
        // Item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .absolute(220)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0.5, bottom: 0, trailing: 0.5)
        
        // Group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(220)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item, item]
        )
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8)
        
        // Header
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(44)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    private func createPopularSection() -> NSCollectionLayoutSection {
        // Item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // Group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.4),
            heightDimension: .absolute(250)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 12
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 16,
            leading: 16,
            bottom: 0,
            trailing: 8
        )
        
        // Header
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(44)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    private func createJustForYouSection() -> NSCollectionLayoutSection {
        // Item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .absolute(282)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // Group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(282)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 2
        )
        group.interItemSpacing = .fixed(16) // Отступ между ячейками по горизонтали
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 8,
            leading: 8,
            bottom: 16,
            trailing: 8
        )
        
        // Header
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(44)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        header.contentInsets = NSDirectionalEdgeInsets(
            top: 8,
            leading: 0,
            bottom: 0,
            trailing: 0
        )
        
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    // MARK: - Actions
    @objc private func cartButtonTapped() {
        if let tabBarController = self.tabBarController as? MainTabBarController {
            tabBarController.selectTab(at: 3) 
        }
    }
    
    @objc func currencyUpdated() {
        presenter.didCurrencyUpdated()
    }
    
    func updateCollectionView() {
        collectionView.reloadData()
    }
    
    @objc private func locationTapped() {
        print("Location button tapped")
        
        if let existingMenu = view.viewWithTag(999) {
            existingMenu.removeFromSuperview()
            return
        }
        
        // Создаем контейнер для меню с тенью
        let menuContainer = UIView()
        menuContainer.tag = 999
        menuContainer.backgroundColor = .white
        menuContainer.layer.cornerRadius = 12
        // Настраиваем тень для контейнера
        menuContainer.layer.shadowColor = UIColor.black.cgColor
        menuContainer.layer.shadowOffset = CGSize(width: 0, height: 5)
        menuContainer.layer.shadowRadius = 10
        menuContainer.layer.shadowOpacity = 0.1
        
        let cities = presenter.interactor.getAvailableCities()
        let selectedCity = presenter.interactor.getSelectedCity()
        
        let dropDownMenu = UITableView(frame: .zero, style: .plain)
        dropDownMenu.backgroundColor = .white
        dropDownMenu.layer.cornerRadius = 12
        dropDownMenu.clipsToBounds = true // Чтобы содержимое не выходило за пределы закругленных углов
        dropDownMenu.separatorStyle = .none
        dropDownMenu.showsVerticalScrollIndicator = false
        
        dropDownMenu.dataSource = self
        dropDownMenu.delegate = self
        dropDownMenu.register(LocationCell.self, forCellReuseIdentifier: "LocationCell")
        
        // Добавляем таблицу в контейнер
        menuContainer.addSubview(dropDownMenu)
        view.addSubview(menuContainer)
        
        // Настраиваем констрейнты для контейнера
        menuContainer.snp.makeConstraints { make in
            make.top.equalTo(locationButton.snp.bottom).offset(4)
            make.leading.equalTo(locationButton)
            make.width.equalTo(280)
            make.height.equalTo(CGFloat(cities.count * 44))
        }
        
        // Настраиваем констрейнты для таблицы
        dropDownMenu.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // Анимация появления
        menuContainer.alpha = 0
        UIView.animate(withDuration: 0.3) {
            menuContainer.alpha = 1
        }
    }
    
    // MARK: - Data Source Configuration
    
    
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, ItemType>(
            collectionView: collectionView
        ) { [weak self] (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell? in
            switch itemIdentifier {
            case .category(let category):
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: String(describing: CategoryCell.self),
                    for: indexPath
                ) as? CategoryCell
                cell?.configure(with: category)
                return cell
                
            case .product(let product):
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: String(describing: ProductCell.self),
                    for: indexPath
                ) as? ProductCell
                
                // Определяем, является ли секция Popular
                let isPopularSection = Section(rawValue: indexPath.section) == .popular
                
                cell?.configure(with: product.product, isPopularSection: isPopularSection)
                cell?.delegate = self
                return cell
            }
        }
        
        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else { return nil }
            
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                                                                        withReuseIdentifier: String(describing: SectionHeaderView.self),
                for: indexPath
            ) as? SectionHeaderView
            
            let section = Section(rawValue: indexPath.section)
            switch section {
            case .categories:
                header?.configure(title: "Categories", showSeeAll: true)
                header?.seeAllTapped = { [weak self] in
                    self?.presenter.didTapSeeAllCategories()
                }
            case .popular:
                header?.configure(title: "Popular", showSeeAll: true)
                header?.seeAllTapped = { [weak self] in
                    self?.presenter.didTapSeeAllPopular()
                }
            case .justForYou:
                header?.configure(title: "Just For You", showSeeAll: true)
                header?.seeAllTapped = { [weak self] in
                    self?.presenter.didTapSeeAllJustForYou()
                }
            case .none:
                break
            }
            
            return header
    }
    
        // Создаем начальный snapshot со всеми секциями
        var snapshot = NSDiffableDataSourceSnapshot<Section, ItemType>()
        snapshot.appendSections([.categories, .popular, .justForYou])
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    
    
//    private func applyInitialSnapshot() {
//        var snapshot = NSDiffableDataSourceSnapshot<Section, ItemType>()
//        
//        let categories = [
//            ShopCategory(title: "Clothing", image: "testPhotoImage", itemCount: 109),
//            ShopCategory(title: "Shoes", image: "testPhotoImage", itemCount: 530),
//            ShopCategory(title: "Bags", image: "testPhotoImage", itemCount: 87),
//            ShopCategory(title: "Lingerie", image: "testPhotoImage", itemCount: 218),
//            ShopCategory(title: "Watch", image: "testPhotoImage", itemCount: 218),
//            ShopCategory(title: "Hoodies", image: "testPhotoImage", itemCount: 218)
//        ].map { ItemType.category($0) }
//        
//        let popularProducts = [
//            Product(id: 1,
//                   title: "Blue Sport Shoes",
//                   price: 17.00,
//                   description: "Comfortable sport shoes",
//                   category: "Shoes",
//                   imageURL: "testPhotoImage",
//                   rating: Rating(rate: 4.5, count: 120),
//                   subcategory: "Sport",
//                   like: false),
//            Product(id: 2,
//                   title: "Red Running Shoes",
//                   price: 32.00,
//                   description: "Professional running shoes",
//                   category: "Shoes",
//                    imageURL: "testPhotoImage",
//                   rating: Rating(rate: 4.8, count: 230),
//                   subcategory: "Running",
//                   like: false),
//            Product(id: 3,
//                   title: "White Sneakers",
//                   price: 21.00,
//                   description: "Casual sneakers",
//                   category: "Shoes",
//                    imageURL: "testPhotoImage",
//                   rating: Rating(rate: 4.3, count: 180),
//                   subcategory: "Casual",
//                   like: false)
//        ].map { ItemType.product(HashableProduct(product: $0)) }
//        
//        let justForYouProducts = [
//            Product(id: 4,
//                   title: "Sunglasses",
//                   price: 17.00,
//                   description: "Stylish sunglasses",
//                   category: "Accessories",
//                    imageURL: "testPhotoImage",
//                   rating: Rating(rate: 4.2, count: 95),
//                   subcategory: "Eyewear",
//                   like: false),
//            Product(id: 5,
//                   title: "Summer Hat",
//                   price: 17.00,
//                   description: "Beach hat",
//                   category: "Accessories",
//                    imageURL: "testPhotoImage",
//                   rating: Rating(rate: 4.0, count: 150),
//                   subcategory: "Hats",
//                   like: false),
//            Product(id: 6,
//                   title: "Beach Bag",
//                   price: 17.00,
//                   description: "Large beach bag",
//                   category: "Bags",
//                    imageURL: "testPhotoImage",
//                   rating: Rating(rate: 4.6, count: 210),
//                   subcategory: "Beach",
//                   like: false),
//            Product(id: 7,
//                   title: "Sandals",
//                   price: 17.00,
//                   description: "Summer sandals",
//                   category: "Shoes",
//                    imageURL: "testPhotoImage",
//                   rating: Rating(rate: 4.4, count: 175),
//                   subcategory: "Summer",
//                   like: false)
//        ].map { ItemType.product(HashableProduct(product: $0)) }
//        
//        let sections: [Section] = [.categories, .popular, .justForYou]
//        snapshot.appendSections(sections)
//        snapshot.appendItems(categories, toSection: .categories)
//        snapshot.appendItems(popularProducts, toSection: .popular)
//        snapshot.appendItems(justForYouProducts, toSection: .justForYou)
//        
//        dataSource.apply(snapshot, animatingDifferences: false)
//    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.interactor.getAvailableCities().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
        let cities = presenter.interactor.getAvailableCities()
        let selectedCity = presenter.interactor.getSelectedCity()//
        
        let city = cities[indexPath.row]
        cell.configure(with: city, isSelected: city == selectedCity)        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cities = presenter.interactor.getAvailableCities()
        let selectedCity = cities[indexPath.row]
        presenter.interactor.updateSelectedCurrency(indexPath.row)
        presenter.didSelectLocation(selectedCity)
    }
    
    // Добавим метод для обновления данных
    @objc private func refreshData() {
        presenter.refreshData()
    }
    
    @objc private func updateCartBadge(_ notification: Notification) {
        if let count = notification.userInfo?["count"] as? Int {
            cartBadgeLabel.text = "\(count)"
            cartBadgeLabel.isHidden = count == 0
        }
    }
}

// MARK: - Cell Types

class SectionHeaderView: UICollectionReusableView {
    static let reuseIdentifier = String(describing: SectionHeaderView.self)
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.Raleway.bold, size: 21)
        label.textColor = .black
        return label
    }()
    
    private let seeAllButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("See All", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(name: Fonts.Raleway.bold, size: 15)
        return button
    }()
    
    private let seeAllIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "button_seeAll"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var seeAllTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(titleLabel)
        addSubview(seeAllButton)
        addSubview(seeAllIcon)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        seeAllButton.snp.makeConstraints { make in
            make.trailing.equalTo(seeAllIcon.snp.leading).offset(-8)
            make.centerY.equalToSuperview()
        }
        
        seeAllIcon.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(30)
        }
        
        // Добавляем обработчики нажатия для обеих кнопок
        seeAllButton.addTarget(self, action: #selector(handleSeeAllTapped), for: .touchUpInside)
        
        // Делаем иконку кликабельной
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSeeAllTapped))
        seeAllIcon.isUserInteractionEnabled = true
        seeAllIcon.addGestureRecognizer(tapGesture)
    }
    
    func configure(title: String, showSeeAll: Bool = true) {
        titleLabel.text = title
        seeAllButton.isHidden = !showSeeAll
        seeAllIcon.isHidden = !showSeeAll
    }
    
    @objc private func handleSeeAllTapped() {
        seeAllTapped?()
    }
}

// MARK: - HomeViewProtocol
extension HomeViewController: HomeViewProtocol {
    func displayCategories(_ categories: [ShopCategory]) {
        var snapshot = dataSource.snapshot()
        snapshot.appendItems(categories.map { ItemType.category($0) }, toSection: .categories)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func displayPopularProducts(_ products: [Product]) {
        var snapshot = dataSource.snapshot()
        let oldItems = snapshot.itemIdentifiers(inSection: .popular)
        snapshot.deleteItems(oldItems)
        snapshot.appendItems(products.map { ItemType.product(HashableProduct(product: $0)) }, toSection: .popular)
        dataSource.apply(snapshot, animatingDifferences: true)
        
        // Назначаем делегата для всех видимых ячеек в секции Popular
        let popularIndexPaths = collectionView.indexPathsForVisibleItems.filter { $0.section == Section.popular.rawValue }
        for indexPath in popularIndexPaths {
            if let cell = collectionView.cellForItem(at: indexPath) as? ProductCell {
                cell.delegate = self
            }
        }
    }
    
    func displayJustForYouProducts(_ products: [Product]) {
        var snapshot = dataSource.snapshot()
        let oldItems = snapshot.itemIdentifiers(inSection: .justForYou)
        snapshot.deleteItems(oldItems)
        snapshot.appendItems(products.map { ItemType.product(HashableProduct(product: $0)) }, toSection: .justForYou)
        dataSource.apply(snapshot, animatingDifferences: true)
        
        // Назначаем делегата для всех видимых ячеек в секции Just For You
        let justForYouIndexPaths = collectionView.indexPathsForVisibleItems.filter { $0.section == Section.justForYou.rawValue }
        for indexPath in justForYouIndexPaths {
            if let cell = collectionView.cellForItem(at: indexPath) as? ProductCell {
                cell.delegate = self
            }
        }
    }
    
    func displayLocationMenu(with cities: [String], selectedCity: String) {
        // ... код для отображения меню локаций ...
    }
    
    func hideLocationMenu() {
        if let existingMenu = view.viewWithTag(999) {
            UIView.animate(withDuration: 0.3, animations: {
                existingMenu.alpha = 0
            }) { _ in
                existingMenu.removeFromSuperview()
            }
        }
    }
    
    func updateLocationLabel(_ location: String) {
        if let locationLabel = locationButton.viewWithTag(100) as? UILabel {
            locationLabel.text = location
        }
    }
    
    func endRefreshing() {
        refreshControl.endRefreshing()
    }
}

extension HomeViewController: ProductCellDelegate {
    func didTapWishlistButton(for product: Product) {
        presenter.interactor.toggleWishlistStatus(for: product)
        
        // Обновляем UI
        var updatedProduct = product
        updatedProduct.like.toggle()
        
        // Находим и обновляем ячейку в каждой секции
        let sectionsToCheck: [Section] = [.popular, .justForYou]
        
        for section in sectionsToCheck {
            if let indexPath = findIndexPath(for: product.id, in: section),
               let cell = collectionView.cellForItem(at: indexPath) as? ProductCell {
                cell.configure(with: updatedProduct, isPopularSection: section == .popular)
            }
        }
    }
    
    private func findIndexPath(for productId: Int, in section: Section) -> IndexPath? {
        guard let snapshot = dataSource?.snapshot() else { return nil }
        let items = snapshot.itemIdentifiers(inSection: section)
        
        if let index = items.firstIndex(where: { item in
            if case .product(let p) = item, p.product.id == productId {
                return true
            }
            return false
        }) {
            return IndexPath(item: index, section: section.rawValue)
        }
        return nil
    }
}

//extension HomeViewController: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        // Пример использования wishlist-контроллера для отображения товаров с поиском
//        // 1. Получаем массив products. Тут взяла мок, но надо из dataSource по indexPath вытащить
//        let products =  [
//            Product(id: 4,
//                   title: "Sunglasses",
//                   price: 17.00,
//                   description: "Stylish sunglasses",
//                   category: "Accessories",
//                    imageURL: "testPhotoImage",
//                   rating: Rating(rate: 4.2, count: 95),
//                   subcategory: "Eyewear",
//                   like: false),
//            Product(id: 5,
//                   title: "Summer Hat",
//                   price: 17.00,
//                   description: "Beach hat",
//                   category: "Accessories",
//                    imageURL: "testPhotoImage",
//                   rating: Rating(rate: 4.0, count: 150),
//                   subcategory: "Hats",
//                   like: false),
//            Product(id: 6,
//                   title: "Beach Bag",
//                   price: 17.00,
//                   description: "Large beach bag",
//                   category: "Bags",
//                    imageURL: "testPhotoImage",
//                   rating: Rating(rate: 4.6, count: 210),
//                   subcategory: "Beach",
//                   like: false),
//            Product(id: 7,
//                   title: "Sandals",
//                   price: 17.00,
//                   description: "Summer sandals",
//                   category: "Shoes",
//                    imageURL: "testPhotoImage",
//                   rating: Rating(rate: 4.4, count: 175),
//                   subcategory: "Summer",
//                   like: false)
//        ]
//        // 2. Создаем вьюмодель для будущего контроллера, в title кладем название категории или просто Shop для всего магазина
//        let viewModel = PresentingControllerViewModel(title: "Shop", products: products)
//        // 3. Создаем контроллер для отображения, передав ему эту модель
//        let vc = WishlistRouter.createModule(viewModel: viewModel)
//        // 4. Пушаем
//        navigationController?.pushViewController(vc, animated: false)
//    }
//}


// Для прописания обработчиков по ячейкам и категориям
extension HomeViewController: UICollectionViewDelegate {
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = Section(rawValue: indexPath.section) else { return }
        
        switch section {
        case .categories:
            if let category = dataSource.itemIdentifier(for: indexPath), case let .category(selectedCategory) = category {
                // Получаем все продукты для выбранной категории
                presenter.interactor.fetchProductsByCategory(selectedCategory.title) { [weak self] result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let products):
                            // Создаем viewModel с реальными данными
                            let viewModel = PresentingControllerViewModel(
                                title: selectedCategory.title.capitalized,
                                products: products
                            )
                            // Открываем экран с продуктами выбранной категории
                            let vc = WishlistRouter.createModule(viewModel: viewModel)
                            self?.navigationController?.pushViewController(vc, animated: true)
                            
                        case .failure(let error):
                            print("Error fetching products for category: \(error)")
                        }
                    }
                }
            }
            
        case .popular, .justForYou:
            if let product = dataSource.itemIdentifier(for: indexPath), case let .product(selectedProduct) = product {
                let newVC = ProductRouter.createModule(by: selectedProduct.product.id, navigationController: navigationController)
                navigationController?.pushViewController(newVC, animated: true)
            }
        }
    }
}

// Также добавим метод для назначения делегата при прокрутке
extension HomeViewController {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // Назначаем делегата для всех видимых ячеек
        for indexPath in collectionView.indexPathsForVisibleItems {
            if let cell = collectionView.cellForItem(at: indexPath) as? ProductCell {
                cell.delegate = self
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            // Назначаем делегата для всех видимых ячеек
            for indexPath in collectionView.indexPathsForVisibleItems {
                if let cell = collectionView.cellForItem(at: indexPath) as? ProductCell {
                    cell.delegate = self
                }
            }
        }
    }
}
