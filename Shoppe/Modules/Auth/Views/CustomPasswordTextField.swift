//
//  CustomPasswordTextField.swift
//  Shoppe
//
//  Created by Dmitry Volkov on 10/03/2025.
//

import UIKit

class CustomPasswordTextField: UITextField {
    
    private let paddingView = UIView()
    private let button = UIButton(type: .custom)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        self.backgroundColor = .customGray
        self.font = UIFont(name: "NunitoSans10pt-Regular", size: 16)
        self.placeholder = "Password"
        self.textContentType = .newPassword
        self.autocapitalizationType = .none
        self.autocorrectionType = .no
        self.layer.cornerRadius = 12
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
        self.isSecureTextEntry = true
        
        // Отступ слева
        paddingView.frame = CGRect(x: 0, y: 0, width: 10, height: self.frame.height)
        self.leftView = paddingView
        self.leftViewMode = .always
        
        // Кнопка-глаз
        let hidePass = UIImage(systemName: "eye.slash")
        
        button.setImage(hidePass, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        button.tintColor = .gray
        button.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        containerView.addSubview(button)
        
        self.rightView = containerView
        self.rightViewMode = .always
    }
    
    @objc private func togglePasswordVisibility() {
        self.isSecureTextEntry.toggle()
        let image = self.isSecureTextEntry ? UIImage(systemName: "eye.slash") : UIImage(systemName: "eye")
        button.setImage(image, for: .normal)
    }
}
