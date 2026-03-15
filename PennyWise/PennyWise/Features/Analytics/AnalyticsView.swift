//
//  AnalyticsView.swift
//  PennyWise
//
//  Analytics/Statistics Screen
//

import SwiftUI
import SwiftData
import Charts

struct AnalyticsView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = AnalyticsViewModel()
    @State private var selectedPeriod: Period = .month
    
    enum Period: String, CaseIterable {
        case week = "Week"
        case month = "Month"
        case year = "Year"
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    SummaryCard(
                        income: viewModel.totalIncome,
                        expense: viewModel.totalExpense,
                        balance: viewModel.balance
                    )
                    
                    if !viewModel.categoryExpenses.isEmpty {
                        CategoryPieChartCard(categoryExpenses: viewModel.categoryExpenses)
                    }
                    
                    if !viewModel.monthlyExpenses.isEmpty {
                        MonthlyTrendChartCard(monthlyExpenses: viewModel.monthlyExpenses)
                    }
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Analytics")
            .onAppear {
                viewModel.setModelContext(modelContext)
                viewModel.loadData()
            }
        }
    }
}

struct SummaryCard: View {
    let income: Double
    let expense: Double
    let balance: Double
    
    var body: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Total Balance")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Text(formatCurrency(balance))
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(balance >= 0 ? AppColors.success : AppColors.danger)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Divider()
            
            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.up.circle.fill")
                            .foregroundStyle(AppColors.success)
                        Text("Income")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Text(formatCurrency(income))
                        .font(.headline)
                        .foregroundStyle(AppColors.success)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.down.circle.fill")
                            .foregroundStyle(AppColors.danger)
                        Text("Expense")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Text(formatCurrency(expense))
                        .font(.headline)
                        .foregroundStyle(AppColors.danger)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
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
        return formatter.string(from: NSNumber(value: abs(value))) ?? "$0.00"
    }
}

struct CategoryPieChartCard: View {
    let categoryExpenses: [CategoryExpense]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Spending by Category")
                .font(.headline)
            
            Chart(categoryExpenses) { item in
                SectorMark(
                    angle: .value("Amount", item.amount),
                    innerRadius: .ratio(0.5),
                    angularInset: 1.5
                )
                .foregroundStyle(Color(hex: item.category.colorHex))
                .cornerRadius(4)
            }
            .frame(height: 200)
            
            VStack(spacing: 8) {
                ForEach(categoryExpenses.prefix(5)) { item in
                    HStack {
                        Circle()
                            .fill(Color(hex: item.category.colorHex))
                            .frame(width: 12, height: 12)
                        
                        Text(item.category.name)
                            .font(.subheadline)
                        
                        Spacer()
                        
                        Text("\(Int(item.percentage * 100))%")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        Text(formatCurrency(item.amount))
                            .font(.subheadline)
                            .fontWeight(.medium)
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

struct MonthlyTrendChartCard: View {
    let monthlyExpenses: [MonthlyExpense]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Monthly Trend")
                .font(.headline)
            
            Chart(monthlyExpenses) { item in
                BarMark(
                    x: .value("Month", item.month),
                    y: .value("Amount", item.amount)
                )
                .foregroundStyle(AppColors.danger.gradient)
                .cornerRadius(4)
            }
            .frame(height: 200)
            .chartYAxis {
                AxisMarks(position: .leading) { value in
                    AxisValueLabel {
                        if let amount = value.as(Double.self) {
                            Text("$\(Int(amount))")
                                .font(.caption2)
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    AnalyticsView()
        .modelContainer(for: [Transaction.self, Category.self, Budget.self], inMemory: true)
}
