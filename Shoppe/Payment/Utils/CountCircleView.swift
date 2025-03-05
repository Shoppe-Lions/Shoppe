//
//  CountCircle.swift
//  Shoppe
//
//  Created by Dmitry Volkov on 05/03/2025.
//

import UIKit
import SnapKit


class CountCircleView: UIView {
    let number: Int
    let label = UILabel()

    init(number: Int, size: Int) {
        self.number = number
        super.init(frame: .zero)
        setupViews(size: size)
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews(size: Int) {
        self.backgroundColor = .lightGray
        self.layer.cornerRadius = 15
        self.clipsToBounds = true

        label.text = "\(number)"
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(label)
    }

    func setConstraints() {
        self.snp.makeConstraints { make in
            make.width.height.equalTo(30)
        }

        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
