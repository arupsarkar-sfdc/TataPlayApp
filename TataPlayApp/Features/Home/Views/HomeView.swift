import SwiftUI

// MARK: - HomeView
// Main dashboard based on JSON content_sections and user_flows

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var navigationCoordinator: NavigationCoordinator
    @State private var showingUserTypeSelection = false
    
    var body: some View {
        NavigationStack(path: $navigationCoordinator.homeNavigationPath) {
            ScrollView {
                VStack(spacing: SpacingTokens.sectionSpacing) {
                    // Hero Section
                    heroSection
                    
                    // User Flow Section (from JSON content_sections)
                    userFlowSection
                    
                    // Quick Actions (from JSON key_features)
                    quickActionsSection
                }
                .contentPadding()
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.automatic)
            .background(TataPlayColors.background)
            .navigationDestination(for: String.self) { destination in
                destinationView(for: destination)
            }
        }
    }
    
    // MARK: - Hero Section
    private var heroSection: some View {
        VStack(spacing: SpacingTokens.lg) {
            // Welcome message
            VStack(spacing: SpacingTokens.md) {
                Text("Welcome to Tata Play")
                    .styled(.heroTitle)
                    .multilineTextAlignment(.center)
                
                Text("Your entertainment destination")
                    .styled(.heroSubtitle)
                    .multilineTextAlignment(.center)
            }
            
            // Live indicator (from JSON key_features: live_tv_streaming)
            HStack(spacing: SpacingTokens.sm) {
                Circle()
                    .fill(TataPlayColors.liveIndicator)
                    .frame(width: 8, height: 8)
                
                Text("Live TV Available")
                    .styled(.captionText)
                    .foregroundColor(TataPlayColors.liveIndicator)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(SpacingTokens.cardInternalPadding)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [TataPlayColors.primary.opacity(0.1), TataPlayColors.accent.opacity(0.05)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(LayoutConstants.cardCornerRadius)
    }
    
    // MARK: - User Flow Section (from JSON content_sections)
    private var userFlowSection: some View {
        VStack(alignment: .leading, spacing: SpacingTokens.lg) {
            Text("What would you like to do?")
                .styled(.sectionHeading)
            
            VStack(spacing: SpacingTokens.md) {
                // Existing customer flow (JSON priority 1)
                UserFlowCard(
                    title: "Existing customer?",
                    subtitle: "Manage your account and services",
                    iconName: "person.circle.fill",
                    color: TataPlayColors.primary,
                    action: {
                        navigationCoordinator.navigateToContentDetail(contentId: "my-account", in: .home)
                    }
                )
                
                // New customer flows (from JSON cta_buttons)
                UserFlowCard(
                    title: "I want a new DTH Connection",
                    subtitle: "Get started with Tata Play DTH",
                    iconName: "tv.fill",
                    color: TataPlayColors.entertainmentCategory,
                    action: {
                        showingUserTypeSelection = true
                    }
                )
                
                UserFlowCard(
                    title: "I want DTH Connection + OTT Apps",
                    subtitle: "Complete entertainment package",
                    iconName: "tv.and.hifispeaker.fill",
                    color: TataPlayColors.accent,
                    action: {
                        showingUserTypeSelection = true
                    }
                )
                
                UserFlowCard(
                    title: "I want to enjoy OTT Apps",
                    subtitle: "Stream your favorite content",
                    iconName: "play.rectangle.on.rectangle.fill",
                    color: TataPlayColors.secondary,
                    action: {
                        showingUserTypeSelection = true
                    }
                )
            }
        }
    }
    
    // MARK: - Quick Actions (from JSON key_features)
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: SpacingTokens.lg) {
            Text("Quick Actions")
                .styled(.sectionHeading)
            
            LazyVGrid(columns: GridHelpers.contentGrid(), spacing: SpacingTokens.gridRowSpacing) {
                // Live TV (key_features: live_tv_streaming)
                // Live TV (key_features: live_tv_streaming)
                QuickActionCard(
                    title: "Live TV",
                    subtitle: "Watch live channels",
                    iconName: "tv.fill",
                    color: TataPlayColors.entertainmentCategory
                )

                // Recharge (from JSON navigation: Recharge)
                QuickActionCard(
                    title: "Recharge",
                    subtitle: "Top up your account",
                    iconName: "creditcard.fill",
                    color: TataPlayColors.success
                )

                // Recordings (key_features: recording_functionality)
                QuickActionCard(
                    title: "Recordings",
                    subtitle: "Your saved content",
                    iconName: "record.circle.fill",
                    color: TataPlayColors.recordingIndicator
                )

                // Channel Management (key_features: channel_management)
                QuickActionCard(
                    title: "Channels",
                    subtitle: "Manage your lineup",
                    iconName: "list.bullet.rectangle.fill",
                    color: TataPlayColors.secondary
                )
            }
        }
    }
    
    // MARK: - Navigation Destination Handler
    @ViewBuilder
    private func destinationView(for destination: String) -> some View {
        if destination.starts(with: "my-account") {
            Text("My Account Details")
                .styled(.contentTitle)
                .navigationTitle("My Account")
        } else if destination.starts(with: "recordings") {
            Text("Your Recordings")
                .styled(.contentTitle)
                .navigationTitle("Recordings")
        } else {
            Text("Content: \(destination)")
                .styled(.bodyText)
                .navigationTitle("Details")
        }
    }

    // MARK: - Supporting Views

    struct UserFlowCard: View {
        let title: String
        let subtitle: String
        let iconName: String
        let color: Color
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                HStack(spacing: SpacingTokens.md) {
                    Image(systemName: iconName)
                        .font(.title2)
                        .foregroundColor(color)
                        .frame(width: 40, height: 40)
                    
                    VStack(alignment: .leading, spacing: SpacingTokens.xs) {
                        Text(title)
                            .styled(.contentTitle)
                            .multilineTextAlignment(.leading)
                        
                        Text(subtitle)
                            .styled(.captionText)
                            .multilineTextAlignment(.leading)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(TataPlayColors.textSecondary)
                }
                .padding(SpacingTokens.cardInternalPadding)
                .background(TataPlayColors.cardBackground)
                .cornerRadius(LayoutConstants.cardCornerRadius)
                .shadow(
                    color: .black.opacity(LayoutConstants.cardShadowOpacity),
                    radius: LayoutConstants.cardShadowRadius,
                    x: LayoutConstants.cardShadowOffset.width,
                    y: LayoutConstants.cardShadowOffset.height
                )
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}
