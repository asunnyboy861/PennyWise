//
//  SettingsView.swift
//  PennyWise
//
//  Settings Screen
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var showingExportSheet = false
    @State private var showingCategorySheet = false
    @State private var showingBudgetSheet = false
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink {
                        CategoryManagementView()
                    } label: {
                        Label("Manage Categories", systemImage: "folder")
                    }
                    
                    NavigationLink {
                        BudgetManagementView()
                    } label: {
                        Label("Budget Settings", systemImage: "chart.pie")
                    }
                } header: {
                    Text("Preferences")
                }
                
                Section {
                    NavigationLink {
                        iCloudSyncSettingsView()
                    } label: {
                        Label("iCloud Sync", systemImage: "icloud")
                    }
                    
                    NavigationLink {
                        SecuritySettingsView()
                    } label: {
                        Label("Security & Privacy", systemImage: "lock.shield")
                    }
                } header: {
                    Text("Data Management")
                }
                
                Section {
                    Button {
                        showingExportSheet = true
                    } label: {
                        Label("Export Data", systemImage: "square.and.arrow.up")
                    }
                } header: {
                    Text("Export")
                } footer: {
                    Text("Export your transaction data to CSV, JSON, or PDF format.")
                }
                
                Section {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundStyle(.secondary)
                    }
                    
                    HStack {
                        Text("Build")
                        Spacer()
                        Text("1")
                            .foregroundStyle(.secondary)
                    }
                } header: {
                    Text("About")
                }
                
                Section {
                    Link(destination: URL(string: "https://pennywise-privacy-vert.vercel.app")!) {
                        Label("Privacy Policy", systemImage: "hand.raised")
                    }
                    
                    Link(destination: URL(string: "https://pennywise-support.vercel.app")!) {
                        Label("Help & Support", systemImage: "questionmark.circle")
                    }
                    
                    NavigationLink {
                        ContactSupportView()
                    } label: {
                        Label("Contact Us", systemImage: "envelope.badge.shield.half.filled")
                    }
                } header: {
                    Text("Support & Legal")
                } footer: {
                    Text("Visit our Help Center for FAQs, or contact us directly for assistance.")
                }
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showingExportSheet) {
                ExportView()
            }
        }
    }
}

#Preview {
    SettingsView()
        .modelContainer(for: [Transaction.self, Category.self, Budget.self], inMemory: true)
}
