//
//  ProfileEntity.swift
//  Shoppe
//
//  Created by Игорь Клевжиц on 15.03.2025.
//

struct AddressModel: Codable {
    var id: String
    var street: String
    var city: String
    var zipCode: String
    var houseNumber: String
    var comment: String?
    var isDefault: Bool
}
