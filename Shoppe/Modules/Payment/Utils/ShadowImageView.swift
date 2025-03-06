//
//  ShadowImageView.swift
//  Shoppe
//
//  Created by Dmitry Volkov on 06/03/2025.
//

import UIKit

class ShadowImageView: UIView {
    
    lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 30
        image.layer.borderWidth = 5
        image.layer.borderColor = UIColor.white.cgColor
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    init(imageName: String) {
        super.init(frame: .zero)
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: -3, height: 0) // Тень слева
        self.layer.shadowRadius = 5
        self.layer.cornerRadius = 30
        
        addSubview(imageView)
        
        imageView.image = UIImage(named: imageName)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
