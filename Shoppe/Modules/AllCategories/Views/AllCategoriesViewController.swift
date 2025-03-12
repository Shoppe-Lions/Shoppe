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
    
    private lazy var titleLabel: UILabel = {
        let element = UILabel()
        element.text = "All Categories"
        element.font = UIFont(name: Fonts.Raleway.bold, size: ACFontSize.title)
        return element
    }()
    
    private lazy var closeButton: UIButton = {
        let element = UIButton(type: .system)
        element.setImage(UIImage(systemName: "xmark"), for: .normal)
        element.tintColor = .customBlack
        element.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        return element
    }()
    
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
        setViews()
        setConstraints()
    }
}

// MARK: - Set UI

private extension AllCategoriesViewController {
    
    func setViews() {
        view.addSubview(titleLabel)
        view.addSubview(closeButton)
        view.addSubview(categoriesTableView)
    }
    
    func setConstraints() {
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().inset(ACLayout.AllCategoriesViewController.sideInset)
        }
        
        closeButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalToSuperview().inset(ACLayout.AllCategoriesViewController.sideInset)
        }
        
        categoriesTableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(ACLayout.AllCategoriesViewController.elementInset)
            make.leading.trailing.bottom.equalToSuperview().inset(ACLayout.AllCategoriesViewController.elementInset)
        }
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
            cell.configure(with: category.subcategories)
            cell.clipsToBounds = false
            return cell
        }
    }
}

extension AllCategoriesViewController: AllCategoriesViewProtocol {
    func showCategories(_ categories: [Category]) {
        self.categories = categories
    }
}
