//
//  StreakCard.swift
//  PennyWise
//
//  Streak display card component
//  REUSES: AppColors from Color+Extensions.swift
//

import SwiftUI

struct StreakCard: View {
    let currentStreak: Int
    let longestStreak: Int
    let totalActiveDays: Int
    let message: String
    let emoji: String
    let isActiveToday: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Your Streak")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text(emoji)
                            .font(.title)
                        Text("\(currentStreak)")
                            .font(.system(size: 40, weight: .bold))
                        Text("days")
                            .font(.title3)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Spacer()
                
                if isActiveToday {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title2)
                        .foregroundStyle(AppColors.success)
                } else {
                    Button {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    } label: {
                        Text("Check In")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(AppColors.primary)
                            .clipShape(Capsule())
                    }
                }
            }
            
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Divider()
            
            HStack(spacing: 24) {
                VStack(spacing: 4) {
                    Text("\(longestStreak)")
                        .font(.title3)
                        .fontWeight(.semibold)
                    Text("Best")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                VStack(spacing: 4) {
                    Text("\(totalActiveDays)")
                        .font(.title3)
                        .fontWeight(.semibold)
                    Text("Total")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    StreakCard(
        currentStreak: 7,
        longestStreak: 14,
        totalActiveDays: 30,
        message: "7 days! You're building a habit!",
        emoji: "⭐",
        isActiveToday: true
    )
    .padding()
}
