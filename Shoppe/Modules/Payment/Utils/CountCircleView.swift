//
//  CountCircle.swift
//  Shoppe
//
//  Created by Dmitry Volkov on 05/03/2025.
//

import UIKit
import SnapKit


class CountCircleView: UIView {
    var size: Int
    var number: Int = 0 {
        didSet {
            label.text = "\(number)"
        }
    }
    let label = UILabel()

    init(size: Int) {
        self.size = size
        super.init(frame: .zero)
        setupViews(size: size)
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews(size: Int) {
        self.backgroundColor = .customLightGray
        self.layer.cornerRadius = CGFloat(size)
        self.clipsToBounds = true

        label.text = "2"
        label.font = .systemFont(ofSize: CGFloat(size), weight: .bold)
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(label)
    }

    func setConstraints() {
        self.snp.makeConstraints { make in
            make.width.height.equalTo(CGFloat(size*2))
        }

        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
