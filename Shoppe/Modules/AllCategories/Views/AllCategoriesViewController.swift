//
//  AllCategoriesViewController.swift
//  Shoppe
//
//  Created by Игорь Клевжиц on 10.03.2025.
//
import UIKit

protocol AllCategoriesViewProtocol: AnyObject {
    func showCategories(_ categories: [Category])
}

class AllCategoriesViewController: UIViewController {
    
    // MARK: - UI
    
//    private lazy var closeButton: UIButton = {
//        let element = UIButton(type: .system)
//        element.setImage(UIImage(systemName: "xmark"), for: .normal)
//        element.tintColor = .customBlack
//        element.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
//        return element
//    }()
    
    private lazy var categoriesTableView: UITableView = {
        let element = UITableView()
        element.separatorStyle = .none
        element.rowHeight = UITableView.automaticDimension
        element.estimatedRowHeight = 100
        element.dataSource = self
        element.delegate = self
        element.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.reuseIdentifier)
        element.allowsSelection = false
        return element
    }()
    
    // MARK: - Properties
    
    var presenter: AllCategoriesPresenterProtocol!
    
    var categories: [Category] = []
    
    // MARK: - Methods
    
    @objc private func didTapClose() {
        dismiss(animated: true)
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        presenter.viewDidLoad()
        setupNavigationBar()
        setViews()
        setConstraints()
    }
    
    private func setViews() {
//        view.addSubview(closeButton)
        view.addSubview(categoriesTableView)
    }
    
    private func setConstraints() {
//        closeButton.snp.makeConstraints { make in
//            make.centerY.equalTo(view.safeAreaLayoutGuide.snp.top)
//            make.trailing.equalToSuperview().inset(ACLayout.AllCategoriesViewController.sideInset)
//        }
        
        categoriesTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.trailing.bottom.equalToSuperview().inset(ACLayout.AllCategoriesViewController.elementInset)
        }
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = .black
        navigationItem.title = presenter.getTitle()
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont(name: Fonts.Raleway.bold, size: 28)!,
            .foregroundColor: UIColor.customBlack
        ]
    }
}

// MARK: - TableView Methods

extension AllCategoriesViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let category = categories[indexPath.section]
        
        if indexPath.row == 1 {
            let subcategories = category.subcategories
            let rowCount = ceil(CGFloat(subcategories.count) / CGFloat(ACLayout.SubcategoryCell.itemsPerRow))
            let totalHeight = rowCount * ACLayout.SubcategoryCell.itemHeight +
            (rowCount - 1) * ACLayout.SubcategoryCell.verticalInset +
            2 * ACLayout.AllCategoriesViewController.elementInset
            return totalHeight
        }
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories[section].isExpanded ? 2 : 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let category = categories[indexPath.section]

        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell", for: indexPath) as! CategoryTableViewCell
            cell.configure(with: category)
            cell.clipsToBounds = false
            cell.arrowButtonTapped = { [weak self] in
                self?.categories[indexPath.section].isExpanded.toggle()
                self?.categoriesTableView.reloadSections([indexPath.section], with: .automatic)
            }
            return cell
        } else {
            let cell = SubcategoryCell()
            cell.configure(with: category.subcategories, presenter: presenter)
            cell.clipsToBounds = false
            return cell
        }
    }
}

extension AllCategoriesViewController: AllCategoriesViewProtocol {
    func showCategories(_ categories: [Category]) {
        self.categories = categories
        categoriesTableView.reloadData()
    }
}
