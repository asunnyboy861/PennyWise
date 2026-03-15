//
//  DashboardViewModel.swift
//  PennyWise
//
//  ViewModel for Dashboard/Home screen
//

import Foundation
import SwiftUI
import SwiftData
import Observation

struct DailyExpense: Identifiable {
    let id = UUID()
    let date: Date
    let amount: Double
    let dayName: String
}

@Observable
@MainActor
final class DashboardViewModel {
    var todayTotal: Double = 0
    var todayIncome: Double = 0
    var todayExpense: Double = 0
    var recentTransactions: [Transaction] = []
    var weeklyData: [DailyExpense] = []
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
        
        loadTodaySummary(context: context)
        loadRecentTransactions(context: context)
        loadWeeklyData(context: context)
        
        isLoading = false
    }
    
    private func loadTodaySummary(context: ModelContext) {
        let today = Date().startOfDay
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today) ?? today
        
        var descriptor = FetchDescriptor<Transaction>()
        descriptor.predicate = #Predicate<Transaction> { transaction in
            transaction.date >= today && transaction.date < tomorrow
        }
        
        do {
            let todayTransactions = try context.fetch(descriptor)
            todayIncome = todayTransactions.filter { $0.amount > 0 }.reduce(0) { $0 + $1.amount }
            todayExpense = todayTransactions.filter { $0.amount < 0 }.reduce(0) { $0 + abs($1.amount) }
            todayTotal = todayIncome - todayExpense
        } catch {
            print("Failed to load today's summary: \(error)")
        }
    }
    
    private func loadRecentTransactions(context: ModelContext) {
        var descriptor = FetchDescriptor<Transaction>()
        descriptor.sortBy = [SortDescriptor(\.date, order: .reverse)]
        descriptor.fetchLimit = 5
        
        do {
            recentTransactions = try context.fetch(descriptor)
        } catch {
            print("Failed to load recent transactions: \(error)")
        }
    }
    
    private func loadWeeklyData(context: ModelContext) {
        let today = Date()
        let calendar = Calendar.current
        
        var weeklyDataTemp: [DailyExpense] = []
        
        for dayOffset in (0..<7).reversed() {
            guard let date = calendar.date(byAdding: .day, value: -dayOffset, to: today) else { continue }
            let startOfDay = calendar.startOfDay(for: date)
            guard let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) else { continue }
            
            var descriptor = FetchDescriptor<Transaction>()
            descriptor.predicate = #Predicate<Transaction> { transaction in
                transaction.date >= startOfDay && transaction.date < endOfDay
            }
            
            do {
                let dayTransactions = try context.fetch(descriptor)
                let totalExpense = dayTransactions
                    .filter { $0.amount < 0 }
                    .reduce(0) { $0 + abs($1.amount) }
                
                let dayFormatter = DateFormatter()
                dayFormatter.dateFormat = "EEE"
                
                let dailyExpense = DailyExpense(
                    date: date,
                    amount: totalExpense,
                    dayName: dayFormatter.string(from: date)
                )
                weeklyDataTemp.append(dailyExpense)
            } catch {
                print("Failed to load weekly data: \(error)")
            }
        }
        
        weeklyData = weeklyDataTemp
    }
    
    var formattedTodayTotal: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: NSNumber(value: todayTotal)) ?? "$0.00"
    }
    
    var formattedTodayIncome: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: NSNumber(value: todayIncome)) ?? "$0.00"
    }
    
    var formattedTodayExpense: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: NSNumber(value: todayExpense)) ?? "$0.00"
    }
    
    // MARK: - Dashboard V2 Properties
    
    var monthlyBudget: Double {
        UserDefaults.standard.double(forKey: "monthlyBudget") > 0 
            ? UserDefaults.standard.double(forKey: "monthlyBudget")
            : 1800.0
    }
    
    var monthlyExpense: Double {
        let startOfMonth = Date().startOfMonth
        let endOfMonth = Date().endOfMonth
        
        return recentTransactions
            .filter { $0.date >= startOfMonth && $0.date <= endOfMonth && $0.amount < 0 }
            .reduce(0) { $0 + abs($1.amount) }
    }
    
    var budgetRemaining: Double {
        monthlyBudget - monthlyExpense
    }
    
    var topCategories: [TopCategoriesCard.CategoryExpense] {
        let startOfMonth = Date().startOfMonth
        let expenseTransactions = recentTransactions.filter { 
            $0.date >= startOfMonth && $0.amount < 0 
        }
        
        var categoryTotals: [UUID: (name: String, icon: String, color: Color, amount: Double)] = [:]
        
        for transaction in expenseTransactions {
            guard let category = transaction.category else { continue }
            let current = categoryTotals[category.id]?.amount ?? 0
            categoryTotals[category.id] = (
                name: category.name,
                icon: category.icon,
                color: Color(hex: category.colorHex),
                amount: current + abs(transaction.amount)
            )
        }
        
        let total = categoryTotals.values.reduce(0) { $0 + $1.amount }
        
        var result: [TopCategoriesCard.CategoryExpense] = []
        for info in categoryTotals.values {
            let percentage = total > 0 ? (info.amount / total) * 100 : 0
            let expense = TopCategoriesCard.CategoryExpense(
                name: info.name,
                icon: info.icon,
                color: info.color,
                amount: info.amount,
                percentage: percentage
            )
            result.append(expense)
        }
        
        return result.sorted { $0.amount > $1.amount }
    }
}
