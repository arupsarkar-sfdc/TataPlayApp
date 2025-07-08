import Foundation
import Combine

// MARK: - Personalization Service Protocol
protocol PersonalizationServiceProtocol {
    func getChannelRecommendations() async throws -> PersonalizationResponse
    func getContentRecommendations(for contentType: String) async throws -> PersonalizationResponse
    func refreshRecommendations() async throws
    func setUserPreferences(_ preferences: PersonalizationPreferences)
}

// MARK: - Personalization Service Implementation
class PersonalizationService: PersonalizationServiceProtocol, ObservableObject {
    
    // MARK: - Singleton
    static let shared = PersonalizationService()
    
    // MARK: - Properties
    @Published private(set) var isLoading = false
    @Published private(set) var lastError: PersonalizationError?
    @Published private(set) var lastUpdated: Date?
    
    private var cachedChannelRecommendations: PersonalizationResponse?
    private var cacheExpiry: TimeInterval = 300 // 5 minutes
    private var currentUserPreferences: PersonalizationPreferences
    
    // MARK: - Configuration
    private let baseURL = "https://api.salesforce.com/einstein/personalization/v1"
    private let apiKey = "SIMULATED_API_KEY" // In production, store securely
    private let timeout: TimeInterval = 10.0
    
    // MARK: - Initialization
    private init() {
        // Initialize with default user preferences
        self.currentUserPreferences = PersonalizationPreferences.defaultPreferences
        
        // Load cached preferences if available
        loadUserPreferences()
    }
    
    // MARK: - Public Methods
    func getChannelRecommendations() async throws -> PersonalizationResponse {
        // Check cache first
        if let cached = cachedChannelRecommendations,
           let lastUpdated = lastUpdated,
           Date().timeIntervalSince(lastUpdated) < cacheExpiry {
            print("📱 PersonalizationService: Returning cached channel recommendations")
            return cached
        }
        
        // Fetch fresh recommendations
        return try await fetchChannelRecommendations()
    }
    
    func getContentRecommendations(for contentType: String) async throws -> PersonalizationResponse {
        print("📱 PersonalizationService: Fetching content recommendations for type: \(contentType)")
        return try await simulateEinsteinAPI(for: .content(contentType))
    }
    
    func refreshRecommendations() async throws {
        print("📱 PersonalizationService: Force refreshing recommendations")
        cachedChannelRecommendations = nil
        lastUpdated = nil
        _ = try await fetchChannelRecommendations()
    }
    
    func setUserPreferences(_ preferences: PersonalizationPreferences) {
        currentUserPreferences = preferences
        saveUserPreferences()
        
        // Invalidate cache when preferences change
        cachedChannelRecommendations = nil
        lastUpdated = nil
        
        print("📱 PersonalizationService: Updated user preferences - \(preferences.topCategories.joined(separator: ", "))")
    }
    
    // MARK: - Private Methods
    private func fetchChannelRecommendations() async throws -> PersonalizationResponse {
        await MainActor.run {
            isLoading = true
            lastError = nil
        }
        
        defer {
            Task { @MainActor in
                isLoading = false
            }
        }
        
        do {
            let response = try await simulateEinsteinAPI(for: .channels)
            
            // Cache the response
            cachedChannelRecommendations = response
            await MainActor.run {
                lastUpdated = Date()
            }
            
            print("📱 PersonalizationService: Successfully fetched \(response.recommendations.count) channel recommendations")
            return response
            
        } catch {
            await MainActor.run {
                lastError = error as? PersonalizationError ?? .unknown
            }
            throw error
        }
    }
    
    private func simulateEinsteinAPI(for requestType: APIRequestType) async throws -> PersonalizationResponse {
        print("\n" + "🚀" * 40)
        print("SIMULATING SALESFORCE EINSTEIN PERSONALIZATION API")
        print("🚀" * 40)
        print("📋 Request Type: \(requestType)")
        print("👤 User Segment: \(currentUserPreferences.userSegment)")
        print("🕐 Time of Day: \(getCurrentTimeOfDay())")
        print("📊 Top Categories: \(currentUserPreferences.topCategories.joined(separator: ", "))")
        print("🚀" * 40)
        
        // Simulate network delay
        let delay = Double.random(in: 0.5...2.0)
        try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        
        // Simulate occasional API failures (5% chance)
        if Double.random(in: 0...1) < 0.05 {
            print("❌ Simulated API Error")
            throw PersonalizationError.networkError("Simulated network timeout")
        }
        
        // Generate personalized recommendations based on user preferences
        let recommendations = generatePersonalizedRecommendations(for: requestType)
        
        let response = PersonalizationResponse(
            recommendations: recommendations,
            personalizationContext: PersonalizationContext(
                userSegment: currentUserPreferences.userSegment,
                timeOfDay: getCurrentTimeOfDay(),
                topCategories: currentUserPreferences.topCategories,
                sessionId: AnalyticsService.shared.getSessionInfo()["sessionId"] as? String ?? "unknown",
                lastUpdated: Date()
            ),
            metadata: PersonalizationMetadata(
                modelVersion: "einstein-v2.1",
                confidence: Double.random(in: 0.75...0.95),
                processingTime: delay
            )
        )
        
        // Log the response
        logPersonalizationResponse(response)
        
        return response
    }
    
    private func generatePersonalizedRecommendations(for requestType: APIRequestType) -> [ChannelRecommendation] {
        let timeOfDay = getCurrentTimeOfDay()
        let userSegment = currentUserPreferences.userSegment
        
        // Base channel IDs from LiveTVView
        let channelData: [(id: String, category: String, name: String)] = [
            ("1", "entertainment", "Star Plus"),
            ("2", "entertainment", "Colors"),
            ("3", "entertainment", "Zee TV"),
            ("4", "sports", "Star Sports 1"),
            ("5", "sports", "Sony Sports"),
            ("6", "news", "Times Now"),
            ("7", "news", "Republic TV"),
            ("8", "kids", "Cartoon Network"),
            ("9", "kids", "Disney Channel"),
            ("10", "movies", "Star Gold"),
            ("11", "movies", "Sony Max"),
            ("12", "music", "MTV"),
            ("13", "regional", "Asianet")
        ]
        
        var recommendations: [ChannelRecommendation] = []
        
        for channel in channelData {
            let score = calculatePersonalizationScore(
                channelId: channel.id,
                category: channel.category,
                channelName: channel.name,
                userSegment: userSegment,
                timeOfDay: timeOfDay
            )
            
            let reason = generateRecommendationReason(
                category: channel.category,
                score: score,
                timeOfDay: timeOfDay,
                userSegment: userSegment
            )
            
            recommendations.append(
                ChannelRecommendation(
                    channelId: channel.id,
                    score: score,
                    reason: reason,
                    category: channel.category,
                    confidence: min(score + Double.random(in: 0...0.1), 1.0)
                )
            )
        }
        
        // Sort by score (highest first)
        return recommendations.sorted { $0.score > $1.score }
    }
    
    private func calculatePersonalizationScore(
        channelId: String,
        category: String,
        channelName: String,
        userSegment: String,
        timeOfDay: String
    ) -> Double {
        var score = 0.5 // Base score
        
        // Category preference boost
        if currentUserPreferences.topCategories.contains(category) {
            let categoryIndex = currentUserPreferences.topCategories.firstIndex(of: category) ?? 2
            score += 0.3 - (Double(categoryIndex) * 0.1) // First preference gets 0.3, second gets 0.2, etc.
        }
        
        // Time-based preferences
        switch (timeOfDay, category) {
        case ("morning", "news"):
            score += 0.25
        case ("afternoon", "entertainment"):
            score += 0.2
        case ("evening", "sports"):
            score += 0.3
        case ("night", "movies"):
            score += 0.25
        default:
            break
        }
        
        // User segment specific boosts
        switch (userSegment, category) {
        case ("sports_entertainment_fan", "sports"),
             ("sports_entertainment_fan", "entertainment"):
            score += 0.2
        case ("family_viewer", "kids"),
             ("family_viewer", "entertainment"):
            score += 0.25
        case ("news_enthusiast", "news"):
            score += 0.3
        default:
            break
        }
        
        // Premium channel boost (simulate HD preferences)
        let premiumChannels = ["1", "4", "6", "8", "10"] // Star Plus, Star Sports 1, Times Now, etc.
        if premiumChannels.contains(channelId) {
            score += 0.1
        }
        
        // Add some randomization to simulate real-world variance
        score += Double.random(in: -0.05...0.05)
        
        return min(max(score, 0.0), 1.0) // Clamp between 0 and 1
    }
    
    private func generateRecommendationReason(
        category: String,
        score: Double,
        timeOfDay: String,
        userSegment: String
    ) -> String {
        if score > 0.8 {
            return "high_\(category)_affinity"
        } else if score > 0.6 {
            switch timeOfDay {
            case "morning":
                return "morning_\(category)_preference"
            case "evening":
                return "prime_time_\(category)"
            default:
                return "\(category)_regular_viewer"
            }
        } else {
            return "similar_users_watched"
        }
    }
    
    private func getCurrentTimeOfDay() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 6..<12:
            return "morning"
        case 12..<17:
            return "afternoon"
        case 17..<22:
            return "evening"
        default:
            return "night"
        }
    }
    
    private func logPersonalizationResponse(_ response: PersonalizationResponse) {
        print("\n✅ PERSONALIZATION RESPONSE GENERATED")
        print("📊 Total Recommendations: \(response.recommendations.count)")
        print("🎯 User Segment: \(response.personalizationContext.userSegment)")
        print("⏰ Time Context: \(response.personalizationContext.timeOfDay)")
        print("🔥 Top Recommendations:")
        
        for (index, rec) in response.recommendations.prefix(5).enumerated() {
            print("   \(index + 1). Channel \(rec.channelId) - Score: \(String(format: "%.2f", rec.score)) - \(rec.reason)")
        }
        
        print("🤖 Model: \(response.metadata.modelVersion)")
        print("📈 Confidence: \(String(format: "%.1f%%", response.metadata.confidence * 100))")
        print("⚡ Processing Time: \(String(format: "%.2f", response.metadata.processingTime))s")
        print("✅" + "=" * 50 + "\n")
    }
    
    // MARK: - User Preferences Management
    private func loadUserPreferences() {
        if let data = UserDefaults.standard.data(forKey: "personalization_preferences"),
           let preferences = try? JSONDecoder().decode(PersonalizationPreferences.self, from: data) {
            currentUserPreferences = preferences
            print("📱 PersonalizationService: Loaded user preferences - \(preferences.userSegment)")
        }
    }
    
    private func saveUserPreferences() {
        if let data = try? JSONEncoder().encode(currentUserPreferences) {
            UserDefaults.standard.set(data, forKey: "personalization_preferences")
        }
    }
    
    // MARK: - Helper Types
    private enum APIRequestType {
        case channels
        case content(String)
        
        var description: String {
            switch self {
            case .channels:
                return "Channel Recommendations"
            case .content(let type):
                return "Content Recommendations (\(type))"
            }
        }
    }
}

// MARK: - Error Types
enum PersonalizationError: Error, LocalizedError {
    case networkError(String)
    case invalidResponse
    case unauthorized
    case rateLimited
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .networkError(let message):
            return "Network error: \(message)"
        case .invalidResponse:
            return "Invalid response from personalization service"
        case .unauthorized:
            return "Unauthorized access to personalization service"
        case .rateLimited:
            return "Rate limit exceeded for personalization requests"
        case .unknown:
            return "Unknown personalization error"
        }
    }
}
