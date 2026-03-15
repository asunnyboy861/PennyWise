//
//  TopCategoriesCard.swift
//  PennyWise
//
//  Top spending categories card
//

import SwiftUI

struct TopCategoriesCard: View {
    let categories: [CategoryExpense]
    
    struct CategoryExpense: Identifiable {
        let id = UUID()
        let name: String
        let icon: String
        let color: Color
        let amount: Double
        let percentage: Double
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Top Categories")
                .font(.headline)
            
            if categories.isEmpty {
                Text("No expenses this month")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 20)
            } else {
                ForEach(categories.prefix(5)) { category in
                    HStack(spacing: 12) {
                        Image(systemName: category.icon)
                            .font(.system(size: 20))
                            .foregroundStyle(category.color)
                            .frame(width: 32, height: 32)
                            .background(category.color.opacity(0.15))
                            .clipShape(Circle())
                        
                        Text(category.name)
                            .font(.subheadline)
                        
                        Spacer()
                        
                        Text("\(Int(category.percentage))%")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        Text(formatCurrency(category.amount))
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                    
                    if category.id != categories.prefix(5).last?.id {
                        Divider()
                    }
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: NSNumber(value: value)) ?? "$0.00"
    }
}

#Preview {
    TopCategoriesCard(categories: [
        .init(name: "Food & Dining", icon: "fork.knife", color: .red, amount: 556, percentage: 45),
        .init(name: "Transportation", icon: "car.fill", color: .blue, amount: 309, percentage: 25)
    ])
    .padding()
}
