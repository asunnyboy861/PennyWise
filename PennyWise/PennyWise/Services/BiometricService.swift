//
//  BiometricService.swift
//  PennyWise
//
//  Service for Face ID / Touch ID authentication
//

import Foundation
import LocalAuthentication

enum BiometricType {
    case none
    case touchID
    case faceID
}

@MainActor
final class BiometricService: ObservableObject {
    static let shared = BiometricService()
    
    @Published var isAuthenticated = false
    @Published var biometricType: BiometricType = .none
    
    private let context = LAContext()
    private let userDefaults = UserDefaults.standard
    
    init() {
        checkBiometricAvailability()
    }
    
    private func checkBiometricAvailability() {
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            switch context.biometryType {
            case .faceID:
                biometricType = .faceID
            case .touchID:
                biometricType = .touchID
            case .opticID:
                biometricType = .faceID
            @unknown default:
                biometricType = .none
            }
        } else {
            biometricType = .none
        }
    }
    
    var isBiometricAvailable: Bool {
        return biometricType != .none
    }
    
    var biometricTypeName: String {
        switch biometricType {
        case .faceID:
            return "Face ID"
        case .touchID:
            return "Touch ID"
        case .none:
            return "None"
        }
    }
    
    /// Check if biometric lock is enabled
    var isBiometricLockEnabled: Bool {
        userDefaults.bool(forKey: "biometricLockEnabled")
    }
    
    /// Enable/disable biometric lock
    func setBiometricLockEnabled(_ enabled: Bool) {
        userDefaults.set(enabled, forKey: "biometricLockEnabled")
    }
    
    func authenticate(reason: String) async -> Bool {
        let context = LAContext()
        var error: NSError?
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            isAuthenticated = false
            return false
        }
        
        do {
            let success = try await context.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: reason
            )
            isAuthenticated = success
            return success
        } catch {
            print("Biometric authentication failed: \(error.localizedDescription)")
            isAuthenticated = false
            return false
        }
    }
    
    func authenticateWithPasscode(reason: String) async -> Bool {
        let context = LAContext()
        
        do {
            let success = try await context.evaluatePolicy(
                .deviceOwnerAuthentication,
                localizedReason: reason
            )
            isAuthenticated = success
            return success
        } catch {
            print("Authentication failed: \(error.localizedDescription)")
            isAuthenticated = false
            return false
        }
    }
    
    func lock() {
        isAuthenticated = false
    }
}
