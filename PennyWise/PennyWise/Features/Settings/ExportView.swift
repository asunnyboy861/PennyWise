//
//  ExportView.swift
//  PennyWise
//
//  Data Export Screen
//

import SwiftUI
import SwiftData

struct ExportView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \Transaction.date, order: .reverse) private var transactions: [Transaction]
    
    @State private var selectedFormat: ExportService.ExportFormat = .csv
    @State private var startDate: Date = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
    @State private var endDate: Date = Date()
    @State private var isExporting = false
    @State private var exportedFileURL: URL?
    @State private var showingShareSheet = false
    @State private var errorMessage: String?
    @State private var showError = false
    
    var filteredTransactions: [Transaction] {
        transactions.filter { $0.date >= startDate && $0.date <= endDate }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Format", selection: $selectedFormat) {
                        ForEach(ExportService.ExportFormat.allCases, id: \.self) { format in
                            HStack {
                                Image(systemName: format.icon)
                                Text(format.displayName)
                            }
                            .tag(format)
                        }
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text("Export Format")
                } footer: {
                    Text(selectedFormat.description)
                }
                
                Section {
                    DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                    DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                } header: {
                    Text("Date Range")
                } footer: {
                    Text("\(filteredTransactions.count) transactions in selected range")
                }
                
                Section {
                    HStack {
                        Text("Total Transactions")
                        Spacer()
                        Text("\(filteredTransactions.count)")
                            .foregroundStyle(.secondary)
                    }
                    
                    HStack {
                        Text("Total Income")
                        Spacer()
                        Text(formatCurrency(totalIncome))
                            .foregroundStyle(AppColors.success)
                    }
                    
                    HStack {
                        Text("Total Expense")
                        Spacer()
                        Text(formatCurrency(totalExpense))
                            .foregroundStyle(AppColors.danger)
                    }
                } header: {
                    Text("Summary")
                }
                
                Section {
                    Button {
                        exportData()
                    } label: {
                        HStack {
                            Spacer()
                            if isExporting {
                                ProgressView()
                                    .padding(.trailing, 8)
                            }
                            Text("Export Data")
                                .fontWeight(.semibold)
                            Spacer()
                        }
                    }
                    .disabled(filteredTransactions.isEmpty || isExporting)
                }
            }
            .navigationTitle("Export Data")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingShareSheet) {
                if let url = exportedFileURL {
                    ShareSheet(items: [url])
                }
            }
            .alert("Export Error", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage ?? "An unknown error occurred.")
            }
        }
    }
    
    private var totalIncome: Double {
        filteredTransactions.filter { $0.amount > 0 }.reduce(0) { $0 + $1.amount }
    }
    
    private var totalExpense: Double {
        filteredTransactions.filter { $0.amount < 0 }.reduce(0) { $0 + abs($1.amount) }
    }
    
    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: NSNumber(value: value)) ?? "$0.00"
    }
    
    private func exportData() {
        isExporting = true
        
        Task {
            do {
                let url = try await ExportService.exportTransactions(
                    filteredTransactions,
                    format: selectedFormat,
                    startDate: startDate,
                    endDate: endDate
                )
                
                await MainActor.run {
                    exportedFileURL = url
                    showingShareSheet = true
                    isExporting = false
                }
            } catch let exportError as ExportError {
                await MainActor.run {
                    errorMessage = exportError.localizedDescription
                    showError = true
                    isExporting = false
                }
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    showError = true
                    isExporting = false
                }
            }
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    ExportView()
        .modelContainer(for: [Transaction.self, Category.self, Budget.self], inMemory: true)
}
