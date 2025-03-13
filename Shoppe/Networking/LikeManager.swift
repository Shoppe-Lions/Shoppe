//
//  LikeManager.swift
//  Shoppe
//
//  Created by Игорь Клевжиц on 13.03.2025.
//

import FirebaseAuth
import FirebaseFirestore

final class LikeManager {
    static let shared = LikeManager()
    private init() {}
    
    var likedProductIDs: Set<Int> = []
    
    func fetchLikesFromFirestore(completion: @escaping () -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            likedProductIDs = []
            completion()
            return
        }
        
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(uid)
        
        userRef.getDocument { snapshot, error in
            if let data = snapshot?.data(),
               let liked = data["likedProducts"] as? [Int] {
                self.likedProductIDs = Set(liked)
            } else {
                self.likedProductIDs = []
            }
            completion()
        }
    }
}
