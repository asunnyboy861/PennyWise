//
//  TransactionViewModel.swift
//  PennyWise
//
//  ViewModel for Transaction management
//

import Foundation
import SwiftData
import Observation

@Observable
@MainActor
final class TransactionViewModel {
    var transactions: [Transaction] = []
    var categories: [Category] = []
    var isLoading = false
    var errorMessage: String?
    
    private var modelContext: ModelContext?
    
    init(modelContext: ModelContext? = nil) {
        self.modelContext = modelContext
    }
    
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
    }
    
    func loadTransactions() {
        guard let context = modelContext else { return }
        
        isLoading = true
        
        let descriptor = FetchDescriptor<Transaction>(
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        
        do {
            transactions = try context.fetch(descriptor)
        } catch {
            errorMessage = "Failed to load transactions: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func loadTransactions(from startDate: Date, to endDate: Date) {
        guard let context = modelContext else { return }
        
        isLoading = true
        
        let descriptor = FetchDescriptor<Transaction>(
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        
        do {
            var result = try context.fetch(descriptor)
            result = result.filter { $0.date >= startDate && $0.date <= endDate }
            transactions = result
        } catch {
            errorMessage = "Failed to load transactions: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func loadCategories() {
        guard let context = modelContext else { return }
        
        let descriptor = FetchDescriptor<Category>(
            sortBy: [SortDescriptor(\.name)]
        )
        
        do {
            categories = try context.fetch(descriptor)
        } catch {
            errorMessage = "Failed to load categories: \(error.localizedDescription)"
        }
    }
    
    func addTransaction(
        amount: Double,
        category: Category,
        note: String = "",
        date: Date = Date()
    ) {
        guard let context = modelContext else { return }
        
        let transaction = Transaction(
            amount: amount,
            note: note,
            date: date,
            category: category
        )
        
        context.insert(transaction)
        
        do {
            try context.save()
            loadTransactions()
        } catch {
            errorMessage = "Failed to save transaction: \(error.localizedDescription)"
        }
    }
    
    func updateTransaction(_ transaction: Transaction, amount: Double, category: Category, note: String, date: Date) {
        guard let context = modelContext else { return }
        
        transaction.amount = amount
        transaction.category = category
        transaction.note = note
        transaction.date = date
        
        do {
            try context.save()
            loadTransactions()
        } catch {
            errorMessage = "Failed to update transaction: \(error.localizedDescription)"
        }
    }
    
    func deleteTransaction(_ transaction: Transaction) {
        guard let context = modelContext else { return }
        
        context.delete(transaction)
        
        do {
            try context.save()
            loadTransactions()
        } catch {
            errorMessage = "Failed to delete transaction: \(error.localizedDescription)"
        }
    }
    
    func getExpenseCategories() -> [Category] {
        return categories.filter { !$0.isIncome }
    }
    
    func getIncomeCategories() -> [Category] {
        return categories.filter { $0.isIncome }
    }
    
    func calculateTotalIncome(from startDate: Date? = nil, to endDate: Date? = nil) -> Double {
        var filteredTransactions = transactions
        
        if let start = startDate, let end = endDate {
            filteredTransactions = transactions.filter { $0.date >= start && $0.date <= end }
        }
        
        return filteredTransactions
            .filter { $0.amount > 0 }
            .reduce(0) { $0 + $1.amount }
    }
    
    func calculateTotalExpense(from startDate: Date? = nil, to endDate: Date? = nil) -> Double {
        var filteredTransactions = transactions
        
        if let start = startDate, let end = endDate {
            filteredTransactions = transactions.filter { $0.date >= start && $0.date <= end }
        }
        
        return filteredTransactions
            .filter { $0.amount < 0 }
            .reduce(0) { $0 + abs($1.amount) }
    }
    
    func getRecentTransactions(limit: Int = 10) -> [Transaction] {
        return Array(transactions.prefix(limit))
    }
    
    func getTransactionsForToday() -> [Transaction] {
        let today = Date().startOfDay
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today) ?? today
        
        return transactions.filter { $0.date >= today && $0.date < tomorrow }
    }
    
    func getTransactionsForThisWeek() -> [Transaction] {
        let today = Date()
        let startOfWeek = today.startOfWeek
        
        return transactions.filter { $0.date >= startOfWeek }
    }
    
    func getTransactionsForThisMonth() -> [Transaction] {
        let today = Date()
        let startOfMonth = today.startOfMonth
        
        return transactions.filter { $0.date >= startOfMonth }
    }
}
