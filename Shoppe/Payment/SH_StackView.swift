//
//  SH_StackView.swift
//  Shoppe
//
//  Created by Dmitry Volkov on 04/03/2025.
//

import UIKit

class SH_VerticalStackView: UIStackView {
    init() {
        super.init(frame: .zero)
        self.axis = .vertical
        self.alignment = .fill
        self.spacing = 12
        self.distribution = .fill
    }
        
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
