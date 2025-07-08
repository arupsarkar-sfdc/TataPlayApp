//
//  TrackingProtocol.swift
//  TataPlayApp
//
//  Created by Arup Sarkar (TA) on 7/8/25.
//

import Foundation
import SwiftUI

// MARK: - Trackable View Protocol
protocol TrackableView {
    var viewName: String { get }
    var analyticsService: AnalyticsServiceProtocol { get }
    
    func createScreenContext() -> ScreenContext
    func trackViewAppeared()
    func trackViewDisappeared()
}

// MARK: - Category Trackable Protocol
protocol CategoryTrackable: TrackableView {
    func trackCategorySelection(
        selectedCategory: String,
        previousCategory: String?,
        availableCategories: [String],
        selectionIndex: Int
    )
}

// MARK: - Content Trackable Protocol
protocol ContentTrackable: TrackableView {
    func trackContentClick(
        contentId: String,
        contentTitle: String,
        contentType: String,
        contentCategory: String,
        gridPosition: Int,
        sectionName: String,
        totalItemsInSection: Int,
        isAboveFold: Bool,
        additionalMetadata: [String: Any]?
    )
}

// MARK: - Search Trackable Protocol
protocol SearchTrackable: TrackableView {
    func trackSearchQuery(
        query: String,
        resultsCount: Int?,
        selectedFilters: [String: String]
    )
    
    func trackSearchResultClick(
        query: String,
        clickedPosition: Int,
        contentId: String,
        contentTitle: String
    )
}

// MARK: - Default Implementations
extension TrackableView {
    var analyticsService: AnalyticsServiceProtocol {
        return AnalyticsService.shared
    }
    
    func createScreenContext() -> ScreenContext {
        return ScreenContext(
            currentView: viewName,
            navigationPath: [] // TODO: Extract from NavigationCoordinator if needed
        )
    }
    
    func trackViewAppeared() {
        print("📱 View Appeared: \(viewName)")
        // TODO: Implement view appearance tracking if needed
    }
    
    func trackViewDisappeared() {
        print("📱 View Disappeared: \(viewName)")
        // TODO: Implement view disappearance tracking if needed
    }
}

// MARK: - Category Trackable Default Implementation
extension CategoryTrackable {
    func trackCategorySelection(
        selectedCategory: String,
        previousCategory: String?,
        availableCategories: [String],
        selectionIndex: Int
    ) {
        analyticsService.trackCategorySelection(
            selectedCategory: selectedCategory,
            previousCategory: previousCategory,
            categoryType: determineCategoryType(),
            availableOptions: availableCategories,
            selectionIndex: selectionIndex,
            screenContext: createScreenContext()
        )
    }
    
    private func determineCategoryType() -> String {
        switch viewName {
        case "LiveTVView":
            return "channel_category"
        case "SearchView":
            return "content_type"
        default:
            return "generic_category"
        }
    }
}

// MARK: - Content Trackable Default Implementation
extension ContentTrackable {
    func trackContentClick(
        contentId: String,
        contentTitle: String,
        contentType: String,
        contentCategory: String,
        gridPosition: Int,
        sectionName: String,
        totalItemsInSection: Int,
        isAboveFold: Bool,
        additionalMetadata: [String: Any]? = nil
    ) {
        // Create content metadata
        let contentMetadata = createContentMetadata(from: additionalMetadata)
        
        // Create click position
        let clickPosition = ClickPosition(
            gridPosition: gridPosition,
            sectionName: sectionName,
            totalItemsInSection: totalItemsInSection,
            isAboveFold: isAboveFold
        )
        
        // Create contextual data
        let contextualData = createContextualData()
        
        analyticsService.trackContentClick(
            contentId: contentId,
            contentTitle: contentTitle,
            contentType: contentType,
            contentCategory: contentCategory,
            contentMetadata: contentMetadata,
            clickPosition: clickPosition,
            contextualData: contextualData,
            screenContext: createScreenContext()
        )
    }
    
    private func createContentMetadata(from additionalMetadata: [String: Any]?) -> ContentMetadata {
        return ContentMetadata(
            isHD: additionalMetadata?["isHD"] as? Bool,
            isLive: additionalMetadata?["isLive"] as? Bool,
            currentProgram: additionalMetadata?["currentProgram"] as? String,
            genre: additionalMetadata?["genre"] as? String,
            language: additionalMetadata?["language"] as? String,
            rating: additionalMetadata?["rating"] as? String,
            duration: additionalMetadata?["duration"] as? TimeInterval
        )
    }
    
    private func createContextualData() -> ContextualData {
        return ContextualData(
            activeFilters: getCurrentFilters(),
            searchQuery: getCurrentSearchQuery(),
            timeSpentOnScreen: getTimeSpentOnScreen(),
            previousAction: getPreviousAction(),
            recommendationSource: getRecommendationSource()
        )
    }
    
    // MARK: - Helper methods to be overridden by implementing views
    private func getCurrentFilters() -> [String: String] {
        // Override in implementing view to return actual filters
        return [:]
    }
    
    private func getCurrentSearchQuery() -> String? {
        // Override in implementing view to return actual search query
        return nil
    }
    
    private func getTimeSpentOnScreen() -> TimeInterval {
        // Override in implementing view to return actual time spent
        return 0
    }
    
    private func getPreviousAction() -> String? {
        // Override in implementing view to return actual previous action
        return nil
    }
    
    private func getRecommendationSource() -> String? {
        // Override in implementing view to return actual recommendation source
        return nil
    }
}

// MARK: - Search Trackable Default Implementation
extension SearchTrackable {
    func trackSearchQuery(
        query: String,
        resultsCount: Int?,
        selectedFilters: [String: String] = [:]
    ) {
        analyticsService.trackSearch(
            searchQuery: query,
            searchType: "text_input",
            resultsCount: resultsCount,
            selectedFilters: selectedFilters,
            searchDuration: nil,
            resultClicked: false,
            clickedResultPosition: nil,
            screenContext: createScreenContext()
        )
    }
    
    func trackSearchResultClick(
        query: String,
        clickedPosition: Int,
        contentId: String,
        contentTitle: String
    ) {
        analyticsService.trackSearch(
            searchQuery: query,
            searchType: "result_click",
            resultsCount: nil,
            selectedFilters: [:],
            searchDuration: nil,
            resultClicked: true,
            clickedResultPosition: clickedPosition,
            screenContext: createScreenContext()
        )
    }
}

// MARK: - Tracking Helper Extensions

// MARK: - LiveTV Specific Tracking Helpers
extension TrackableView where Self: AnyObject {
    
    /// Helper for LiveTV Channel tracking
    func trackChannelClick(
        channel: Any, // Use Any to avoid tight coupling to MockChannel
        gridPosition: Int,
        totalChannels: Int,
        isAboveFold: Bool
    ) {
        // Use reflection to extract channel properties safely
        let mirror = Mirror(reflecting: channel)
        var channelId = "unknown"
        var channelName = "unknown"
        var category = "unknown"
        var isHD = false
        var isLive = false
        var currentProgram: String?
        
        for (label, value) in mirror.children {
            switch label {
            case "id":
                channelId = "\(value)"
            case "name":
                channelName = "\(value)"
            case "category":
                category = "\(value)"
            case "isHD":
                isHD = value as? Bool ?? false
            case "isLive":
                isLive = value as? Bool ?? false
            case "currentProgram":
                currentProgram = value as? String
            default:
                break
            }
        }
        
        let metadata: [String: Any] = [
            "isHD": isHD,
            "isLive": isLive,
            "currentProgram": currentProgram as Any
        ]
        
        if let contentTrackable = self as? ContentTrackable {
            contentTrackable.trackContentClick(
                contentId: channelId,
                contentTitle: channelName,
                contentType: "channel",
                contentCategory: category,
                gridPosition: gridPosition,
                sectionName: "channel_grid",
                totalItemsInSection: totalChannels,
                isAboveFold: isAboveFold,
                additionalMetadata: metadata
            )
        }
    }
}

// MARK: - Search Specific Tracking Helpers
extension TrackableView where Self: AnyObject {
    
    /// Helper for Search Content tracking
    func trackSearchContentClick(
        content: Any, // Use Any to avoid tight coupling to MockSearchContent
        gridPosition: Int,
        totalResults: Int,
        isAboveFold: Bool,
        searchQuery: String?
    ) {
        // Use reflection to extract content properties safely
        let mirror = Mirror(reflecting: content)
        var contentId = "unknown"
        var contentTitle = "unknown"
        var contentType = "unknown"
        var category = "unknown"
        
        for (label, value) in mirror.children {
            switch label {
            case "id":
                contentId = "\(value)"
            case "title":
                contentTitle = "\(value)"
            case "type":
                contentType = "\(value)"
            case "category":
                category = "\(value)"
            default:
                break
            }
        }
        
        let metadata: [String: Any] = [
            "searchQuery": searchQuery as Any
        ]
        
        if let contentTrackable = self as? ContentTrackable {
            contentTrackable.trackContentClick(
                contentId: contentId,
                contentTitle: contentTitle,
                contentType: contentType,
                contentCategory: category,
                gridPosition: gridPosition,
                sectionName: searchQuery != nil ? "search_results" : "popular_content",
                totalItemsInSection: totalResults,
                isAboveFold: isAboveFold,
                additionalMetadata: metadata
            )
        }
    }
}

// MARK: - View Modifier for Easy Tracking Integration
struct TrackingViewModifier: ViewModifier {
    let trackableView: TrackableView
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                trackableView.trackViewAppeared()
            }
            .onDisappear {
                trackableView.trackViewDisappeared()
            }
    }
}

extension View {
    func trackingEnabled(for trackableView: TrackableView) -> some View {
        modifier(TrackingViewModifier(trackableView: trackableView))
    }
}
