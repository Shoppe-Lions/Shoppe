//
//  StorageCartManager.swift
//  Shoppe
//
//  Created by Игорь Клевжиц on 09.03.2025.
//
import Foundation
import FirebaseFirestore
import FirebaseAuth

final class StorageCartManager {
    static let shared = StorageCartManager()
    private let db = Firestore.firestore()

    private init() {}

    func saveCart(_ cart: [CartItem]) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let cartData = cart.map { ["id": $0.id, "quantity": $0.quantity] }

        db.collection("users").document(uid).setData(["cart": cartData], merge: true)
    }

    func loadCart(completion: @escaping ([CartItem]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion([])
            return
        }

        db.collection("users").document(uid).getDocument { snapshot, error in
            guard let data = snapshot?.data(),
                  let cartArray = data["cart"] as? [[String: Any]] else {
                completion([])
                return
            }

            let cartItems: [CartItem] = cartArray.compactMap { dict in
                if let id = dict["id"] as? Int,
                   let quantity = dict["quantity"] as? Int {
                    return CartItem(product: Product.placeholder(id: id), quantity: quantity)
                }
                return nil
            }

            completion(cartItems)
        }
    }

    func fetchProductsForCartItems(_ items: [CartItem], completion: @escaping ([CartItem]) -> Void) {
        let ids = items.map { $0.id }
        var updatedCart: [CartItem] = []
        let group = DispatchGroup()

        for item in items {
            group.enter()
            APIService.shared.fetchProduct(by: item.id) { result in
                switch result {
                case .success(let product):
                    updatedCart.append(CartItem(product: product, quantity: item.quantity))
                case .failure:
                    break
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            completion(updatedCart)
        }
    }

    func addProduct(_ product: Product, completion: (() -> Void)? = nil) {
        loadCart { cart in
            var newCart = cart
            if let index = newCart.firstIndex(where: { $0.id == product.id }) {
                newCart[index].quantity += 1
            } else {
                newCart.append(CartItem(product: product, quantity: 1))
            }
            self.saveCart(newCart)
            completion?()
        }
    }

    // Новый метод для обновления товара
    func updateProduct(_ item: CartItem, completion: (() -> Void)? = nil) {
        loadCart { cart in
            var updatedCart = cart
            if let index = updatedCart.firstIndex(where: { $0.id == item.id }) {
                updatedCart[index].quantity = item.quantity
            }
            self.saveCart(updatedCart)
            completion?()
        }
    }

    func removeProduct(_ product: Product, completion: (() -> Void)? = nil) {
        loadCart { cart in
            let updatedCart = cart.filter { $0.id != product.id }
            self.saveCart(updatedCart)
            completion?()
        }
    }

    func removeAllOfProduct(by id: Int, completion: (() -> Void)? = nil) {
        loadCart { cart in
            let updatedCart = cart.filter { $0.id != id }
            self.saveCart(updatedCart)
            completion?()
        }
    }

    func clearCart(completion: (() -> Void)? = nil) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion?()
            return
        }
        db.collection("users").document(uid).updateData(["cart": FieldValue.delete()]) { _ in
            completion?()
        }
    }
}

