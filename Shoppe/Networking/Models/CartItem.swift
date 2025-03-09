//
//  CartItem.swift
//  Shoppe
//
//  Created by Игорь Клевжиц on 09.03.2025.
//

struct CartItem: Codable, Equatable {
    let product: Product
    var quantity: Int

    var id: Int {
        return product.id
    }

    static func == (lhs: CartItem, rhs: CartItem) -> Bool {
        return lhs.product.id == rhs.product.id
    }
}
