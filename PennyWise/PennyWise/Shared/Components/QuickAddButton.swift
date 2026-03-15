//
//  QuickAddButton.swift
//  PennyWise
//
//  Floating Action Button for quick transaction entry
//  Optimized for iOS 17+ with SwiftUI
//

import SwiftUI

struct QuickAddButton: View {
    @Binding var isPresented: Bool
    
    private let buttonSize: CGFloat = 60
    
    var body: some View {
        Button {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            isPresented = true
        } label: {
            ZStack {
                Circle()
                    .fill(AppColors.primary)
                    .frame(width: buttonSize, height: buttonSize)
                    .shadow(color: AppColors.primary.opacity(0.4), radius: 8, x: 0, y: 4)
                
                Image(systemName: "plus")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.white)
            }
        }
    }
}

#Preview {
    @Previewable @State var isPresented = false
    
    ZStack {
        Color.gray.opacity(0.3)
        VStack {
            Spacer()
            QuickAddButton(isPresented: $isPresented)
                .padding(.trailing, 20)
                .padding(.bottom, 100)
        }
    }
}
