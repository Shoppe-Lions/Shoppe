//
//  Product.swift
//  Shoppe
//
//  Created by Игорь Клевжиц on 04.03.2025.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

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
    let imageURL: String
    let rating: Rating
    var subcategory: String
    var like: Bool
    var localImagePath: String
    
    enum CodingKeys: String, CodingKey {
        case id, title, price, description, category, imageURL = "image", rating, subcategory, like, localImagePath
    }
    
    init(id: Int, title: String, price: Double, description: String, category: String, imageURL: String, rating: Rating, subcategory: String = "Other", like: Bool = false, localImagePath: String = "Path") {
        self.id = id
        self.title = title
        self.price = price
        self.description = description
        self.category = category
        self.imageURL = imageURL
        self.rating = rating
        self.subcategory = subcategory
        self.like = like
        self.localImagePath = localImagePath
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.price = try container.decode(Double.self, forKey: .price)
        self.description = try container.decode(String.self, forKey: .description)
        self.category = try container.decode(String.self, forKey: .category)
        self.imageURL = try container.decode(String.self, forKey: .imageURL)
        self.rating = try container.decode(Rating.self, forKey: .rating)
        
        self.subcategory = "Other"
        self.like = false
        self.localImagePath = "Path"
        
        self.subcategory = getSubcategory(for: id)
        self.localImagePath = getCachedImagePath(for: imageURL)
        self.like = LikeManager.shared.likedProductIDs.contains(id)
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
    
    private func getCachedImagePath(for url: String) -> String {
        let imageName = URL(string: url)?.lastPathComponent ?? ""
        let fileURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent(imageName)
        return FileManager.default.fileExists(atPath: fileURL.path) ? fileURL.path : "Path"
    }
    
    mutating func toggleLike(completion: (() -> Void)? = nil) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(uid)
        
        if like {
            like = false
            LikeManager.shared.likedProductIDs.remove(self.id)
            userRef.updateData([
                "likedProducts": FieldValue.arrayRemove([self.id])
            ]) { _ in completion?() }
        } else {
            like = true
            LikeManager.shared.likedProductIDs.insert(self.id)
            userRef.setData([
                "likedProducts": FieldValue.arrayUnion([self.id])
            ], merge: true) { _ in completion?() }
        }
    }
}

