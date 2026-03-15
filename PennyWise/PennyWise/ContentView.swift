//
//  ContentView.swift
//  PennyWise
//
//  Main Content View with Tab Navigation
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
    @AppStorage("biometricLockEnabled") private var biometricLockEnabled = false
    @State private var isUnlocked = !UserDefaults.standard.bool(forKey: "biometricLockEnabled")
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        Group {
            if !hasCompletedOnboarding {
                OnboardingView(isOnboardingComplete: $hasCompletedOnboarding)
            } else if biometricLockEnabled && !isUnlocked {
                BiometricLockView(isUnlocked: $isUnlocked)
            } else {
                TabView(selection: $selectedTab) {
                    DashboardView()
                        .tabItem {
                            Label("Home", systemImage: "house.fill")
                        }
                        .tag(0)
                    
                    TransactionListView()
                        .tabItem {
                            Label("Transactions", systemImage: "list.bullet.rectangle")
                        }
                        .tag(1)
                    
                    AnalyticsView()
                        .tabItem {
                            Label("Analytics", systemImage: "chart.bar.fill")
                        }
                        .tag(2)
                    
                    SettingsView()
                        .tabItem {
                            Label("Settings", systemImage: "gearshape.fill")
                        }
                        .tag(3)
                }
                .tint(AppColors.primary)
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Transaction.self, Category.self, Budget.self, BillReminder.self, UserStreak.self], inMemory: true)
}
