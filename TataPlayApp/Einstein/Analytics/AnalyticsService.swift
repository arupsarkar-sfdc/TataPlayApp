//
//  AnalyticsService.swift
//  TataPlayApp
//
//  Created by Arup Sarkar (TA) on 7/8/25.
//

import Foundation
import Combine
import UIKit

// MARK: - Analytics Service Protocol
protocol AnalyticsServiceProtocol {
    func trackEvent(_ event: AnalyticsEvent)
    func trackCategorySelection(
        selectedCategory: String,
        previousCategory: String?,
        categoryType: String,
        availableOptions: [String],
        selectionIndex: Int,
        screenContext: ScreenContext
    )
    func trackContentClick(
        contentId: String,
        contentTitle: String,
        contentType: String,
        contentCategory: String,
        contentMetadata: ContentMetadata,
        clickPosition: ClickPosition,
        contextualData: ContextualData,
        screenContext: ScreenContext
    )
    func trackSearch(
        searchQuery: String,
        searchType: String,
        resultsCount: Int?,
        selectedFilters: [String: String],
        searchDuration: TimeInterval?,
        resultClicked: Bool,
        clickedResultPosition: Int?,
        screenContext: ScreenContext
    )
    func startSession()
    func endSession()
}

// MARK: - Analytics Service Implementation
class AnalyticsService: AnalyticsServiceProtocol, ObservableObject {
    
    // MARK: - Singleton
    static let shared = AnalyticsService()
    
    // MARK: - Properties
    private var sessionId: String = ""
    private var userId: String?
    private var sessionStartTime: Date?
    private var lastCategorySelection: (category: String, time: Date)?
    private var eventQueue: [AnalyticsEvent] = []
    private var isEnabled: Bool = true
    
    // MARK: - Configuration
    private let maxQueueSize = 100
    private let flushInterval: TimeInterval = 30.0 // Flush every 30 seconds
    private var flushTimer: Timer?
    
    // MARK: - Publishers for real-time monitoring
    @Published private(set) var lastEvent: AnalyticsEvent?
    @Published private(set) var eventCount: Int = 0
    
    // MARK: - Initialization
    private init() {
        generateNewSession()
        setupPeriodicFlush()
        
        // Listen for app lifecycle events
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidEnterBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appWillEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }
    
    deinit {
        flushTimer?.invalidate()
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Session Management
    func startSession() {
        generateNewSession()
        logEvent("📱 Analytics Session Started", [
            "sessionId": sessionId,
            "userId": userId ?? "anonymous",
            "timestamp": ISO8601DateFormatter().string(from: Date())
        ])
    }
    
    func endSession() {
        if let startTime = sessionStartTime {
            let sessionDuration = Date().timeIntervalSince(startTime)
            logEvent("📱 Analytics Session Ended", [
                "sessionId": sessionId,
                "duration": sessionDuration,
                "eventsTracked": eventCount
            ])
        }
        
        flushEvents()
    }
    
    func setUserId(_ userId: String) {
        self.userId = userId
        logEvent("👤 User ID Set", ["userId": userId])
    }
    
    // MARK: - Event Tracking Methods
    func trackEvent(_ event: AnalyticsEvent) {
        guard isEnabled else { return }
        
        // Add to queue
        eventQueue.append(event)
        eventCount += 1
        lastEvent = event
        
        // Log to console immediately
        logEventToConsole(event)
        
        // Flush if queue is full
        if eventQueue.count >= maxQueueSize {
            flushEvents()
        }
    }
    
    func trackCategorySelection(
        selectedCategory: String,
        previousCategory: String?,
        categoryType: String,
        availableOptions: [String],
        selectionIndex: Int,
        screenContext: ScreenContext
    ) {
        // Calculate time since last selection
        let timeSinceLastSelection: TimeInterval? = {
            if let last = lastCategorySelection {
                return Date().timeIntervalSince(last.time)
            }
            return nil
        }()
        
        // Create and track event
        let event = CategorySelectionEvent(
            selectedCategory: selectedCategory,
            previousCategory: previousCategory,
            categoryType: categoryType,
            availableOptions: availableOptions,
            selectionIndex: selectionIndex,
            timeSinceLastSelection: timeSinceLastSelection,
            userId: userId,
            sessionId: sessionId,
            screenContext: screenContext
        )
        
        trackEvent(event)
        
        // Update last selection
        lastCategorySelection = (selectedCategory, Date())
    }
    
    func trackContentClick(
        contentId: String,
        contentTitle: String,
        contentType: String,
        contentCategory: String,
        contentMetadata: ContentMetadata,
        clickPosition: ClickPosition,
        contextualData: ContextualData,
        screenContext: ScreenContext
    ) {
        let event = ContentClickEvent(
            contentId: contentId,
            contentTitle: contentTitle,
            contentType: contentType,
            contentCategory: contentCategory,
            contentMetadata: contentMetadata,
            clickPosition: clickPosition,
            contextualData: contextualData,
            userId: userId,
            sessionId: sessionId,
            screenContext: screenContext
        )
        
        trackEvent(event)
    }
    
    func trackSearch(
        searchQuery: String,
        searchType: String,
        resultsCount: Int?,
        selectedFilters: [String: String],
        searchDuration: TimeInterval?,
        resultClicked: Bool,
        clickedResultPosition: Int?,
        screenContext: ScreenContext
    ) {
        let event = SearchEvent(
            searchQuery: searchQuery,
            searchType: searchType,
            resultsCount: resultsCount,
            selectedFilters: selectedFilters,
            searchDuration: searchDuration,
            resultClicked: resultClicked,
            clickedResultPosition: clickedResultPosition,
            userId: userId,
            sessionId: sessionId,
            screenContext: screenContext
        )
        
        trackEvent(event)
    }
    
    // MARK: - Private Helper Methods
    private func generateNewSession() {
        sessionId = UUID().uuidString
        sessionStartTime = Date()
        eventCount = 0
        eventQueue.removeAll()
    }
    
    private func setupPeriodicFlush() {
        flushTimer = Timer.scheduledTimer(withTimeInterval: flushInterval, repeats: true) { [weak self] _ in
            self?.flushEvents()
        }
    }
    
    private func flushEvents() {
        guard !eventQueue.isEmpty else { return }
        
        logEvent("🚀 Flushing Events to Salesforce", [
            "eventCount": eventQueue.count,
            "sessionId": sessionId
        ])
        
        // TODO: Send to Salesforce Data Cloud API
        // For now, we'll just log the batch
        logBatchToConsole()
        
        // Clear the queue after successful flush
        eventQueue.removeAll()
    }
    
    private func logEventToConsole(_ event: AnalyticsEvent) {
        let eventData = event.toDictionary()
        
        print("\n" + "="*60)
        print("🎯 ANALYTICS EVENT TRACKED")
        print("="*60)
        print("📋 Event Type: \(event.eventType)")
        print("🆔 Event ID: \(event.eventId)")
        print("⏰ Timestamp: \(ISO8601DateFormatter().string(from: event.timestamp))")
        print("👤 User ID: \(event.userId ?? "anonymous")")
        print("📱 Session ID: \(event.sessionId)")
        
        // Pretty print the full payload
        if let jsonData = try? JSONSerialization.data(withJSONObject: eventData, options: .prettyPrinted),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            print("📦 Full Payload:")
            print(jsonString)
        }
        
        print("="*60 + "\n")
    }
    
    private func logBatchToConsole() {
        print("\n" + "🚀"*20)
        print("BATCH FLUSH TO SALESFORCE DATA CLOUD")
        print("🚀"*20)
        print("📊 Total Events in Batch: \(eventQueue.count)")
        print("📱 Session ID: \(sessionId)")
        print("⏰ Flush Time: \(ISO8601DateFormatter().string(from: Date()))")
        
        // Log summary of event types
        let eventTypeCounts = Dictionary(grouping: eventQueue, by: { $0.eventType })
            .mapValues { $0.count }
        
        print("📈 Event Breakdown:")
        for (eventType, count) in eventTypeCounts {
            print("   • \(eventType): \(count)")
        }
        
        print("🚀"*20 + "\n")
    }
    
    private func logEvent(_ message: String, _ data: [String: Any] = [:]) {
        print("\n📊 AnalyticsService: \(message)")
        if !data.isEmpty {
            for (key, value) in data {
                print("   • \(key): \(value)")
            }
        }
        print("")
    }
    
    // MARK: - App Lifecycle Handlers
    @objc private func appDidEnterBackground() {
        flushEvents()
    }
    
    @objc private func appWillEnterForeground() {
        // Generate new session for foreground return
        generateNewSession()
    }
    
    // MARK: - Configuration Methods
    func setEnabled(_ enabled: Bool) {
        isEnabled = enabled
        logEvent(enabled ? "Analytics Enabled" : "Analytics Disabled")
    }
    
    func getSessionInfo() -> [String: Any] {
        return [
            "sessionId": sessionId,
            "userId": userId ?? "anonymous",
            "sessionStartTime": sessionStartTime?.timeIntervalSince1970 ?? 0,
            "eventCount": eventCount,
            "queueSize": eventQueue.count,
            "isEnabled": isEnabled
        ]
    }
}

// MARK: - String Extension for Console Formatting
extension String {
    static func *(lhs: String, rhs: Int) -> String {
        return String(repeating: lhs, count: rhs)
    }
}
