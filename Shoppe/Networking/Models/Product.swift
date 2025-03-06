//
//  Product.swift
//  Shoppe
//
//  Created by Игорь Клевжиц on 04.03.2025.
//

import Foundation

struct Rating: Codable {
    let rate: Double
    let count: Int
}

struct Product: Codable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: String
    let image: String
    let rating: Rating
    var subcategory: String
    var like: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case price
        case description
        case category
        case image
        case rating
        case subcategory
        case like
    }
    
    init(id: Int, title: String, price: Double, description: String, category: String, image: String, rating: Rating, subcategory: String = "Other", like: Bool = false) {
        self.id = id
        self.title = title
        self.price = price
        self.description = description
        self.category = category
        self.image = image
        self.rating = rating
        self.subcategory = subcategory
        self.like = like
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.price = try container.decode(Double.self, forKey: .price)
        self.description = try container.decode(String.self, forKey: .description)
        self.category = try container.decode(String.self, forKey: .category)
        self.image = try container.decode(String.self, forKey: .image)
        self.rating = try container.decode(Rating.self, forKey: .rating)
        
        self.subcategory = "Other"
        self.like = false
        
        subcategory = getSubcategory(for: id)
        like = self.isLiked()
    }
    
    private func getSubcategory(for productID: Int) -> String {
        switch productID {
        case 1:
            return "Backpacks"
        case 2...4:
            return "Clothing"
        case 5, 8:
            return "Cheap"
        case 6...7:
            return "Expensive"
        case 9...12:
            return "Hard Drives"
        case 13...14:
            return "Monitors"
        case 15...17:
            return "Warm Clothing"
        case 18...20:
            return "Light Clothing"
        default:
            return "Other"
        }
    }
    
    private func isLiked() -> Bool {
        let likedProducts = UserDefaults.standard.object(forKey: "likedProducts") as? [Int] ?? []
        return likedProducts.contains(self.id)
    }
    
    mutating func toggleLike() {
        var likedProducts = UserDefaults.standard.object(forKey: "likedProducts") as? [Int] ?? []
        
        if let index = likedProducts.firstIndex(of: self.id) {
            likedProducts.remove(at: index)
            self.like = false
        } else {
            likedProducts.append(self.id)
            self.like = true
        }
        
        UserDefaults.standard.set(likedProducts, forKey: "likedProducts")
    }
}
