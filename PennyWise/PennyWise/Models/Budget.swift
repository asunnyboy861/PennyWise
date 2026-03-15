//
//  Budget.swift
//  PennyWise
//
//  SwiftData Model - Budget
//

import Foundation
import SwiftData

@Model
final class Budget {
    var id: UUID = UUID()
    var limitAmount: Double = 0.0
    var startDate: Date = Date().startOfMonth
    var endDate: Date = Date().endOfMonth
    var alertThreshold: Double = 0.8
    
    @Relationship(inverse: \Category.budgets)
    var category: Category?
    
    init(
        id: UUID = UUID(),
        limitAmount: Double = 0.0,
        startDate: Date = Date().startOfMonth,
        endDate: Date = Date().endOfMonth,
        alertThreshold: Double = 0.8,
        category: Category? = nil
    ) {
        self.id = id
        self.limitAmount = limitAmount
        self.startDate = startDate
        self.endDate = endDate
        self.alertThreshold = alertThreshold
        self.category = category
    }
    
    var spentAmount: Double = 0
    
    var remainingAmount: Double {
        return limitAmount - spentAmount
    }
    
    var progressPercentage: Double {
        guard limitAmount > 0 else { return 0 }
        return min(spentAmount / limitAmount, 1.0)
    }
    
    var isOverBudget: Bool {
        return spentAmount > limitAmount
    }
    
    var isWarning: Bool {
        return progressPercentage >= alertThreshold && !isOverBudget
    }
}

extension Date {
    var startOfMonth: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: self)
        return calendar.date(from: components) ?? self
    }
    
    var endOfMonth: Date {
        let calendar = Calendar.current
        guard let startOfNextMonth = calendar.date(byAdding: .month, value: 1, to: self.startOfMonth) else {
            return self
        }
        return calendar.date(byAdding: .second, value: -1, to: startOfNextMonth) ?? self
    }
    
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
    
    var startOfWeek: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        return calendar.date(from: components) ?? self
    }
}
