//
//  SearchView.swift
//  Shoppe
//
//  Created by ordoko on 15.03.2025.
//

import UIKit

final class PaddedTextField: UITextField {
    let padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
}

enum SearchBarType {
    case fake
    case real
}

protocol FakeSearchViewDelegate: AnyObject {
    func didTapSearch()
}

protocol SearchViewDelegate: AnyObject {
    func didChangeSearchText(_ text: String?)
    func searchButtonClicked(_ text: String?)
}

final class SearchView: UIView {

    weak var delegate: SearchViewDelegate?
    weak var fakeSearchViewDelegate: FakeSearchViewDelegate?
    
    var searchBarType: SearchBarType = .fake
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.spacing = 16
        return stack
    }()
    
    private lazy var leftTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Search"
        label.textColor = UIColor(red: 0.779, green: 0.779, blue: 0.779, alpha: 1)
        label.font = UIFont(name: Fonts.Raleway.medium, size: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    private lazy var searchTextField: PaddedTextField = {
        let textField = PaddedTextField()
        textField.clearButtonMode = .always
        textField.font = UIFont(name: Fonts.Raleway.regular, size: 16)
        textField.borderStyle = .none
        textField.returnKeyType = .search
        textField.textColor = .black
        textField.backgroundColor = .customGray
        textField.layer.cornerRadius = 20
        textField.delegate = self
        textField.returnKeyType = .search
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isUserInteractionEnabled = false
        return textField
    }()
    

    init(title: String? = nil) {
        super.init(frame: .zero)
        if let title = title {
            setupTitle(title)
            setupTextField()
        }
        setupView()
        setupConstraints()
        setupGestures()
    }
    
    func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
    }
    
    func setupReal() {
        searchBarType = .real
        searchTextField.isUserInteractionEnabled = true
    }
    
    func updateSearchBar(with query: String) {
        searchTextField.text = query
        searchTextField.becomeFirstResponder()
    }
    
    func setFirstResponder() {
        searchTextField.becomeFirstResponder()
    }
    
    @objc func handleTap() {
        if searchBarType == .fake {
            fakeSearchViewDelegate?.didTapSearch()
        }
    }
    
    private func setupTitle(_ text: String) {
        leftTitleLabel.text = text
        leftTitleLabel.font = UIFont(name: Fonts.Raleway.bold, size: 28)
        leftTitleLabel.textColor = .black
    }
    
    private func setupTextField() {
        searchTextField.placeholder = "Search"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension SearchView {
    func setupView() {
        addSubview(stackView)
        stackView.addArrangedSubview(leftTitleLabel)
        stackView.addArrangedSubview(searchTextField)
    }
    
    func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        leftTitleLabel.snp.makeConstraints { make in
            make.width.equalTo(75)
            make.centerY.equalTo(searchTextField.snp.centerY)
        }
    }
}

extension SearchView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        delegate?.didChangeSearchText(textField.text)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text {
            delegate?.searchButtonClicked(text)
        }
        textField.resignFirstResponder()
        return true
    }
}
