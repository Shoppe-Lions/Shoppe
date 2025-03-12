//
//  AllCategoriesConstants.swift
//  Shoppe
//
//  Created by Игорь Клевжиц on 11.03.2025.
//
import UIKit

// MARK: - Constraint Constants
enum ACLayout {
    static let cornerRadius: CGFloat = 10
    static let borderSubcategory: CGFloat = 2
    
    enum SubcategoryCell {
        static let interItemSpacing: CGFloat = 8
        static let lineSpacing: CGFloat = 12
        static let itemHeight: CGFloat = 40
        static let itemsPerRow: CGFloat = 2
        static let verticalInset: CGFloat = 16
        static let horizontalInset: CGFloat = 8
    }
    
    enum CategoryTableViewCell {
        static let containerInset: CGFloat = 8
        static let itemHeight: CGFloat = 44
        static let spacing: CGFloat = 10
    }
    
    enum AllCategoriesViewController {
        static let sideInset: CGFloat = 24
        static let elementInset: CGFloat = 16
    }
}


// MARK: - Font Constants
enum ACFontSize {
    static let subcategory: CGFloat = 15
    static let category: CGFloat = 17
    static let title: CGFloat = 28
}
