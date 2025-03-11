//
//  AuthViewController.swift
//  Shoppe
//
//  Created by Dmitry Volkov on 09/03/2025.
//

import UIKit

protocol AnyAuthView: AnyObject {
    var presenter: AnyAuthPresenter? { get set }
    var authType: AuthType { get set }
    func setupViews()
}

enum AuthType {
    case getStarted
    case register
    case login
}

final class AuthViewController: UIViewController, UITextFieldDelegate, AnyAuthView {
    // MARK: - Properties
    var presenter: AnyAuthPresenter?
    var authType: AuthType = .getStarted
    
    // MARK: - UI
    lazy var logo = ShadowImageView(imageName: "logoBag", radius: 70, borderWidth: 10)
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Raleway-Bold", size: PFontSize.authLarge)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "NunitoSans10pt-Regular", size: PFontSize.medium)
        label.text = "Glad to see you back ♥︎"
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .customGray
        textField.font = UIFont(name: "NunitoSans10pt-Regular", size: PFontSize.normal)
        textField.placeholder = "Email"
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.white.cgColor
        textField.delegate = self
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        return textField
    }()
    
    lazy var passwordTextField = CustomPasswordTextField(frame: CGRect(x: 20, y: 100, width: 300, height: 50))
    
    lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "NunitoSans10pt-Regular", size: PFontSize.large)
        button.layer.cornerRadius = PLayout.horizontalPadding
        button.backgroundColor = .customBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var plainButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: "arrowButtonAuth")
        config.imagePlacement = .trailing
        config.imagePadding = 8
        
        let button = UIButton(configuration: config)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "NunitoSans10pt-Regular", size: PFontSize.normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
        
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setCommonConstraints()
    }
    
    // MARK: - UI Setup
    func setupViews() {
        view.backgroundColor = .white
        passwordTextField.delegate = self
        
        view.addSubview(label)
        view.addSubview(welcomeLabel)
        view.addSubview(button)
        view.addSubview(plainButton)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        
        switch authType {
        case .getStarted:
            view.addSubview(logo)
            button.removeTarget(nil, action: nil, for: .touchUpInside)
            button.addTarget(self, action: #selector(didGetStartedTapped), for: .touchUpInside)
            plainButton.addTarget(self, action: #selector(didHaveAccountTapped), for: .touchUpInside)
            resetConstraints()
            setGetStartedConstraints()
            setGetStartedUI()
        case .register:
            button.removeTarget(nil, action: nil, for: .touchUpInside)
            button.addTarget(self, action: #selector(didCreateAccountTapped), for: .touchUpInside)
            plainButton.addTarget(self, action: #selector(didCancelTapped), for: .touchUpInside)
            resetConstraints()
            setRegisterConstraints()
            setRegisterUI()
            
        case .login:
            button.removeTarget(nil, action: nil, for: .touchUpInside)
            button.addTarget(self, action: #selector(didLoginNextTapped), for: .touchUpInside)
            plainButton.addTarget(self, action: #selector(didCancelTapped), for: .touchUpInside)
            resetConstraints()
            setLoginConstraints()
            setLoginUI()
        }
        
    }
    
    // MARK: - Actions
  
    @objc func didGetStartedTapped() {
        presenter?.viewDidGetStartedTapped()
    }
    
    @objc func didHaveAccountTapped() {
        presenter?.viewDidHaveAccountTapped()
    }
    
    @objc func didCancelTapped() {
        presenter?.viewDidCancelTapped()
    }
    
    @objc func didCreateAccountTapped() {
        presenter?.viewDidCreateAccountTapped()
    }
    
    @objc func didLoginNextTapped() {
        presenter?.viewDidLoginNextTapped()
    }
    
    
    // MARK: - UITextFieldDelegate

        func textFieldDidBeginEditing(_ textField: UITextField) {
            textField.layer.borderColor = UIColor.systemBlue.cgColor
            textField.layer.borderWidth = 2
        }

        func textFieldDidEndEditing(_ textField: UITextField) {
            textField.layer.borderColor = UIColor.white.cgColor
            textField.layer.borderWidth = 1
        }
    
}


// MARK: - Setting different UIs
extension AuthViewController {
    func setGetStartedUI() {
        view.layer.contents = nil
        logo.isHidden = false
        label.text = "Shoppe"
        welcomeLabel.isHidden = true
        button.setTitle("Let's get started", for: .normal)
        plainButton.setTitle("I already have an account", for: .normal)
        emailTextField.isHidden = true
        passwordTextField.isHidden = true
        
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: "arrowButtonAuth")
        config.imagePlacement = .trailing
        config.imagePadding = 8
        plainButton.configuration = config
    }
    
    func setRegisterUI() {
        view.layer.contents = UIImage(named: "BubblesRegister")?.cgImage
        logo.isHidden = true
        label.text = "Create Account"
        welcomeLabel.isHidden = true
        button.setTitle("Done", for: .normal)
        emailTextField.isHidden = false
        passwordTextField.isHidden = false
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        plainButton.setTitle("Cancel", for: .normal)
        var config = UIButton.Configuration.plain()
        config.image = nil
        plainButton.configuration = config
    }
    
    func setLoginUI() {
        view.layer.contents = UIImage(named: "Bubbles")?.cgImage
        view.layer.contentsGravity = .resizeAspectFill
        logo.isHidden = true
        label.text = "Login"
        welcomeLabel.isHidden = false
        button.setTitle("Next", for: .normal)
        emailTextField.isHidden = false
        passwordTextField.isHidden = false
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        plainButton.setTitle("Cancel", for: .normal)
        var config = UIButton.Configuration.plain()
        config.image = nil
        plainButton.configuration = config
    }
}

// MARK: - Setting constraints
extension AuthViewController {
    func resetConstraints() {
        label.snp.removeConstraints()
        logo.snp.removeConstraints()
        emailTextField.snp.removeConstraints()
        passwordTextField.snp.removeConstraints()
    }
    
    func setCommonConstraints() {
        button.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-PLayout.horizontalPadding * 6)
            make.trailing.equalToSuperview().offset(-PLayout.horizontalPadding)
            make.leading.equalToSuperview().offset(PLayout.horizontalPadding)
            make.height.equalTo(PLayout.horizontalPadding*3)
        }
        
        plainButton.snp.makeConstraints { make in
            make.top.equalTo(button.snp.bottom).offset(PLayout.horizontalPadding)
            make.centerX.equalToSuperview()
        }
    }
    
    func setGetStartedConstraints() {
        logo.snp.makeConstraints { make in
            make.bottom.equalTo(label.snp.top).offset(-PLayout.horizontalPadding)
            make.centerX.equalToSuperview()
            make.height.equalTo(140)
            make.width.equalTo(140)
        }
        
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.top.equalTo(logo.snp.bottom).offset(PLayout.horizontalPadding)
        }
    }
    
    func setRegisterConstraints() {
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(PLayout.horizontalPadding)
            make.top.equalToSuperview().offset(PLayout.horizontalPadding*8)
            make.width.equalTo(view.frame.width*0.6)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.bottom.equalTo(passwordTextField.snp.top).offset(-PLayout.horizontalPadding)
            make.trailing.equalToSuperview().offset(-PLayout.horizontalPadding)
            make.leading.equalToSuperview().offset(PLayout.horizontalPadding)
            make.height.equalTo(PLayout.horizontalPadding*3)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.bottom.equalTo(button.snp.top).offset(-PLayout.horizontalPadding*3)
            make.trailing.equalToSuperview().offset(-PLayout.horizontalPadding)
            make.leading.equalToSuperview().offset(PLayout.horizontalPadding)
            make.height.equalTo(PLayout.horizontalPadding*3)
        }
    }
    
    func setLoginConstraints() {
        label.snp.makeConstraints { make in
            make.centerY.centerY.equalToSuperview().offset(-PLayout.horizontalPadding*2)
            make.leading.equalToSuperview().offset(PLayout.horizontalPadding)
        }
        
        welcomeLabel.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom)
            make.leading.equalToSuperview().offset(PLayout.horizontalPadding)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.bottom.equalTo(passwordTextField.snp.top).offset(-PLayout.horizontalPadding)
            make.trailing.equalToSuperview().offset(-PLayout.horizontalPadding)
            make.leading.equalToSuperview().offset(PLayout.horizontalPadding)
            make.height.equalTo(PLayout.horizontalPadding*3)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.bottom.equalTo(button.snp.top).offset(-PLayout.horizontalPadding*3)
            make.trailing.equalToSuperview().offset(-PLayout.horizontalPadding)
            make.leading.equalToSuperview().offset(PLayout.horizontalPadding)
            make.height.equalTo(PLayout.horizontalPadding*3)
        }
    }
}
