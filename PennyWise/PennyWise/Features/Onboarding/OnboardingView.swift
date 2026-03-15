//
//  OnboardingView.swift
//  PennyWise
//
//  Onboarding flow for first-time users
//  REUSES: AppColors from Color+Extensions.swift
//

import SwiftUI

struct OnboardingView: View {
    @Binding var isOnboardingComplete: Bool
    @State private var currentStep = 0
    @State private var monthlyBudget: Double = 1800
    @State private var budgetText: String = "1800"
    
    private let steps = [
        OnboardingStep(
            title: "Welcome to PennyWise",
            subtitle: "Your personal finance companion",
            description: "Track expenses, set budgets, and achieve your financial goals with ease.",
            icon: "dollarsign.circle.fill",
            color: AppColors.primary
        ),
        OnboardingStep(
            title: "Set Your Budget",
            subtitle: "Monthly spending limit",
            description: "Set a monthly budget to help you stay on track with your spending.",
            icon: "chart.pie.fill",
            color: AppColors.success
        ),
        OnboardingStep(
            title: "Ready to Start",
            subtitle: "Let's begin!",
            description: "You're all set! Start tracking your expenses and take control of your finances.",
            icon: "checkmark.circle.fill",
            color: AppColors.primary
        )
    ]
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Progress indicator
                HStack(spacing: 8) {
                    ForEach(0..<steps.count, id: \.self) { index in
                        Capsule()
                            .fill(index <= currentStep ? AppColors.primary : Color(.systemGray4))
                            .frame(height: 4)
                    }
                }
                .padding(.horizontal, 40)
                .padding(.top, 20)
                
                Spacer()
                
                // Step content
                VStack(spacing: 24) {
                    Image(systemName: steps[currentStep].icon)
                        .font(.system(size: 80))
                        .foregroundStyle(steps[currentStep].color)
                    
                    VStack(spacing: 8) {
                        Text(steps[currentStep].title)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text(steps[currentStep].subtitle)
                            .font(.title3)
                            .foregroundStyle(.secondary)
                    }
                    
                    Text(steps[currentStep].description)
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    
                    // Budget input for step 1
                    if currentStep == 1 {
                        VStack(spacing: 12) {
                            Text("Monthly Budget")
                                .font(.headline)
                            
                            HStack {
                                Text("$")
                                    .font(.title2)
                                    .foregroundStyle(.secondary)
                                
                                TextField("Budget", text: $budgetText)
                                    .font(.system(size: 40, weight: .bold))
                                    .keyboardType(.decimalPad)
                                    .multilineTextAlignment(.center)
                                    .onChange(of: budgetText) { newValue in
                                        if let value = Double(newValue) {
                                            monthlyBudget = value
                                        }
                                    }
                            }
                            .padding()
                            .background(Color(.secondarySystemGroupedBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            
                            Text("You can change this later in Settings")
                                .font(.caption)
                                .foregroundStyle(.tertiary)
                        }
                        .padding(.horizontal, 40)
                    }
                }
                
                Spacer()
                
                // Navigation buttons
                VStack(spacing: 16) {
                    Button {
                        if currentStep < steps.count - 1 {
                            withAnimation {
                                currentStep += 1
                            }
                        } else {
                            completeOnboarding()
                        }
                    } label: {
                        Text(currentStep < steps.count - 1 ? "Continue" : "Get Started")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(AppColors.primary)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    
                    if currentStep > 0 {
                        Button("Back") {
                            withAnimation {
                                currentStep -= 1
                            }
                        }
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    }
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
            }
        }
    }
    
    private func completeOnboarding() {
        UserDefaults.standard.set(monthlyBudget, forKey: "monthlyBudget")
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        isOnboardingComplete = true
    }
}

struct OnboardingStep {
    let title: String
    let subtitle: String
    let description: String
    let icon: String
    let color: Color
}

#Preview {
    @Previewable @State var isComplete = false
    OnboardingView(isOnboardingComplete: $isComplete)
}
