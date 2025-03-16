//
//  CartViewController.swift
//  Shoppe
//
//  Created by Artem Kriukov on 04.03.2025.
//

import UIKit
import SnapKit
import FirebaseAuth

protocol CartViewProtocol: AnyObject {
    func showCartProducts(_ products: [Product], quantities: [Int])
    func updateProduct(at index: Int, product: Product, quantity: Int)
    func updateCartCount(_ count: Int)
    func updateTotalPrice(_ totalPrice: String)
    func removeProduct(at index: Int)
    func clearCart()
}

final class CartViewController: UIViewController {
    
    var presenter: CartPresenterProtocol?
    
    private var products: [Product] = []
    private var quantities: [Int] = []
    
    lazy var alertView = CustomAlertView(
        title: "Delete Item?",
        message: "Are you shure?",
        buttonText: "Delete",
        secondButtonText: "Cancel"
    )
    // MARK: - UI
    private lazy var topStackView: UIStackView = {
        let element = UIStackView()
        element.axis = .horizontal
        element.spacing = 8
        return element
    }()
    
    private lazy var cartTitle: UILabel = {
        let element = UILabel()
        element.text = "Cart"
        element.font = UIFont(name: Fonts.Raleway.bold, size: 28)
        element.textColor = UIColor(named: "CustomBlack")
        return element
    }()
    
    private lazy var cartCountLabel: UILabel = {
        let element = UILabel()
        element.text = "1"
        element.font = UIFont(name: Fonts.Raleway.bold, size: 18)
        element.textAlignment = .center
        element.backgroundColor = UIColor(named: "CustomLightGray")
        element.layer.masksToBounds = true
        element.layer.cornerRadius = 15
        return element
    }()
    
    private lazy var spacerView: UIView = {
        let element = UIView()
        element.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return element
    }()
    
    private lazy var cartIconImageView: UIImageView = {
        let element = UIImageView()
        element.image = UIImage(systemName: "trash.fill")
        element.tintColor = UIColor(named: "CustomBlack")
        element.isUserInteractionEnabled = true
        return element
    }()
    
    private lazy var cartTableView: UITableView = {
        let element = UITableView()
        element.dataSource = self
        element.delegate = self
        element.separatorStyle = .none
        element.showsVerticalScrollIndicator = false
        element.register(
            CartTableViewCell.self,
            forCellReuseIdentifier: "CartTableViewCell"
        )
        element.register(
            ShippingAdressTableViewCell.self,
            forCellReuseIdentifier: "ShippingAdressTableViewCell"
        )
        return element
    }()
    
    private lazy var bottomStackView: UIStackView = {
        let element = UIStackView()
        element.axis = .horizontal
        element.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
        element.isLayoutMarginsRelativeArrangement = true
        element.layoutMargins = UIEdgeInsets(top: 15, left: 20, bottom: 10, right: 20)
        element.distribution = .fill
        element.alignment = .center
        return element
    }()
    
    private lazy var totalPriceStackView: UIStackView = {
        let element = UIStackView()
        element.axis = .horizontal
        element.spacing = 5
        element.distribution = .fill
        element.alignment = .center
        return element
    }()
    private lazy var totalNameLabel: UILabel = {
        let element = UILabel()
        element.text = "Total"
        element.font = UIFont(name: Fonts.Raleway.extraBold, size: 20)
        return element
    }()
    
    private lazy var totalPriceLabel: UILabel = {
        let element = UILabel()
        element.text = "$34.00"
        element.font = UIFont(name: Fonts.Raleway.bold, size: 18)
        return element
    }()
    
    private lazy var checkoutButton: UIButton = {
        let element = UIButton(type: .system)
        element.setTitle("Checkout", for: .normal)
        element.backgroundColor = UIColor(named: "CustomBlue")
        element.tintColor = .white
        element.titleLabel?.font = UIFont(
            name: Fonts.NunitoSans.light,
            size: 16
        )
        element.addTarget(self, action: #selector(showPaymentScreen), for: .touchUpInside)
        element.layer.cornerRadius = 11
        return element
    }()
    
    private lazy var topSpacerView: UIView = {
        let element = UIView()
        element.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return element
    }()
    
    private lazy var emptyCartLabel: UILabel = {
        let element = UILabel()
        element.text = "Your cart is empty"
        element.font = UIFont(name: Fonts.Raleway.bold, size: 22)
        element.textColor = .gray
        element.textAlignment = .center
        element.isHidden = true
        return element
    }()
    // MARK: - Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        presenter?.updateCartCount()
        presenter?.updateTotalPrice()
        
        setupViews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(loadDefaultAddress), name: .addressUpdated, object: nil)
        navigationController?.navigationBar.isHidden = true
        presenter?.fetchCartProducts()
        loadDefaultAddress()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Action
    
    @objc func showPaymentScreen() {
        presenter?.didTapCheckoutButton()
    }
    
    @objc private func loadDefaultAddress() {
        if let user = Auth.auth().currentUser {
            let userId = user.uid
            AddressManager.shared.fetchDefaultAddress(for: userId) { [weak self] address, errorMessage in
                if let address = address {
                    self?.updateShippingAddressCell(with: address)
                } else if let errorMessage = errorMessage {
                    print(errorMessage)
                    self?.updateShippingAddressCell(with: nil)
                }
            }
        } else {
            print("Пользователь не авторизован")
            self.updateShippingAddressCell(with: nil)
        }
    }
    
    private func updateShippingAddressCell(with address: AddressModel?) {
        if let cell = cartTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ShippingAdressTableViewCell {
            cell.updateAddress(with: address) 
        }
    }
    
    private func setupCartIconTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cartIconTapped))
        cartIconImageView.addGestureRecognizer(tapGesture)
    }
    
    
    @objc private func cartIconTapped() {
        alertView.show()
        alertView.button.addTarget(self, action: #selector(confirmDelete), for: .touchUpInside)
        alertView.secondButton.addTarget(self, action: #selector(cancelDelete), for: .touchUpInside)
        print("Cart icon tapped")
    }
    
    @objc func confirmDelete() {
        alertView.dismiss()
        presenter?.clearCart()
    }
    
    @objc func cancelDelete() {
        alertView.dismiss()
    }
}

// MARK: - CartViewProtocol
extension CartViewController: CartViewProtocol {
    func showCartProducts(_ products: [Product], quantities: [Int]) {
        self.products = products
        self.quantities = quantities
        emptyCartLabel.isHidden = !products.isEmpty
        presenter?.updateCartCount()
        presenter?.updateTotalPrice()
        cartTableView.reloadData()
    }
    
    func updateProduct(at index: Int, product: Product, quantity: Int) {
        products[index] = product
        quantities[index] = quantity // Обновляем количество
        if let cell = cartTableView.cellForRow(at: IndexPath(row: index + 1, section: 0)) as? CartTableViewCell {
            cell.updateQuantity(quantity)
        }
    }
    
    
    func updateCartCount(_ count: Int) {
        cartCountLabel.text = "\(count)"
        
        // Обновляем бейдж в HomeViewController
        if let tabBarController = tabBarController,
           let homeVC = tabBarController.viewControllers?[0] as? HomeViewController {
            //            homeVC.presenter.updateCartBadge()
        }
    }
    
    func updateTotalPrice(_ totalPrice: String) {
        totalPriceLabel.text = totalPrice
    }
    
    func removeProduct(at index: Int) {
        guard products.indices.contains(index) else { return }
        products.remove(at: index)
        quantities.remove(at: index)
        let indexPath = IndexPath(row: index + 1, section: 0)
        cartTableView.deleteRows(at: [indexPath], with: .automatic)
        emptyCartLabel.isHidden = !products.isEmpty
    }
    
    func clearCart() {
        products.removeAll()
        quantities.removeAll()
        cartTableView.reloadData()
        emptyCartLabel.isHidden = false
        updateCartCount(0)
        updateTotalPrice("$0.00")
    }
}


// MARK: - UITableViewDataSource and UITableViewDelegate

extension CartViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        products.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShippingAdressTableViewCell", for: indexPath) as! ShippingAdressTableViewCell
            cell.parentViewController = self
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableViewCell", for: indexPath) as! CartTableViewCell
            
            let product = products[indexPath.row - 1]
            let quantity = quantities[indexPath.row - 1]
            
            if let presenter = presenter {
                cell.configure(
                    with: product,
                    at: indexPath.row - 1,
                    quantity: quantity,
                    presenter: presenter
                )
            }
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 80
        } else {
            return 120
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row > 0 else { return }
        let product = products[indexPath.row - 1]
        presenter?.didSelectProduct(product)
    }
}


// MARK: - Set Views and Setup Constraints
private extension CartViewController {
    func setupViews() {
        view.addSubview(topStackView)
        
        topStackView.addArrangedSubview(cartTitle)
        topStackView.addArrangedSubview(cartCountLabel)
        topStackView.addArrangedSubview(topSpacerView)
        topStackView.addArrangedSubview(cartIconImageView)
        
        view.addSubview(cartTableView)
        
        view.addSubview(bottomStackView)
        bottomStackView.addArrangedSubview(totalPriceStackView)
        totalPriceStackView.addArrangedSubview(totalNameLabel)
        totalPriceStackView.addArrangedSubview(totalPriceLabel)
        totalPriceStackView.addArrangedSubview(spacerView)
        
        bottomStackView.addArrangedSubview(checkoutButton)
        
        view.addSubview(emptyCartLabel)
        
        setupCartIconTapGesture()
    }
    
    private func setupConstraints() {
        topStackView.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(5)
        }
        
        cartCountLabel.snp.makeConstraints { make in
            make.width.height.equalTo(30)
        }
        
        cartIconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(30)
        }
        
        cartTableView.snp.makeConstraints { make in
            make.top.equalTo(topStackView.snp.bottom).inset(-15)
            make.trailing.leading.equalTo(view.safeAreaLayoutGuide).inset(15)
            make.bottom.equalTo(bottomStackView.snp.top).inset(15)
        }
        
        bottomStackView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
        }
        
        checkoutButton.snp.makeConstraints { make in
            make.width.equalTo(130)
            make.height.equalTo(40)
        }
        
        emptyCartLabel.snp.makeConstraints { make in
            make.center.equalTo(view)
        }
    }
}
