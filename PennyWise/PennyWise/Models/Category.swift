//
//  Category.swift
//  PennyWise
//
//  SwiftData Model - Category
//

import Foundation
import SwiftData

@Model
final class Category {
    var id: UUID = UUID()
    var name: String = ""
    var icon: String = "questionmark.circle"
    var colorHex: String = "#95A5A6"
    var isIncome: Bool = false
    var isDefault: Bool = false
    
    @Relationship(deleteRule: .cascade, inverse: \Transaction.category)
    var transactions: [Transaction]?
    
    var budgets: [Budget]?
    
    init(
        id: UUID = UUID(),
        name: String = "",
        icon: String = "questionmark.circle",
        colorHex: String = "#95A5A6",
        isIncome: Bool = false,
        isDefault: Bool = false
    ) {
        self.id = id
        self.name = name
        self.icon = icon
        self.colorHex = colorHex
        self.isIncome = isIncome
        self.isDefault = isDefault
    }
    
    static let defaultCategories: [(name: String, icon: String, color: String, isIncome: Bool)] = [
        ("Food & Dining", "fork.knife", "#FF6B6B", false),
        ("Transportation", "car.fill", "#4ECDC4", false),
        ("Shopping", "bag.fill", "#45B7D1", false),
        ("Entertainment", "tv.fill", "#96CEB4", false),
        ("Bills & Utilities", "bolt.fill", "#FFEAA7", false),
        ("Health", "heart.fill", "#DDA0DD", false),
        ("Education", "book.fill", "#98D8C8", false),
        ("Salary", "dollarsign.circle.fill", "#2ECC71", true),
        ("Investment", "chart.line.uptrend.xyaxis", "#3498DB", true),
        ("Other", "ellipsis.circle.fill", "#95A5A6", false)
    ]
    
    static func createDefaultCategories(context: ModelContext) {
        for categoryData in defaultCategories {
            let category = Category(
                name: categoryData.name,
                icon: categoryData.icon,
                colorHex: categoryData.color,
                isIncome: categoryData.isIncome,
                isDefault: true
            )
            context.insert(category)
        }
        try? context.save()
    }
}
