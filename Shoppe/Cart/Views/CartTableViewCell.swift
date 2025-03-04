//
//  CartTableViewCell.swift
//  Shoppe
//
//  Created by Artem Kriukov on 04.03.2025.
//

import UIKit
import SnapKit

final class CartTableViewCell: UITableViewCell {

    private lazy var size: UILabel = {
        let element = UILabel()
        element.text = "Size"
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(size)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension CartTableViewCell {
    func setupConstraints() {
        size.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).inset(15)
            make.centerY.equalTo(contentView)
        }
    }
}

extension UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
