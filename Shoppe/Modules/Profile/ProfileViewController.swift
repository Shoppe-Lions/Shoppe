//
//  ProfileViewController.swift
//  Shoppe
//
//  Created by Дарья on 07.03.2025.
//

import UIKit
import SnapKit
import FirebaseAuth
import FirebaseFirestore

class ProfileViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let horizontalPadding = UIScreen.main.bounds.width * 0.05
    let verticalPadding = UIScreen.main.bounds.height * 0.05
    let textFieldVerticalPadding = UIScreen.main.bounds.height * 0.02
    var changesMode = false
    
    private lazy var settingsStackView: UIStackView = {
        let element = UIStackView()
        element.axis = .vertical
        element.spacing = verticalPadding / 4
        return element
    }()
    
    lazy var shippingDetails = DetailsView(type: .shipping)
    
    private lazy var nameLabel: UILabel = {
        let element = UILabel()
        element.font = UIFont(name: Fonts.Raleway.medium, size: ProductFontSize.medium)
        return element
    }()
    
    private lazy var emailLabel: UILabel = {
        let element = UILabel()
        element.font = UIFont(name: Fonts.Raleway.medium, size: ProductFontSize.medium)
        return element
    }()
    
    private lazy var bufferView: UIView = {
        let element = UIView()
        return element
    }()
    
    lazy var nameTextField: UITextField = {
        return createTextField(placeholder: "Name", keyboardType: .default, isSecure: false)
    }()
    
//    lazy var emailTextField: UITextField = {
//        return createTextField(placeholder: "Email", keyboardType: .emailAddress , isSecure: false)
//    }()
    
    lazy var passwordTextField: CustomPasswordTextField = {
        let textField = CustomPasswordTextField()
        textField.backgroundColor = UIColor(named: "CustomLightGray")
        textField.placeholder = "New Password"
        textField.textContentType = .newPassword
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.delegate = self
        return textField
    }()
    
    lazy var chekPasswordTextField: CustomPasswordTextField = {
        let textField = CustomPasswordTextField()
        textField.backgroundColor = UIColor(named: "CustomLightGray")
        textField.placeholder = "Re-enter Password"
        textField.textContentType = .newPassword
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.delegate = self
        return textField
    }()
    
    lazy var editButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "EditButton"), for: .normal)
        button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        return button
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
        image.image = UIImage(named: "Profile")
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let profileImageFrame: UIView = {
        let frame = UIView()
        frame.backgroundColor = .white
        frame.clipsToBounds = false
        frame.layer.shadowColor = UIColor.black.cgColor
        frame.layer.shadowOpacity = 0.3
        frame.layer.shadowOffset = CGSize(width: 0, height: 2)
        frame.layer.shadowRadius = 9
        frame.translatesAutoresizingMaskIntoConstraints = false
        return frame
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Settings", for: .normal)
        button.titleLabel?.font = UIFont(name: Fonts.NunitoSans.light, size: 18)
        button.backgroundColor = .customBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(nil, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        updateShippingAddress()
        NotificationCenter.default.addObserver(self, selector: #selector(updateShippingAddress), name: .addressUpdated, object: nil)
        fetchDisplayName { name in
            if let name = name {
                self.nameLabel.text = "Name: \(name)"
            }
        }
        if let userEmail = Auth.auth().currentUser?.email {
            self.emailLabel.text = "Email: \(userEmail)"
        }
        loadProfileImage()
        
        let logOutButton = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logOutButtonTapped))
        logOutButton.tintColor = .customBlue
        navigationItem.rightBarButtonItem = logOutButton
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        shippingDetails.editButton.addTarget(self, action: #selector(editShippingDetailsTapped), for: .touchUpInside)
        
        nameTextField.isHidden = true
//        emailTextField.isHidden = true
        passwordTextField.isHidden = true
        chekPasswordTextField.isHidden = true
        editButton.isHidden = true
        shippingDetails.editButton.isHidden = true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        DispatchQueue.main.async {
            self.profileImageFrame.layer.cornerRadius = self.profileImageFrame.frame.height / 2
            self.profileImage.layer.cornerRadius = self.profileImage.frame.height / 2
            self.saveButton.layer.cornerRadius = self.saveButton.frame.height * 0.25
        }
    }
    
    // MARK: - Methods
    
    @objc func updateShippingAddress() {
        if let user = Auth.auth().currentUser {
            let userId = user.uid
            AddressManager.shared.fetchDefaultAddress(for: userId) { [weak self] address, errorMessage in
                if let address = address {
                    let addressString = "\(address.zipCode), \(address.city), \(address.street), \(address.houseNumber)"
                    self?.shippingDetails.addressLabel.text = addressString
                } else if let errorMessage = errorMessage {
                    self?.shippingDetails.addressLabel.text = "Please, add your address."
                }
            }
        } else {
            print("Пользователь не авторизован")
        }
    }
    
    @objc func editShippingDetailsTapped() {
        let vc = AddressesViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .pageSheet

        if let sheet = nav.sheetPresentationController {
            let customDetent = UISheetPresentationController.Detent.custom { context in
                return context.maximumDetentValue * 0.3
            }
            sheet.detents = [customDetent]
        }

        present(nav, animated: true, completion: nil)
    }
    
    func loadProfileImage() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()

        db.collection("users").document(uid).getDocument { [weak self] document, error in
            if let document = document, document.exists {
                if let filePath = document.data()?["profileImagePath"] as? String {
                    ImageLoader.shared.loadImage(from: filePath) { image, _ in
                        if let image = image {
                            self?.profileImage.image = image
                        }
                    }
                }
            }
        }
    }
    
    @objc private func logOutButtonTapped() {
        do {
          try Auth.auth().signOut()
            guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
                return
            }
            sceneDelegate.window?.rootViewController = AuthRouter.createModule()
            sceneDelegate.window?.makeKeyAndVisible()
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
    
    func updateDisplayName(newName: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        if newName.isEmpty { return }
        
        switch newName.count {
            case 0...1:
            self.showAlert(title: "Error", message: "Name too short")
            return
            case 16...:
            self.showAlert(title: "Error", message: "Name too long")
            return
        default:
            break
        }
        
        if newName.contains(where: { !$0.isLetter }) {
            self.showAlert(title: "Error", message: "Name must contain only letters")
            return
        }
        
        db.collection("users").document(uid).setData([
            "username": newName
        ], merge: true) { error in
            if let error = error {
                print("Ошибка при обновлении имени: \(error.localizedDescription)")
            } else {
                print("Имя успешно обновлено")
            }
        }
    }
    
    func fetchDisplayName(completion: @escaping (String?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }

        let db = Firestore.firestore()
        db.collection("users").document(uid).getDocument { document, error in
            if let document = document, document.exists {
                let data = document.data()
                let username = data?["username"] as? String
                completion(username)
            } else {
                completion(nil)
            }
        }
    }
    
    private func updateUIforChanges() {
        switch changesMode {
        case false:
            changesMode = true
            UIView.transition(with: settingsStackView, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.editButton.isHidden = false
                self.shippingDetails.editButton.isHidden = false
                self.nameTextField.isHidden = false
                self.nameLabel.isHidden = true
//                self.emailTextField.isHidden = false
                self.emailLabel.isHidden = true
                self.passwordTextField.isHidden = false
                self.chekPasswordTextField.isHidden = false
                self.saveButton.setTitle("Save Changes", for: .normal)
            }, completion: nil)
        case true:
            guard let user = Auth.auth().currentUser else { return }
            
            if let userName = nameTextField.text {
                updateDisplayName(newName: userName)
            }
            
//            if let newEmail = emailTextField.text, !newEmail.isEmpty {
//                user.updateEmail(to: newEmail) { [weak self] error in
//                    if let error = error {
//                        self?.showAlert(title: "Ошибка", message: "Не удалось изменить email: \(error.localizedDescription)")
//                        return
//                    }
//                }
//            }
            
            if let newPassword = passwordTextField.text, !newPassword.isEmpty,
               let confirmPassword = chekPasswordTextField.text, !confirmPassword.isEmpty {
                if newPassword == confirmPassword {
                    user.updatePassword(to: newPassword) { [weak self] error in
                        if let error = error {
                            self?.showAlert(title: "Error", message: "Failed to change password: \(error.localizedDescription)")
                            return
                        }
                    }
                } else {
                    showAlert(title: "Error", message: "The passwords do not match.")
                    return
                }
            }
            changesMode = false
            UIView.transition(with: settingsStackView, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.editButton.isHidden = true
                self.shippingDetails.editButton.isHidden = true
                self.nameTextField.isHidden = true
                self.nameTextField.text = ""
                self.nameLabel.isHidden = false
//                self.emailTextField.isHidden = true
                self.emailLabel.isHidden = false
                self.passwordTextField.isHidden = true
                self.passwordTextField.text = ""
                self.chekPasswordTextField.isHidden = true
                self.chekPasswordTextField.text = ""
                self.saveButton.setTitle("Edit Settings", for: .normal)
                self.fetchDisplayName { name in
                    if let name = name {
                        self.nameLabel.text = "Name: \(name)"
                    }
                }
            }, completion: nil)
        }
    }
    
    @objc private func saveButtonTapped() {
        updateUIforChanges()
    }
    
    @objc private func editButtonTapped() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.allowsEditing = true
            present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.editedImage] as? UIImage {
            ImageLoader.shared.loadImage(from: selectedImage) { [weak self] image, filePath in
                if let image = image, let filePath = filePath {
                    self?.profileImage.image = image
                    
                    self?.saveImagePathToFirestore(filePath)
                }
            }
        }
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func saveImagePathToFirestore(_ filePath: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        
        db.collection("users").document(uid).setData([
            "profileImagePath": filePath
        ], merge: true) { error in
            if let error = error {
                print("Ошибка при сохранении пути к изображению: \(error.localizedDescription)")
            } else {
                print("Путь к изображению успешно сохранен")
            }
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
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
        profileImageFrame.addSubview(editButton)
        view.addSubview(settingsStackView)
        settingsStackView.addArrangedSubview(shippingDetails)
        settingsStackView.addArrangedSubview(nameTextField)
        settingsStackView.addArrangedSubview(nameLabel)
//        settingsStackView.addArrangedSubview(emailTextField)
        settingsStackView.addArrangedSubview(emailLabel)
        settingsStackView.addArrangedSubview(passwordTextField)
        settingsStackView.addArrangedSubview(chekPasswordTextField)
        settingsStackView.addArrangedSubview(bufferView)
        view.addSubview(saveButton)
        
    }
}

//MARK: - Set Constraints
extension ProfileViewController {
    
    private func setupConstraints() {
        
        settingsLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().inset(horizontalPadding)
        }
        
        profileLabel.snp.makeConstraints { make in
            make.top.equalTo(settingsLabel.snp.bottom).offset(verticalPadding / 4)
            make.leading.equalToSuperview().inset(horizontalPadding)
        }
        
        profileImageFrame.snp.makeConstraints { make in
            make.top.equalTo(profileLabel.snp.bottom).offset(verticalPadding / 2)
            make.width.height.equalTo(PLayout.horizontalPadding * 5)
            make.leading.equalToSuperview().inset(horizontalPadding)
        }
        
        profileImage.snp.makeConstraints { make in
            make.width.height.equalTo(profileImageFrame.snp.height).multipliedBy(0.9)
            make.centerX.centerY.equalTo(profileImageFrame)
        }
        
        settingsStackView.snp.makeConstraints { make in
            make.top.equalTo(profileImageFrame.snp.bottom).offset(verticalPadding / 2)
            make.leading.trailing.equalToSuperview().inset(horizontalPadding)
            make.bottom.equalTo(saveButton.snp.top).offset(-verticalPadding / 2)
        }
        
        shippingDetails.snp.makeConstraints { make in
            make.height.equalTo(PLayout.horizontalPadding * 3)
        }
        
        editButton.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.trailing.equalTo(profileImageFrame).offset(1)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.height.equalTo(PLayout.horizontalPadding * 2.5)
        }
        
//        emailTextField.snp.makeConstraints { make in
//            make.height.equalTo(PLayout.horizontalPadding * 2.5)
//        }
        
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(PLayout.horizontalPadding * 2.5)
        }
        
        chekPasswordTextField.snp.makeConstraints { make in
            make.height.equalTo(PLayout.horizontalPadding * 2.5)
        }
        
        saveButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(horizontalPadding)
            make.height.equalTo(PLayout.horizontalPadding * 2.5)
            make.bottom.equalToSuperview().inset(horizontalPadding)
        }
    }
    
    
}
// MARK: - Create TextField
extension ProfileViewController {
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func createTextField(placeholder: String, keyboardType: UIKeyboardType, isSecure: Bool) -> UITextField {
        let textField = UITextField()
        textField.backgroundColor = UIColor(named: "CustomLightGray")
        textField.font = UIFont(name: "NunitoSans10pt-Regular", size: PFontSize.normal)
        textField.placeholder = placeholder
        textField.isSecureTextEntry = isSecure
        textField.keyboardType = keyboardType
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.white.cgColor
        textField.delegate = self
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
    
    
    // MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.systemBlue.cgColor
        textField.layer.borderWidth = 2
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.white.cgColor
        textField.layer.borderWidth = 1
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


