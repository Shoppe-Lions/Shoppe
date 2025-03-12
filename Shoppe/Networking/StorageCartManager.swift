//
//  StorageCartManager.swift
//  Shoppe
//
//  Created by Игорь Клевжиц on 09.03.2025.
//
import Foundation

final class StorageCartManager {
    static let shared = StorageCartManager()
    private let defaults = UserDefaults.standard
    private let cartKey = "cart"

    private init() {}

    // MARK: - Save/Load

    func saveCart(_ cart: [CartItem]) {
        if let encoded = try? JSONEncoder().encode(cart) {
            defaults.set(encoded, forKey: cartKey)
        }
    }

    func loadCart() -> [CartItem] {
        guard let data = defaults.data(forKey: cartKey),
              let cart = try? JSONDecoder().decode([CartItem].self, from: data) else {
            return []
        }
        return cart
    }

    // MARK: - Modify

    func addProduct(_ product: Product) {
        var cart = loadCart()
        if let index = cart.firstIndex(where: { $0.id == product.id }) {
            cart[index].quantity += 1
        } else {
            cart.append(CartItem(product: product, quantity: 1))
        }
        saveCart(cart)
    }

    func removeProduct(_ product: Product) {
        var cart = loadCart()
        if let index = cart.firstIndex(where: { $0.id == product.id }) {
            if cart[index].quantity > 1 {
                cart[index].quantity -= 1
            } else {
                cart.remove(at: index)
            }
            saveCart(cart)
        }
    }

    func removeAllOfProduct(by id: Int) {
        var cart = loadCart()
        cart.removeAll { $0.id == id }
        saveCart(cart)
    }

    func clearCart() {
        defaults.removeObject(forKey: cartKey)
    }
}


