//
//  EventModels.swift
//  TataPlayApp
//
//  Created by Arup Sarkar (TA) on 7/8/25.
//

import Foundation
import UIKit

// MARK: - Base Event Protocol
protocol AnalyticsEvent {
    var eventId: String { get }
    var eventType: String { get }
    var timestamp: Date { get }
    var userId: String? { get }
    var sessionId: String { get }
    var deviceContext: DeviceContext { get }
    var screenContext: ScreenContext { get }
    
    func toDictionary() -> [String: Any]
}

// MARK: - Device Context
struct DeviceContext: Codable {
    let deviceType: String
    let osVersion: String
    let appVersion: String
    let deviceId: String
    let networkType: String // WiFi, Cellular, etc.
    
    init() {
        self.deviceType = UIDevice.current.model
        self.osVersion = UIDevice.current.systemVersion
        self.appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
        self.deviceId = UIDevice.current.identifierForVendor?.uuidString ?? "Unknown"
        self.networkType = "Unknown" // TODO: Implement network detection
    }
}

// MARK: - Screen Context
struct ScreenContext: Codable {
    let currentView: String
    let navigationPath: [String]
    let viewLoadTime: Date
    
    init(currentView: String, navigationPath: [String] = []) {
        self.currentView = currentView
        self.navigationPath = navigationPath
        self.viewLoadTime = Date()
    }
}

// MARK: - Category Selection Event
struct CategorySelectionEvent: AnalyticsEvent {
    let eventId: String
    let eventType: String = "category_selected"
    let timestamp: Date
    let userId: String?
    let sessionId: String
    let deviceContext: DeviceContext
    let screenContext: ScreenContext
    
    // Category-specific data
    let selectedCategory: String
    let previousCategory: String?
    let categoryType: String // "channel_category", "content_type", etc.
    let availableOptions: [String]
    let selectionIndex: Int
    let timeSinceLastSelection: TimeInterval?
    
    init(
        selectedCategory: String,
        previousCategory: String?,
        categoryType: String,
        availableOptions: [String],
        selectionIndex: Int,
        timeSinceLastSelection: TimeInterval?,
        userId: String?,
        sessionId: String,
        screenContext: ScreenContext
    ) {
        self.eventId = UUID().uuidString
        self.timestamp = Date()
        self.userId = userId
        self.sessionId = sessionId
        self.deviceContext = DeviceContext()
        self.screenContext = screenContext
        self.selectedCategory = selectedCategory
        self.previousCategory = previousCategory
        self.categoryType = categoryType
        self.availableOptions = availableOptions
        self.selectionIndex = selectionIndex
        self.timeSinceLastSelection = timeSinceLastSelection
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "eventId": eventId,
            "eventType": eventType,
            "timestamp": ISO8601DateFormatter().string(from: timestamp),
            "userId": userId ?? NSNull(),
            "sessionId": sessionId,
            "deviceContext": deviceContext.toDictionary(),
            "screenContext": screenContext.toDictionary(),
            "selectedCategory": selectedCategory,
            "previousCategory": previousCategory ?? NSNull(),
            "categoryType": categoryType,
            "availableOptions": availableOptions,
            "selectionIndex": selectionIndex,
            "timeSinceLastSelection": timeSinceLastSelection ?? NSNull()
        ]
    }
}

// MARK: - Channel/Content Click Event
struct ContentClickEvent: AnalyticsEvent {
    let eventId: String
    let eventType: String = "content_clicked"
    let timestamp: Date
    let userId: String?
    let sessionId: String
    let deviceContext: DeviceContext
    let screenContext: ScreenContext
    
    // Content-specific data
    let contentId: String
    let contentTitle: String
    let contentType: String // "channel", "movie", "series", etc.
    let contentCategory: String
    let contentMetadata: ContentMetadata
    let clickPosition: ClickPosition
    let contextualData: ContextualData
    
    init(
        contentId: String,
        contentTitle: String,
        contentType: String,
        contentCategory: String,
        contentMetadata: ContentMetadata,
        clickPosition: ClickPosition,
        contextualData: ContextualData,
        userId: String?,
        sessionId: String,
        screenContext: ScreenContext
    ) {
        self.eventId = UUID().uuidString
        self.timestamp = Date()
        self.userId = userId
        self.sessionId = sessionId
        self.deviceContext = DeviceContext()
        self.screenContext = screenContext
        self.contentId = contentId
        self.contentTitle = contentTitle
        self.contentType = contentType
        self.contentCategory = contentCategory
        self.contentMetadata = contentMetadata
        self.clickPosition = clickPosition
        self.contextualData = contextualData
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "eventId": eventId,
            "eventType": eventType,
            "timestamp": ISO8601DateFormatter().string(from: timestamp),
            "userId": userId ?? NSNull(),
            "sessionId": sessionId,
            "deviceContext": deviceContext.toDictionary(),
            "screenContext": screenContext.toDictionary(),
            "contentId": contentId,
            "contentTitle": contentTitle,
            "contentType": contentType,
            "contentCategory": contentCategory,
            "contentMetadata": contentMetadata.toDictionary(),
            "clickPosition": clickPosition.toDictionary(),
            "contextualData": contextualData.toDictionary()
        ]
    }
}

// MARK: - Search Event
struct SearchEvent: AnalyticsEvent {
    let eventId: String
    let eventType: String
    let timestamp: Date
    let userId: String?
    let sessionId: String
    let deviceContext: DeviceContext
    let screenContext: ScreenContext
    
    // Search-specific data
    let searchQuery: String
    let searchType: String // "text_input", "voice_search", "suggestion_click"
    let resultsCount: Int?
    let selectedFilters: [String: String]
    let searchDuration: TimeInterval?
    let resultClicked: Bool
    let clickedResultPosition: Int?
    
    init(
        searchQuery: String,
        searchType: String,
        resultsCount: Int?,
        selectedFilters: [String: String],
        searchDuration: TimeInterval?,
        resultClicked: Bool,
        clickedResultPosition: Int?,
        userId: String?,
        sessionId: String,
        screenContext: ScreenContext
    ) {
        self.eventId = UUID().uuidString
        self.timestamp = Date()
        self.eventType = searchType == "text_input" ? "search_query" : "search_interaction"
        self.userId = userId
        self.sessionId = sessionId
        self.deviceContext = DeviceContext()
        self.screenContext = screenContext
        self.searchQuery = searchQuery
        self.searchType = searchType
        self.resultsCount = resultsCount
        self.selectedFilters = selectedFilters
        self.searchDuration = searchDuration
        self.resultClicked = resultClicked
        self.clickedResultPosition = clickedResultPosition
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "eventId": eventId,
            "eventType": eventType,
            "timestamp": ISO8601DateFormatter().string(from: timestamp),
            "userId": userId ?? NSNull(),
            "sessionId": sessionId,
            "deviceContext": deviceContext.toDictionary(),
            "screenContext": screenContext.toDictionary(),
            "searchQuery": searchQuery,
            "searchType": searchType,
            "resultsCount": resultsCount ?? NSNull(),
            "selectedFilters": selectedFilters,
            "searchDuration": searchDuration ?? NSNull(),
            "resultClicked": resultClicked,
            "clickedResultPosition": clickedResultPosition ?? NSNull()
        ]
    }
}


// MARK: - Generic Button Click Event
struct GenericButtonClickEvent: AnalyticsEvent {
    let eventId: String
    let eventType: String = "button_clicked"
    let timestamp: Date
    let userId: String?
    let sessionId: String
    let deviceContext: DeviceContext
    let screenContext: ScreenContext
    
    let buttonName: String
    let buttonType: String
    
    init(buttonName: String, buttonType: String, screenContext: ScreenContext, userId: String?, sessionId: String) {
        self.eventId = UUID().uuidString
        self.timestamp = Date()
        self.userId = userId
        self.sessionId = sessionId
        self.deviceContext = DeviceContext()
        self.screenContext = screenContext
        self.buttonName = buttonName
        self.buttonType = buttonType
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "eventId": eventId,
            "eventType": eventType,
            "timestamp": ISO8601DateFormatter().string(from: timestamp),
            "userId": userId ?? NSNull(),
            "sessionId": sessionId,
            "deviceContext": deviceContext.toDictionary(),
            "screenContext": screenContext.toDictionary(),
            "buttonName": buttonName,
            "buttonType": buttonType
        ]
    }
}


// MARK: - View Appearance Event
struct ViewAppearanceEvent: AnalyticsEvent {
    let eventId: String
    let eventType: String = "view_appeared"
    let timestamp: Date
    let userId: String?
    let sessionId: String
    let deviceContext: DeviceContext
    let screenContext: ScreenContext
    
    let viewName: String
    let selectedCategory: String
    let totalChannels: Int
    
    init(viewName: String, selectedCategory: String, totalChannels: Int, screenContext: ScreenContext, userId: String?, sessionId: String) {
        self.eventId = UUID().uuidString
        self.timestamp = Date()
        self.userId = userId
        self.sessionId = sessionId
        self.deviceContext = DeviceContext()
        self.screenContext = screenContext
        self.viewName = viewName
        self.selectedCategory = selectedCategory
        self.totalChannels = totalChannels
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "eventId": eventId,
            "eventType": eventType,
            "timestamp": ISO8601DateFormatter().string(from: timestamp),
            "userId": userId ?? NSNull(),
            "sessionId": sessionId,
            "deviceContext": deviceContext.toDictionary(),
            "screenContext": screenContext.toDictionary(),
            "viewName": viewName,
            "selectedCategory": selectedCategory,
            "totalChannels": totalChannels
        ]
    }
}

// MARK: - Search View Appearance Event
struct SearchViewAppearanceEvent: AnalyticsEvent {
    let eventId: String
    let eventType: String = "search_view_appeared"
    let timestamp: Date
    let userId: String?
    let sessionId: String
    let deviceContext: DeviceContext
    let screenContext: ScreenContext
    
    let viewName: String
    let selectedContentType: String
    let hasActiveSearch: Bool
    let currentSearchQuery: String?
    
    init(viewName: String, selectedContentType: String, hasActiveSearch: Bool, currentSearchQuery: String?, screenContext: ScreenContext, userId: String?, sessionId: String) {
        self.eventId = UUID().uuidString
        self.timestamp = Date()
        self.userId = userId
        self.sessionId = sessionId
        self.deviceContext = DeviceContext()
        self.screenContext = screenContext
        self.viewName = viewName
        self.selectedContentType = selectedContentType
        self.hasActiveSearch = hasActiveSearch
        self.currentSearchQuery = currentSearchQuery
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "eventId": eventId,
            "eventType": eventType,
            "timestamp": ISO8601DateFormatter().string(from: timestamp),
            "userId": userId ?? NSNull(),
            "sessionId": sessionId,
            "deviceContext": deviceContext.toDictionary(),
            "screenContext": screenContext.toDictionary(),
            "viewName": viewName,
            "selectedContentType": selectedContentType,
            "hasActiveSearch": hasActiveSearch,
            "currentSearchQuery": currentSearchQuery ?? NSNull()
        ]
    }
}

// MARK: - Supporting Data Structures

struct ContentMetadata: Codable {
    let isHD: Bool?
    let isLive: Bool?
    let currentProgram: String?
    let genre: String?
    let language: String?
    let rating: String?
    let duration: TimeInterval?
    
    func toDictionary() -> [String: Any] {
        return [
            "isHD": isHD ?? NSNull(),
            "isLive": isLive ?? NSNull(),
            "currentProgram": currentProgram ?? NSNull(),
            "genre": genre ?? NSNull(),
            "language": language ?? NSNull(),
            "rating": rating ?? NSNull(),
            "duration": duration ?? NSNull()
        ]
    }
}

struct ClickPosition: Codable {
    let gridPosition: Int // Position in grid (0-based)
    let sectionName: String // "trending", "popular", "search_results"
    let totalItemsInSection: Int
    let isAboveFold: Bool // Whether item was visible without scrolling
    
    func toDictionary() -> [String: Any] {
        return [
            "gridPosition": gridPosition,
            "sectionName": sectionName,
            "totalItemsInSection": totalItemsInSection,
            "isAboveFold": isAboveFold
        ]
    }
}

struct ContextualData: Codable {
    let activeFilters: [String: String]
    let searchQuery: String?
    let timeSpentOnScreen: TimeInterval
    let previousAction: String?
    let recommendationSource: String? // "trending", "personalized", "popular"
    
    func toDictionary() -> [String: Any] {
        return [
            "activeFilters": activeFilters,
            "searchQuery": searchQuery ?? NSNull(),
            "timeSpentOnScreen": timeSpentOnScreen,
            "previousAction": previousAction ?? NSNull(),
            "recommendationSource": recommendationSource ?? NSNull()
        ]
    }
}

// MARK: - Dictionary Extensions
extension DeviceContext {
    func toDictionary() -> [String: Any] {
        return [
            "deviceType": deviceType,
            "osVersion": osVersion,
            "appVersion": appVersion,
            "deviceId": deviceId,
            "networkType": networkType
        ]
    }
}

extension ScreenContext {
    func toDictionary() -> [String: Any] {
        return [
            "currentView": currentView,
            "navigationPath": navigationPath,
            "viewLoadTime": ISO8601DateFormatter().string(from: viewLoadTime)
        ]
    }
}
