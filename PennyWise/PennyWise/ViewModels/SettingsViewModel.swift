//
//  SettingsViewModel.swift
//  PennyWise
//
//  ViewModel for Settings screen
//

import Foundation
import SwiftData
import Observation

@Observable
@MainActor
final class SettingsViewModel {
    var categories: [Category] = []
    var budgets: [Budget] = []
    var isLoading = false
    var errorMessage: String?
    
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
        
        loadCategories(context: context)
        loadBudgets(context: context)
        
        isLoading = false
    }
    
    private func loadCategories(context: ModelContext) {
        let descriptor = FetchDescriptor<Category>(
            sortBy: [SortDescriptor(\.name)]
        )
        
        do {
            categories = try context.fetch(descriptor)
        } catch {
            errorMessage = "Failed to load categories: \(error.localizedDescription)"
        }
    }
    
    private func loadBudgets(context: ModelContext) {
        let descriptor = FetchDescriptor<Budget>(
            sortBy: [SortDescriptor(\.startDate, order: .reverse)]
        )
        
        do {
            budgets = try context.fetch(descriptor)
        } catch {
            errorMessage = "Failed to load budgets: \(error.localizedDescription)"
        }
    }
    
    func addCategory(name: String, icon: String, colorHex: String, isIncome: Bool) {
        guard let context = modelContext else { return }
        
        let category = Category(
            name: name,
            icon: icon,
            colorHex: colorHex,
            isIncome: isIncome,
            isDefault: false
        )
        
        context.insert(category)
        
        do {
            try context.save()
            loadCategories(context: context)
        } catch {
            errorMessage = "Failed to add category: \(error.localizedDescription)"
        }
    }
    
    func updateCategory(_ category: Category, name: String, icon: String, colorHex: String) {
        category.name = name
        category.icon = icon
        category.colorHex = colorHex
        
        do {
            try modelContext?.save()
            loadCategories(context: modelContext!)
        } catch {
            errorMessage = "Failed to update category: \(error.localizedDescription)"
        }
    }
    
    func deleteCategory(_ category: Category) {
        guard let context = modelContext else { return }
        
        context.delete(category)
        
        do {
            try context.save()
            loadCategories(context: context)
        } catch {
            errorMessage = "Failed to delete category: \(error.localizedDescription)"
        }
    }
    
    func addBudget(limitAmount: Double, category: Category) {
        guard let context = modelContext else { return }
        
        let budget = Budget(
            limitAmount: limitAmount,
            startDate: Date().startOfMonth,
            endDate: Date().endOfMonth,
            category: category
        )
        
        context.insert(budget)
        
        do {
            try context.save()
            loadBudgets(context: context)
        } catch {
            errorMessage = "Failed to add budget: \(error.localizedDescription)"
        }
    }
    
    func deleteBudget(_ budget: Budget) {
        guard let context = modelContext else { return }
        
        context.delete(budget)
        
        do {
            try context.save()
            loadBudgets(context: context)
        } catch {
            errorMessage = "Failed to delete budget: \(error.localizedDescription)"
        }
    }
    
    func getExpenseCategories() -> [Category] {
        return categories.filter { !$0.isIncome }
    }
}
