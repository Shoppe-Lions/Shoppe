//
//  ProfileViewController.swift
//  Shoppe
//
//  Created by Дарья on 07.03.2025.
//

import UIKit

class ProfileViewController: UIViewController {
    
    private lazy var nameTextField: UITextField = {
        return createTextField(placeholder: "Ваше Имя", keyboardType: .default, isSecure: false, autocapitalization: .words)
    }()
    
    private lazy var emailTextField: UITextField = {
        return createTextField(placeholder: "gmail@example.com", keyboardType: .emailAddress, isSecure: false, autocapitalization: .none)
    }()
    
    private lazy var passwordTextField: UITextField = {
        return createTextField(placeholder: "Введите пароль", keyboardType: .default, isSecure: true, autocapitalization: .none)
    }()
    
    private lazy var profileStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameTextField, emailTextField, passwordTextField])
        stack.axis = .vertical
        stack.spacing = 16
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    
    private let settingsLabel: UILabel = {
        let label = UILabel()
        label.text = "Settings"
        label.font = UIFont(name: Fonts.Raleway.bold, size: 28)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let profileLabel: UILabel = {
        let label = UILabel()
        label.text = "Your Profile"
        label.font = UIFont(name: Fonts.Raleway.medium, size: 16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let profileImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .red
        image.image = UIImage(named: "Profile")
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 100 / 2
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let profileImageFrame: UIView = {
        let frame = UIView()
        frame.backgroundColor = .white
        frame.layer.cornerRadius = 110 / 2
        frame.clipsToBounds = false
        frame.layer.shadowColor = UIColor.black.cgColor
        frame.layer.shadowOpacity = 0.3
        frame.layer.shadowOffset = CGSize(width: 0, height: 2)
        frame.layer.shadowRadius = 9
        frame.translatesAutoresizingMaskIntoConstraints = false
        return frame
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
    
    private func createTextField(placeholder: String, keyboardType: UIKeyboardType, isSecure: Bool, autocapitalization: UITextAutocapitalizationType) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.keyboardType = keyboardType
        textField.isSecureTextEntry = isSecure
        textField.autocapitalizationType = autocapitalization
        textField.layer.cornerRadius = 15
        textField.clipsToBounds = true
        textField.backgroundColor = UIColor(named: "CustomLightGray")
        textField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftView = leftPaddingView
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
    
}



//MARK: - Set Views
extension ProfileViewController {
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(settingsLabel)
        view.addSubview(profileLabel)
        view.addSubview(profileImageFrame)
        profileImageFrame.addSubview(profileImage)
        view.addSubview(profileStackView)
    }
}

//MARK: - Set Constraints
extension ProfileViewController {
        private func setupConstraints() {
        NSLayoutConstraint.activate ([
            settingsLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            settingsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),

            profileLabel.topAnchor.constraint(equalTo: settingsLabel.bottomAnchor, constant: 7),
            profileLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            profileImageFrame.heightAnchor.constraint(equalToConstant: 110),
            profileImageFrame.widthAnchor.constraint(equalTo: profileImageFrame.heightAnchor),
            profileImageFrame.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            profileImageFrame.topAnchor.constraint(equalTo: profileLabel.bottomAnchor, constant: 20),
            
            profileImage.widthAnchor.constraint(equalToConstant: 100),
            profileImage.heightAnchor.constraint(equalTo: profileImage.widthAnchor),
            profileImage.centerXAnchor.constraint(equalTo: profileImageFrame.centerXAnchor),
            profileImage.centerYAnchor.constraint(equalTo: profileImageFrame.centerYAnchor),
            
            profileStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            profileStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            profileStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            profileStackView.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 20),
            //profileStackView.heightAnchor.constraint(equalToConstant: 180)
            
        ])
    }
}
