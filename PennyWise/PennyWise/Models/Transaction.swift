//
//  Transaction.swift
//  PennyWise
//
//  SwiftData Model - Transaction
//

import Foundation
import SwiftData

@Model
final class Transaction {
    var id: UUID = UUID()
    var amount: Double = 0.0
    var note: String = ""
    var date: Date = Date()
    var isRecurring: Bool = false
    var recurringInterval: String?
    
    var category: Category?
    
    init(
        id: UUID = UUID(),
        amount: Double = 0.0,
        note: String = "",
        date: Date = Date(),
        isRecurring: Bool = false,
        recurringInterval: String? = nil,
        category: Category? = nil
    ) {
        self.id = id
        self.amount = amount
        self.note = note
        self.date = date
        self.isRecurring = isRecurring
        self.recurringInterval = recurringInterval
        self.category = category
    }
    
    var isExpense: Bool {
        return amount < 0
    }
    
    var formattedAmount: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        let value = abs(amount)
        return formatter.string(from: NSNumber(value: value)) ?? "$0.00"
    }
    
    var signedFormattedAmount: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: NSNumber(value: amount)) ?? "$0.00"
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    var shortFormattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }
}
