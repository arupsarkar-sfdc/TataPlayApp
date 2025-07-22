//
//  ConsentView.swift
//  TataPlayApp
//
//  Created by Arup Sarkar (TA) on 7/22/25.
//

import SwiftUI

struct ConsentView: View {
    @AppStorage("hasConsented") private var hasConsented: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Data Collection Consent")
                .font(.title)
                .bold()
            
            Text("We collect data to improve your shopping experience. Please choose your preference below.")
                .multilineTextAlignment(.center)
                .padding()
            
            Button(action: {
                ConsentService.shared.setConsent(isOptedIn: true)
                hasConsented = true
            }) {
                Text("Allow Data Collection")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            
            Button(action: {
                ConsentService.shared.setConsent(isOptedIn: false)
                hasConsented = true
            }) {
                Text("Decline")
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.blue, lineWidth: 1)
                    )
            }
        }
        .padding()
    }
}
