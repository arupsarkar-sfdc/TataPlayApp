import SwiftUI

// MARK: - MyAccountView
// Account management based on JSON: account_management, subscription_billing, recharge_subscription

struct MyAccountView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var navigationCoordinator: NavigationCoordinator
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var showingProfileEdit = false
    @State private var showingBillingDetails = false
    
    var body: some View {
        NavigationStack(path: $navigationCoordinator.accountNavigationPath) {
            ScrollView {
                VStack(spacing: SpacingTokens.sectionSpacing) {
                    // Profile Header
                    profileHeaderSection
                    
                    // Subscription Overview
                    subscriptionOverviewSection
                    
                    // Quick Actions
                    quickActionsSection
                    
                    // Account Management
                    accountManagementSection
                    
                    // Settings & Support
                    settingsSection
                }
                .contentPadding()
            }
            .navigationTitle("My Account")
            .navigationBarTitleDisplayMode(.large)
            .background(TataPlayColors.background)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    profileEditButton
                }
            }
            .navigationDestination(for: String.self) { destination in
                destinationView(for: destination)
            }
        }
    }
    
    // MARK: - Profile Header Section
    private var profileHeaderSection: some View {
        VStack(spacing: SpacingTokens.lg) {
            // Profile Picture and Basic Info
            HStack(spacing: SpacingTokens.lg) {
                // Profile Avatar
                Circle()
                    .fill(TataPlayColors.primary.opacity(0.1))
                    .frame(width: 80, height: 80)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.title)
                            .foregroundColor(TataPlayColors.primary)
                    )
                    .overlay(
                        Circle()
                            .stroke(TataPlayColors.primary.opacity(0.2), lineWidth: 2)
                    )
                
                // User Information
                VStack(alignment: .leading, spacing: SpacingTokens.sm) {
                    Text(currentUser.name)
                        .styled(.contentTitle)
                    
                    Text("Subscriber ID: \(currentUser.subscriberId)")
                        .styled(.captionText)
                        .foregroundColor(TataPlayColors.textSecondary)
                    
                    HStack(spacing: SpacingTokens.sm) {
                        Circle()
                            .fill(currentUser.isActive ? TataPlayColors.success : TataPlayColors.error)
                            .frame(width: 8, height: 8)
                        
                        Text(currentUser.isActive ? "Active" : "Inactive")
                            .styled(.captionText)
                            .foregroundColor(currentUser.isActive ? TataPlayColors.success : TataPlayColors.error)
                    }
                }
                
                Spacer()
            }
            .padding(SpacingTokens.cardInternalPadding)
            .background(TataPlayColors.cardBackground)
            .cornerRadius(LayoutConstants.cardCornerRadius)
        }
    }

    // MARK: - Subscription Overview Section
    private var subscriptionOverviewSection: some View {
        VStack(alignment: .leading, spacing: SpacingTokens.lg) {
            Text("Current Subscription")
                .styled(.sectionHeading)
            
            VStack(spacing: SpacingTokens.md) {
                // Subscription Card
                VStack(alignment: .leading, spacing: SpacingTokens.lg) {
                    // Plan Header
                    HStack {
                        VStack(alignment: .leading, spacing: SpacingTokens.xs) {
                            Text(currentUser.subscription.planName)
                                .styled(.contentTitle)
                            
                            Text(currentUser.subscription.planType)
                                .styled(.captionText)
                                .foregroundColor(TataPlayColors.textSecondary)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: SpacingTokens.xs) {
                            Text("₹\(currentUser.subscription.monthlyPrice)")
                                .styled(.priceDisplay)
                            
                            Text("/month")
                                .styled(.captionText)
                                .foregroundColor(TataPlayColors.textSecondary)
                        }
                    }
                    
                    // Subscription Details
                    VStack(spacing: SpacingTokens.sm) {
                        SubscriptionDetailRow(
                            title: "Channels",
                            value: "\(currentUser.subscription.channelCount)+"
                        )
                        
                        SubscriptionDetailRow(
                            title: "HD Channels",
                            value: "\(currentUser.subscription.hdChannelCount)"
                        )
                        
                        SubscriptionDetailRow(
                            title: "OTT Apps",
                            value: "\(currentUser.subscription.ottApps.count)"
                        )
                        
                        SubscriptionDetailRow(
                            title: "Validity",
                            value: currentUser.subscription.expiryDate
                        )
                    }
                    
                    // Renewal Button
                    Button(action: {
                        navigationCoordinator.navigateToSubscriptionDetails()
                    }) {
                        Text("Manage Subscription")
                            .font(TataPlayTypography.buttonSecondary)
                            .foregroundColor(TataPlayColors.primary)
                            .frame(maxWidth: .infinity)
                            .padding(SpacingTokens.buttonPadding)
                            .overlay(
                                RoundedRectangle(cornerRadius: LayoutConstants.cardCornerRadius)
                                    .stroke(TataPlayColors.primary, lineWidth: 1)
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(SpacingTokens.cardInternalPadding)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            TataPlayColors.primary.opacity(0.05),
                            TataPlayColors.accent.opacity(0.02)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(LayoutConstants.cardCornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: LayoutConstants.cardCornerRadius)
                        .stroke(TataPlayColors.primary.opacity(0.2), lineWidth: 1)
                )
            }
        }
    }
    
    // MARK: - Quick Actions Section (from JSON user_flows)
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: SpacingTokens.lg) {
            Text("Quick Actions")
                .styled(.sectionHeading)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: SpacingTokens.gridRowSpacing) {
                // Recharge (from JSON: recharge_subscription)
                QuickActionCard(
                    title: "Recharge",
                    subtitle: "Top up your account",
                    iconName: "creditcard.fill",
                    color: TataPlayColors.accent
                ) {
                    navigationCoordinator.presentRecharge()
                }
                
                // View Bill
                QuickActionCard(
                    title: "View Bill",
                    subtitle: "Check your billing",
                    iconName: "doc.text.fill",
                    color: TataPlayColors.info
                ){
                    navigationCoordinator.navigateToBillingHistory()
                }
                
                // Track Order (from JSON navigation)
                QuickActionCard(
                    title: "Track Order",
                    subtitle: "Check order status",
                    iconName: "location.fill",
                    color: TataPlayColors.warning
                ){
                    navigationCoordinator.navigateToExternal(.trackOrder(), parameter: nil)
                }
                
                // Get Help (from JSON navigation)
                QuickActionCard(
                    title: "Get Help",
                    subtitle: "Support & FAQs",
                    iconName: "questionmark.circle.fill",
                    color: TataPlayColors.accent
                ){
                    navigationCoordinator.navigateToHelpCenter()
                }
            }
        }
    }

    // MARK: - Account Management Section
    private var accountManagementSection: some View {
        VStack(alignment: .leading, spacing: SpacingTokens.lg) {
            Text("Account Management")
                .styled(.sectionHeading)
            
            VStack(spacing: SpacingTokens.sm) {
                // Subscription Details
                AccountMenuRow(
                    title: "Subscription Details",
                    subtitle: "Manage your plan and add-ons",
                    iconName: "rectangle.stack.fill",
                    color: TataPlayColors.primary
                ) {
                    navigationCoordinator.navigateToSubscriptionDetails()
                }
                
                // Billing History
                AccountMenuRow(
                    title: "Billing History",
                    subtitle: "View transactions and payments",
                    iconName: "doc.plaintext.fill",
                    color: TataPlayColors.success
                ) {
                    navigationCoordinator.navigateToBillingHistory()
                }
                
                // Payment Methods
                AccountMenuRow(
                    title: "Payment Methods",
                    subtitle: "Manage cards and payment options",
                    iconName: "wallet.pass.fill",
                    color: TataPlayColors.accent
                ) {
                    navigationCoordinator.navigateToContentDetail(contentId: "payment-methods", in: .account)
                }
                
                // Channel Packages
                AccountMenuRow(
                    title: "Channel Packages",
                    subtitle: "Add or remove channel packs",
                    iconName: "tv.fill",
                    color: TataPlayColors.entertainmentCategory
                ) {
                    navigationCoordinator.presentChannelPackages()
                }
                
                // Recordings (from JSON key_features: recording_functionality)
                AccountMenuRow(
                    title: "My Recordings",
                    subtitle: "Manage recorded content",
                    iconName: "record.circle.fill",
                    color: TataPlayColors.recordingIndicator
                ) {
                    navigationCoordinator.navigateToContentDetail(contentId: "recordings", in: .account)
                }
            }
        }
    }

    // MARK: - Profile Edit Button
    private var profileEditButton: some View {
        Button(action: {
            showingProfileEdit = true
        }) {
            Image(systemName: "pencil.circle")
                .font(.title3)
                .foregroundColor(TataPlayColors.primary)
        }
        .sheet(isPresented: $showingProfileEdit) {
            ProfileEditView()
        }
    }
    
    // MARK: - Settings Section
    private var settingsSection: some View {
        VStack(alignment: .leading, spacing: SpacingTokens.lg) {
            Text("Settings & Support")
                .styled(.sectionHeading)
            
            VStack(spacing: SpacingTokens.sm) {
                // Account Settings
                AccountMenuRow(
                    title: "Account Settings",
                    subtitle: "Privacy, notifications, preferences",
                    iconName: "gearshape.fill",
                    color: TataPlayColors.secondary
                ) {
                    navigationCoordinator.navigateToAccountSettings()
                }
                
                // Language & Region
                AccountMenuRow(
                    title: "Language & Region",
                    subtitle: "App language and regional settings",
                    iconName: "globe.fill",
                    color: TataPlayColors.regionalCategory
                ) {
                    navigationCoordinator.presentLanguageSelection()
                }
                
                // Parental Controls (from JSON key_features)
                AccountMenuRow(
                    title: "Parental Controls",
                    subtitle: "Content restrictions and PIN",
                    iconName: "hand.raised.fill",
                    color: TataPlayColors.warning
                ) {
                    navigationCoordinator.navigateToContentDetail(contentId: "parental-controls", in: .account)
                }
                
                // Help & Support
                AccountMenuRow(
                    title: "Help & Support",
                    subtitle: "FAQs, contact us, live chat",
                    iconName: "questionmark.circle.fill",
                    color: TataPlayColors.info
                ) {
                    navigationCoordinator.navigateToHelpCenter()
                }
                
                // About App
                AccountMenuRow(
                    title: "About",
                    subtitle: "App version, terms, privacy policy",
                    iconName: "info.circle.fill",
                    color: TataPlayColors.textSecondary
                ) {
                    navigationCoordinator.navigateToContentDetail(contentId: "about", in: .account)
                }
            }
            
            // Sign Out Button
            VStack(spacing: SpacingTokens.lg) {
                Divider()
                    .background(TataPlayColors.separator)
                
                Button(action: {
                    authManager.signOut()
                }) {
                    HStack {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .foregroundColor(TataPlayColors.error)
                        
                        Text("Sign Out")
                            .font(TataPlayTypography.buttonSecondary)
                            .foregroundColor(TataPlayColors.error)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(SpacingTokens.buttonPadding)
                    .overlay(
                        RoundedRectangle(cornerRadius: LayoutConstants.cardCornerRadius)
                            .stroke(TataPlayColors.error, lineWidth: 1)
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }

    // MARK: - Current User Mock Data
    private var currentUser: MockUser {
        MockUser(
            name: "Arup Sarkar",
            subscriberId: "TP123456789",
            email: "arup@example.com",
            phoneNumber: "+91 98765 43210",
            isActive: true,
            subscription: MockSubscription(
                planName: "Tata Play Premium HD",
                planType: "DTH + OTT",
                monthlyPrice: 599,
                channelCount: 350,
                hdChannelCount: 125,
                ottApps: ["Disney+ Hotstar", "SonyLIV", "Zee5", "Voot"],
                expiryDate: "31 Mar 2025",
                autoRenewal: true
            )
        )
    }

    // MARK: - Navigation Destination Handler
    @ViewBuilder
    private func destinationView(for destination: String) -> some View {
        if destination == "subscriptionDetails" {
            SubscriptionDetailsView()
        } else if destination == "billingHistory" {
            BillingHistoryView()
        } else if destination == "accountSettings" {
            AccountSettingsView()
        } else if destination == "helpCenter" {
            HelpCenterView()
        } else if destination.starts(with: "contentDetail_") {
            let contentId = String(destination.dropFirst("contentDetail_".count))
            AccountContentDetailView(contentId: contentId)
        } else {
            Text("Account: \(destination)")
                .styled(.bodyText)
                .navigationTitle("Account Details")
        }
    }
    
    // MARK: - Mock Data Models
    struct MockUser {
        let name: String
        let subscriberId: String
        let email: String
        let phoneNumber: String
        let isActive: Bool
        let subscription: MockSubscription
    }

    struct MockSubscription {
        let planName: String
        let planType: String
        let monthlyPrice: Int
        let channelCount: Int
        let hdChannelCount: Int
        let ottApps: [String]
        let expiryDate: String
        let autoRenewal: Bool
    }

    // MARK: - Supporting UI Components

    struct SubscriptionDetailRow: View {
        let title: String
        let value: String
        
        var body: some View {
            HStack {
                Text(title)
                    .styled(.captionText)
                    .foregroundColor(TataPlayColors.textSecondary)
                
                Spacer()
                
                Text(value)
                    .styled(.captionText)
                    .fontWeight(.medium)
            }
        }
    }

    struct AccountMenuRow: View {
        let title: String
        let subtitle: String
        let iconName: String
        let color: Color
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                HStack(spacing: SpacingTokens.lg) {
                    // Icon
                    Image(systemName: iconName)
                        .font(.title3)
                        .foregroundColor(color)
                        .frame(width: 24, height: 24)
                    
                    // Content
                    VStack(alignment: .leading, spacing: SpacingTokens.xs) {
                        Text(title)
                            .styled(.contentTitle)
                            .multilineTextAlignment(.leading)
                        
                        Text(subtitle)
                            .styled(.captionText)
                            .multilineTextAlignment(.leading)
                    }
                    
                    Spacer()
                    
                    // Chevron
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(TataPlayColors.textSecondary)
                }
                .padding(SpacingTokens.lg)
                .background(TataPlayColors.cardBackground)
                .cornerRadius(LayoutConstants.cardCornerRadius)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }

    struct QuickActionCard: View {
        let title: String
        let subtitle: String
        let iconName: String
        let color: Color
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                VStack(spacing: SpacingTokens.md) {
                    Image(systemName: iconName)
                        .font(.title2)
                        .foregroundColor(color)
                        .frame(width: 40, height: 40)
                    
                    VStack(spacing: SpacingTokens.xs) {
                        Text(title)
                            .styled(.contentTitle)
                            .multilineTextAlignment(.center)
                        
                        Text(subtitle)
                            .styled(.captionText)
                            .multilineTextAlignment(.center)
                    }
                }
                .frame(maxWidth: .infinity)
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

    struct ProfileEditView: View {
        @Environment(\.dismiss) private var dismiss
        @State private var name = "Arup Sarkar"
        @State private var email = "arup@example.com"
        @State private var phoneNumber = "+91 98765 43210"
        
        var body: some View {
            NavigationView {
                Form {
                    Section("Personal Information") {
                        HStack {
                            Text("Name")
                            Spacer()
                            TextField("Full Name", text: $name)
                                .multilineTextAlignment(.trailing)
                        }
                        
                        HStack {
                            Text("Email")
                            Spacer()
                            TextField("Email Address", text: $email)
                                .multilineTextAlignment(.trailing)
                                .keyboardType(.emailAddress)
                        }
                        
                        HStack {
                            Text("Phone")
                            Spacer()
                            TextField("Phone Number", text: $phoneNumber)
                                .multilineTextAlignment(.trailing)
                                .keyboardType(.phonePad)
                        }
                    }
                    
                    Section("Preferences") {
                        HStack {
                            Text("Language")
                            Spacer()
                            Text("English")
                                .foregroundColor(TataPlayColors.textSecondary)
                        }
                        
                        HStack {
                            Text("Region")
                            Spacer()
                            Text("India")
                                .foregroundColor(TataPlayColors.textSecondary)
                        }
                    }
                }
                .navigationTitle("Edit Profile")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") { dismiss() }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Save") {
                            // Save profile changes
                            dismiss()
                        }
                        .fontWeight(.semibold)
                    }
                }
            }
        }
    }

    struct AccountContentDetailView: View {
        let contentId: String
        
        var body: some View {
            ScrollView {
                VStack(alignment: .leading, spacing: SpacingTokens.lg) {
                    Text(getContentTitle(for: contentId))
                        .styled(.contentTitle)
                    
                    Text("Content for \(contentId) will be implemented here.")
                        .styled(.bodyText)
                    
                    Text("This includes detailed information and management options for this account feature.")
                        .styled(.captionText)
                }
                .contentPadding()
            }
            .navigationTitle(getContentTitle(for: contentId))
            .navigationBarTitleDisplayMode(.inline)
        }
        
        private func getContentTitle(for contentId: String) -> String {
            switch contentId {
            case "payment-methods": return "Payment Methods"
            case "recordings": return "My Recordings"
            case "parental-controls": return "Parental Controls"
            case "about": return "About"
            default: return "Account Details"
            }
        }
    }
}
