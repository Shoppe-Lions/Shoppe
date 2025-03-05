//
//  EditButton.swift
//  Shoppe
//
//  Created by Dmitry Volkov on 04/03/2025.
//

import UIKit
import SnapKit

class EditButton: UIButton {
    
    init() {
        super.init(frame: .zero)
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        let image = UIImage(named: "EditButton")
        self.setImage(image, for: .normal)
        self.tintColor = .blue
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setConstraints() {
        
    }
}
