//
//  ShadowImageView.swift
//  Shoppe
//
//  Created by Dmitry Volkov on 06/03/2025.
//

import UIKit

class ShadowImageView: UIView {
    var radius: CGFloat
    var borderWidth: Int
    
    lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = CGFloat(radius)
        image.layer.borderWidth = CGFloat(borderWidth)
        image.layer.borderColor = UIColor.white.cgColor
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    init(imageName: String, radius: CGFloat = CGFloat(30), borderWidth: Int = 5) {
        self.radius = radius
        self.borderWidth = borderWidth
        super.init(frame: .zero)
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: -3, height: 0)
        self.layer.shadowRadius = 5
        self.layer.cornerRadius = CGFloat(radius)
        
        addSubview(imageView)
        
        imageView.image = UIImage(named: imageName)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(radius*2)
            make.height.equalTo(radius*2)
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
