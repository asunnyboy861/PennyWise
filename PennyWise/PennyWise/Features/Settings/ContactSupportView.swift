//
//  ContactSupportView.swift
//  PennyWise
//
//  Contact Support Screen with Feedback Form
//

import SwiftUI

// MARK: - Feedback Subject Type

enum FeedbackSubject: String, CaseIterable, Identifiable {
    case general = "General Feedback"
    case bug = "Bug Report"
    case feature = "Feature Request"
    case account = "Account Issue"
    case billing = "Billing Question"
    case other = "Other"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .general: return "message.fill"
        case .bug: return "exclamationmark.triangle.fill"
        case .feature: return "lightbulb.fill"
        case .account: return "person.fill"
        case .billing: return "creditcard.fill"
        case .other: return "ellipsis.circle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .general: return Color(hex: "#007AFF")
        case .bug: return Color(hex: "#FF3B30")
        case .feature: return Color(hex: "#FF9500")
        case .account: return Color(hex: "#5856D6")
        case .billing: return Color(hex: "#34C759")
        case .other: return Color(hex: "#8E8E93")
        }
    }
    
    var description: String {
        switch self {
        case .general: return "Share your thoughts about the app"
        case .bug: return "Report something not working"
        case .feature: return "Suggest a new feature or improvement"
        case .account: return "Issues with your account or data"
        case .billing: return "Questions about subscriptions or payments"
        case .other: return "Anything else you'd like to share"
        }
    }
}

// MARK: - Contact Support View

struct ContactSupportView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    
    // Form Fields
    @State private var selectedSubject: FeedbackSubject = .general
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var message: String = ""
    
    // UI States
    @State private var isSubmitting: Bool = false
    @State private var showSuccessToast: Bool = false
    @State private var showErrorToast: Bool = false
    @State private var errorMessage: String = ""
    @State private var showSubjectPicker: Bool = false
    
    // Validation
    private var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        !email.trimmingCharacters(in: .whitespaces).isEmpty &&
        email.contains("@") &&
        !message.trimmingCharacters(in: .whitespaces).isEmpty &&
        message.count >= 10
    }
    
    private var backgroundColor: Color {
        colorScheme == .dark ? Color(hex: "#1C1C1E") : Color(hex: "#F2F2F7")
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header Illustration
                    headerSection
                    
                    // Subject Selection Cards
                    subjectSection
                    
                    // Contact Form
                    formSection
                    
                    // Submit Button
                    submitButton
                    
                    // Privacy Note
                    privacyNote
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            .background(backgroundColor.ignoresSafeArea())
            .navigationTitle("Contact Support")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .overlay {
                if showSuccessToast {
                    ToastView(
                        message: "Feedback sent successfully!",
                        type: .success,
                        onDismiss: {
                            showSuccessToast = false
                            dismiss()
                        }
                    )
                    .transition(.move(edge: .top))
                    .zIndex(1)
                }
                
                if showErrorToast {
                    ToastView(
                        message: errorMessage,
                        type: .error,
                        onDismiss: { showErrorToast = false }
                    )
                    .transition(.move(edge: .top))
                    .zIndex(1)
                }
            }
        }
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "envelope.badge.shield.half.filled")
                .font(.system(size: 60))
                .foregroundStyle(
                    LinearGradient(
                        colors: [AppColors.primary, Color(hex: "#5856D6")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            Text("We're here to help")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Have a question or feedback? We'd love to hear from you. Fill out the form below and we'll get back to you as soon as possible.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
        }
        .padding(.vertical, 8)
    }
    
    // MARK: - Subject Selection Section
    
    private var subjectSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("What can we help you with?")
                .font(.headline)
                .fontWeight(.semibold)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                ForEach(FeedbackSubject.allCases) { subject in
                    SubjectCard(
                        subject: subject,
                        isSelected: selectedSubject == subject
                    ) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedSubject = subject
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Form Section
    
    private var formSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your Information")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(spacing: 16) {
                // Name Field
                FormField(
                    icon: "person.fill",
                    title: "Name",
                    placeholder: "Enter your name",
                    text: $name
                )
                
                // Email Field
                FormField(
                    icon: "envelope.fill",
                    title: "Email",
                    placeholder: "your.email@example.com",
                    text: $email,
                    keyboardType: .emailAddress
                )
                
                // Message Field
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "text.bubble.fill")
                            .foregroundStyle(AppColors.primary)
                        Text("Message")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        Spacer()
                        Text("\(message.count) chars")
                            .font(.caption)
                            .foregroundStyle(message.count < 10 ? AppColors.danger : .secondary)
                    }
                    
                    TextEditor(text: $message)
                        .frame(minHeight: 120, maxHeight: 200)
                        .padding(12)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(message.count < 10 && !message.isEmpty ? AppColors.danger.opacity(0.5) : Color.clear, lineWidth: 1)
                        )
                }
            }
        }
    }
    
    // MARK: - Submit Button
    
    private var submitButton: some View {
        Button {
            submitFeedback()
        } label: {
            HStack {
                if isSubmitting {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .padding(.trailing, 8)
                }
                
                Text("Send Feedback")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                if !isSubmitting {
                    Image(systemName: "paperplane.fill")
                        .font(.subheadline)
                }
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                LinearGradient(
                    colors: isFormValid ? [AppColors.primary, Color(hex: "#5856D6")] : [Color.gray.opacity(0.5), Color.gray.opacity(0.3)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(16)
            .shadow(color: isFormValid ? AppColors.primary.opacity(0.3) : Color.clear, radius: 8, x: 0, y: 4)
        }
        .disabled(!isFormValid || isSubmitting)
        .padding(.top, 8)
    }
    
    // MARK: - Privacy Note
    
    private var privacyNote: some View {
        HStack(spacing: 8) {
            Image(systemName: "lock.shield.fill")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Text("Your information is secure and will only be used to respond to your feedback.")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 8)
    }
    
    // MARK: - Submit Feedback
    
    private func submitFeedback() {
        guard isFormValid else { return }
        
        isSubmitting = true
        
        let feedbackData: [String: Any] = [
            "name": name.trimmingCharacters(in: .whitespaces),
            "email": email.trimmingCharacters(in: .whitespaces),
            "subject": selectedSubject.rawValue,
            "message": message.trimmingCharacters(in: .whitespaces),
            "app_name": "PennyWise"
        ]
        
        guard let url = URL(string: "https://feedback-board.iocompile67692.workers.dev/api/feedback") else {
            showError("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: feedbackData)
        } catch {
            showError("Failed to encode data")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isSubmitting = false
                
                if let error = error {
                    showError("Network error: \(error.localizedDescription)")
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    showError("Invalid response")
                    return
                }
                
                if httpResponse.statusCode == 200 || httpResponse.statusCode == 201 {
                    withAnimation {
                        showSuccessToast = true
                    }
                } else {
                    showError("Server error (\(httpResponse.statusCode)). Please try again.")
                }
            }
        }.resume()
    }
    
    private func showError(_ message: String) {
        errorMessage = message
        withAnimation {
            showErrorToast = true
        }
    }
}

// MARK: - Subject Card

struct SubjectCard: View {
    let subject: FeedbackSubject
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 10) {
                Image(systemName: subject.icon)
                    .font(.system(size: 24))
                    .foregroundStyle(subject.color)
                
                Text(subject.rawValue)
                    .font(.subheadline)
                    .fontWeight(isSelected ? .semibold : .medium)
                    .foregroundStyle(isSelected ? .primary : .secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity, minHeight: 90)
            .padding(.horizontal, 8)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? subject.color.opacity(0.15) : Color(.secondarySystemBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? subject.color : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Form Field

struct FormField: View {
    let icon: String
    let title: String
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(AppColors.primary)
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            
            TextField(placeholder, text: $text)
                .keyboardType(keyboardType)
                .textContentType(title == "Name" ? .name : .emailAddress)
                .autocapitalization(title == "Name" ? .words : .none)
                .disableAutocorrection(title == "Email")
                .padding(12)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
        }
    }
}

// MARK: - Preview

#Preview {
    ContactSupportView()
}