//
//  iCloudSyncSettingsView.swift
//  PennyWise
//
//  iCloud sync settings and controls
//  REUSES: AppColors from Color+Extensions.swift
//

import SwiftUI

struct iCloudSyncSettingsView: View {
    @State private var isSyncing = false
    @State private var isCloudKitAvailable = false
    @State private var lastSyncDate: Date?
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        List {
            Section {
                HStack {
                    Image(systemName: "icloud.fill")
                        .font(.title2)
                        .foregroundStyle(AppColors.primary)
                        .frame(width: 30)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("iCloud Sync")
                            .font(.headline)
                        
                        if isCloudKitAvailable {
                            Text("Connected")
                                .font(.caption)
                                .foregroundStyle(AppColors.success)
                        } else {
                            Text("Not available")
                                .font(.caption)
                                .foregroundStyle(AppColors.danger)
                        }
                    }
                }
            }
            
            if isCloudKitAvailable {
                Section("Sync Status") {
                    if let date = lastSyncDate {
                        HStack {
                            Text("Last synced")
                            Spacer()
                            Text(date, style: .relative)
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    Button {
                        Task {
                            isSyncing = true
                            await CloudKitSyncManager.shared.syncData()
                            lastSyncDate = CloudKitSyncManager.shared.lastSyncDate
                            isSyncing = false
                            alertMessage = "Sync completed successfully!"
                            showAlert = true
                        }
                    } label: {
                        HStack {
                            if isSyncing {
                                ProgressView()
                                    .scaleEffect(0.8)
                            } else {
                                Image(systemName: "arrow.triangle.2.circlepath")
                            }
                            Text(isSyncing ? "Syncing..." : "Sync Now")
                        }
                    }
                    .disabled(isSyncing)
                }
                
                Section("About iCloud Sync") {
                    VStack(alignment: .leading, spacing: 8) {
                        FeatureRow(icon: "checkmark.icloud", text: "Automatically backs up your data")
                        FeatureRow(icon: "icloud.fill", text: "Syncs across all your devices")
                        FeatureRow(icon: "lock.shield", text: "End-to-end encrypted")
                    }
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                }
            } else {
                Section {
                    VStack(spacing: 12) {
                        Image(systemName: "exclamationmark.icloud")
                            .font(.largeTitle)
                            .foregroundStyle(AppColors.warning)
                        
                        Text("iCloud Not Available")
                            .font(.headline)
                        
                        Text("Please sign in to iCloud in Settings to enable sync.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                        
                        Button("Open Settings") {
                            if let url = URL(string: UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(url)
                            }
                        }
                        .buttonStyle(.bordered)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                }
            }
        }
        .navigationTitle("iCloud Sync")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Sync", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
        .task {
            isCloudKitAvailable = await CloudKitSyncManager.shared.checkAccountStatus()
            lastSyncDate = CloudKitSyncManager.shared.lastSyncDate
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(AppColors.success)
                .frame(width: 20)
            Text(text)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    NavigationStack {
        iCloudSyncSettingsView()
    }
}
