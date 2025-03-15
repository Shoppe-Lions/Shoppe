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
    
    lazy var nameTextField: UITextField = {
        return createTextField(placeholder: "Name", keyboardType: .default, isSecure: false)
    }()
    
    lazy var emailTextField: UITextField = {
        return createTextField(placeholder: "Email", keyboardType: .emailAddress , isSecure: false)
    }()
    
    lazy var passwordTextField: CustomPasswordTextField = {
        let textField = CustomPasswordTextField()
        textField.backgroundColor = UIColor(named: "CustomLightGray")
        textField.delegate = self
        return textField
    }()
    
    lazy var chekPasswordTextField: CustomPasswordTextField = {
        let textField = CustomPasswordTextField()
        textField.backgroundColor = UIColor(named: "CustomLightGray")
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
        button.setTitle("Save Changes", for: .normal)
        button.titleLabel?.font = UIFont(name: Fonts.NunitoSans.light, size: 18)
        button.backgroundColor = .customBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(nil, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        
        fetchDisplayName { name in
            if let name = name {
                self.nameTextField.text = name
            }
        }
        
        let logOutButton = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logOutButtonTapped))
        logOutButton.tintColor = .customBlue
        navigationItem.rightBarButtonItem = logOutButton
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        DispatchQueue.main.async {
            self.profileImageFrame.layer.cornerRadius = self.profileImageFrame.frame.height / 2
            self.profileImage.layer.cornerRadius = self.profileImage.frame.height / 2
            self.saveButton.layer.cornerRadius = self.saveButton.frame.height * 0.25
        }
    }
    
    @objc private func logOutButtonTapped() {
        print("Выход из аккаунта")
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
    
    @objc private func saveButtonTapped() {
        if let userName = nameTextField.text {
            updateDisplayName(newName: userName)
        }
//        let vc = AddressesViewController()
//        let nav = UINavigationController(rootViewController: vc)
//        nav.modalPresentationStyle = .pageSheet
//
//        if let sheet = nav.sheetPresentationController {
//            let customDetent = UISheetPresentationController.Detent.custom { context in
//                return context.maximumDetentValue * 0.3
//            }
//            sheet.detents = [customDetent]
//        }
//
//        present(nav, animated: true, completion: nil)
        print("Изменения сохранены")
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
            profileImage.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
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
        view.addSubview(nameTextField)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(chekPasswordTextField)
        view.addSubview(saveButton)
        
    }
}

//MARK: - Set Constraints
extension ProfileViewController {
    
    private func setupConstraints() {
        
        let horizontalPadding = UIScreen.main.bounds.width * 0.05
        let verticalPadding = UIScreen.main.bounds.height * 0.05
        let textFieldVerticalPadding = UIScreen.main.bounds.height * 0.02
        
        settingsLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(verticalPadding * 1)
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
        
        editButton.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.trailing.equalTo(profileImageFrame).offset(1)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(profileImageFrame.snp.bottom).offset(verticalPadding / 2)
            make.leading.trailing.equalToSuperview().inset(horizontalPadding)
            make.height.equalTo(PLayout.horizontalPadding * 2.5)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(textFieldVerticalPadding / 2)
            make.leading.trailing.equalToSuperview().inset(horizontalPadding)
            make.height.equalTo(PLayout.horizontalPadding * 2.5)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(textFieldVerticalPadding / 2)
            make.leading.trailing.equalToSuperview().inset(horizontalPadding)
            make.height.equalTo(PLayout.horizontalPadding * 2.5)
        }
        
        chekPasswordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(textFieldVerticalPadding / 2)
            make.leading.trailing.equalToSuperview().inset(horizontalPadding)
            make.height.equalTo(PLayout.horizontalPadding * 2.5)
        }
        
        saveButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(horizontalPadding)
            make.height.equalTo(PLayout.horizontalPadding * 2.5)
            make.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide.snp.bottom).offset(-verticalPadding * 1)
        }
    }
    
    
}
// MARK: - Create TextField
extension ProfileViewController {
    
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


