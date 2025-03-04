//
//  Product.swift
//  Shoppe
//
//  Created by Игорь Клевжиц on 04.03.2025.
//

struct Product: Decodable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: String
    let image: String
    let rating: Rating
}
