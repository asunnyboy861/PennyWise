//
//  BudgetProgressCard.swift
//  PennyWise
//
//  Budget progress visualization card
//  REUSES: AppColors from Color+Extensions.swift
//

import SwiftUI

struct BudgetProgressCard: View {
    let spent: Double
    let budget: Double
    
    private var progress: Double {
        guard budget > 0 else { return 0 }
        return min(spent / budget, 1.0)
    }
    
    private var remaining: Double {
        budget - spent
    }
    
    private var progressColor: Color {
        if progress >= 1.0 { return AppColors.danger }
        else if progress >= 0.8 { return AppColors.warning }
        else { return AppColors.success }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("This Month")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Spacer()
                Text("Budget: \(formatCurrency(budget))")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
            
            Text("\(formatCurrency(spent)) spent")
                .font(.title2)
                .fontWeight(.bold)
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color(.systemGray5))
                        .frame(height: 12)
                    
                    RoundedRectangle(cornerRadius: 6)
                        .fill(progressColor)
                        .frame(width: geometry.size.width * progress, height: 12)
                }
            }
            .frame(height: 12)
            
            HStack {
                if remaining > 0 {
                    Text("\(formatCurrency(remaining)) remaining")
                        .foregroundStyle(AppColors.success)
                } else {
                    Text("\(formatCurrency(abs(remaining))) over budget")
                        .foregroundStyle(AppColors.danger)
                }
                Spacer()
                Text("\(Int(progress * 100))%")
                    .fontWeight(.semibold)
                    .foregroundStyle(progressColor)
            }
            .font(.caption)
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
    BudgetProgressCard(spent: 1200, budget: 1800)
        .padding()
}
