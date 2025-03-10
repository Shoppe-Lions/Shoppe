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
    var radius: Int
    var number: Int = 0 {
        didSet {
            label.text = "\(number)"
        }
    }
    let label = UILabel()

    init(size: Int, radius: Int, number: Int) {
        self.size = size
        self.radius = radius
        self.number = number
        super.init(frame: .zero)
        setupViews(size: size)
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews(size: Int) {
        self.backgroundColor = .customLightGray
        self.layer.cornerRadius = CGFloat(radius)*1.5
        self.clipsToBounds = true

        label.text = "\(number)"
        label.font = UIFont(name: "Raleway-Bold", size: CGFloat(size))
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        self.layer.borderWidth = 4
        self.layer.borderColor = UIColor.white.cgColor

        self.addSubview(label)
    }

    func setConstraints() {
        self.snp.makeConstraints { make in
            make.width.height.equalTo(CGFloat(radius*3))
        }

        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
