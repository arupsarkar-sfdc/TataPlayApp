
import Foundation

// MARK: - BaseModels.swift
// Core data structures for Tata Play entertainment streaming app
// Based on business_model: "entertainment_streaming" from JSON scaffolding

// MARK: - Base Protocols

/// Base protocol for all identifiable models
protocol Identifiable {
    var id: String { get }
}

/// Base protocol for models with timestamps
protocol Timestampable {
    var createdAt: Date { get }
    var updatedAt: Date { get }
}

/// Base protocol for models with metadata
protocol Metadatable {
    var metadata: [String: String] { get }
}

// MARK: - User Models

/// User account model
struct User: Codable, Identifiable, Timestampable {
    let id: String
    let email: String
    let name: String
    let phoneNumber: String
    let subscriberID: String
    let accountStatus: AccountStatus
    let preferences: UserPreferences
    let subscription: Subscription?
    let createdAt: Date
    let updatedAt: Date
    
    enum AccountStatus: String, Codable, CaseIterable {
        case active = "active"
        case inactive = "inactive"
        case suspended = "suspended"
        case blocked = "blocked"
    }
}

/// User preferences for personalization (from JSON personalization_opportunities)
struct UserPreferences: Codable {
    var preferredLanguages: [String]
    var favoriteGenres: [ContentGenre]
    var parentalControlEnabled: Bool
    var parentalControlPIN: String?
    var autoPlayEnabled: Bool
    var hdPreferred: Bool
    var notificationSettings: NotificationSettings
    var privacySettings: PrivacySettings
    
    init() {
        self.preferredLanguages = ["en"]
        self.favoriteGenres = []
        self.parentalControlEnabled = false
        self.parentalControlPIN = nil
        self.autoPlayEnabled = true
        self.hdPreferred = true
        self.notificationSettings = NotificationSettings()
        self.privacySettings = PrivacySettings()
    }
}

struct NotificationSettings: Codable {
    var pushNotificationsEnabled: Bool
    var emailNotificationsEnabled: Bool
    var smsNotificationsEnabled: Bool
    var programRemindersEnabled: Bool
    var promotionalOffersEnabled: Bool
    
    init() {
        self.pushNotificationsEnabled = true
        self.emailNotificationsEnabled = true
        self.smsNotificationsEnabled = false
        self.programRemindersEnabled = true
        self.promotionalOffersEnabled = true
    }
}

struct PrivacySettings: Codable {
    var dataCollectionEnabled: Bool
    var analyticsEnabled: Bool
    var personalizedAdsEnabled: Bool
    var viewingHistoryEnabled: Bool
    
    init() {
        self.dataCollectionEnabled = true
        self.analyticsEnabled = true
        self.personalizedAdsEnabled = true
        self.viewingHistoryEnabled = true
    }
}

// MARK: - Subscription Models (from JSON key_features: subscription_billing)

/// Subscription details
struct Subscription: Codable, Identifiable, Timestampable {
    let id: String
    let subscriberID: String
    let planName: String
    let planType: PlanType
    let status: SubscriptionStatus
    let startDate: Date
    let endDate: Date
    let autoRenewal: Bool
    let price: Double
    let currency: String
    let features: [SubscriptionFeature]
    let channelsIncluded: Int
    let ottAppsIncluded: [String]
    let createdAt: Date
    let updatedAt: Date
    
    enum PlanType: String, Codable, CaseIterable {
        case basic = "basic"
        case standard = "standard"
        case premium = "premium"
        case vip = "vip"
        case family = "family"
        case sports = "sports"
        case movies = "movies"
    }
    
    enum SubscriptionStatus: String, Codable, CaseIterable {
        case active = "active"
        case expired = "expired"
        case suspended = "suspended"
        case cancelled = "cancelled"
        case pending = "pending"
    }
}

/// Subscription features (from JSON key_features)
enum SubscriptionFeature: String, Codable, CaseIterable {
    case liveTV = "live_tv_streaming"
    case channelManagement = "channel_management"
    case catchUpTV = "catch_up_tv"
    case recording = "recording_functionality"
    case multiDevice = "multi_device_support"
    case parentalControls = "parental_controls"
    case remoteControl = "remote_control"
    case hdChannels = "hd_channels"
    case pictureInPicture = "picture_in_picture"
    case chromecastSupport = "chromecast_support"
    case backgroundPlayback = "background_playback"
    case downloadForOffline = "download_for_offline"
    
    var displayName: String {
        switch self {
        case .liveTV: return "Live TV Streaming"
        case .channelManagement: return "Channel Management"
        case .catchUpTV: return "Catch-up TV"
        case .recording: return "Recording"
        case .multiDevice: return "Multi-device Support"
        case .parentalControls: return "Parental Controls"
        case .remoteControl: return "Remote Control"
        case .hdChannels: return "HD Channels"
        case .pictureInPicture: return "Picture-in-Picture"
        case .chromecastSupport: return "Chromecast Support"
        case .backgroundPlayback: return "Background Playback"
        case .downloadForOffline: return "Download for Offline"
        }
    }
}

// MARK: - Channel Models (from JSON navigation: Watch, live_tv_streaming)

/// TV Channel model
struct Channel: Codable, Identifiable, Metadatable {
    let id: String
    let channelNumber: Int
    let name: String
    let displayName: String
    let logoURL: String?
    let category: ChannelCategory
    let genre: ContentGenre
    let language: String
    let isHD: Bool
    let isLive: Bool
    let currentProgram: Program?
    let upcomingPrograms: [Program]
    let streamingURL: String?
    let metadata: [String: String]
    
    enum ChannelCategory: String, Codable, CaseIterable {
        case entertainment = "entertainment"
        case sports = "sports"
        case news = "news"
        case movies = "movies"
        case kids = "kids"
        case music = "music"
        case lifestyle = "lifestyle"
        case documentary = "documentary"
        case regional = "regional"
        case international = "international"
        case religious = "religious"
        case educational = "educational"
        
        var displayName: String {
            return rawValue.capitalized
        }
        
        var iconName: String {
            switch self {
            case .entertainment: return "tv"
            case .sports: return "sportscourt"
            case .news: return "newspaper"
            case .movies: return "film"
            case .kids: return "gamecontroller"
            case .music: return "music.note"
            case .lifestyle: return "heart"
            case .documentary: return "doc.text"
            case .regional: return "globe.asia.australia"
            case .international: return "globe"
            case .religious: return "leaf"
            case .educational: return "graduationcap"
            }
        }
    }
}

enum ContentGenre: String, Codable, CaseIterable {
    case drama = "drama"
    case comedy = "comedy"
    case action = "action"
    case thriller = "thriller"
    case romance = "romance"
    case horror = "horror"
    case sciFi = "sci_fi"
    case fantasy = "fantasy"
    case documentary = "documentary"
    case reality = "reality"
    case talk = "talk_show"
    case game = "game_show"
    case news = "news"
    case sports = "sports"
    case music = "music"
    case kids = "kids"
    case educational = "educational"
    case lifestyle = "lifestyle"
    
    var displayName: String {
        switch self {
        case .sciFi: return "Sci-Fi"
        default: return rawValue.replacingOccurrences(of: "_", with: " ").capitalized
        }
    }
}

// MARK: - Program Models (EPG - Electronic Program Guide)

/// TV Program/Show model
struct Program: Codable, Identifiable, Timestampable {
    let id: String
    let title: String
    let description: String
    let shortDescription: String?
    let channelID: String
    let genre: ContentGenre
    let startTime: Date
    let endTime: Date
    let duration: TimeInterval
    let rating: ContentRating
    let isLive: Bool
    let isRecordable: Bool
    let isPremium: Bool
    let thumbnailURL: String?
    let bannerURL: String?
    let cast: [String]
    let director: String?
    let year: Int?
    let language: String
    let subtitles: [String]
    let audioTracks: [String]
    let createdAt: Date
    let updatedAt: Date
    
    enum ContentRating: String, Codable, CaseIterable {
        case universal = "U"
        case parentalGuidance = "PG"
        case adult = "A"
        case restricted = "R"
        case unrated = "NR"
        
        var displayName: String {
            switch self {
            case .universal: return "Universal"
            case .parentalGuidance: return "Parental Guidance"
            case .adult: return "Adult"
            case .restricted: return "Restricted"
            case .unrated: return "Not Rated"
            }
        }
        
        var colorIndicator: String {
            switch self {
            case .universal: return "green"
            case .parentalGuidance: return "yellow"
            case .adult: return "orange"
            case .restricted: return "red"
            case .unrated: return "gray"
            }
        }
    }
}

// MARK: - Content Models (from JSON content_discovery)

/// Generic content item (for recommendations, search results)
struct ContentItem: Codable, Identifiable, Timestampable {
    let id: String
    let title: String
    let description: String
    let type: ContentType
    let category: Channel.ChannelCategory
    let genre: ContentGenre
    let thumbnailURL: String?
    let bannerURL: String?
    let duration: TimeInterval?
    let rating: Program.ContentRating
    let isLive: Bool
    let isPremium: Bool
    let isFavorite: Bool
    let viewCount: Int
    let tags: [String]
    let availability: ContentAvailability
    let createdAt: Date
    let updatedAt: Date
    
    enum ContentType: String, Codable, CaseIterable {
        case liveTV = "live_tv"
        case program = "program"
        case movie = "movie"
        case series = "series"
        case episode = "episode"
        case clip = "clip"
        case trailer = "trailer"
        
        var displayName: String {
            switch self {
            case .liveTV: return "Live TV"
            default: return rawValue.capitalized
            }
        }
        
        var iconName: String {
            switch self {
            case .liveTV: return "tv"
            case .program: return "tv.fill"
            case .movie: return "film"
            case .series: return "tv.and.hifispeaker.fill"
            case .episode: return "play.rectangle"
            case .clip: return "play.circle"
            case .trailer: return "play.rectangle.on.rectangle"
            }
        }
    }
    
    struct ContentAvailability: Codable {
        let isAvailable: Bool
        let availableFrom: Date?
        let availableUntil: Date?
        let geoRestrictions: [String]
        let subscriptionRequired: Bool
        let purchaseRequired: Bool
    }
}

// MARK: - Billing Models (from JSON monetization)

/// Transaction model for payments/recharges
struct Transaction: Codable, Identifiable, Timestampable {
    let id: String
    let userID: String
    let type: TransactionType
    let amount: Double
    let currency: String
    let status: TransactionStatus
    let paymentMethod: PaymentMethod
    let description: String
    let subscriptionID: String?
    let createdAt: Date
    let updatedAt: Date
    
    enum TransactionType: String, Codable, CaseIterable {
        case subscription = "subscription"
        case recharge = "recharge"
        case payPerView = "pay_per_view"
        case premiumChannel = "premium_channel"
        case addon = "addon"
        case refund = "refund"
        
        var displayName: String {
            switch self {
            case .payPerView: return "Pay-per-View"
            case .premiumChannel: return "Premium Channel"
            default: return rawValue.capitalized
            }
        }
    }
    
    enum TransactionStatus: String, Codable, CaseIterable {
        case pending = "pending"
        case processing = "processing"
        case completed = "completed"
        case failed = "failed"
        case cancelled = "cancelled"
        case refunded = "refunded"
        
        var displayName: String {
            return rawValue.capitalized
        }
        
        var colorIndicator: String {
            switch self {
            case .completed: return "green"
            case .pending, .processing: return "yellow"
            case .failed, .cancelled: return "red"
            case .refunded: return "orange"
            }
        }
    }
    
    enum PaymentMethod: String, Codable, CaseIterable {
        case creditCard = "credit_card"
        case debitCard = "debit_card"
        case netBanking = "net_banking"
        case upi = "upi"
        case wallet = "wallet"
        case bankTransfer = "bank_transfer"
        
        var displayName: String {
            switch self {
            case .creditCard: return "Credit Card"
            case .debitCard: return "Debit Card"
            case .netBanking: return "Net Banking"
            case .upi: return "UPI"
            case .wallet: return "Digital Wallet"
            case .bankTransfer: return "Bank Transfer"
            }
        }
        
        var iconName: String {
            switch self {
            case .creditCard, .debitCard: return "creditcard"
            case .netBanking: return "building.columns"
            case .upi: return "qrcode"
            case .wallet: return "wallet.pass"
            case .bankTransfer: return "banknote"
            }
        }
    }
}

// MARK: - Search Models (from JSON user_flows: search_content)

/// Search query and results
struct SearchQuery: Codable, Identifiable, Timestampable {
    let id: String
    let query: String
    let userID: String
    let filters: SearchFilters
    let resultCount: Int
    let createdAt: Date
    let updatedAt: Date
}

struct SearchFilters: Codable {
    var categories: [Channel.ChannelCategory]
    var genres: [ContentGenre]
    var languages: [String]
    var ratings: [Program.ContentRating]
    var isHDOnly: Bool
    var isLiveOnly: Bool
    var isPremiumOnly: Bool
    var dateRange: DateRange?
    
    struct DateRange: Codable {
        let from: Date
        let to: Date
    }
    
    init() {
        self.categories = []
        self.genres = []
        self.languages = []
        self.ratings = []
        self.isHDOnly = false
        self.isLiveOnly = false
        self.isPremiumOnly = false
        self.dateRange = nil
    }
}

struct SearchResult: Codable, Identifiable {
    let id: String
    let content: ContentItem
    let relevanceScore: Double
    let highlightedFields: [String]
}

// MARK: - API Response Models

/// Generic API response wrapper
struct APIResponse<T: Codable>: Codable {
    let success: Bool
    let data: T?
    let message: String?
    let errorCode: String?
    let timestamp: Date
    
    enum CodingKeys: String, CodingKey {
        case success, data, message, errorCode, timestamp
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        success = try container.decode(Bool.self, forKey: .success)
        data = try container.decodeIfPresent(T.self, forKey: .data)
        message = try container.decodeIfPresent(String.self, forKey: .message)
        errorCode = try container.decodeIfPresent(String.self, forKey: .errorCode)
        
        // Handle flexible timestamp formats
        if let timestampString = try? container.decode(String.self, forKey: .timestamp) {
            let formatter = ISO8601DateFormatter()
            timestamp = formatter.date(from: timestampString) ?? Date()
        } else {
            timestamp = try container.decodeIfPresent(Date.self, forKey: .timestamp) ?? Date()
        }
    }
}

/// Paginated response for lists
struct PaginatedResponse<T: Codable>: Codable {
    let items: [T]
    let page: Int
    let pageSize: Int
    let totalItems: Int
    let totalPages: Int
    let hasNext: Bool
    let hasPrevious: Bool
    
    var isEmpty: Bool {
        return items.isEmpty
    }
}

// MARK: - Error Models

/// App-specific error types
enum AppError: Error, LocalizedError {
    case networkError(String)
    case authenticationError(String)
    case subscriptionError(String)
    case paymentError(String)
    case contentNotAvailable(String)
    case parentalControlRestriction
    case deviceLimitExceeded
    case geoRestriction
    case unknown(String)
    
    var errorDescription: String? {
        switch self {
        case .networkError(let message):
            return "Network Error: \(message)"
        case .authenticationError(let message):
            return "Authentication Error: \(message)"
        case .subscriptionError(let message):
            return "Subscription Error: \(message)"
        case .paymentError(let message):
            return "Payment Error: \(message)"
        case .contentNotAvailable(let message):
            return "Content Not Available: \(message)"
        case .parentalControlRestriction:
            return "This content is restricted by parental controls"
        case .deviceLimitExceeded:
            return "Device limit exceeded. Please log out from another device"
        case .geoRestriction:
            return "This content is not available in your region"
        case .unknown(let message):
            return "Unknown Error: \(message)"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .networkError:
            return "Please check your internet connection and try again"
        case .authenticationError:
            return "Please log in again"
        case .subscriptionError:
            return "Please check your subscription status"
        case .paymentError:
            return "Please verify your payment method"
        case .contentNotAvailable:
            return "Try again later or contact support"
        case .parentalControlRestriction:
            return "Enter parental control PIN to proceed"
        case .deviceLimitExceeded:
            return "Manage your devices in account settings"
        case .geoRestriction:
            return "This content may be available in other regions"
        case .unknown:
            return "Please try again or contact support"
        }
    }
}

// MARK: - Constants

struct ModelConstants {
    static let maxChannelsPerSubscription = 1000
    static let maxDevicesPerAccount = 10
    static let maxSimultaneousStreams = 2
    static let defaultLanguage = "en"
    static let supportedLanguages = ["en", "hi", "ta", "te", "bn", "ml", "kn", "mr", "gu", "pa"]
    static let maxSearchHistoryItems = 50
    static let maxWatchlistItems = 200
    static let defaultPageSize = 20
}
