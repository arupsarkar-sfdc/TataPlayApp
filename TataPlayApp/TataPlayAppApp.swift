// MARK: - TataPlayAppApp.swift
// Main app entry point with modern iOS architecture
// Based on JSON navigation: Home, Watch, Search, My Account, More

import SwiftUI

@main
struct TataPlayApp: App {
    @StateObject private var appState = AppState()
    @StateObject private var authenticationManager = AuthenticationManager()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appState)
                .environmentObject(authenticationManager)
                .preferredColorScheme(appState.colorScheme)
                .onAppear {
                    setupApp()
                }
        }
    }
    
    private func setupApp() {
        // Configure app-wide settings
        configureUIAppearance()
        
        // Initialize analytics
        appState.initializeAnalytics()
        
        // Check authentication status
        authenticationManager.checkAuthenticationStatus()
    }
    
    private func configureUIAppearance() {
        // Configure navigation bar appearance
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.backgroundColor = UIColor(TataPlayColors.navigationBackground)
        navigationBarAppearance.titleTextAttributes = [
            .foregroundColor: UIColor(TataPlayColors.navigationTitle),
            .font: UIFont.systemFont(ofSize: TataPlayTypography.title3, weight: .semibold)
        ]
        
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        
        // Configure tab bar appearance
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor(TataPlayColors.background)
        
        // Selected tab appearance
        tabBarAppearance.stackedLayoutAppearance.selected.iconColor = UIColor(TataPlayColors.tabBarSelected)
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(TataPlayColors.tabBarSelected),
            .font: UIFont.systemFont(ofSize: TataPlayTypography.captionSmall, weight: .medium)
        ]
        
        // Normal tab appearance
        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = UIColor(TataPlayColors.tabBarUnselected)
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(TataPlayColors.tabBarUnselected),
            .font: UIFont.systemFont(ofSize: TataPlayTypography.captionSmall, weight: .regular)
        ]
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
}

// MARK: - AppState
// Global app state management

@MainActor
class AppState: ObservableObject {
    @Published var colorScheme: ColorScheme? = nil
    @Published var isLoading = false
    @Published var networkStatus: NetworkStatus = .connected
    @Published var currentUser: User?
    @Published var selectedTab: TabItem = .home
    @Published var showOnboarding = false
    
    enum NetworkStatus {
        case connected
        case disconnected
        case poor
        
        var displayText: String {
            switch self {
            case .connected: return "Connected"
            case .disconnected: return "No Connection"
            case .poor: return "Poor Connection"
            }
        }
        
        var color: Color {
            switch self {
            case .connected: return TataPlayColors.success
            case .disconnected: return TataPlayColors.error
            case .poor: return TataPlayColors.warning
            }
        }
    }
    
    func initializeAnalytics() {
        // Initialize analytics and tracking
        // This will be implemented with Einstein integration
    }
    
    func updateNetworkStatus(_ status: NetworkStatus) {
        networkStatus = status
    }
    
    func setUser(_ user: User) {
        currentUser = user
    }
    
    func clearUser() {
        currentUser = nil
    }
}

// MARK: - AuthenticationManager
// Handle user authentication state

@MainActor
class AuthenticationManager: ObservableObject {
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var authenticationError: String?
    
    func checkAuthenticationStatus() {
        isLoading = true
        
        // Simulate authentication check
        // In production, this would check keychain/token validity
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.isLoading = false
            // For now, user starts unauthenticated
            self.isAuthenticated = false
        }
    }
    
    func signIn(email: String, password: String) async {
        isLoading = true
        authenticationError = nil
        
        do {
            // Simulate sign in process
            try await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
            
            // In production, this would call authentication service
            isAuthenticated = true
            isLoading = false
        } catch {
            authenticationError = "Sign in failed. Please try again."
            isLoading = false
        }
    }
    
    func signOut() {
        isAuthenticated = false
        authenticationError = nil
    }
}

// MARK: - RootView
// Root navigation container

struct RootView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var authManager: AuthenticationManager
    
    var body: some View {
        Group {
            if authManager.isLoading {
                LoadingView()
            } else if appState.showOnboarding {
                OnboardingView()
            } else if authManager.isAuthenticated {
                EnhancedMainTabView()
            } else {
                AuthenticationView()
            }
        }
        .animation(.easeInOut(duration: LayoutConstants.standardAnimation), value: authManager.isAuthenticated)
        .animation(.easeInOut(duration: LayoutConstants.standardAnimation), value: authManager.isLoading)
    }
}

// MARK: - MainTabView
// Main tab bar navigation (based on JSON navigation structure)

struct MainTabView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        TabView(selection: $appState.selectedTab) {
            // Home Tab (from JSON: "Home")
            HomeView()
                .tabItem {
                    TabItemView(
                        item: .home,
                        isSelected: appState.selectedTab == .home
                    )
                }
                .tag(TabItem.home)
            
            // Watch Tab (from JSON: "Watch")
            LiveTVView()
                .tabItem {
                    TabItemView(
                        item: .watch,
                        isSelected: appState.selectedTab == .watch
                    )
                }
                .tag(TabItem.watch)
            
            // Search Tab (content discovery)
            SearchView()
                .tabItem {
                    TabItemView(
                        item: .search,
                        isSelected: appState.selectedTab == .search
                    )
                }
                .tag(TabItem.search)
            
            // My Account Tab (from JSON: "Login" -> Account)
            MyAccountView()
                .tabItem {
                    TabItemView(
                        item: .account,
                        isSelected: appState.selectedTab == .account
                    )
                }
                .tag(TabItem.account)
            
            // More Tab (from JSON: "Get Help" + additional features)
            MoreView()
                .tabItem {
                    TabItemView(
                        item: .more,
                        isSelected: appState.selectedTab == .more
                    )
                }
                .tag(TabItem.more)
        }
        .accentColor(TataPlayColors.tabBarSelected)
        .background(TataPlayColors.background)
    }
}

// MARK: - TabItem Enum
// Tab bar items based on JSON navigation

enum TabItem: String, CaseIterable {
    case home = "home"
    case watch = "watch"
    case search = "search"
    case account = "account"
    case more = "more"
    
    var title: String {
        switch self {
        case .home: return "Home"
        case .watch: return "Watch"
        case .search: return "Search"
        case .account: return "My Account"
        case .more: return "More"
        }
    }
    
    var iconName: String {
        switch self {
        case .home: return "house"
        case .watch: return "tv"
        case .search: return "magnifyingglass"
        case .account: return "person.circle"
        case .more: return "ellipsis"
        }
    }
    
    var selectedIconName: String {
        switch self {
        case .home: return "house.fill"
        case .watch: return "tv.fill"
        case .search: return "magnifyingglass"
        case .account: return "person.circle.fill"
        case .more: return "ellipsis"
        }
    }
}

// MARK: - TabItemView
// Custom tab item view with proper styling

struct TabItemView: View {
    let item: TabItem
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: SpacingTokens.xs) {
            Image(systemName: isSelected ? item.selectedIconName : item.iconName)
                .font(.system(size: 20, weight: isSelected ? .semibold : .regular))
                .foregroundColor(isSelected ? TataPlayColors.tabBarSelected : TataPlayColors.tabBarUnselected)
            
            Text(item.title)
                .font(.custom(TataPlayTypography.secondaryFontFamily, size: TataPlayTypography.captionSmall))
                .fontWeight(isSelected ? .medium : .regular)
                .foregroundColor(isSelected ? TataPlayColors.tabBarSelected : TataPlayColors.tabBarUnselected)
        }
    }
}

// MARK: - Placeholder Views
// Temporary views for each tab (will be replaced in Phase 5)

struct HomeView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: SpacingTokens.sectionSpacing) {
                    // Hero Section
                    VStack(spacing: SpacingTokens.lg) {
                        Text("Welcome to Tata Play")
                            .styled(.heroTitle)
                        
                        Text("Your entertainment destination")
                            .styled(.heroSubtitle)
                    }
                    .contentPadding()
                    .sectionSpacing()
                    
                    // Quick Actions
                    LazyVGrid(columns: GridHelpers.contentGrid(), spacing: SpacingTokens.gridRowSpacing) {
                        QuickActionCard(
                            title: "Live TV",
                            subtitle: "Watch live channels",
                            iconName: "tv.fill",
                            color: TataPlayColors.entertainmentCategory
                        )
                        
                        QuickActionCard(
                            title: "Recharge",
                            subtitle: "Top up your account",
                            iconName: "creditcard.fill",
                            color: TataPlayColors.success
                        )
                        
                        QuickActionCard(
                            title: "Recordings",
                            subtitle: "Your saved content",
                            iconName: "record.circle.fill",
                            color: TataPlayColors.recordingIndicator
                        )
                        
                        QuickActionCard(
                            title: "Settings",
                            subtitle: "Manage preferences",
                            iconName: "gearshape.fill",
                            color: TataPlayColors.secondary
                        )
                    }
                    .contentPadding()
                }
            }
            .navigationTitle("Home")
            .background(TataPlayColors.background)
        }
    }
}

struct LiveTVView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Live TV")
                    .styled(.sectionHeading)
                
                Text("Channel grid and live streaming will be implemented here")
                    .styled(.bodyText)
                    .multilineTextAlignment(.center)
                    .contentPadding()
                
                Spacer()
            }
            .navigationTitle("Watch")
            .background(TataPlayColors.background)
        }
    }
}

struct SearchView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Search & Discovery")
                    .styled(.sectionHeading)
                
                Text("Content search and recommendations will be implemented here")
                    .styled(.bodyText)
                    .multilineTextAlignment(.center)
                    .contentPadding()
                
                Spacer()
            }
            .navigationTitle("Search")
            .background(TataPlayColors.background)
        }
    }
}

struct MyAccountView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("My Account")
                    .styled(.sectionHeading)
                
                Text("Profile, subscription, and billing management will be implemented here")
                    .styled(.bodyText)
                    .multilineTextAlignment(.center)
                    .contentPadding()
                
                Spacer()
            }
            .navigationTitle("My Account")
            .background(TataPlayColors.background)
        }
    }
}

struct MoreView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("More")
                    .styled(.sectionHeading)
                
                Text("Settings, help, and additional features will be implemented here")
                    .styled(.bodyText)
                    .multilineTextAlignment(.center)
                    .contentPadding()
                
                Spacer()
            }
            .navigationTitle("More")
            .background(TataPlayColors.background)
        }
    }
}

// MARK: - Supporting Views

struct LoadingView: View {
    var body: some View {
        VStack(spacing: SpacingTokens.lg) {
            ProgressView()
                .scaleEffect(1.5)
                .tint(TataPlayColors.primary)
            
            Text("Loading Tata Play...")
                .styled(.bodyText)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(TataPlayColors.background)
    }
}

struct OnboardingView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack(spacing: SpacingTokens.sectionSpacing) {
            Spacer()
            
            Text("Welcome to Tata Play")
                .styled(.heroTitle)
            
            Text("Your premium entertainment experience")
                .styled(.heroSubtitle)
            
            Spacer()
            
            Button("Get Started") {
                appState.showOnboarding = false
            }
            .font(TataPlayTypography.buttonPrimary)
            .foregroundColor(.white)
            .padding(SpacingTokens.buttonPadding)
            .background(TataPlayColors.primary)
            .cornerRadius(LayoutConstants.cardCornerRadius)
        }
        .contentPadding()
        .background(TataPlayColors.background)
    }
}

struct AuthenticationView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack(spacing: SpacingTokens.sectionSpacing) {
            Spacer()
            
            // Logo and title
            VStack(spacing: SpacingTokens.lg) {
                Image(systemName: "tv.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(TataPlayColors.primary)
                
                Text("Tata Play")
                    .styled(.heroTitle)
                
                Text("Sign in to continue")
                    .styled(.bodyText)
            }
            
            // Sign in form
            VStack(spacing: SpacingTokens.lg) {
                VStack(spacing: SpacingTokens.md) {
                    TextField("Email or Subscriber ID", text: $email)
                        .font(TataPlayTypography.inputField)
                        .padding(SpacingTokens.inputPadding)
                        .background(TataPlayColors.cardBackground)
                        .cornerRadius(LayoutConstants.smallCardCornerRadius)
                    
                    SecureField("Password", text: $password)
                        .font(TataPlayTypography.inputField)
                        .padding(SpacingTokens.inputPadding)
                        .background(TataPlayColors.cardBackground)
                        .cornerRadius(LayoutConstants.smallCardCornerRadius)
                }
                
                if let error = authManager.authenticationError {
                    Text(error)
                        .styled(.captionText)
                        .foregroundColor(TataPlayColors.error)
                }
                
                Button(action: {
                    Task {
                        await authManager.signIn(email: email, password: password)
                    }
                }) {
                    if authManager.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("Sign In")
                            .font(TataPlayTypography.buttonPrimary)
                    }
                }
                .disabled(authManager.isLoading || email.isEmpty || password.isEmpty)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(SpacingTokens.buttonPadding)
                .background(
                    (authManager.isLoading || email.isEmpty || password.isEmpty) ?
                    TataPlayColors.textSecondary : TataPlayColors.primary
                )
                .cornerRadius(LayoutConstants.cardCornerRadius)
            }
            .contentPadding()
            
            Spacer()
            
            // Quick sign in for demo
            Button("Demo Sign In") {
                Task {
                    await authManager.signIn(email: "demo@tataplay.com", password: "demo123")
                }
            }
            .font(TataPlayTypography.buttonSecondary)
            .foregroundColor(TataPlayColors.primary)
        }
        .contentPadding()
        .background(TataPlayColors.background)
    }
}

struct QuickActionCard: View {
    let title: String
    let subtitle: String
    let iconName: String
    let color: Color
    
    var body: some View {
        VStack(spacing: SpacingTokens.md) {
            Image(systemName: iconName)
                .font(.system(size: 32))
                .foregroundColor(color)
            
            VStack(spacing: SpacingTokens.xs) {
                Text(title)
                    .styled(.contentTitle)
                
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
}
