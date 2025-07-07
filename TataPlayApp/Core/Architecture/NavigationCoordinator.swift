import SwiftUI
import Combine

// MARK: - SimpleNavigationCoordinator.swift
// Simplified navigation coordinator that avoids complex type issues

@MainActor
class NavigationCoordinator: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var homeNavigationPath = NavigationPath()
    @Published var watchNavigationPath = NavigationPath()
    @Published var searchNavigationPath = NavigationPath()
    @Published var accountNavigationPath = NavigationPath()
    @Published var moreNavigationPath = NavigationPath()
    
    @Published var showSheet = false
    @Published var sheetType: SheetType?
    @Published var showFullScreen = false
    @Published var fullScreenType: FullScreenType?
    @Published var showAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    // MARK: - Step 8: Enhanced Navigation Properties
    @Published var showExternalLinkAlert = false
    @Published var pendingExternalURL: URL?
    
    // MARK: - Simple Navigation Types
    
    enum SheetType: CaseIterable {
        case recharge
        case channelPackages
        case userProfile
        case notifications
        case languageSelection
        case quickPayment
        
        var title: String {
            switch self {
            case .recharge: return "Recharge"
            case .channelPackages: return "Channel Packages"
            case .userProfile: return "User Profile"
            case .notifications: return "Notifications"
            case .languageSelection: return "Language Selection"
            case .quickPayment: return "Quick Payment"
            }
        }
    }
    
    enum FullScreenType: CaseIterable {
        case liveTV
        case onDemandVideo
        case authentication
        case onboarding
        
        var title: String {
            switch self {
            case .liveTV: return "Live TV"
            case .onDemandVideo: return "On Demand Video"
            case .authentication: return "Authentication"
            case .onboarding: return "Onboarding"
            }
        }
    }
    
    // MARK: - Step 8: External Navigation Types

    enum ExternalNavigationTarget {
        case watch(channelId: String? = nil)
        case trackOrder(orderId: String? = nil)
        case recharge(planType: String? = nil)
        case help(section: String? = nil)
        case login
        
        var baseURL: String {
            switch self {
            case .watch: return "https://watch.tataplay.com"
            case .trackOrder: return "https://www.tataplayrecharge.com/my-account/raise-req-new"
            case .recharge: return "https://www.tataplayrecharge.com/Recharge/QuickRecharge"
            case .help: return "https://www.tataplay.com/dth/help"
            case .login: return "/my-account/login"
            }
        }
        
        func fullURL(with parameter: String? = nil) -> URL? {
            var urlString = baseURL
            if let parameter = parameter {
                switch self {
                case .watch:
                    urlString += "/channel/\(parameter)"
                case .trackOrder:
                    urlString += "?order=\(parameter)"
                case .recharge:
                    urlString += "?plan=\(parameter)"
                case .help:
                    urlString += "#\(parameter)"
                default:
                    break
                }
            }
            return URL(string: urlString)
        }
    }
    
    // MARK: - Navigation Methods
    
    func navigateToChannelDetail(channelId: String, in tab: TabItem) {
        switch tab {
        case .home:
            homeNavigationPath.append("channelDetail_\(channelId)")
        case .watch:
            watchNavigationPath.append("channelDetail_\(channelId)")
        default:
            break
        }
    }
    
    func navigateToContentDetail(contentId: String, in tab: TabItem) {
        switch tab {
        case .home:
            homeNavigationPath.append("contentDetail_\(contentId)")
        case .search:
            searchNavigationPath.append("contentDetail_\(contentId)")
        default:
            break
        }
    }
    
    func navigateToSubscriptionDetails() {
        accountNavigationPath.append("subscriptionDetails")
    }
    
    func navigateToBillingHistory() {
        accountNavigationPath.append("billingHistory")
    }
    
    func navigateToAccountSettings() {
        accountNavigationPath.append("accountSettings")
    }
    
    func navigateToHelpCenter() {
        moreNavigationPath.append("helpCenter")
    }
    
    func navigateToSearchResults(query: String) {
        searchNavigationPath.append("searchResults_\(query)")
    }
    
    // MARK: - Sheet Methods
    
    func presentRecharge() {
        sheetType = .recharge
        showSheet = true
    }
    
    func presentChannelPackages() {
        sheetType = .channelPackages
        showSheet = true
    }
    
    func presentUserProfile() {
        sheetType = .userProfile
        showSheet = true
    }
    
    func presentNotifications() {
        sheetType = .notifications
        showSheet = true
    }
    
    func presentLanguageSelection() {
        sheetType = .languageSelection
        showSheet = true
    }
    
    func presentQuickPayment() {
        sheetType = .quickPayment
        showSheet = true
    }
    
    func dismissSheet() {
        showSheet = false
        sheetType = nil
    }
    
    // MARK: - Full Screen Methods
    
    func presentLiveTV() {
        fullScreenType = .liveTV
        showFullScreen = true
    }
    
    func presentOnDemandVideo() {
        fullScreenType = .onDemandVideo
        showFullScreen = true
    }
    
    func dismissFullScreen() {
        showFullScreen = false
        fullScreenType = nil
    }
    
    // MARK: - Alert Methods
    
    func presentAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
    
    func dismissAlert() {
        showAlert = false
        alertTitle = ""
        alertMessage = ""
    }
    
    // MARK: - Navigation Helpers
    
    func popToRoot(in tab: TabItem) {
        switch tab {
        case .home:
            homeNavigationPath = NavigationPath()
        case .watch:
            watchNavigationPath = NavigationPath()
        case .search:
            searchNavigationPath = NavigationPath()
        case .account:
            accountNavigationPath = NavigationPath()
        case .more:
            moreNavigationPath = NavigationPath()
        }
    }
    
    func pop(in tab: TabItem) {
        switch tab {
        case .home:
            if !homeNavigationPath.isEmpty {
                homeNavigationPath.removeLast()
            }
        case .watch:
            if !watchNavigationPath.isEmpty {
                watchNavigationPath.removeLast()
            }
        case .search:
            if !searchNavigationPath.isEmpty {
                searchNavigationPath.removeLast()
            }
        case .account:
            if !accountNavigationPath.isEmpty {
                accountNavigationPath.removeLast()
            }
        case .more:
            if !moreNavigationPath.isEmpty {
                moreNavigationPath.removeLast()
            }
        }
    }
    
    // MARK: - Entertainment-Specific Navigation
    
    func startWatchingChannel(channelId: String) {
        presentLiveTV()
    }
    
    func startWatchingContent(contentId: String) {
        presentOnDemandVideo()
    }
    
    func showRechargeFlow() {
        presentRecharge()
    }
    
    func showChannelPackages() {
        presentChannelPackages()
    }
    
    // MARK: - Step 8: External Navigation Methods

    func navigateToExternal(_ target: ExternalNavigationTarget, parameter: String? = nil) {
        guard let url = target.fullURL(with: parameter) else { return }
        pendingExternalURL = url
        showExternalLinkAlert = true
    }

    func confirmExternalNavigation() {
        guard let url = pendingExternalURL else { return }
        UIApplication.shared.open(url)
        pendingExternalURL = nil
        showExternalLinkAlert = false
    }

    func cancelExternalNavigation() {
        pendingExternalURL = nil
        showExternalLinkAlert = false
    }
    
}

// MARK: - Enhanced MainTabView with Simple Navigation

struct EnhancedMainTabView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var navigationCoordinator = NavigationCoordinator()
    
    var body: some View {
        TabView(selection: $appState.selectedTab) {
            // Home Tab with Navigation Stack
            NavigationStack(path: $navigationCoordinator.homeNavigationPath) {
                HomeView()
                    .navigationDestination(for: String.self) { destination in
                        destinationView(for: destination)
                    }
            }
            .tabItem {
                TabItemView(item: .home, isSelected: appState.selectedTab == .home)
            }
            .tag(TabItem.home)
            
            // Watch Tab with Navigation Stack
            NavigationStack(path: $navigationCoordinator.watchNavigationPath) {
                LiveTVView()
                    .navigationDestination(for: String.self) { destination in
                        destinationView(for: destination)
                    }
            }
            .tabItem {
                TabItemView(item: .watch, isSelected: appState.selectedTab == .watch)
            }
            .tag(TabItem.watch)
            
            // Search Tab with Navigation Stack
            NavigationStack(path: $navigationCoordinator.searchNavigationPath) {
                SearchView()
                    .navigationDestination(for: String.self) { destination in
                        destinationView(for: destination)
                    }
            }
            .tabItem {
                TabItemView(item: .search, isSelected: appState.selectedTab == .search)
            }
            .tag(TabItem.search)
            
            // Account Tab with Navigation Stack
            NavigationStack(path: $navigationCoordinator.accountNavigationPath) {
                MyAccountView()
                    .navigationDestination(for: String.self) { destination in
                        destinationView(for: destination)
                    }
            }
            .tabItem {
                TabItemView(item: .account, isSelected: appState.selectedTab == .account)
            }
            .tag(TabItem.account)
            
            // More Tab with Navigation Stack
            NavigationStack(path: $navigationCoordinator.moreNavigationPath) {
                MoreView()
                    .navigationDestination(for: String.self) { destination in
                        destinationView(for: destination)
                    }
            }
            .tabItem {
                TabItemView(item: .more, isSelected: appState.selectedTab == .more)
            }
            .tag(TabItem.more)
        }
        .environmentObject(navigationCoordinator)
        .sheet(isPresented: $navigationCoordinator.showSheet) {
            if let sheetType = navigationCoordinator.sheetType {
                sheetView(for: sheetType)
            }
        }
        .fullScreenCover(isPresented: $navigationCoordinator.showFullScreen) {
            if let fullScreenType = navigationCoordinator.fullScreenType {
                fullScreenView(for: fullScreenType)
            }
        }
        .alert(navigationCoordinator.alertTitle, isPresented: $navigationCoordinator.showAlert) {
//            Button("OK") {
//                navigationCoordinator.dismissAlert()
//            }
            Button("Open") {
                navigationCoordinator.confirmExternalNavigation()
            }
            Button("Cancel", role: .cancel) {
                navigationCoordinator.cancelExternalNavigation()
            }
        } message: {
            Text(navigationCoordinator.alertMessage)
        }
    }
    
    // MARK: - View Builders
    
    @ViewBuilder
    private func destinationView(for destination: String) -> some View {
        if destination.starts(with: "channelDetail_") {
            let channelId = String(destination.dropFirst("channelDetail_".count))
            ChannelDetailView(channelId: channelId)
        } else if destination.starts(with: "contentDetail_") {
            let contentId = String(destination.dropFirst("contentDetail_".count))
            ContentDetailView(contentId: contentId)
        } else if destination.starts(with: "searchResults_") {
            let query = String(destination.dropFirst("searchResults_".count))
            SearchResultsView(query: query)
        } else {
            switch destination {
            case "subscriptionDetails":
                SubscriptionDetailsView()
            case "billingHistory":
                BillingHistoryView()
            case "accountSettings":
                AccountSettingsView()
            case "helpCenter":
                HelpCenterView()
            default:
                Text("Unknown destination: \(destination)")
                    .styled(.bodyText)
            }
        }
    }
    
    @ViewBuilder
    private func sheetView(for sheetType: NavigationCoordinator.SheetType) -> some View {
        NavigationView {
            VStack {
                Text(sheetType.title)
                    .styled(.sectionHeading)
                
                Text("This is the \(sheetType.title) sheet")
                    .styled(.bodyText)
                    .contentPadding()
                
                Button("Close") {
                    navigationCoordinator.dismissSheet()
                }
                .font(TataPlayTypography.buttonSecondary)
                .foregroundColor(TataPlayColors.primary)
                .padding()
                
                Spacer()
            }
            .navigationTitle(sheetType.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        navigationCoordinator.dismissSheet()
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func fullScreenView(for fullScreenType: NavigationCoordinator.FullScreenType) -> some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack {
                Text(fullScreenType.title)
                    .styled(.heroTitle)
                    .foregroundColor(.white)
                
                Text("Full screen \(fullScreenType.title) view")
                    .styled(.bodyText)
                    .foregroundColor(.white)
                
                Button("Close") {
                    navigationCoordinator.dismissFullScreen()
                }
                .font(TataPlayTypography.buttonPrimary)
                .foregroundColor(.white)
                .padding(SpacingTokens.buttonPadding)
                .background(TataPlayColors.primary)
                .cornerRadius(LayoutConstants.cardCornerRadius)
                .padding()
            }
        }
    }
}

// MARK: - Simple Detail Views

struct ChannelDetailView: View {
    let channelId: String
    @EnvironmentObject var navigationCoordinator: NavigationCoordinator
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SpacingTokens.lg) {
                Text("Channel Details")
                    .styled(.contentTitle)
                
                Text("Channel ID: \(channelId)")
                    .styled(.bodyText)
                
                Text("This would show channel information, current program, upcoming shows, etc.")
                    .styled(.captionText)
                
                Button("Watch Live") {
                    navigationCoordinator.startWatchingChannel(channelId: channelId)
                }
                .font(TataPlayTypography.buttonPrimary)
                .foregroundColor(.white)
                .padding(SpacingTokens.buttonPadding)
                .background(TataPlayColors.primary)
                .cornerRadius(LayoutConstants.cardCornerRadius)
                
                Button("Show Recharge") {
                    navigationCoordinator.showRechargeFlow()
                }
                .font(TataPlayTypography.buttonSecondary)
                .foregroundColor(TataPlayColors.primary)
                .padding(SpacingTokens.buttonPadding)
                .overlay(
                    RoundedRectangle(cornerRadius: LayoutConstants.cardCornerRadius)
                        .stroke(TataPlayColors.primary, lineWidth: 1)
                )
                
                // MARK: - Step 8: External Navigation Example
                Button("Open in Tata Play Web") {
                    navigationCoordinator.navigateToExternal(.watch(), parameter: channelId)
                }
                .font(TataPlayTypography.buttonSecondary)
                .foregroundColor(TataPlayColors.secondary)
                .padding(SpacingTokens.buttonPadding)
                .overlay(
                    RoundedRectangle(cornerRadius: LayoutConstants.cardCornerRadius)
                        .stroke(TataPlayColors.secondary, lineWidth: 1)
                )
            }
            .contentPadding()
        }
        .navigationTitle("Channel")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ContentDetailView: View {
    let contentId: String
    @EnvironmentObject var navigationCoordinator: NavigationCoordinator
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SpacingTokens.lg) {
                Text("Content Details")
                    .styled(.contentTitle)
                
                Text("Content ID: \(contentId)")
                    .styled(.bodyText)
                
                Text("This would show content information, description, cast, etc.")
                    .styled(.captionText)
                
                Button("Watch Now") {
                    navigationCoordinator.startWatchingContent(contentId: contentId)
                }
                .font(TataPlayTypography.buttonPrimary)
                .foregroundColor(.white)
                .padding(SpacingTokens.buttonPadding)
                .background(TataPlayColors.primary)
                .cornerRadius(LayoutConstants.cardCornerRadius)
            }
            .contentPadding()
        }
        .navigationTitle("Content")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SearchResultsView: View {
    let query: String
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SpacingTokens.lg) {
                Text("Search Results")
                    .styled(.contentTitle)
                
                Text("Query: \(query)")
                    .styled(.bodyText)
                
                Text("This would show search results for the query.")
                    .styled(.captionText)
            }
            .contentPadding()
        }
        .navigationTitle("Search")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SubscriptionDetailsView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SpacingTokens.lg) {
                Text("Subscription Details")
                    .styled(.contentTitle)
                
                Text("Plan: Premium HD")
                    .styled(.bodyText)
                
                Text("Expiry: 31 Dec 2024")
                    .styled(.bodyText)
                
                Text("Channels: 250+")
                    .styled(.bodyText)
            }
            .contentPadding()
        }
        .navigationTitle("Subscription")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct BillingHistoryView: View {
    @EnvironmentObject var navigationCoordinator: NavigationCoordinator
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SpacingTokens.lg) {
                Text("Billing History")
                    .styled(.contentTitle)
                
                Text("Recent transactions and payment history would be shown here.")
                    .styled(.bodyText)
                
                // MARK: - Step 8: External Navigation for Billing
                Button("Recharge Now") {
                    navigationCoordinator.navigateToExternal(.recharge(), parameter: nil)
                }
                .font(TataPlayTypography.buttonPrimary)
                .foregroundColor(.white)
                .padding(SpacingTokens.buttonPadding)
                .background(TataPlayColors.primary)
                .cornerRadius(LayoutConstants.cardCornerRadius)

                Button("Track Recent Order") {
                    navigationCoordinator.navigateToExternal(.trackOrder(), parameter: nil)
                }
                .font(TataPlayTypography.buttonSecondary)
                .foregroundColor(TataPlayColors.primary)
                .padding(SpacingTokens.buttonPadding)
                .overlay(
                    RoundedRectangle(cornerRadius: LayoutConstants.cardCornerRadius)
                        .stroke(TataPlayColors.primary, lineWidth: 1)
                )
            }
            .contentPadding()
        }
        .navigationTitle("Billing")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AccountSettingsView: View {
    @EnvironmentObject var navigationCoordinator: NavigationCoordinator
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SpacingTokens.lg) {
                Text("Account Settings")
                    .styled(.contentTitle)
                
                Text("Profile settings, preferences, and account management options.")
                    .styled(.bodyText)
                
                // MARK: - Step 8: External Navigation Examples
                Button("Get Help Online") {
                    navigationCoordinator.navigateToExternal(.help(), parameter: "account-settings")
                }
                .font(TataPlayTypography.buttonSecondary)
                .foregroundColor(TataPlayColors.primary)
                .padding(SpacingTokens.buttonPadding)
                .overlay(
                    RoundedRectangle(cornerRadius: LayoutConstants.cardCornerRadius)
                        .stroke(TataPlayColors.primary, lineWidth: 1)
                )

                Button("Recharge Online") {
                    navigationCoordinator.navigateToExternal(.recharge(), parameter: nil)
                }
                .font(TataPlayTypography.buttonSecondary)
                .foregroundColor(TataPlayColors.secondary)
                .padding(SpacingTokens.buttonPadding)
                .overlay(
                    RoundedRectangle(cornerRadius: LayoutConstants.cardCornerRadius)
                        .stroke(TataPlayColors.secondary, lineWidth: 1)
                )
            }
            .contentPadding()
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct HelpCenterView: View {
    @EnvironmentObject var navigationCoordinator: NavigationCoordinator
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SpacingTokens.lg) {
                Text("Help Center")
                    .styled(.contentTitle)
                
                Text("FAQs, support articles, and contact information.")
                    .styled(.bodyText)
                
                // MARK: - Step 8: External Help Navigation
                Button("Visit Help Website") {
                    navigationCoordinator.navigateToExternal(.help(), parameter: "mobile-app")
                }
                .font(TataPlayTypography.buttonPrimary)
                .foregroundColor(.white)
                .padding(SpacingTokens.buttonPadding)
                .background(TataPlayColors.primary)
                .cornerRadius(LayoutConstants.cardCornerRadius)

                Button("Track Your Order") {
                    navigationCoordinator.navigateToExternal(.trackOrder(), parameter: nil)
                }
                .font(TataPlayTypography.buttonSecondary)
                .foregroundColor(TataPlayColors.primary)
                .padding(SpacingTokens.buttonPadding)
                .overlay(
                    RoundedRectangle(cornerRadius: LayoutConstants.cardCornerRadius)
                        .stroke(TataPlayColors.primary, lineWidth: 1)
                )
            }
            .contentPadding()
        }
        .navigationTitle("Help")
        .navigationBarTitleDisplayMode(.inline)
    }
}
