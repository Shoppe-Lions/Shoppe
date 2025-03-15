//
//  SubcategoryCell.swift
//  Shoppe
//
//  Created by Игорь Клевжиц on 10.03.2025.
//
import UIKit

class SubcategoryCell: UITableViewCell  {
    
    // MARK: - UI
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = ACLayout.SubcategoryCell.interItemSpacing
        layout.minimumLineSpacing = ACLayout.SubcategoryCell.lineSpacing
        let element = UICollectionView(frame: .zero, collectionViewLayout: layout)
        element.register(SubcategoryItemCell.self, forCellWithReuseIdentifier: SubcategoryItemCell.subItemReuseId)
        element.dataSource = self
        element.delegate = self
        element.isScrollEnabled = false
        return element
    }()
    
    // MARK: - Properties
    
    var presenter: AllCategoriesPresenterProtocol!
    
    private var items: [String] = []
    
    // MARK: - Life Cycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setViews()
        setConstraints()
    }
    
    // MARK: - Set UI
    
    private func setViews() {
        contentView.addSubview(collectionView)
    }
    
    private func setConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(ACLayout.SubcategoryCell.verticalInset)
            make.leading.trailing.equalToSuperview().inset(ACLayout.SubcategoryCell.horizontalInset)
        }
    }

    func configure(with subcategories: [String], presenter: AllCategoriesPresenterProtocol) {
        self.items = subcategories
        self.presenter = presenter
        collectionView.reloadData()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        items = []
        collectionView.reloadData()
    }
    
    func collectionViewContentHeight() -> CGFloat {
        let rowCount = ceil(CGFloat(items.count) / ACLayout.SubcategoryCell.itemsPerRow)
        return rowCount * ACLayout.SubcategoryCell.itemHeight + (rowCount - 1) * ACLayout.SubcategoryCell.lineSpacing
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - CollectionView Methods

extension SubcategoryCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SubcategoryItemCell.subItemReuseId, for: indexPath) as! SubcategoryItemCell
        cell.configure(with: items[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = items[indexPath.item]
        presenter.fetchSelectedSubcategory(selectedItem)
    }
}

// MARK: - Layout Cell

extension SubcategoryCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = ACLayout.SubcategoryCell.interItemSpacing
        let itemsPerRow: CGFloat = ACLayout.SubcategoryCell.itemsPerRow
        let totalSpacing = spacing * (itemsPerRow - 1)
        let availableWidth = collectionView.bounds.width - totalSpacing
        let itemWidth = availableWidth / itemsPerRow
        return CGSize(width: itemWidth, height: ACLayout.SubcategoryCell.itemHeight)
    }
}
