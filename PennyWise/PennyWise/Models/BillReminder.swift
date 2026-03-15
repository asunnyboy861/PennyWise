//
//  BillReminder.swift
//  PennyWise
//
//  Model for recurring bill reminders
//

import Foundation
import SwiftData

@Model
final class BillReminder {
    var id: UUID = UUID()
    var name: String = ""
    var amount: Double = 0.0
    var icon: String = "doc.text"
    var dueDay: Int = 1
    var isActive: Bool = true
    var lastNotified: Date?
    
    init(
        id: UUID = UUID(),
        name: String = "",
        amount: Double = 0.0,
        icon: String = "doc.text",
        dueDay: Int = 1,
        isActive: Bool = true
    ) {
        self.id = id
        self.name = name
        self.amount = amount
        self.icon = icon
        self.dueDay = dueDay
        self.isActive = isActive
    }
    
    var daysUntilDue: Int {
        let calendar = Calendar.current
        let today = calendar.component(.day, from: Date())
        
        if dueDay > today {
            return dueDay - today
        } else {
            let nextMonth = calendar.date(byAdding: .month, value: 1, to: Date())!
            let daysInMonth = calendar.range(of: .day, in: .month, for: nextMonth)?.count ?? 30
            return (daysInMonth - today) + dueDay
        }
    }
    
    var isDueSoon: Bool {
        daysUntilDue <= 3
    }
    
    var daysUntilDueText: String {
        let days = daysUntilDue
        if days == 0 { return "Today" }
        else if days == 1 { return "Tomorrow" }
        else { return "\(days)d" }
    }
}
