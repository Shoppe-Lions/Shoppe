//
//  AddAddressViewController.swift
//  Shoppe
//
//  Created by Игорь Клевжиц on 15.03.2025.
//
import UIKit

class AddAddressViewController: UIViewController, UITextFieldDelegate {
    var userId: String!
    var existingAddress: AddressModel?
    var onAddressAdded: (() -> Void)?
    
    lazy var streetField: UITextField = {
        return createTextField(placeholder: "Street*", keyboardType: .default, isSecure: false)
    }()
    
    lazy var cityField: UITextField = {
        return createTextField(placeholder: "City*", keyboardType: .default , isSecure: false)
    }()
    
    lazy var zipField: UITextField = {
        return createTextField(placeholder: "Zip Code*", keyboardType: .numberPad, isSecure: false)
    }()
    
    lazy var houseNumberField: UITextField = {
        return createTextField(placeholder: "House Number*", keyboardType: .numberPad , isSecure: false)
    }()
    
    lazy var commentField: UITextField = {
        return createTextField(placeholder: "Add a comment...", keyboardType: .default, isSecure: false)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupFields()
        setupSaveButton()
        
        if let address = existingAddress {
            title = "Edit address"
            streetField.text = address.street
            cityField.text = address.city
            zipField.text = address.zipCode
            houseNumberField.text = address.houseNumber
            commentField.text = address.comment
        } else {
            title = "Add address"
        }
    }
    
    private func setupFields() {
        let stack = UIStackView(arrangedSubviews: [streetField, cityField, zipField, houseNumberField, commentField])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        
        streetField.inputAccessoryView = createToolBar()
        cityField.inputAccessoryView = createToolBar()
        zipField.inputAccessoryView = createToolBar()
        houseNumberField.inputAccessoryView = createToolBar()
        commentField.inputAccessoryView = createToolBar()
        
        zipField.keyboardType = .numberPad
        zipField.inputAccessoryView = createToolBar()
        houseNumberField.keyboardType = .numberPad
        houseNumberField.inputAccessoryView = createToolBar()
        
        streetField.snp.makeConstraints { make in
            make.height.equalTo(PLayout.horizontalPadding * 2.5)
        }
        
        cityField.snp.makeConstraints { make in
            make.height.equalTo(PLayout.horizontalPadding * 2.5)
        }
        
        zipField.snp.makeConstraints { make in
            make.height.equalTo(PLayout.horizontalPadding * 2.5)
        }
        
        houseNumberField.snp.makeConstraints { make in
            make.height.equalTo(PLayout.horizontalPadding * 2.5)
        }
        
        commentField.snp.makeConstraints { make in
            make.height.equalTo(PLayout.horizontalPadding * 2.5)
        }
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func createToolBar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneTapped))
        toolbar.items = [doneButton]
        
        return toolbar
    }
    
    @objc private func doneTapped() {
        if streetField.isFirstResponder {
            cityField.becomeFirstResponder()
        } else if cityField.isFirstResponder {
            zipField.becomeFirstResponder()
        } else if zipField.isFirstResponder {
            houseNumberField.becomeFirstResponder()
        } else if houseNumberField.isFirstResponder {
            commentField.becomeFirstResponder()
        } else if commentField.isFirstResponder {
            commentField.resignFirstResponder() // Скрываем клавиатуру, если это последнее поле
        }
    }
    
    private func setupSaveButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeTapped))
    }
    
    @objc private func saveTapped() {
        guard let street = streetField.text, !street.isEmpty,
              let city = cityField.text, !city.isEmpty,
              let zip = zipField.text, !zip.isEmpty,
              let house = houseNumberField.text, !house.isEmpty else { return }

        // Используем новый адрес с дополнительными данными
        let newAddress = AddressModel(
            id: existingAddress?.id ?? UUID().uuidString,
            street: street,
            city: city,
            zipCode: zip,
            houseNumber: house,
            comment: commentField.text,
            isDefault: true
        )

        AddressManager.shared.fetchAddresses(for: userId) { [weak self] addresses in
            guard let self = self else { return }

            let group = DispatchGroup()

            for var addr in addresses {
                if addr.isDefault {
                    addr.isDefault = false
                    group.enter()
                    AddressManager.shared.updateAddress(addr, for: self.userId) { _ in
                        group.leave()
                    }
                }
            }

            group.notify(queue: .main) {
                AddressManager.shared.addAddress(newAddress, for: self.userId) { success in
                    if success {
                        DispatchQueue.main.async {
                            self.onAddressAdded?()
                            self.dismiss(animated: true)
                        }
                    }
                }
            }
        }
    }

    @objc private func closeTapped() {
        dismiss(animated: true)
    }
}

extension AddAddressViewController {
    
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
