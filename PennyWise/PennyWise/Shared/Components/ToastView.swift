//
//  ToastView.swift
//  PennyWise
//
//  Toast notification component for user feedback
//

import SwiftUI

/// Toast notification view for displaying brief messages
struct ToastView: View {
    let message: String
    let type: ToastType
    let onDismiss: () -> Void
    
    @State private var offset: CGFloat = 100
    @State private var opacity: Double = 0
    
    var body: some View {
        HStack {
            Image(systemName: type.iconName)
                .font(.subheadline.weight(.semibold))
            Text(message)
                .font(.subheadline.weight(.medium))
        }
        .foregroundColor(type.textColor)
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(type.backgroundColor)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
        .offset(y: offset)
        .opacity(opacity)
        .onAppear {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                offset = 0
                opacity = 1
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                dismiss()
            }
        }
    }
    
    private func dismiss() {
        withAnimation(.easeOut(duration: 0.3)) {
            offset = 100
            opacity = 0
        } completion: {
            onDismiss()
        }
    }
}

// MARK: - Toast Type

enum ToastType {
    case success
    case error
    case warning
    case info
    
    var iconName: String {
        switch self {
        case .success: return "checkmark.circle.fill"
        case .error: return "exclamationmark.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .info: return "info.circle.fill"
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .success: return Color(hex: "#34C759")
        case .error: return Color(hex: "#FF3B30")
        case .warning: return Color(hex: "#FF9500")
        case .info: return Color(hex: "#007AFF")
        }
    }
    
    var textColor: Color {
        .white
    }
}

// MARK: - View Extension

extension View {
    /// Add a toast notification to the view
    /// - Parameters:
    ///   - message: Binding to optional message string. Set to nil to dismiss.
    ///   - type: Type of toast (success, error, warning, info)
    func toast(message: Binding<String?>, type: ToastType = .info) -> some View {
        modifier(ToastModifier(message: message, type: type))
    }
}

struct ToastModifier: ViewModifier {
    @Binding var message: String?
    let type: ToastType
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if let message = message {
                ToastView(
                    message: message,
                    type: type,
                    onDismiss: {
                        self.message = nil
                    }
                )
            }
        }
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 20) {
        ToastView(
            message: "Transaction saved successfully!",
            type: .success,
            onDismiss: {}
        )
        
        ToastView(
            message: "Failed to sync with iCloud",
            type: .error,
            onDismiss: {}
        )
        
        ToastView(
            message: "Budget limit approaching",
            type: .warning,
            onDismiss: {}
        )
        
        ToastView(
            message: "Data exported successfully",
            type: .info,
            onDismiss: {}
        )
    }
    .padding()
}
