//
//  AnalyticsViewModel.swift
//  PennyWise
//
//  ViewModel for Analytics/Statistics screen
//

import Foundation
import SwiftData
import Observation

struct CategoryExpense: Identifiable {
    let id = UUID()
    let category: Category
    let amount: Double
    let percentage: Double
}

struct MonthlyExpense: Identifiable {
    let id = UUID()
    let month: String
    let amount: Double
    let income: Double
}

@Observable
@MainActor
final class AnalyticsViewModel {
    var categoryExpenses: [CategoryExpense] = []
    var monthlyExpenses: [MonthlyExpense] = []
    var totalIncome: Double = 0
    var totalExpense: Double = 0
    var balance: Double = 0
    var isLoading = false
    
    private var modelContext: ModelContext?
    
    init(modelContext: ModelContext? = nil) {
        self.modelContext = modelContext
    }
    
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
    }
    
    func loadData() {
        guard let context = modelContext else { return }
        
        isLoading = true
        
        loadCategoryExpenses(context: context)
        loadMonthlyExpenses(context: context)
        
        isLoading = false
    }
    
    private func loadCategoryExpenses(context: ModelContext) {
        let startOfMonth = Date().startOfMonth
        let endOfMonth = Date().endOfMonth
        
        var descriptor = FetchDescriptor<Transaction>()
        descriptor.predicate = #Predicate<Transaction> { transaction in
            transaction.date >= startOfMonth && 
            transaction.date <= endOfMonth && 
            transaction.amount < 0
        }
        
        do {
            let transactions = try context.fetch(descriptor)
            
            var categoryAmounts: [Category: Double] = [:]
            
            for transaction in transactions {
                if let category = transaction.category {
                    categoryAmounts[category, default: 0] += abs(transaction.amount)
                }
            }
            
            let totalExpense = categoryAmounts.values.reduce(0, +)
            
            categoryExpenses = categoryAmounts.map { category, amount in
                CategoryExpense(
                    category: category,
                    amount: amount,
                    percentage: totalExpense > 0 ? amount / totalExpense : 0
                )
            }.sorted { $0.amount > $1.amount }
            
            self.totalExpense = totalExpense
        } catch {
            print("Failed to load category expenses: \(error)")
        }
    }
    
    private func loadMonthlyExpenses(context: ModelContext) {
        let calendar = Calendar.current
        let today = Date()
        
        var monthlyData: [MonthlyExpense] = []
        
        for monthOffset in (0..<12).reversed() {
            guard let monthDate = calendar.date(byAdding: .month, value: -monthOffset, to: today) else { continue }
            
            let startOfMonth = monthDate.startOfMonth
            let endOfMonth = monthDate.endOfMonth
            
            var descriptor = FetchDescriptor<Transaction>()
            descriptor.predicate = #Predicate<Transaction> { transaction in
                transaction.date >= startOfMonth && transaction.date <= endOfMonth
            }
            
            do {
                let transactions = try context.fetch(descriptor)
                let monthIncome = transactions.filter { $0.amount > 0 }.reduce(0) { $0 + $1.amount }
                let monthExpense = transactions.filter { $0.amount < 0 }.reduce(0) { $0 + abs($1.amount) }
                
                let formatter = DateFormatter()
                formatter.dateFormat = "MMM"
                
                let monthlyExpense = MonthlyExpense(
                    month: formatter.string(from: monthDate),
                    amount: monthExpense,
                    income: monthIncome
                )
                monthlyData.append(monthlyExpense)
            } catch {
                print("Failed to load monthly expenses: \(error)")
            }
        }
        
        monthlyExpenses = monthlyData
        
        totalIncome = monthlyExpenses.reduce(0) { $0 + $1.income }
        balance = totalIncome - totalExpense
    }
}
