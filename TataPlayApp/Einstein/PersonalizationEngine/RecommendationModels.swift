import Foundation

// MARK: - Main Personalization Response
struct PersonalizationResponse: Codable {
    let recommendations: [ChannelRecommendation]
    let personalizationContext: PersonalizationContext
    let metadata: PersonalizationMetadata
    
    var topRecommendations: [ChannelRecommendation] {
        return Array(recommendations.prefix(5))
    }
    
    var recommendationsByCategory: [String: [ChannelRecommendation]] {
        return Dictionary(grouping: recommendations, by: { $0.category })
    }
}

// MARK: - Channel Recommendation
struct ChannelRecommendation: Codable {
    let channelId: String
    let score: Double
    let reason: String
    let category: String
    let confidence: Double
    
    // SwiftUI Identifiable conformance
    var id: String { channelId }
    
    var isHighlyRecommended: Bool {
        return score > 0.8
    }
    
    var scorePercentage: Int {
        return Int(score * 100)
    }
    
    var displayReason: String {
        switch reason {
        case "high_sports_affinity":
            return "Based on your sports viewing"
        case "high_entertainment_affinity":
            return "Perfect for entertainment lovers"
        case "high_news_affinity":
            return "Stay updated with news"
        case "morning_news_preference":
            return "Great for morning news"
        case "prime_time_entertainment":
            return "Prime time favorite"
        case "evening_sports":
            return "Evening sports pick"
        case "similar_users_watched":
            return "Popular with similar viewers"
        default:
            return "Recommended for you"
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case channelId, score, reason, category, confidence
    }
}

// MARK: - Content Recommendation (for Search view)
struct ContentRecommendation: Codable {
    let contentId: String
    let title: String
    let contentType: String
    let category: String
    let score: Double
    let reason: String
    let confidence: Double
    let metadata: ContentRecommendationMetadata
    
    // SwiftUI Identifiable conformance
    var id: String { contentId }
    
    var isHighlyRecommended: Bool {
        return score > 0.75
    }
    
    var displayReason: String {
        switch reason {
        case "high_affinity":
            return "Based on your preferences"
        case "trending_similar":
            return "Trending with similar users"
        case "genre_match":
            return "Matches your favorite genres"
        case "time_based":
            return "Perfect for this time"
        default:
            return "Recommended for you"
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case contentId, title, contentType, category, score, reason, confidence, metadata
    }
}

// MARK: - Content Recommendation Metadata
struct ContentRecommendationMetadata: Codable {
    let genre: String?
    let language: String?
    let rating: String?
    let duration: TimeInterval?
    let isNew: Bool
    let isPremium: Bool
    
    func toDictionary() -> [String: Any] {
        return [
            "genre": genre ?? NSNull(),
            "language": language ?? NSNull(),
            "rating": rating ?? NSNull(),
            "duration": duration ?? NSNull(),
            "isNew": isNew,
            "isPremium": isPremium
        ]
    }
}

// MARK: - Personalization Context
struct PersonalizationContext: Codable {
    let userSegment: String
    let timeOfDay: String
    let topCategories: [String]
    let sessionId: String
    let lastUpdated: Date
    
    var contextDescription: String {
        return "\(userSegment.capitalized) viewer, \(timeOfDay) preferences"
    }
    
    var isRecent: Bool {
        return Date().timeIntervalSince(lastUpdated) < 300 // 5 minutes
    }
}

// MARK: - Personalization Metadata
struct PersonalizationMetadata: Codable {
    let modelVersion: String
    let confidence: Double
    let processingTime: TimeInterval
    
    var confidencePercentage: Int {
        return Int(confidence * 100)
    }
    
    var formattedProcessingTime: String {
        return String(format: "%.2fs", processingTime)
    }
}

// MARK: - Einstein Personalization Preferences (renamed to avoid conflict with BaseModels)
struct PersonalizationPreferences: Codable {
    let userSegment: String
    let topCategories: [String]
    let preferredLanguages: [String]
    let timePreferences: TimePreferences
    let contentPreferences: ContentPreferences
    let lastUpdated: Date
    
    static var defaultPreferences: PersonalizationPreferences {
        return PersonalizationPreferences(
            userSegment: "sports_entertainment_fan",
            topCategories: ["sports", "entertainment", "news"],
            preferredLanguages: ["hindi", "english"],
            timePreferences: TimePreferences.defaultPreferences,
            contentPreferences: ContentPreferences.defaultPreferences,
            lastUpdated: Date()
        )
    }
    
    var isOutdated: Bool {
        return Date().timeIntervalSince(lastUpdated) > 86400 // 24 hours
    }
    
    func withUpdatedCategories(_ categories: [String]) -> PersonalizationPreferences {
        return PersonalizationPreferences(
            userSegment: determineUserSegment(from: categories),
            topCategories: categories,
            preferredLanguages: preferredLanguages,
            timePreferences: timePreferences,
            contentPreferences: contentPreferences,
            lastUpdated: Date()
        )
    }
    
    private func determineUserSegment(from categories: [String]) -> String {
        let categorySet = Set(categories)
        
        if categorySet.contains("sports") && categorySet.contains("entertainment") {
            return "sports_entertainment_fan"
        } else if categorySet.contains("kids") && categorySet.contains("entertainment") {
            return "family_viewer"
        } else if categorySet.contains("news") && categories.first == "news" {
            return "news_enthusiast"
        } else if categorySet.contains("movies") && categorySet.contains("series") {
            return "movie_series_lover"
        } else if categorySet.contains("regional") {
            return "regional_content_viewer"
        } else {
            return "general_viewer"
        }
    }
}

// MARK: - Time Preferences
struct TimePreferences: Codable {
    let morningCategories: [String]
    let afternoonCategories: [String]
    let eveningCategories: [String]
    let nightCategories: [String]
    
    static var defaultPreferences: TimePreferences {
        return TimePreferences(
            morningCategories: ["news", "kids"],
            afternoonCategories: ["entertainment", "music"],
            eveningCategories: ["sports", "entertainment"],
            nightCategories: ["movies", "series"]
        )
    }
    
    func getCategoriesForCurrentTime() -> [String] {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 6..<12:
            return morningCategories
        case 12..<17:
            return afternoonCategories
        case 17..<22:
            return eveningCategories
        default:
            return nightCategories
        }
    }
}

// MARK: - Content Preferences
struct ContentPreferences: Codable {
    let preferredGenres: [String]
    let avoidGenres: [String]
    let preferHD: Bool
    let preferLive: Bool
    let maxContentDuration: TimeInterval?
    
    static var defaultPreferences: ContentPreferences {
        return ContentPreferences(
            preferredGenres: ["action", "comedy", "drama", "sports"],
            avoidGenres: ["horror"],
            preferHD: true,
            preferLive: true,
            maxContentDuration: 7200 // 2 hours
        )
    }
    
    func scoreContent(genre: String?, isHD: Bool, isLive: Bool, duration: TimeInterval?) -> Double {
        var score = 0.5 // Base score
        
        // Genre preference
        if let genre = genre {
            if preferredGenres.contains(genre.lowercased()) {
                score += 0.3
            } else if avoidGenres.contains(genre.lowercased()) {
                score -= 0.2
            }
        }
        
        // HD preference
        if preferHD && isHD {
            score += 0.1
        }
        
        // Live preference
        if preferLive && isLive {
            score += 0.1
        }
        
        // Duration preference
        if let duration = duration, let maxDuration = maxContentDuration {
            if duration <= maxDuration {
                score += 0.1
            } else {
                score -= 0.1
            }
        }
        
        return min(max(score, 0.0), 1.0)
    }
}

// MARK: - Recommendation Request
struct RecommendationRequest: Codable {
    let userId: String?
    let sessionId: String
    let requestType: RequestType
    let context: RequestContext
    let preferences: PersonalizationPreferences?
    
    enum RequestType: String, Codable {
        case channels = "channels"
        case content = "content"
        case search = "search"
        case mixed = "mixed"
    }
}

// MARK: - Request Context
struct RequestContext: Codable {
    let currentView: String
    let timeOfDay: String
    let deviceType: String
    let appVersion: String
    let filterState: [String: String]
    let searchQuery: String?
    
    func toDictionary() -> [String: Any] {
        return [
            "currentView": currentView,
            "timeOfDay": timeOfDay,
            "deviceType": deviceType,
            "appVersion": appVersion,
            "filterState": filterState,
            "searchQuery": searchQuery ?? NSNull()
        ]
    }
}

// MARK: - Personalization Cache
struct PersonalizationCache: Codable {
    let channelRecommendations: PersonalizationResponse?
    let contentRecommendations: [String: PersonalizationResponse] // Keyed by content type
    let lastChannelUpdate: Date?
    let lastContentUpdate: Date?
    let userPreferences: PersonalizationPreferences
    
    var isChannelCacheValid: Bool {
        guard let lastUpdate = lastChannelUpdate else { return false }
        return Date().timeIntervalSince(lastUpdate) < 300 // 5 minutes
    }
    
    func isContentCacheValid(for contentType: String) -> Bool {
        guard let lastUpdate = lastContentUpdate else { return false }
        return Date().timeIntervalSince(lastUpdate) < 600 // 10 minutes for content
    }
    
    static var empty: PersonalizationCache {
        return PersonalizationCache(
            channelRecommendations: nil,
            contentRecommendations: [:],
            lastChannelUpdate: nil,
            lastContentUpdate: nil,
            userPreferences: PersonalizationPreferences.defaultPreferences
        )
    }
}

// MARK: - Analytics Integration Models
struct PersonalizationAnalyticsEvent: Codable {
    let eventType: String
    let recommendationId: String
    let channelId: String?
    let contentId: String?
    let score: Double
    let reason: String
    let userAction: UserAction
    let timestamp: Date
    
    enum UserAction: String, Codable {
        case viewed = "viewed"
        case clicked = "clicked"
        case ignored = "ignored"
        case dismissed = "dismissed"
    }
}

// MARK: - Helper Extensions
extension PersonalizationResponse {
    func getRecommendation(for channelId: String) -> ChannelRecommendation? {
        return recommendations.first { $0.channelId == channelId }
    }
    
    func getScore(for channelId: String) -> Double? {
        return getRecommendation(for: channelId)?.score
    }
    
    func isRecommended(channelId: String, threshold: Double = 0.6) -> Bool {
        return getScore(for: channelId) ?? 0.0 > threshold
    }
}

extension Array where Element == ChannelRecommendation {
    func sortedByCategory() -> [String: [ChannelRecommendation]] {
        return Dictionary(grouping: self, by: { $0.category })
    }
    
    func topRecommendations(limit: Int = 5) -> [ChannelRecommendation] {
        return Array(self.sorted { $0.score > $1.score }.prefix(limit))
    }
    
    func recommendationsForCategory(_ category: String) -> [ChannelRecommendation] {
        return self.filter { $0.category == category }.sorted { $0.score > $1.score }
    }
}

// MARK: - User Segment Extensions
extension PersonalizationPreferences {
    var displayName: String {
        switch userSegment {
        case "sports_entertainment_fan":
            return "Sports & Entertainment Fan"
        case "family_viewer":
            return "Family Viewer"
        case "news_enthusiast":
            return "News Enthusiast"
        case "movie_series_lover":
            return "Movies & Series Lover"
        case "regional_content_viewer":
            return "Regional Content Viewer"
        default:
            return "General Viewer"
        }
    }
    
    var icon: String {
        switch userSegment {
        case "sports_entertainment_fan":
            return "sportscourt.fill"
        case "family_viewer":
            return "house.fill"
        case "news_enthusiast":
            return "newspaper.fill"
        case "movie_series_lover":
            return "film.fill"
        case "regional_content_viewer":
            return "globe.asia.australia.fill"
        default:
            return "person.fill"
        }
    }
}
