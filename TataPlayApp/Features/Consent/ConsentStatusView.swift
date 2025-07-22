//
//  ConsentStatusView.swift
//  TataPlayApp
//
//  Created by Arup Sarkar (TA) on 7/22/25.
//

import SwiftUI
import Cdp
import SFMCSDK

typealias Consent = SFMCSDK.Consent

struct ConsentStatusView: View {
    @AppStorage("hasConsented") private var hasConsented: Bool = false
    @State private var currentConsent: SFMCSDK.Consent = .none
    let onManageConsentTapped: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: SpacingTokens.md) {
            Text("Data Collection Preferences")
                .styled(.contentTitle)
            
            if hasConsented {
                consentStatusCard
            } else {
                noConsentCard
            }
        }
        .onAppear {
            updateConsentStatus()
        }
    }
    
    // MARK: - Consent Status Card (when user has made a choice)
    private var consentStatusCard: some View {
        HStack(spacing: SpacingTokens.md) {
            // Status icon
            Image(systemName: currentConsent == .optIn ? "checkmark.shield.fill" : "xmark.shield.fill")
                .font(.title2)
                .foregroundColor(currentConsent == SFMCSDK.Consent.optIn ? TataPlayColors.success : TataPlayColors.error)
            
            VStack(alignment: .leading, spacing: SpacingTokens.xs) {
                Text(currentConsent == .optIn ? "Data Collection Enabled" : "Data Collection Disabled")
                    .styled(.contentTitle)
                    .foregroundColor(currentConsent == .optIn ? TataPlayColors.success : TataPlayColors.error)
                
                Text(currentConsent == SFMCSDK.Consent.optIn ?
                     "You have opted in to data collection for personalized experience" :
                     "You have opted out of data collection")
                    .styled(.captionText)
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
            
            Button("Change") {
                onManageConsentTapped()
            }
            .font(TataPlayTypography.buttonSecondary)
            .foregroundColor(TataPlayColors.primary)
            .padding(.horizontal, SpacingTokens.md)
            .padding(.vertical, SpacingTokens.sm)
            .overlay(
                RoundedRectangle(cornerRadius: LayoutConstants.smallCardCornerRadius)
                    .stroke(TataPlayColors.primary, lineWidth: 1)
            )
        }
        .padding(SpacingTokens.cardInternalPadding)
        .background(
            (currentConsent == .optIn ? TataPlayColors.success : TataPlayColors.error)
                .opacity(0.1)
        )
        .cornerRadius(LayoutConstants.cardCornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: LayoutConstants.cardCornerRadius)
                .stroke(
                    currentConsent == .optIn ? TataPlayColors.success : TataPlayColors.error,
                    lineWidth: 1
                )
        )
    }
    
    // MARK: - No Consent Card (when user hasn't made a choice)
    private var noConsentCard: some View {
        VStack(spacing: SpacingTokens.md) {
            HStack(spacing: SpacingTokens.md) {
                Image(systemName: "questionmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(TataPlayColors.warning)
                
                VStack(alignment: .leading, spacing: SpacingTokens.xs) {
                    Text("Consent Not Provided")
                        .styled(.contentTitle)
                        .foregroundColor(TataPlayColors.warning)
                    
                    Text("Please set your data collection preferences")
                        .styled(.captionText)
                }
                
                Spacer()
            }
            
            Button("Set Preferences") {
                onManageConsentTapped()
            }
            .font(TataPlayTypography.buttonPrimary)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(SpacingTokens.buttonPadding)
            .background(TataPlayColors.primary)
            .cornerRadius(LayoutConstants.cardCornerRadius)
        }
        .padding(SpacingTokens.cardInternalPadding)
        .background(TataPlayColors.warning.opacity(0.1))
        .cornerRadius(LayoutConstants.cardCornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: LayoutConstants.cardCornerRadius)
                .stroke(TataPlayColors.warning, lineWidth: 1)
        )
    }
    
    // MARK: - Helper Methods
    private func updateConsentStatus() {
        currentConsent = ConsentService.shared.getCurrentConsent()
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 20) {
        ConsentStatusView(onManageConsentTapped: {
            print("Manage consent tapped")
        })
    }
    .padding()
    .background(TataPlayColors.background)
}
