//
//  TransactionRowView.swift
//  PennyWise
//
//  Reusable transaction row component
//

import SwiftUI

struct TransactionRowView: View {
    let transaction: Transaction
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color(hex: transaction.category?.colorHex ?? "#8E8E93").opacity(0.2))
                    .frame(width: 44, height: 44)
                
                Image(systemName: transaction.category?.icon ?? "questionmark")
                    .font(.system(size: 18))
                    .foregroundStyle(Color(hex: transaction.category?.colorHex ?? "#8E8E93"))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.category?.name ?? "Uncategorized")
                    .font(.body)
                    .fontWeight(.medium)
                
                if !transaction.note.isEmpty {
                    Text(transaction.note)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(transaction.signedFormattedAmount)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundStyle(transaction.amount >= 0 ? AppColors.success : AppColors.danger)
                
                Text(transaction.shortFormattedDate)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .contentShape(Rectangle())
    }
}

#Preview {
    let category = Category(
        name: "Food & Dining",
        icon: "fork.knife",
        colorHex: "#FF6B6B",
        isIncome: false
    )
    
    let transaction = Transaction(
        amount: -25.50,
        note: "Lunch with team",
        date: Date(),
        category: category
    )
    
    return TransactionRowView(transaction: transaction)
        .modelContainer(for: [Transaction.self, Category.self], inMemory: true)
}
