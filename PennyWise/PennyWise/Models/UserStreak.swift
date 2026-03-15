//
//  UserStreak.swift
//  PennyWise
//
//  Model for tracking user streak/motivation
//

import Foundation
import SwiftData

@Model
final class UserStreak {
    var id: UUID = UUID()
    var currentStreak: Int = 0
    var longestStreak: Int = 0
    var lastActiveDate: Date?
    var totalActiveDays: Int = 0
    
    init(
        id: UUID = UUID(),
        currentStreak: Int = 0,
        longestStreak: Int = 0,
        lastActiveDate: Date? = nil,
        totalActiveDays: Int = 0
    ) {
        self.id = id
        self.currentStreak = currentStreak
        self.longestStreak = longestStreak
        self.lastActiveDate = lastActiveDate
        self.totalActiveDays = totalActiveDays
    }
    
    func updateStreak() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        if let lastDate = lastActiveDate {
            let lastActive = calendar.startOfDay(for: lastDate)
            
            if lastActive == today {
                return
            } else if let yesterday = calendar.date(byAdding: .day, value: -1, to: today),
                      lastActive == yesterday {
                currentStreak += 1
            } else {
                currentStreak = 1
            }
        } else {
            currentStreak = 1
        }
        
        if currentStreak > longestStreak {
            longestStreak = currentStreak
        }
        
        lastActiveDate = Date()
        totalActiveDays += 1
    }
}
