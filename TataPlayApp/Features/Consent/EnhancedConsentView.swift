//
//  EnhancedConsentView.swift
//  TataPlayApp
//
//  Created by Arup Sarkar (TA) on 7/22/25.
//

import SwiftUI
import Cdp


struct EnhancedConsentView: View {
    @Binding var isPresented: Bool
    let onConsentChanged: () -> Void
    
    @AppStorage("hasConsented") private var hasConsented: Bool = false
    @State private var selectedChoice: ConsentChoice?
    @State private var isSubmitting = false
    
    enum ConsentChoice {
        case allow
        case decline
        
        var title: String {
            switch self {
            case .allow: return "Allow Data Collection"
            case .decline: return "Decline"
            }
        }
        
        var description: String {
            switch self {
            case .allow: return "Help us personalize your experience"
            case .decline: return "Use app with basic functionality"
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: SpacingTokens.sectionSpacing) {
                // Header Section
                headerSection
                
                // Consent Options
                VStack(spacing: SpacingTokens.md) {
                    consentOptionCard(for: .allow)
                    consentOptionCard(for: .decline)
                }
                
                Spacer()
                
                // Action Button
                submitButton
            }
            .contentPadding()
            .navigationTitle("Privacy Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
            }
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: SpacingTokens.lg) {
            Image(systemName: "shield.checkerboard")
                .font(.system(size: 60))
                .foregroundColor(TataPlayColors.primary)
            
            Text("Data Collection Consent")
                .styled(.heroTitle)
                .multilineTextAlignment(.center)
            
            Text("We collect data to improve your entertainment experience and provide personalized recommendations.")
                .styled(.bodyText)
                .multilineTextAlignment(.center)
        }
    }
    
    // MARK: - Consent Option Card
    private func consentOptionCard(for choice: ConsentChoice) -> some View {
        Button(action: {
            selectedChoice = choice
        }) {
            HStack(spacing: SpacingTokens.md) {
                // Selection indicator (radio button)
                ZStack {
                    Circle()
                        .stroke(TataPlayColors.primary, lineWidth: 2)
                        .frame(width: 24, height: 24)
                    
                    if selectedChoice == choice {
                        Circle()
                            .fill(TataPlayColors.primary)
                            .frame(width: 12, height: 12)
                    }
                }
                
                VStack(alignment: .leading, spacing: SpacingTokens.xs) {
                    Text(choice.title)
                        .styled(.contentTitle)
                        .foregroundColor(TataPlayColors.accent)
                    
                    Text(choice.description)
                        .styled(.captionText)
                        .foregroundColor(TataPlayColors.textSecondary)
                }
                
                Spacer()
            }
            .padding(SpacingTokens.cardInternalPadding)
            .background(
                selectedChoice == choice ?
                TataPlayColors.primary.opacity(0.1) : TataPlayColors.cardBackground
            )
            .cornerRadius(LayoutConstants.cardCornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: LayoutConstants.cardCornerRadius)
                    .stroke(
                        selectedChoice == choice ? TataPlayColors.primary : TataPlayColors.cardBackground,
                        lineWidth: selectedChoice == choice ? 2 : 1
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - Submit Button
    private var submitButton: some View {
        Button(action: submitConsent) {
            if isSubmitting {
                HStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                    Text("Saving...")
                }
            } else {
                Text("Save Preferences")
            }
        }
        .disabled(selectedChoice == nil || isSubmitting)
        .font(TataPlayTypography.buttonPrimary)
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
        .padding(SpacingTokens.buttonPadding)
        .background(
            selectedChoice == nil || isSubmitting ?
            TataPlayColors.textSecondary : TataPlayColors.primary
        )
        .cornerRadius(LayoutConstants.cardCornerRadius)
    }
    
    // MARK: - Actions
    private func submitConsent() {
        guard let choice = selectedChoice else { return }
        
        isSubmitting = true
        
        // Simulate network delay for better UX
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let isOptedIn = choice == .allow
            ConsentService.shared.setConsent(isOptedIn: isOptedIn)
            hasConsented = true
            
            isSubmitting = false
            isPresented = false
            onConsentChanged()
        }
    }
}

// MARK: - Preview
#Preview {
    EnhancedConsentView(
        isPresented: .constant(true),
        onConsentChanged: {
            print("Consent changed")
        }
    )
}

