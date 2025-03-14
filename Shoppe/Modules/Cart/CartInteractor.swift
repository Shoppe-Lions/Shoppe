//
//  CartInteractor.swift
//  Shoppe
//
//  Created by Artem Kriukov on 04.03.2025.
//

protocol CartInteractorProtocol: AnyObject {
    func fetchCartProducts()
    func increaseProductQuantity(at index: Int)
    func decreaseProductQuantity(at index: Int)
    func getQuantity(for productId: Int) -> Int
    func loadTotalItems()
    func loadTotalAmount()
    func deleteProduct(at index: Int)
}

final class CartInteractor: CartInteractorProtocol {
    weak var presenter: CartPresenterProtocol?

    func fetchCartProducts() {
        StorageCartManager.shared.loadCart { cartItems in
            StorageCartManager.shared.fetchProductsForCartItems(cartItems) { updatedCartItems in
                let products = updatedCartItems.map { $0.product }
                self.presenter?.didFetchCartProducts(products)
            }
        }
    }

    func increaseProductQuantity(at index: Int) {
        updateQuantity(at: index, increase: true)
    }

    func decreaseProductQuantity(at index: Int) {
        updateQuantity(at: index, increase: false)
    }

    private func updateQuantity(at index: Int, increase: Bool) {
        StorageCartManager.shared.loadCart { cartItems in
            guard index >= 0, index < cartItems.count else { return }

            var item = cartItems[index]
            item.quantity = increase ? item.quantity + 1 : max(1, item.quantity - 1)

            StorageCartManager.shared.updateProduct(item) {
                APIService.shared.fetchProduct(by: item.id) { result in
                    switch result {
                    case .success(let product):
                        self.presenter?.didUpdateProduct(at: index, product: product, quantity: item.quantity)
                    case .failure:
                        break
                    }
                }
            }
        }
    }

    func getQuantity(for productId: Int) -> Int {
        // Заглушка — чтобы не менять протокол
        return 0
    }

    func loadTotalItems() {
        StorageCartManager.shared.loadCart { cartItems in
            let total = cartItems.reduce(0) { $0 + $1.quantity }
            self.presenter?.updateCartCount(total)
        }
    }

    func loadTotalAmount() {
        StorageCartManager.shared.loadCart { cartItems in
            StorageCartManager.shared.fetchProductsForCartItems(cartItems) { updatedCartItems in
                let total: Double = updatedCartItems.reduce(0.0) {
                    $0 + ($1.product.price * Double($1.quantity))
                }
                let formatted = String(format: "%.2f", total)
                self.presenter?.updateTotalPrice(formatted)
            }
        }
    }

    func deleteProduct(at index: Int) {
        StorageCartManager.shared.loadCart { cartItems in
            guard index >= 0, index < cartItems.count else { return }

            let product = cartItems[index].product
            StorageCartManager.shared.removeProduct(product) {
                self.fetchCartProducts()
                self.loadTotalItems()
                self.loadTotalAmount()
            }
        }
    }
}
