//
//  AddressManager.swift
//  Shoppe
//
//  Created by Игорь Клевжиц on 15.03.2025.
//

import FirebaseFirestore

class AddressManager {
    static let shared = AddressManager()
    private let db = Firestore.firestore()
    
    func fetchAddresses(for userId: String, completion: @escaping ([AddressModel]) -> Void) {
        db.collection("users").document(userId).collection("addresses").getDocuments { snapshot, error in
            guard let docs = snapshot?.documents else {
                completion([])
                return
            }
            let addresses = docs.compactMap { try? $0.data(as: AddressModel.self) }
            completion(addresses)
        }
    }
    
    func fetchDefaultAddress(for userId: String, completion: @escaping (AddressModel?, String?) -> Void) {
        db.collection("users").document(userId).collection("addresses")
            .whereField("isDefault", isEqualTo: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(nil, "Ошибка при загрузке адресов: \(error.localizedDescription)")
                    return
                }
                
                guard let docs = snapshot?.documents, !docs.isEmpty else {
                    completion(nil, "Нет дефолтного адреса.")
                    return
                }
                
                // Если адрес найден
                if let address = try? docs.first?.data(as: AddressModel.self) {
                    completion(address, nil)
                } else {
                    completion(nil, "Ошибка при извлечении адреса.")
                }
            }
    }
    
    func addAddress(_ address: AddressModel, for userId: String, completion: @escaping (Bool) -> Void) {
        do {
            try db.collection("users").document(userId).collection("addresses").document(address.id).setData(from: address)
            completion(true)
        } catch {
            completion(false)
        }
    }

    func updateAddress(_ address: AddressModel, for userId: String, completion: @escaping (Bool) -> Void) {
        addAddress(address, for: userId, completion: completion)
    }
    
    func deleteAddress(_ addressId: String, for userId: String, completion: @escaping (Bool) -> Void) {
        db.collection("users").document(userId).collection("addresses").document(addressId).delete { error in
            completion(error == nil)
        }
    }
}

