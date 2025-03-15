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
    func showAuthErrorMessage(error: String)
    func shakeTextField()
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
    
    lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "NunitoSans10pt-Regular", size: PFontSize.small)
        label.textColor = .customBlue
        label.textAlignment = .center
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
        config.title = "I already have an account"
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
        addKeyboardObservers()
    }

    deinit {
        removeKeyboardObservers()
    }
    
    // MARK: - UI Setup
    func setupViews() {
        view.backgroundColor = .white
        passwordTextField.delegate = self
        
        view.addSubview(label)
        view.addSubview(errorLabel)
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
            errorLabel.text = ""
            resetConstraints()
            setGetStartedConstraints()
            setGetStartedUI()
        case .register:
            emailTextField.text = ""
            passwordTextField.text = ""
            button.removeTarget(nil, action: nil, for: .touchUpInside)
            button.addTarget(self, action: #selector(didCreateAccountTapped), for: .touchUpInside)
            plainButton.addTarget(self, action: #selector(didCancelTapped), for: .touchUpInside)
            errorLabel.text = ""
            resetConstraints()
            setRegisterConstraints()
            setRegisterUI()
            
        case .login:
            emailTextField.text = ""
            passwordTextField.text = ""
            button.removeTarget(nil, action: nil, for: .touchUpInside)
            button.addTarget(self, action: #selector(didLoginNextTapped), for: .touchUpInside)
            plainButton.addTarget(self, action: #selector(didCancelTapped), for: .touchUpInside)
            errorLabel.text = ""
            resetConstraints()
            setLoginConstraints()
            setLoginUI()
        }
        //Для быстрого входа
        emailTextField.text = "1@2.com"
        passwordTextField.text = "A1234567"
    }
    
    // MARK: - Keyboard notifications
    func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }
    
    // MARK: - Actions
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        let keyboardHeight = keyboardFrame?.height ?? 0
        
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = -keyboardHeight / 2
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = 0
        }
    }
  
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
        guard let email = emailTextField.text, !email.isEmpty else {
            shakeTextField()
            errorLabel.text = "Email can´t be empty"
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            shakeTextField()
            errorLabel.text = "Password can´t be empty"
            return
        }
        
        presenter?.viewDidCreateAccountTapped(email: email, password: password)
    }
    
    @objc func didLoginNextTapped() {
        guard let email = emailTextField.text, !email.isEmpty else {
            errorLabel.text = "Email can´t be empty"
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            errorLabel.text = "Password can´t be empty"
            return
        }
        
        presenter?.viewDidLoginNextTapped(email: email, password: password)
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
    
    func shakeTextField() {
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position.x"
        animation.values = [0, 10, -10, 10, 0]
        animation.keyTimes = [0, 0.16, 0.5, 0.83, 1]
        animation.duration = 0.4
        
        animation.isAdditive = true
        emailTextField.layer.add(animation, forKey: "shake")
        passwordTextField.layer.add(animation, forKey: "shake")
    }
    
    func animateImageScale() {
        let animation = CABasicAnimation(keyPath: "contentsRect")
            animation.fromValue = CGRect(x: -0.15, y: -0.15, width: 1.3, height: 1.3) // Увеличенный размер
            animation.toValue = CGRect(x: 0, y: 0, width: 1, height: 1) // Обычный размер
            animation.duration = 1
            animation.timingFunction = CAMediaTimingFunction(name: .easeOut)

            view.layer.add(animation, forKey: "backgroundScale")
    }
    
    func setGetStartedUI() {
        view.layer.contents = nil
        logo.isHidden = false
        label.text = "Shoppe"
        welcomeLabel.isHidden = true
        button.setTitle("Let's get started", for: .normal)
        emailTextField.isHidden = true
        passwordTextField.isHidden = true
        
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: "arrowButtonAuth")
        config.imagePlacement = .trailing
        config.imagePadding = 8
        config.title = "I already have an account"
        plainButton.configuration = config
    }
    
    func setRegisterUI() {
        view.layer.contents = UIImage(named: "BubblesRegister")?.cgImage
        animateImageScale()
        logo.isHidden = true
        label.text = "Create Account"
        welcomeLabel.isHidden = true
        button.setTitle("Done", for: .normal)
        emailTextField.isHidden = false
        passwordTextField.isHidden = false
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        var config = UIButton.Configuration.plain()
        config.image = nil
        config.title = "Cancel"
        plainButton.configuration = config
    }
    
    func setLoginUI() {
        view.layer.contents = UIImage(named: "Bubbles")?.cgImage
        animateImageScale()
        view.layer.contentsGravity = .resizeAspectFill
        logo.isHidden = true
        label.text = "Login"
        welcomeLabel.isHidden = false
        button.setTitle("Next", for: .normal)
        emailTextField.isHidden = false
        passwordTextField.isHidden = false
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        var config = UIButton.Configuration.plain()
        config.image = nil
        config.title = "Cancel"
        plainButton.configuration = config
    }
    
    func showAuthErrorMessage(error: String) {
        errorLabel.text = error
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
        
        errorLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(passwordTextField.snp.bottom).offset(PLayout.paddingS)
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
