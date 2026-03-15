//
//  AddTransactionView.swift
//  PennyWise
//
//  Add Transaction Screen - 3 Second Entry
//

import SwiftUI
import SwiftData

struct AddTransactionView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @Query(sort: \Category.name) private var categories: [Category]
    
    @State private var amount: String = ""
    @State private var selectedCategory: Category?
    @State private var note: String = ""
    @State private var date: Date = Date()
    @State private var isExpense: Bool = true
    
    private let quickAmounts: [Double] = [5, 10, 20, 50, 100]
    
    var filteredCategories: [Category] {
        categories.filter { $0.isIncome == !isExpense }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Text("$")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundStyle(.secondary)
                        
                        TextField("0.00", text: $amount)
                            .font(.system(size: 40, weight: .bold))
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.leading)
                    }
                    .padding(.vertical, 8)
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 8) {
                        ForEach(quickAmounts, id: \.self) { quickAmount in
                            Button {
                                amount = String(format: "%.2f", quickAmount)
                            } label: {
                                Text("$\(Int(quickAmount))")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 8)
                                    .background(Color(.tertiarySystemFill))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            .foregroundStyle(.primary)
                        }
                    }
                } header: {
                    Text("Amount")
                }
                
                Section {
                    Picker("Type", selection: $isExpense) {
                        Text("Expense").tag(true)
                        Text("Income").tag(false)
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: isExpense) { _, _ in
                        selectedCategory = filteredCategories.first
                    }
                } header: {
                    Text("Type")
                }
                
                Section {
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 12) {
                        ForEach(filteredCategories) { category in
                            CategoryButton(
                                category: category,
                                isSelected: selectedCategory?.id == category.id
                            ) {
                                selectedCategory = category
                            }
                        }
                    }
                } header: {
                    Text("Category")
                }
                
                Section {
                    TextField("Add a note (optional)", text: $note)
                } header: {
                    Text("Note")
                }
                
                Section {
                    DatePicker(
                        "Date",
                        selection: $date,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                } header: {
                    Text("Date")
                }
            }
            .navigationTitle("Add Transaction")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveTransaction()
                    }
                    .disabled(!isValid)
                    .fontWeight(.semibold)
                }
            }
            .onAppear {
                selectedCategory = filteredCategories.first
            }
        }
    }
    
    private var isValid: Bool {
        guard let amountValue = Double(amount), amountValue > 0 else {
            return false
        }
        return selectedCategory != nil
    }
    
    private func saveTransaction() {
        guard let amountValue = Double(amount),
              let category = selectedCategory else {
            return
        }
        
        let transactionAmount = isExpense ? -abs(amountValue) : abs(amountValue)
        
        let transaction = Transaction(
            amount: transactionAmount,
            note: note,
            date: date,
            category: category
        )
        
        modelContext.insert(transaction)
        
        do {
            try modelContext.save()
            dismiss()
        } catch {
            print("Failed to save transaction: \(error)")
        }
    }
}

struct CategoryButton: View {
    let category: Category
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                ZStack {
                    Circle()
                        .fill(Color(hex: category.colorHex).opacity(isSelected ? 0.3 : 0.15))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: category.icon)
                        .font(.system(size: 20))
                        .foregroundStyle(Color(hex: category.colorHex))
                }
                .overlay(
                    Circle()
                        .stroke(Color(hex: category.colorHex), lineWidth: isSelected ? 2 : 0)
                )
                
                Text(category.name)
                    .font(.caption2)
                    .lineLimit(1)
                    .foregroundStyle(isSelected ? Color(hex: category.colorHex) : .secondary)
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    AddTransactionView()
        .modelContainer(for: [Transaction.self, Category.self, Budget.self], inMemory: true)
}
