import SwiftUI

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
