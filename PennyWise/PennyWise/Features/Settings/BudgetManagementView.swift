//
//  BudgetManagementView.swift
//  PennyWise
//
//  Budget Management Screen
//

import SwiftUI
import SwiftData

struct BudgetManagementView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Budget.startDate, order: .reverse) private var budgets: [Budget]
    @Query(sort: \Category.name) private var categories: [Category]
    @State private var showingAddBudget = false
    
    var expenseCategories: [Category] {
        categories.filter { !$0.isIncome }
    }
    
    var body: some View {
        List {
            if budgets.isEmpty {
                Section {
                    VStack(spacing: 12) {
                        Image(systemName: "chart.pie")
                            .font(.system(size: 40))
                            .foregroundStyle(.secondary)
                        
                        Text("No budgets set")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        
                        Text("Create a budget to track your spending")
                            .font(.subheadline)
                            .foregroundStyle(.tertiary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 30)
                }
            } else {
                ForEach(budgets) { budget in
                    BudgetRowView(budget: budget)
                }
                .onDelete { indexSet in
                    deleteBudgets(at: indexSet)
                }
            }
        }
        .navigationTitle("Budgets")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingAddBudget = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddBudget) {
            AddBudgetView(expenseCategories: expenseCategories)
        }
    }
    
    private func deleteBudgets(at indexSet: IndexSet) {
        for index in indexSet {
            let budget = budgets[index]
            modelContext.delete(budget)
        }
        try? modelContext.save()
    }
}

struct BudgetRowView: View {
    let budget: Budget
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(budget.category?.name ?? "Uncategorized")
                    .font(.headline)
                
                Spacer()
                
                Text("\(Int(budget.progressPercentage * 100))%")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(budgetColor)
            }
            
            ProgressView(value: budget.progressPercentage)
                .progressViewStyle(.linear)
                .tint(budgetColor)
            
            HStack {
                Text("Spent: \(formatCurrency(budget.spentAmount))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Text("Budget: \(formatCurrency(budget.limitAmount))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 8)
    }
    
    private var budgetColor: Color {
        if budget.isOverBudget {
            return AppColors.danger
        } else if budget.isWarning {
            return AppColors.warning
        } else {
            return AppColors.success
        }
    }
    
    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: NSNumber(value: value)) ?? "$0.00"
    }
}

struct AddBudgetView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    let expenseCategories: [Category]
    
    @State private var selectedCategory: Category?
    @State private var budgetAmount: String = ""
    @State private var alertThreshold: Double = 0.8
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Category", selection: $selectedCategory) {
                        Text("Select a category").tag(nil as Category?)
                        ForEach(expenseCategories) { category in
                            HStack {
                                Image(systemName: category.icon)
                                Text(category.name)
                            }
                            .tag(category as Category?)
                        }
                    }
                } header: {
                    Text("Category")
                }
                
                Section {
                    HStack {
                        Text("$")
                            .foregroundStyle(.secondary)
                        TextField("0.00", text: $budgetAmount)
                            .keyboardType(.decimalPad)
                    }
                } header: {
                    Text("Budget Amount")
                }
                
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Alert when spending reaches \(Int(alertThreshold * 100))%")
                            .font(.subheadline)
                        
                        Slider(value: $alertThreshold, in: 0.5...1.0, step: 0.1)
                    }
                } header: {
                    Text("Alert Threshold")
                }
            }
            .navigationTitle("Add Budget")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveBudget()
                    }
                    .disabled(!isValid)
                }
            }
            .onAppear {
                selectedCategory = expenseCategories.first
            }
        }
    }
    
    private var isValid: Bool {
        guard let _ = Double(budgetAmount),
              let _ = selectedCategory else {
            return false
        }
        return true
    }
    
    private func saveBudget() {
        guard let amount = Double(budgetAmount),
              let category = selectedCategory else {
            return
        }
        
        let budget = Budget(
            limitAmount: amount,
            startDate: Date().startOfMonth,
            endDate: Date().endOfMonth,
            alertThreshold: alertThreshold,
            category: category
        )
        
        modelContext.insert(budget)
        try? modelContext.save()
        dismiss()
    }
}

#Preview {
    NavigationStack {
        BudgetManagementView()
    }
    .modelContainer(for: [Transaction.self, Category.self, Budget.self], inMemory: true)
}
