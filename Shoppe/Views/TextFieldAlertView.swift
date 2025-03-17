//
//  TextFieldAlert.swift
//  Shoppe
//
//  Created by Dmitry Volkov on 08/03/2025.
//

import UIKit

final class TextFieldAlertView: UIView {
    private var titleText: String
    private var messageText: String
    private var buttonText: String
    
    lazy var alertBox: UIView = {
        let alertBox = UIView()
        alertBox.backgroundColor = .white
        alertBox.layer.cornerRadius = 20
        
        alertBox.layer.shadowColor = UIColor.black.cgColor
        alertBox.layer.shadowOpacity = 0.3
        alertBox.layer.shadowOffset = CGSize(width: 0, height: 4)
        alertBox.layer.shadowRadius = 10
        
        return alertBox
    }()
    
    lazy var image = ShadowImageView(imageName: "alertImage", radius: PLayout.paddingL*1.3, borderWidth: 15)
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = titleText
        label.font = UIFont(name: "Raleway-Bold", size: PFontSize.medium)
        label.textAlignment = .right
        return label
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .customGray
        textField.font = UIFont(name: "NunitoSans10pt-Regular", size: PFontSize.normal)
        textField.placeholder = messageText
        textField.layer.cornerRadius = 12
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        return textField
    }()
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle(buttonText, for: .normal)
        button.setTitleColor(.customBlack, for: .normal)
        button.titleLabel?.font = UIFont(name: "NunitoSans10pt-Regular", size: PFontSize.normal)
        button.backgroundColor = .customAlertGray
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    init(title: String, message: String, buttonText: String) {
        self.titleText = title
        self.messageText = message
        self.buttonText = buttonText
        super.init(frame: .zero)
        setupView()
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {
        backgroundColor = UIColor.customAlertGray.withAlphaComponent(0.7)
        
        addSubview(alertBox)
        alertBox.addSubview(image)
        alertBox.addSubview(titleLabel)
        alertBox.addSubview(textField)
        alertBox.addSubview(button)
    }
    
    func setConstraints() {
        alertBox.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(200)
        }
        
        image.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(-PLayout.paddingL)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(textField.snp.top).offset(-PLayout.paddingS)
        }
        
        textField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(PLayout.horizontalPadding)
            make.trailing.equalToSuperview().offset(-PLayout.horizontalPadding)
            make.centerY.equalToSuperview()
            make.height.equalTo(30)
        }
        
        button.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(PLayout.horizontalPadding*7.5)
            make.height.equalTo(PLayout.horizontalPadding*2.1)
            make.top.equalTo(textField.snp.bottom).offset(PLayout.paddingL)
        }
        
    }

    func show() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) else {
            return
        }

        keyWindow.addSubview(self)
        self.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func dismiss() {
        self.removeFromSuperview()
    }
}


