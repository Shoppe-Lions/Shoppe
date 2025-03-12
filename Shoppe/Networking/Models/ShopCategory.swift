//
//  ShopCategory.swift
//  Shoppe
//
//  Created by Victor Garitskyu on 08.03.2025.
//

import Foundation

struct ShopCategory: Hashable {
    let id: UUID
    let title: String
    let image: String
    let itemCount: Int
    let subcategoryImages: [String]
    
    init(title: String, image: String, itemCount: Int, subcategoryImages: [String] = []) {
        self.id = UUID()
        self.title = title
        self.image = image
        self.itemCount = itemCount
        self.subcategoryImages = subcategoryImages
    }
}


struct HashableProduct: Hashable {
    let product: Product
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(product.id)
    }
    
    static func == (lhs: HashableProduct, rhs: HashableProduct) -> Bool {
        return lhs.product.id == rhs.product.id
    }
}

struct HashableRating: Hashable {
    let rating: Rating
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(rating.rate)
        hasher.combine(rating.count)
    }
    
    static func == (lhs: HashableRating, rhs: HashableRating) -> Bool {
        return lhs.rating.rate == rhs.rating.rate && lhs.rating.count == rhs.rating.count
    }
}

enum HomeSection: Int, CaseIterable {
    case categories
    case popular
    case justForYou
}

enum HomeItem: Hashable {
    case category(ShopCategory)
    case product(HashableProduct)
} 
