//
//  PennyWiseWidget.swift
//  PennyWiseWidget
//
//  Budget tracking widget
//

import WidgetKit
import SwiftUI

struct BudgetEntry: TimelineEntry {
    let date: Date
    let monthlyBudget: Double
    let monthlyExpense: Double
    let daysRemaining: Int
    let configuration: ConfigurationAppIntent
}

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> BudgetEntry {
        BudgetEntry(
            date: Date(),
            monthlyBudget: 1800,
            monthlyExpense: 900,
            daysRemaining: 15,
            configuration: ConfigurationAppIntent()
        )
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> BudgetEntry {
        let budget = getBudget()
        let expense = getExpense()
        let days = getDaysRemaining()
        
        return BudgetEntry(
            date: Date(),
            monthlyBudget: budget,
            monthlyExpense: expense,
            daysRemaining: days,
            configuration: configuration
        )
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<BudgetEntry> {
        let budget = getBudget()
        let expense = getExpense()
        let days = getDaysRemaining()
        
        let currentDate = Date()
        
        var entries: [BudgetEntry] = []
        
        for hourOffset in 0..<24 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = BudgetEntry(
                date: entryDate,
                monthlyBudget: budget,
                monthlyExpense: expense,
                daysRemaining: days,
                configuration: configuration
            )
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
    
    private func getBudget() -> Double {
        UserDefaults.standard.double(forKey: "monthlyBudget") > 0 
            ? UserDefaults.standard.double(forKey: "monthlyBudget") 
            : 1800.0
    }
    
    private func getExpense() -> Double {
        return 0
    }
    
    private func getDaysRemaining() -> Int {
        let calendar = Calendar.current
        let today = Date()
        let range = calendar.range(of: .day, in: .month, for: today)!
        let daysInMonth = range.count
        let currentDay = calendar.component(.day, from: today)
        return daysInMonth - currentDay
    }
}

struct PennyWiseWidgetEntryView: View {
    var entry: BudgetEntry
    
    private var progress: Double {
        guard entry.monthlyBudget > 0 else { return 0 }
        return min(entry.monthlyExpense / entry.monthlyBudget, 1.0)
    }
    
    private var progressColor: Color {
        if progress >= 1.0 { return .red }
        else if progress >= 0.8 { return .orange }
        else { return .green }
    }
    
    private var remaining: Double {
        entry.monthlyBudget - entry.monthlyExpense
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "dollarsign.circle.fill")
                    .foregroundStyle(.blue)
                Text("PennyWise")
                    .font(.caption)
                    .fontWeight(.semibold)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("\(Int(progress * 100))%")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("of \(formatCurrency(entry.monthlyBudget))")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(.systemGray5))
                        .frame(height: 8)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(progressColor)
                        .frame(width: geometry.size.width * progress, height: 8)
                }
            }
            .frame(height: 8)
            
            HStack {
                if remaining > 0 {
                    Text("\(formatCurrency(remaining)) left")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                } else {
                    Text("Over budget!")
                        .font(.caption2)
                        .foregroundStyle(.red)
                }
                
                Spacer()
                
                Text("\(entry.daysRemaining)d left")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
    }
    
    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "$0"
    }
}

struct PennyWiseWidget: Widget {
    let kind: String = "PennyWiseWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            PennyWiseWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Budget Tracker")
        .description("Track your monthly budget at a glance.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

#Preview(as: .systemSmall) {
    PennyWiseWidget()
} timeline: {
    BudgetEntry(date: .now, monthlyBudget: 1800, monthlyExpense: 900, daysRemaining: 15, configuration: ConfigurationAppIntent())
    BudgetEntry(date: .now, monthlyBudget: 1800, monthlyExpense: 1500, daysRemaining: 5, configuration: ConfigurationAppIntent())
}

#Preview(as: .systemMedium) {
    PennyWiseWidget()
} timeline: {
    BudgetEntry(date: .now, monthlyBudget: 1800, monthlyExpense: 900, daysRemaining: 15, configuration: ConfigurationAppIntent())
}
