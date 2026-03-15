//
//  CategoryManagementView.swift
//  PennyWise
//
//  Category Management Screen
//

import SwiftUI
import SwiftData

struct CategoryManagementView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Category.name) private var categories: [Category]
    @State private var showingAddCategory = false
    @State private var editingCategory: Category?
    
    var expenseCategories: [Category] {
        categories.filter { !$0.isIncome }
    }
    
    var incomeCategories: [Category] {
        categories.filter { $0.isIncome }
    }
    
    var body: some View {
        List {
            Section {
                ForEach(expenseCategories) { category in
                    CategoryListRow(category: category) {
                        editingCategory = category
                    }
                }
                .onDelete { indexSet in
                    deleteCategories(expenseCategories, at: indexSet)
                }
            } header: {
                Text("Expense Categories")
            }
            
            Section {
                ForEach(incomeCategories) { category in
                    CategoryListRow(category: category) {
                        editingCategory = category
                    }
                }
                .onDelete { indexSet in
                    deleteCategories(incomeCategories, at: indexSet)
                }
            } header: {
                Text("Income Categories")
            }
        }
        .navigationTitle("Categories")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingAddCategory = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddCategory) {
            AddCategoryView()
        }
        .sheet(item: $editingCategory) { category in
            EditCategoryView(category: category)
        }
    }
    
    private func deleteCategories(_ categories: [Category], at indexSet: IndexSet) {
        for index in indexSet {
            let category = categories[index]
            if category.isDefault {
                continue
            }
            modelContext.delete(category)
        }
        try? modelContext.save()
    }
}

struct CategoryListRow: View {
    let category: Category
    let onEdit: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color(hex: category.colorHex).opacity(0.2))
                    .frame(width: 40, height: 40)
                
                Image(systemName: category.icon)
                    .foregroundStyle(Color(hex: category.colorHex))
            }
            
            Text(category.name)
                .font(.body)
            
            Spacer()
            
            if category.isDefault {
                Text("Default")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Button {
                onEdit()
            } label: {
                Image(systemName: "pencil")
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(.plain)
        }
    }
}

struct AddCategoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var icon: String = "questionmark"
    @State private var colorHex: String = "#007AFF"
    @State private var isIncome: Bool = false
    
    private let availableIcons = [
        "fork.knife", "car.fill", "bag.fill", "tv.fill", "bolt.fill",
        "heart.fill", "book.fill", "dollarsign.circle.fill", "chart.line.uptrend.xyaxis",
        "ellipsis.circle.fill", "house.fill", "gift.fill", "airplane", "gamecontroller.fill",
        "music.note", "cart.fill", "creditcard.fill", "banknote.fill"
    ]
    
    private let availableColors = [
        "#FF6B6B", "#4ECDC4", "#45B7D1", "#96CEB4", "#FFEAA7",
        "#DDA0DD", "#98D8C8", "#2ECC71", "#3498DB", "#95A5A6",
        "#F39C12", "#E74C3C", "#9B59B6", "#1ABC9C", "#34495E"
    ]
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Category Name", text: $name)
                } header: {
                    Text("Name")
                }
                
                Section {
                    Picker("Type", selection: $isIncome) {
                        Text("Expense").tag(false)
                        Text("Income").tag(true)
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text("Type")
                }
                
                Section {
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 12) {
                        ForEach(availableIcons, id: \.self) { iconName in
                            Button {
                                icon = iconName
                            } label: {
                                ZStack {
                                    Circle()
                                        .fill(Color(hex: colorHex).opacity(icon == iconName ? 0.3 : 0.1))
                                        .frame(width: 44, height: 44)
                                    
                                    Image(systemName: iconName)
                                        .foregroundStyle(Color(hex: colorHex))
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                } header: {
                    Text("Icon")
                }
                
                Section {
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 12) {
                        ForEach(availableColors, id: \.self) { color in
                            Button {
                                colorHex = color
                            } label: {
                                ZStack {
                                    Circle()
                                        .fill(Color(hex: color))
                                        .frame(width: 44, height: 44)
                                    
                                    if colorHex == color {
                                        Image(systemName: "checkmark")
                                            .foregroundStyle(.white)
                                            .fontWeight(.bold)
                                    }
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                } header: {
                    Text("Color")
                }
            }
            .navigationTitle("Add Category")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveCategory()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
    
    private func saveCategory() {
        let category = Category(
            name: name,
            icon: icon,
            colorHex: colorHex,
            isIncome: isIncome,
            isDefault: false
        )
        modelContext.insert(category)
        try? modelContext.save()
        dismiss()
    }
}

struct EditCategoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    let category: Category
    
    @State private var name: String = ""
    @State private var icon: String = ""
    @State private var colorHex: String = ""
    
    private let availableIcons = [
        "fork.knife", "car.fill", "bag.fill", "tv.fill", "bolt.fill",
        "heart.fill", "book.fill", "dollarsign.circle.fill", "chart.line.uptrend.xyaxis",
        "ellipsis.circle.fill", "house.fill", "gift.fill", "airplane", "gamecontroller.fill",
        "music.note", "cart.fill", "creditcard.fill", "banknote.fill"
    ]
    
    private let availableColors = [
        "#FF6B6B", "#4ECDC4", "#45B7D1", "#96CEB4", "#FFEAA7",
        "#DDA0DD", "#98D8C8", "#2ECC71", "#3498DB", "#95A5A6",
        "#F39C12", "#E74C3C", "#9B59B6", "#1ABC9C", "#34495E"
    ]
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Category Name", text: $name)
                } header: {
                    Text("Name")
                }
                
                Section {
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 12) {
                        ForEach(availableIcons, id: \.self) { iconName in
                            Button {
                                icon = iconName
                            } label: {
                                ZStack {
                                    Circle()
                                        .fill(Color(hex: colorHex).opacity(icon == iconName ? 0.3 : 0.1))
                                        .frame(width: 44, height: 44)
                                    
                                    Image(systemName: iconName)
                                        .foregroundStyle(Color(hex: colorHex))
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                } header: {
                    Text("Icon")
                }
                
                Section {
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 12) {
                        ForEach(availableColors, id: \.self) { color in
                            Button {
                                colorHex = color
                            } label: {
                                ZStack {
                                    Circle()
                                        .fill(Color(hex: color))
                                        .frame(width: 44, height: 44)
                                    
                                    if colorHex == color {
                                        Image(systemName: "checkmark")
                                            .foregroundStyle(.white)
                                            .fontWeight(.bold)
                                    }
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                } header: {
                    Text("Color")
                }
            }
            .navigationTitle("Edit Category")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveCategory()
                    }
                    .disabled(name.isEmpty)
                }
            }
            .onAppear {
                name = category.name
                icon = category.icon
                colorHex = category.colorHex
            }
        }
    }
    
    private func saveCategory() {
        category.name = name
        category.icon = icon
        category.colorHex = colorHex
        try? modelContext.save()
        dismiss()
    }
}

#Preview {
    NavigationStack {
        CategoryManagementView()
    }
    .modelContainer(for: [Transaction.self, Category.self, Budget.self], inMemory: true)
}
