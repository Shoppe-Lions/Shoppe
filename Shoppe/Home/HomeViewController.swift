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
}

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - VIPER
    var presenter: HomePresenterProtocol!
    
    // MARK: - Properties
    private let customNavigationBar: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        // Добавляем тень
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 4
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
        locationLabel.text = "Salatiga City, Central Java"
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
        
        // Обновляем констрейнты
        locationLabel.snp.makeConstraints { make in
            make.left.equalToSuperview() // Привязываем к левому краю
            make.centerY.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints { make in
            make.left.equalTo(locationLabel.snp.right).offset(2) // Минимальный отступ от label
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
        label.text = "2"
        label.font = .systemFont(ofSize: 10)
        label.textColor = .white
        label.backgroundColor = .systemRed
        label.textAlignment = .center
        label.layer.cornerRadius = 7
        label.clipsToBounds = true
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Shop"
        label.font = UIFont(name: Fonts.Raleway.bold, size: 28)
        label.textColor = .black
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    private let searchContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()
    
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Search"
        textField.font = UIFont(name: Fonts.Raleway.regular, size: 16)
        textField.borderStyle = .none
        textField.backgroundColor = .clear
        textField.returnKeyType = .search
        textField.textColor = .black
        return textField
    }()
    
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
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        if presenter != nil {
            presenter.viewDidLoad()
        }
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        view.backgroundColor = .systemBackground
        setupCustomNavigationBar()
        setupCollectionView()
        configureDataSource()
    }
    
    // MARK: - Setup
    private func setupCustomNavigationBar() {
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
        
        // Настраиваем размеры locationButton
        locationButton.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.width.greaterThanOrEqualTo(200)
        }
        
        // Настраиваем верхний стек
        customNavigationBar.addSubview(topStackView)
        customNavigationBar.addSubview(bottomStackView)
        
        topStackView.addArrangedSubview(addressStackView)
        topStackView.addArrangedSubview(cartButton)
        cartButton.addSubview(cartBadgeLabel)
        
        // Настраиваем нижний стек
        bottomStackView.addSubview(titleLabel)
        bottomStackView.addSubview(searchContainer)
        searchContainer.addSubview(searchTextField)
        
        // Настраиваем констрейнты для навбара
        customNavigationBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(bottomStackView.snp.bottom).offset(16)
        }
        
        // Обновляем констрейнты для topStackView
        topStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.equalToSuperview().offset(13)
            make.trailing.equalToSuperview().offset(-13)
        }
        
        // Обновляем констрейнты для addressStackView
        addressStackView.snp.makeConstraints { make in
            make.height.equalTo(30)
        }
        
        // Обновляем констрейнты для cartButton
        cartButton.snp.remakeConstraints { make in
            make.width.equalTo(31)
            make.height.equalTo(28)
        }
        
        // Обновляем констрейнты для cartBadgeLabel
        cartBadgeLabel.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(-2)
            make.trailing.equalToSuperview().offset(2)
            make.width.height.equalTo(14)
        }
        
        // Обновим констрейнты для titleLabel
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(40)
        }
        
        // Обновим констрейнты для searchContainer
        searchContainer.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.top)
            make.leading.equalTo(titleLabel.snp.trailing).offset(13)
            make.trailing.equalToSuperview().offset(0)
            make.height.equalTo(40)
        }
        
        // Обновим констрейнты для searchTextField
        searchTextField.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 13, bottom: 0, right: 13))
        }
        
        // Обновим констрейнты для collectionView
        collectionView?.snp.remakeConstraints { make in
            make.top.equalTo(customNavigationBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        // Обновляем констрейнты для bottomStackView
        bottomStackView.snp.makeConstraints { make in
            make.top.equalTo(topStackView.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(13)
            make.trailing.equalToSuperview().offset(-13)
            make.height.equalTo(30)
        }
        
        // Для отладки добавим цвета фона
        locationButton.backgroundColor = .clear
        addressStackView.backgroundColor = .clear
        topStackView.backgroundColor = .clear
        customNavigationBar.backgroundColor = .white
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, 
                                        collectionViewLayout: createCompositionalLayout())
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        
        // Register cell types
        collectionView.register(CategoryCell.self, 
                              forCellWithReuseIdentifier: String(describing: CategoryCell.self))
        collectionView.register(ProductCell.self, 
                              forCellWithReuseIdentifier: String(describing: ProductCell.self))
        
        // Register header types
        collectionView.register(SectionHeaderView.self,
                              forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                              withReuseIdentifier: String(describing: SectionHeaderView.self))
        
        // Устанавливаем констрейнты после добавления в иерархию
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(customNavigationBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Layout
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let section = Section(rawValue: sectionIndex) else { 
                fatalError("Unknown section") 
            }
            
            switch section {
            case .categories:
                return self?.createCategorySection() ?? NSCollectionLayoutSection(group: NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100)), subitems: []))
            case .popular:
                return self?.createPopularSection() ?? NSCollectionLayoutSection(group: NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100)), subitems: []))
            case .justForYou:
                return self?.createJustForYouSection() ?? NSCollectionLayoutSection(group: NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100)), subitems: []))
            }
        }
        return layout
    }
    
    private func createCategorySection() -> NSCollectionLayoutSection {
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
    
    // MARK: - Actions
    @objc private func cartTapped() {
        // Handle cart tap
    }
    
    @objc private func locationTapped() {
        print("Location button tapped") // Добавим для отладки
        
        if let existingMenu = view.viewWithTag(999) {
            existingMenu.removeFromSuperview()
            return
        }
        
        let dropDownMenu = UITableView(frame: .zero, style: .plain)
        dropDownMenu.tag = 999
        dropDownMenu.backgroundColor = .white
        dropDownMenu.layer.cornerRadius = 12
        dropDownMenu.layer.shadowColor = UIColor.black.cgColor
        dropDownMenu.layer.shadowOffset = CGSize(width: 0, height: 2)
        dropDownMenu.layer.shadowRadius = 8
        dropDownMenu.layer.shadowOpacity = 0.1
        dropDownMenu.separatorStyle = .none
        dropDownMenu.showsVerticalScrollIndicator = false
        
        dropDownMenu.dataSource = self
        dropDownMenu.delegate = self
        dropDownMenu.register(LocationCell.self, forCellReuseIdentifier: "LocationCell")
        
        view.addSubview(dropDownMenu)
        
        dropDownMenu.snp.makeConstraints { make in
            make.top.equalTo(locationButton.snp.bottom).offset(4)
            make.leading.equalTo(locationButton)
            make.width.equalTo(250)
            make.height.equalTo(CGFloat(cities.count * 44))
        }
        
        dropDownMenu.alpha = 0
        UIView.animate(withDuration: 0.3) {
            dropDownMenu.alpha = 1
        }
    }
    
    // MARK: - Layout Methods
    private func createPopularSection() -> NSCollectionLayoutSection {
        // Item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(150),
            heightDimension: .absolute(240)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // Group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(150),
            heightDimension: .absolute(200)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8)
        section.interGroupSpacing = 0.5
        
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
    
    private func createJustForYouSection() -> NSCollectionLayoutSection {
        // Item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        // Group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(300)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
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
    
    // MARK: - Data Source Configuration
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, ItemType>(collectionView: collectionView) { 
            (collectionView: UICollectionView, indexPath: IndexPath, item: ItemType) -> UICollectionViewCell? in
            
            guard let section = Section(rawValue: indexPath.section) else { return nil }
            
            switch section {
            case .categories:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CategoryCell.self),
                                                            for: indexPath) as! CategoryCell
                if case .category(let category) = item {
                    cell.configure(with: category)
                }
                return cell
                
            case .popular, .justForYou:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ProductCell.self),
                                                            for: indexPath) as! ProductCell
                if case .product(let hashableProduct) = item {
                    cell.configure(with: hashableProduct.product, isPopularSection: section == .popular)
                }
                return cell
            }
        }
        
        dataSource.supplementaryViewProvider = { 
            (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            
            guard kind == UICollectionView.elementKindSectionHeader else { return nil }
            
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                        withReuseIdentifier: String(describing: SectionHeaderView.self),
                                                                        for: indexPath) as! SectionHeaderView
            
            guard let section = Section(rawValue: indexPath.section) else { return header }
            
            switch section {
            case .categories:
                header.configure(title: "Categories")
            case .popular:
                header.configure(title: "Popular")
            case .justForYou:
                header.configure(title: "Just For You")
            }
            
            return header
        }
    }
    
    private func applyInitialSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ItemType>()
        
        let categories = [
            ShopCategory(title: "Clothing", image: "testPhotoImage", itemCount: 109),
            ShopCategory(title: "Shoes", image: "testPhotoImage", itemCount: 530),
            ShopCategory(title: "Bags", image: "testPhotoImage", itemCount: 87),
            ShopCategory(title: "Lingerie", image: "testPhotoImage", itemCount: 218),
            ShopCategory(title: "Watch", image: "testPhotoImage", itemCount: 218),
            ShopCategory(title: "Hoodies", image: "testPhotoImage", itemCount: 218)
        ].map { ItemType.category($0) }
        
        let popularProducts = [
            Product(id: 1,
                   title: "Blue Sport Shoes",
                   price: 17.00,
                   description: "Comfortable sport shoes",
                   category: "Shoes",
                   imageURL: "testPhotoImage",
                   rating: Rating(rate: 4.5, count: 120),
                   subcategory: "Sport",
                   like: false),
            Product(id: 2,
                   title: "Red Running Shoes",
                   price: 32.00,
                   description: "Professional running shoes",
                   category: "Shoes",
                    imageURL: "testPhotoImage",
                   rating: Rating(rate: 4.8, count: 230),
                   subcategory: "Running",
                   like: false),
            Product(id: 3,
                   title: "White Sneakers",
                   price: 21.00,
                   description: "Casual sneakers",
                   category: "Shoes",
                    imageURL: "testPhotoImage",
                   rating: Rating(rate: 4.3, count: 180),
                   subcategory: "Casual",
                   like: false)
        ].map { ItemType.product(HashableProduct(product: $0)) }
        
        let justForYouProducts = [
            Product(id: 4,
                   title: "Sunglasses",
                   price: 17.00,
                   description: "Stylish sunglasses",
                   category: "Accessories",
                    imageURL: "testPhotoImage",
                   rating: Rating(rate: 4.2, count: 95),
                   subcategory: "Eyewear",
                   like: false),
            Product(id: 5,
                   title: "Summer Hat",
                   price: 17.00,
                   description: "Beach hat",
                   category: "Accessories",
                    imageURL: "testPhotoImage",
                   rating: Rating(rate: 4.0, count: 150),
                   subcategory: "Hats",
                   like: false),
            Product(id: 6,
                   title: "Beach Bag",
                   price: 17.00,
                   description: "Large beach bag",
                   category: "Bags",
                    imageURL: "testPhotoImage",
                   rating: Rating(rate: 4.6, count: 210),
                   subcategory: "Beach",
                   like: false),
            Product(id: 7,
                   title: "Sandals",
                   price: 17.00,
                   description: "Summer sandals",
                   category: "Shoes",
                    imageURL: "testPhotoImage",
                   rating: Rating(rate: 4.4, count: 175),
                   subcategory: "Summer",
                   like: false)
        ].map { ItemType.product(HashableProduct(product: $0)) }
        
        let sections: [Section] = [.categories, .popular, .justForYou]
        snapshot.appendSections(sections)
        snapshot.appendItems(categories, toSection: .categories)
        snapshot.appendItems(popularProducts, toSection: .popular)
        snapshot.appendItems(justForYouProducts, toSection: .justForYou)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private let cities = ["Salatiga City, Central Java", "Jakarta", "Surabaya", "Bandung", "Yogyakarta"]
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
        let currentCity = locationButton.viewWithTag(100) as? UILabel
        let isSelected = cities[indexPath.row] == currentCity?.text
        cell.configure(with: cities[indexPath.row], isSelected: isSelected)
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCity = cities[indexPath.row]
        
        if let locationLabel = locationButton.viewWithTag(100) as? UILabel {
            locationLabel.text = selectedCity
        }
        
        tableView.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            UIView.animate(withDuration: 0.3, animations: {
                tableView.alpha = 0
            }) { _ in
                tableView.removeFromSuperview()
            }
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
    }
    
    func configure(title: String, showSeeAll: Bool = true) {
        titleLabel.text = title
        seeAllButton.isHidden = !showSeeAll
        seeAllIcon.isHidden = !showSeeAll
    }
}

// MARK: - HomeViewProtocol
extension HomeViewController: HomeViewProtocol {
    func displayCategories(_ categories: [ShopCategory]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ItemType>()
        snapshot.appendSections([.categories])
        snapshot.appendItems(categories.map { ItemType.category($0) }, toSection: .categories)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func displayPopularProducts(_ products: [Product]) {
        var snapshot = dataSource.snapshot()
        snapshot.appendSections([.popular])
        snapshot.appendItems(products.map { ItemType.product(HashableProduct(product: $0)) }, toSection: .popular)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func displayJustForYouProducts(_ products: [Product]) {
        var snapshot = dataSource.snapshot()
        snapshot.appendSections([.justForYou])
        snapshot.appendItems(products.map { ItemType.product(HashableProduct(product: $0)) }, toSection: .justForYou)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func displayLocationMenu(with cities: [String], selectedCity: String) {
        // ... код для отображения меню локаций ...
    }
    
    func hideLocationMenu() {
        if let existingMenu = view.viewWithTag(999) {
            existingMenu.removeFromSuperview()
        }
    }
}






