//
//  StreakViewModel.swift
//  PennyWise
//
//  ViewModel for managing user streak
//

import Foundation
import SwiftData
import Observation

@Observable
@MainActor
final class StreakViewModel {
    var currentStreak: Int = 0
    var longestStreak: Int = 0
    var totalActiveDays: Int = 0
    var isActiveToday: Bool = false
    
    private var modelContext: ModelContext?
    private var userStreak: UserStreak?
    
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
    }
    
    func loadStreak() {
        guard let context = modelContext else { return }
        
        let descriptor = FetchDescriptor<UserStreak>()
        let streaks = (try? context.fetch(descriptor)) ?? []
        
        if let streak = streaks.first {
            userStreak = streak
            currentStreak = streak.currentStreak
            longestStreak = streak.longestStreak
            totalActiveDays = streak.totalActiveDays
            
            if let lastDate = streak.lastActiveDate {
                let calendar = Calendar.current
                let today = calendar.startOfDay(for: Date())
                let lastActive = calendar.startOfDay(for: lastDate)
                isActiveToday = today == lastActive
            }
        } else {
            let newStreak = UserStreak()
            context.insert(newStreak)
            try? context.save()
            userStreak = newStreak
        }
    }
    
    func recordActivity() {
        guard let streak = userStreak else { return }
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        if let lastDate = streak.lastActiveDate {
            let lastActive = calendar.startOfDay(for: lastDate)
            if today == lastActive {
                return
            }
        }
        
        streak.updateStreak()
        try? modelContext?.save()
        
        currentStreak = streak.currentStreak
        longestStreak = streak.longestStreak
        totalActiveDays = streak.totalActiveDays
        isActiveToday = true
    }
    
    var streakMessage: String {
        if currentStreak == 0 {
            return "Start your streak today!"
        } else if currentStreak == 1 {
            return "Great start! Keep it up!"
        } else if currentStreak < 7 {
            return "\(currentStreak) days! You're building a habit!"
        } else if currentStreak < 30 {
            return "\(currentStreak) days! Amazing consistency!"
        } else {
            return "\(currentStreak) days! You're a finance pro!"
        }
    }
    
    var streakEmoji: String {
        if currentStreak == 0 { return "🔥" }
        else if currentStreak < 3 { return "🌱" }
        else if currentStreak < 7 { return "⭐" }
        else if currentStreak < 14 { return "🌟" }
        else if currentStreak < 30 { return "🏆" }
        else { return "👑" }
    }
}
