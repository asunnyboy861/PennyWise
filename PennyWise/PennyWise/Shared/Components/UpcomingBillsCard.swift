//
//  UpcomingBillsCard.swift
//  PennyWise
//
//  Upcoming bills reminder card
//

import SwiftUI

struct UpcomingBillsCard: View {
    let bills: [BillReminder]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Upcoming Bills")
                    .font(.headline)
                Spacer()
                Button("Manage") { }
                    .font(.caption)
            }
            
            if bills.isEmpty {
                Text("No upcoming bills")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 20)
            } else {
                ForEach(bills.prefix(3)) { bill in
                    HStack(spacing: 12) {
                        Image(systemName: bill.icon)
                            .font(.system(size: 20))
                            .foregroundStyle(.secondary)
                            .frame(width: 32, height: 32)
                            .background(Color(.systemGray5))
                            .clipShape(Circle())
                        
                        Text(bill.name)
                            .font(.subheadline)
                        
                        Spacer()
                        
                        Text(formatCurrency(bill.amount))
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        Text(bill.daysUntilDueText)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(bill.isDueSoon ? AppColors.warning.opacity(0.15) : Color(.systemGray5))
                            .foregroundStyle(bill.isDueSoon ? AppColors.warning : .secondary)
                            .clipShape(Capsule())
                    }
                    
                    if bill.id != bills.prefix(3).last?.id {
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
    UpcomingBillsCard(bills: [
        BillReminder(name: "Netflix", amount: 15.99, icon: "tv", dueDay: 15),
        BillReminder(name: "Rent", amount: 1200, icon: "house", dueDay: 1)
    ])
    .padding()
}
