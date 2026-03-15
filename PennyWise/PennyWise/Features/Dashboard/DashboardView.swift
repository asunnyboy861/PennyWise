//
//  DashboardView.swift
//  PennyWise
//
//  Dashboard/Home Screen
//

import SwiftUI
import SwiftData
import Charts

struct DashboardView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = DashboardViewModel()
    @State private var streakViewModel = StreakViewModel()
    @State private var showingAddTransaction = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Streak Card (P2)
                    StreakCard(
                        currentStreak: streakViewModel.currentStreak,
                        longestStreak: streakViewModel.longestStreak,
                        totalActiveDays: streakViewModel.totalActiveDays,
                        message: streakViewModel.streakMessage,
                        emoji: streakViewModel.streakEmoji,
                        isActiveToday: streakViewModel.isActiveToday
                    )
                    
                    // Budget Progress Card (Dashboard V2)
                    BudgetProgressCard(
                        spent: viewModel.monthlyExpense,
                        budget: viewModel.monthlyBudget
                    )
                    
                    // Today's Overview
                    TodayOverviewCard(
                        todayTotal: viewModel.formattedTodayTotal,
                        income: viewModel.formattedTodayIncome,
                        expense: viewModel.formattedTodayExpense
                    )
                    
                    // Top Categories Card (Dashboard V2)
                    if !viewModel.topCategories.isEmpty {
                        TopCategoriesCard(categories: viewModel.topCategories)
                    }
                    
                    // Weekly Chart
                    if !viewModel.weeklyData.isEmpty {
                        WeeklyChartCard(weeklyData: viewModel.weeklyData)
                    }
                    
                    // Recent Transactions
                    if !viewModel.recentTransactions.isEmpty {
                        RecentTransactionsCard(transactions: viewModel.recentTransactions)
                    } else {
                        EmptyTransactionsCard()
                    }
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("PennyWise")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddTransaction = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundStyle(AppColors.primary)
                    }
                }
            }
            // FAB overlay for quick transaction entry
            .overlay(alignment: .bottomTrailing) {
                QuickAddButton(isPresented: $showingAddTransaction)
                    .padding(.trailing, 20)
                    .padding(.bottom, 20)
            }
            .sheet(isPresented: $showingAddTransaction) {
                AddTransactionView()
            }
            .onAppear {
                viewModel.setModelContext(modelContext)
                viewModel.loadData()
                streakViewModel.setModelContext(modelContext)
                streakViewModel.loadStreak()
            }
        }
    }
}

struct TodayOverviewCard: View {
    let todayTotal: String
    let income: String
    let expense: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Today's Balance")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            Text(todayTotal)
                .font(.system(size: 34, weight: .bold))
                .foregroundStyle(todayTotal.contains("-") ? .red : .primary)
            
            HStack(spacing: 20) {
                HStack(spacing: 4) {
                    Image(systemName: "arrow.up.circle.fill")
                        .foregroundStyle(.green)
                    Text(income)
                        .foregroundStyle(.green)
                }
                
                HStack(spacing: 4) {
                    Image(systemName: "arrow.down.circle.fill")
                        .foregroundStyle(.red)
                    Text(expense)
                        .foregroundStyle(.red)
                }
            }
            .font(.caption)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct WeeklyChartCard: View {
    let weeklyData: [DailyExpense]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("This Week")
                .font(.headline)
            
            Chart(weeklyData) { item in
                BarMark(
                    x: .value("Day", item.dayName),
                    y: .value("Amount", item.amount)
                )
                .foregroundStyle(Color(hex: "#007AFF").gradient)
                .cornerRadius(4)
            }
            .frame(height: 150)
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

struct RecentTransactionsCard: View {
    let transactions: [Transaction]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent Transactions")
                .font(.headline)
                .padding(.horizontal)
            
            VStack(spacing: 0) {
                ForEach(transactions) { transaction in
                    TransactionRowView(transaction: transaction)
                    
                    if transaction.id != transactions.last?.id {
                        Divider()
                            .padding(.leading, 56)
                    }
                }
            }
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}

struct EmptyTransactionsCard: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "tray")
                .font(.system(size: 40))
                .foregroundStyle(.secondary)
            
            Text("No transactions yet")
                .font(.headline)
                .foregroundStyle(.secondary)
            
            Text("Tap + to add your first expense")
                .font(.subheadline)
                .foregroundStyle(.tertiary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    DashboardView()
        .modelContainer(for: [Transaction.self, Category.self, Budget.self, BillReminder.self, UserStreak.self], inMemory: true)
}
