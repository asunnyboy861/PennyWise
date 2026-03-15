//
//  CoreDataManager.swift
//  PennyWise
//
//  SwiftData Manager - Central data management
//

import Foundation
import SwiftData

@MainActor
final class CoreDataManager {
    static let shared = CoreDataManager()
    
    let modelContainer: ModelContainer
    let modelContext: ModelContext
    
    private init() {
        let schema = Schema([
            Transaction.self,
            Category.self,
            Budget.self,
            BillReminder.self,
            UserStreak.self
        ])
        
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false,
            allowsSave: true,
            cloudKitDatabase: .private("iCloud.com.zzoutuo.pennywise")
        )
        
        do {
            modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
            modelContext = modelContainer.mainContext
            initializeDefaultCategories()
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
    
    private func initializeDefaultCategories() {
        let descriptor = FetchDescriptor<Category>()
        let existingCategories = (try? modelContext.fetch(descriptor)) ?? []
        
        if existingCategories.isEmpty {
            Category.createDefaultCategories(context: modelContext)
        }
    }
    
    func save() {
        do {
            try modelContext.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
    
    func fetchTransactions(
        startDate: Date? = nil,
        endDate: Date? = nil,
        category: Category? = nil,
        isIncome: Bool? = nil
    ) -> [Transaction] {
        let descriptor = FetchDescriptor<Transaction>(
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        
        var transactions = (try? modelContext.fetch(descriptor)) ?? []
        
        if let start = startDate {
            transactions = transactions.filter { $0.date >= start }
        }
        
        if let end = endDate {
            transactions = transactions.filter { $0.date <= end }
        }
        
        if let category = category {
            transactions = transactions.filter { $0.category?.id == category.id }
        }
        
        if let isIncome = isIncome {
            if isIncome {
                transactions = transactions.filter { $0.amount > 0 }
            } else {
                transactions = transactions.filter { $0.amount < 0 }
            }
        }
        
        return transactions
    }
    
    func fetchCategories(isIncome: Bool? = nil) -> [Category] {
        let descriptor = FetchDescriptor<Category>(
            sortBy: [SortDescriptor(\.name)]
        )
        
        var categories = (try? modelContext.fetch(descriptor)) ?? []
        
        if let isIncome = isIncome {
            categories = categories.filter { $0.isIncome == isIncome }
        }
        
        return categories
    }
    
    func fetchBudgets() -> [Budget] {
        let descriptor = FetchDescriptor<Budget>(
            sortBy: [SortDescriptor(\.startDate, order: .reverse)]
        )
        return (try? modelContext.fetch(descriptor)) ?? []
    }
    
    func addTransaction(_ transaction: Transaction) {
        modelContext.insert(transaction)
        save()
    }
    
    func deleteTransaction(_ transaction: Transaction) {
        modelContext.delete(transaction)
        save()
    }
    
    func addCategory(_ category: Category) {
        modelContext.insert(category)
        save()
    }
    
    func deleteCategory(_ category: Category) {
        modelContext.delete(category)
        save()
    }
    
    func addBudget(_ budget: Budget) {
        modelContext.insert(budget)
        save()
    }
    
    func deleteBudget(_ budget: Budget) {
        modelContext.delete(budget)
        save()
    }
    
    // MARK: - Bill Reminders
    
    func fetchBillReminders() -> [BillReminder] {
        let descriptor = FetchDescriptor<BillReminder>(
            sortBy: [SortDescriptor(\.dueDay)]
        )
        return (try? modelContext.fetch(descriptor)) ?? []
    }
    
    func addBillReminder(_ bill: BillReminder) {
        modelContext.insert(bill)
        save()
    }
    
    func deleteBillReminder(_ bill: BillReminder) {
        modelContext.delete(bill)
        save()
    }
}
