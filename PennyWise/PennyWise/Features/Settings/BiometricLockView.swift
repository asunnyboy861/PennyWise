//
//  BiometricLockView.swift
//  PennyWise
//
//  Biometric lock screen for app security
//

import SwiftUI
import LocalAuthentication

struct BiometricLockView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var isUnlocked: Bool
    
    @State private var isAuthenticating = false
    @State private var errorMessage: String?
    @State private var usePasscode = false
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "lock.shield")
                .font(.system(size: 80))
                .foregroundStyle(.primary)
            
            Text("PennyWise is Locked")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Authenticate to access your financial data")
                .font(.body)
                .foregroundStyle(.secondary)
            
            if let error = errorMessage {
                Text(error)
                    .font(.caption)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
            }
            
            VStack(spacing: 15) {
                Button {
                    authenticateWithBiometrics()
                } label: {
                    HStack {
                        Image(systemName: "faceid")
                        Text("Use Face ID")
                    }
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundStyle(.white)
                    .cornerRadius(12)
                }
                .disabled(isAuthenticating)
                
                Button {
                    usePasscode = true
                } label: {
                    Text("Use Passcode Instead")
                        .fontWeight(.medium)
                        .foregroundStyle(.blue)
                }
            }
            .padding(.top)
            
            Spacer()
        }
        .padding()
        .sheet(isPresented: $usePasscode) {
            PasscodeAuthenticationView(isUnlocked: $isUnlocked)
        }
    }
    
    private func authenticateWithBiometrics() {
        isAuthenticating = true
        errorMessage = nil
        
        let context = LAContext()
        var error: NSError?
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            isAuthenticating = false
            errorMessage = "Biometric authentication is not available."
            return
        }
        
        Task {
            do {
                let success = try await context.evaluatePolicy(
                    .deviceOwnerAuthenticationWithBiometrics,
                    localizedReason: "Authenticate to access PennyWise and your financial data"
                )
                
                await MainActor.run {
                    isAuthenticating = false
                    if success {
                        isUnlocked = true
                    } else {
                        errorMessage = "Authentication failed. Please try again."
                    }
                }
            } catch {
                await MainActor.run {
                    isAuthenticating = false
                    errorMessage = "Authentication failed: \(error.localizedDescription)"
                }
            }
        }
    }
}

// MARK: - Passcode Authentication View

struct PasscodeAuthenticationView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var isUnlocked: Bool
    
    @State private var isAuthenticating = false
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Spacer()
                
                Image(systemName: "passkey.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(.primary)
                
                Text("Enter Passcode")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Use your device passcode to unlock PennyWise")
                    .font(.body)
                    .foregroundStyle(.secondary)
                
                if let error = errorMessage {
                    Text(error)
                        .font(.caption)
                        .foregroundStyle(.red)
                }
                
                Button {
                    authenticateWithPasscode()
                } label: {
                    Text(isAuthenticating ? "Authenticating..." : "Use Passcode")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundStyle(.white)
                        .cornerRadius(12)
                }
                .disabled(isAuthenticating)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Passcode Authentication")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func authenticateWithPasscode() {
        isAuthenticating = true
        
        let context = LAContext()
        
        Task {
            do {
                let success = try await context.evaluatePolicy(
                    .deviceOwnerAuthentication,
                    localizedReason: "Authenticate to access PennyWise"
                )
                
                await MainActor.run {
                    isAuthenticating = false
                    if success {
                        isUnlocked = true
                        dismiss()
                    } else {
                        errorMessage = "Authentication failed. Please try again."
                    }
                }
            } catch {
                await MainActor.run {
                    isAuthenticating = false
                    errorMessage = "Authentication failed: \(error.localizedDescription)"
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    BiometricLockView(isUnlocked: .constant(false))
}
