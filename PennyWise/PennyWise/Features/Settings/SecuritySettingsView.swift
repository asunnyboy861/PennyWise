//
//  SecuritySettingsView.swift
//  PennyWise
//
//  Security and privacy settings
//

import SwiftUI
import LocalAuthentication

struct SecuritySettingsView: View {
    @AppStorage("biometricLockEnabled") private var biometricLockEnabled = false
    @State private var showingBiometricSetup = false
    @State private var biometricType: LABiometryType = .none
    
    var body: some View {
        Form {
            Section {
                Toggle(isOn: $biometricLockEnabled) {
                    Label(
                        biometricTypeName,
                        systemImage: biometricTypeIcon
                    )
                }
                .onChange(of: biometricLockEnabled) { _, newValue in
                    if newValue {
                        showingBiometricSetup = true
                    }
                }
                
                Text("Require \(biometricTypeName) to open the app and protect your financial data")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            } header: {
                Text("App Lock")
            } footer: {
                Text("Your data will be protected with \(biometricTypeName). You'll need to authenticate each time you open the app.")
            }
            
            Section {
                Link(destination: URL(string: "https://support.apple.com/103247")!) {
                    Label("Learn about \(biometricTypeName) Security", systemImage: "info.circle")
                }
            } footer: {
                Text("Learn how Apple protects your biometric data.")
            }
        }
        .navigationTitle("Security & Privacy")
        .sheet(isPresented: $showingBiometricSetup) {
            BiometricSetupView(isEnabled: $biometricLockEnabled)
        }
        .onAppear {
            loadBiometricType()
        }
    }
    
    private var biometricTypeName: String {
        switch biometricType {
        case .faceID: return "Face ID"
        case .touchID: return "Touch ID"
        case .none: return "Biometric Authentication"
        @unknown default: return "Biometric Authentication"
        }
    }
    
    private var biometricTypeIcon: String {
        switch biometricType {
        case .faceID: return "faceid"
        case .touchID: return "touchid"
        case .none: return "lock.shield"
        @unknown default: return "lock.shield"
        }
    }
    
    private func loadBiometricType() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            biometricType = context.biometryType
        } else {
            biometricType = .none
        }
    }
}

// MARK: - Biometric Setup View

struct BiometricSetupView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var isEnabled: Bool
    
    @State private var isAuthenticating = false
    @State private var authSuccess = false
    @State private var authError: String?
    
    var biometricType: LABiometryType {
        let context = LAContext()
        var error: NSError?
        context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        return context.biometryType
    }
    
    var biometricTypeName: String {
        switch biometricType {
        case .faceID: return "Face ID"
        case .touchID: return "Touch ID"
        case .none: return "Biometric"
        @unknown default: return "Biometric"
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Spacer()
                
                Image(systemName: "lock.shield")
                    .font(.system(size: 80))
                    .foregroundStyle(.primary)
                
                Text("Enable App Lock")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("You'll need to use \(biometricTypeName) to open PennyWise and access your financial data. This adds an extra layer of security to protect your information.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                if let error = authError {
                    Text(error)
                        .font(.caption)
                        .foregroundStyle(.red)
                        .multilineTextAlignment(.center)
                }
                
                Button {
                    authenticate()
                } label: {
                    Text(isAuthenticating ? "Authenticating..." : "Enable \(biometricTypeName)")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(authSuccess ? Color.green : Color.blue)
                        .foregroundStyle(.white)
                        .cornerRadius(12)
                }
                .disabled(isAuthenticating || !authSuccess)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Setup App Lock")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func authenticate() {
        isAuthenticating = true
        
        Task {
            let context = LAContext()
            var error: NSError?
            
            guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
                await MainActor.run {
                    isAuthenticating = false
                    authError = "Biometric authentication is not available on this device."
                }
                return
            }
            
            do {
                let success = try await context.evaluatePolicy(
                    .deviceOwnerAuthenticationWithBiometrics,
                    localizedReason: "Enable App Lock to protect your financial data in PennyWise"
                )
                
                await MainActor.run {
                    isAuthenticating = false
                    authSuccess = success
                    
                    if success {
                        BiometricService.shared.setBiometricLockEnabled(true)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            dismiss()
                        }
                    } else {
                        authError = "Authentication failed. Please try again."
                    }
                }
            } catch {
                await MainActor.run {
                    isAuthenticating = false
                    authError = "Authentication failed: \(error.localizedDescription)"
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        SecuritySettingsView()
    }
}
