//
//  AddressesViewController.swift
//  Shoppe
//
//  Created by Игорь Клевжиц on 15.03.2025.
//

import UIKit
import FirebaseAuth

class AddressesViewController: UIViewController {
    var addresses: [AddressModel] = []
    let tableView = UITableView()
    var userId: String?
    var onAddressSelected: ((AddressModel) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My addresses"
        view.backgroundColor = .systemBackground
        setupTableView()
        setupAddButton()
        
        if let user = Auth.auth().currentUser {
            userId = user.uid
            fetchAddresses()
        } else {
            print("Пользователь не авторизован")
        }
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "AddressCell")
    }
    
    private func setupAddButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addAddressTapped))
    }

    @objc private func addAddressTapped() {
        let addVC = AddAddressViewController()
        addVC.userId = userId
        addVC.onAddressAdded = { [weak self] in
            self?.fetchAddresses()
        }
        let nav = UINavigationController(rootViewController: addVC)
        present(nav, animated: true)
    }

    private func fetchAddresses() {
        guard let userId = userId else { return }
        
        AddressManager.shared.fetchAddresses(for: userId) { [weak self] addresses in
            self?.addresses = addresses
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
}

extension AddressesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        addresses.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let address = addresses[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressCell", for: indexPath)
        cell.textLabel?.text = "\(address.city), \(address.street), \(address.houseNumber)"
        cell.accessoryType = address.isDefault ? .checkmark : .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let userId = userId else { return }
        let selectedAddress = addresses[indexPath.row]
        guard selectedAddress.isDefault == false else {
            dismiss(animated: true) { [weak self] in
                self?.onAddressSelected?(selectedAddress)
            }
            return
        }

        for i in 0..<addresses.count {
            addresses[i].isDefault = (i == indexPath.row)
        }

        let group = DispatchGroup()
        for address in addresses {
            group.enter()
            AddressManager.shared.updateAddress(address, for: userId) { _ in
                group.leave()
            }
        }

        group.notify(queue: .main) { [weak self] in
            self?.tableView.reloadData()
            self?.dismiss(animated: true) { [weak self] in
                self?.onAddressSelected?(selectedAddress) 
            }
            
            NotificationCenter.default.post(name: .addressUpdated, object: nil)
        }
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        guard let userId = userId else { return }
        let address = addresses[indexPath.row]
        AddressManager.shared.deleteAddress(address.id, for: userId) { [weak self] success in
            if success {
                self?.addresses.remove(at: indexPath.row)
                DispatchQueue.main.async {
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = UIContextualAction(style: .normal, title: "Change") { [weak self] (_, _, completion) in
            guard let self = self else { return }
            let editVC = AddAddressViewController()
            editVC.userId = self.userId
            editVC.existingAddress = self.addresses[indexPath.row]
            editVC.onAddressAdded = {
                self.fetchAddresses()
            }
            let nav = UINavigationController(rootViewController: editVC)
            self.present(nav, animated: true)
            completion(true)
        }
        edit.backgroundColor = .systemBlue
        
        let delete = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completion) in
            self?.tableView(tableView, commit: .delete, forRowAt: indexPath)
            completion(true)
        }
        
        return UISwipeActionsConfiguration(actions: [delete, edit])
    }
}

