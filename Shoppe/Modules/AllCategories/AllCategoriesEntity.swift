//
//  AllCategoriesEntity.swift
//  Shoppe
//
//  Created by Игорь Клевжиц on 10.03.2025.
//

struct Category {
    let title: String
    let imagePath: String
    let subcategories: [String]
    var isExpanded: Bool = false
}
