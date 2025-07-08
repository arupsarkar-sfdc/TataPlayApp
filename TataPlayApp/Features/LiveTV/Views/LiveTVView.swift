import SwiftUI

// MARK: - LiveTVView
// Live TV streaming interface based on JSON key_features: live_tv_streaming, channel_management

struct LiveTVView: View, CategoryTrackable, ContentTrackable {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var navigationCoordinator: NavigationCoordinator
    @State private var selectedCategory: ChannelCategory = .all
    @State private var showingChannelGuide = false
    @State private var searchText = ""
    let viewName: String = "LiveTVView"
    // personalization properties
    @StateObject private var personalizationService = PersonalizationService.shared
    @State private var recommendations: PersonalizationResponse?
    @State private var isLoadingRecommendations = false
    
    var body: some View {
        NavigationStack(path: $navigationCoordinator.watchNavigationPath) {
            VStack(spacing: 0) {
                // Search and Filter Header
                headerSection
                
                // Channel Categories Filter
                categoryFilterSection
                
                // Channel Grid
                channelGridSection
            }
            .navigationTitle("Watch Live")
            .navigationBarTitleDisplayMode(.large)
            .background(TataPlayColors.background)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    channelGuideButton
                }
            }
            .navigationDestination(for: String.self) { destination in
                destinationView(for: destination)
            }
            .onAppear {
                trackViewAppeared()
                
                // Track specific LiveTV view appearance
                analyticsService.trackEvent(
                    ViewAppearanceEvent(
                        viewName: viewName,
                        selectedCategory: selectedCategory.rawValue,
                        totalChannels: sampleChannels.count,
                        screenContext: createScreenContext(),
                        userId: nil,
                        sessionId: AnalyticsService.shared.getSessionInfo()["sessionId"] as? String ?? ""
                    )
                )
                // Load personalization recommendations
                loadPersonalizationRecommendations()
            }
            .onDisappear {
                trackViewDisappeared()
            }
            
        }
    }
    
    // MARK: - Channel Categories (from JSON entertainment categories)
    enum ChannelCategory: String, CaseIterable {
        case all = "All"
        case entertainment = "Entertainment"
        case sports = "Sports"
        case news = "News"
        case kids = "Kids"
        case movies = "Movies"
        case music = "Music"
        case regional = "Regional"
        
        var displayName: String {
            return rawValue
        }
        
        var color: Color {
            switch self {
            case .all: return TataPlayColors.primary
            case .entertainment: return TataPlayColors.entertainmentCategory
            case .sports: return TataPlayColors.sportsCategory
            case .news: return TataPlayColors.newsCategory
            case .kids: return TataPlayColors.kidsCategory
            case .movies: return TataPlayColors.moviesCategory
            case .music: return TataPlayColors.musicCategory
            case .regional: return TataPlayColors.regionalCategory
            }
        }
        
        var iconName: String {
            switch self {
            case .all: return "tv"
            case .entertainment: return "star.fill"
            case .sports: return "sportscourt.fill"
            case .news: return "newspaper.fill"
            case .kids: return "face.smiling.fill"
            case .movies: return "film.fill"
            case .music: return "music.note"
            case .regional: return "globe.asia.australia.fill"
            }
        }
    }

    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: SpacingTokens.md) {
            // Live TV Status
            HStack {
                Circle()
                    .fill(TataPlayColors.liveIndicator)
                    .frame(width: 8, height: 8)
                
                Text("Live TV")
                    .styled(.captionText)
                    .foregroundColor(TataPlayColors.liveIndicator)
                
                Spacer()
                
                Text("\(sampleChannels.count) Channels")
                    .styled(.captionText)
                    .foregroundColor(TataPlayColors.textSecondary)
            }
            
            // Search Bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(TataPlayColors.textSecondary)
                
                TextField("Search channels...", text: $searchText)
                    .font(TataPlayTypography.inputField)
                    .onChange(of: searchText) {
                        // Track search input with debounce
                        if !searchText.isEmpty {
                            analyticsService.trackSearch(
                                searchQuery: searchText,
                                searchType: "text_input",
                                resultsCount: filteredChannels.count,
                                selectedFilters: ["category": selectedCategory.rawValue],
                                searchDuration: nil,
                                resultClicked: false,
                                clickedResultPosition: nil,
                                screenContext: createScreenContext()
                            )
                        }
                    }
            }
            .padding(SpacingTokens.inputPadding)
            .background(TataPlayColors.cardBackground)
            .cornerRadius(LayoutConstants.smallCardCornerRadius)
        }
        .padding(.horizontal, SpacingTokens.contentPadding)
        .padding(.top, SpacingTokens.sm)
    }
    
    // MARK: - Category Filter Section
    private var categoryFilterSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: SpacingTokens.md) {
                ForEach(ChannelCategory.allCases, id: \.self) { category in
                    CategoryFilterChip(
                        category: category,
                        isSelected: selectedCategory == category
                    ) {
                        // Track category selection before changing state
                        let previousCategory = selectedCategory.rawValue
                        let allCategories = ChannelCategory.allCases.map { $0.rawValue }
                        let selectionIndex = ChannelCategory.allCases.firstIndex(of: category) ?? 0
                        
                        trackCategorySelection(
                            selectedCategory: category.rawValue,
                            previousCategory: previousCategory != category.rawValue ? previousCategory : nil,
                            availableCategories: allCategories,
                            selectionIndex: selectionIndex
                        )
                        
                        selectedCategory = category
                    }
                }
            }
            .padding(.horizontal, SpacingTokens.contentPadding)
        }
        .padding(.vertical, SpacingTokens.sm)
    }

    // MARK: - Channel Grid Section
    private var channelGridSection: some View {
        ScrollView {
            LazyVGrid(columns: channelGridColumns, spacing: SpacingTokens.gridRowSpacing) {
                ForEach(Array(filteredChannels.enumerated()), id: \.element.id) { index, channel in
                    ChannelCard(channel: channel, recommendations: recommendations) {
                        // Track channel click before navigation
                        // Track channel click manually
                        let metadata: [String: Any] = [
                            "isHD": channel.isHD,
                            "isLive": channel.isLive,
                            "currentProgram": channel.currentProgram
                        ]

                        trackContentClick(
                            contentId: channel.id,
                            contentTitle: channel.name,
                            contentType: "channel",
                            contentCategory: channel.category.rawValue,
                            gridPosition: index,
                            sectionName: "channel_grid",
                            totalItemsInSection: filteredChannels.count,
                            isAboveFold: index < 4,
                            additionalMetadata: metadata
                        )
                        
                        navigationCoordinator.navigateToChannelDetail(channelId: channel.id, in: .watch)
                    }
                }
            }
            .padding(.horizontal, SpacingTokens.contentPadding)
            .padding(.bottom, SpacingTokens.sectionSpacing)
        }
    }

    // MARK: - Channel Guide Button
    private var channelGuideButton: some View {
        Button(action: {
            // Track channel guide button click
            analyticsService.trackEvent(
                GenericButtonClickEvent(
                    buttonName: "channel_guide",
                    buttonType: "toolbar_button",
                    screenContext: createScreenContext(),
                    userId: nil,
                    sessionId: AnalyticsService.shared.getSessionInfo()["sessionId"] as? String ?? ""
                )
            )
            
            showingChannelGuide = true
        }) {
            Image(systemName: "list.bullet.rectangle")
                .font(.title3)
                .foregroundColor(TataPlayColors.primary)
        }
        .sheet(isPresented: $showingChannelGuide) {
            ChannelGuideView()
        }
    }

    // MARK: - Grid Configuration
    private var channelGridColumns: [GridItem] {
        [
            GridItem(.flexible(), spacing: SpacingTokens.gridColumnSpacing),
            GridItem(.flexible(), spacing: SpacingTokens.gridColumnSpacing)
        ]
    }

    // MARK: - Filtered Channels
    private var filteredChannels: [MockChannel] {
        let categoryFiltered = selectedCategory == .all ?
            sampleChannels :
            sampleChannels.filter { $0.category == selectedCategory }
        
        let searchFiltered = searchText.isEmpty ?
            categoryFiltered :
            categoryFiltered.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        
        // Apply personalization ordering
        return applyPersonalizationOrdering(to: searchFiltered)
    }

    // MARK: - Personalization Integration
    private func applyPersonalizationOrdering(to channels: [MockChannel]) -> [MockChannel] {
        guard let recommendations = recommendations else {
            // No recommendations loaded yet, return original order
            return channels
        }
        
        return channels.sorted { channel1, channel2 in
            let score1 = recommendations.getScore(for: channel1.id) ?? 0.0
            let score2 = recommendations.getScore(for: channel2.id) ?? 0.0
            
            // Sort by personalization score (highest first)
            if score1 != score2 {
                return score1 > score2
            }
            
            // Fallback to alphabetical if scores are equal
            return channel1.name < channel2.name
        }
    }
    
    private func loadPersonalizationRecommendations() {
        guard !isLoadingRecommendations else { return }
        
        isLoadingRecommendations = true
        
        Task {
            do {
                let response = try await personalizationService.getChannelRecommendations()
                
                await MainActor.run {
                    self.recommendations = response
                    self.isLoadingRecommendations = false
                    
                    print("🎯 LiveTVView: Loaded \(response.recommendations.count) personalized recommendations")
                    print("📊 Top 3 recommendations:")
                    for (index, rec) in response.topRecommendations.prefix(3).enumerated() {
                        print("   \(index + 1). Channel \(rec.channelId) - Score: \(String(format: "%.2f", rec.score))")
                    }
                }
                
            } catch {
                await MainActor.run {
                    self.isLoadingRecommendations = false
                    print("❌ Failed to load personalization recommendations: \(error)")
                }
            }
        }
    }
    
    // MARK: - Navigation Destination Handler
    @ViewBuilder
    private func destinationView(for destination: String) -> some View {
        if destination.starts(with: "channelDetail_") {
            let channelId = String(destination.dropFirst("channelDetail_".count))
            ChannelDetailView(channelId: channelId)
        } else {
            Text("Live TV Content: \(destination)")
                .styled(.bodyText)
                .navigationTitle("Details")
        }
    }

    // MARK: - Sample Data (from JSON entertainment categories)
    private var sampleChannels: [MockChannel] {
        [
            // Entertainment Channels
            MockChannel(
                id: "1",
                name: "Star Plus",
                category: .entertainment,
                isHD: true,
                isLive: true,
                currentProgram: "Anupamaa",
                logoImageName: "star_plus",
                fallbackIcon: "star.fill"
            ),
            MockChannel(
                id: "2",
                name: "Colors",
                category: .entertainment,
                isHD: true,
                isLive: true,
                currentProgram: "Bigg Boss",
                logoImageName: "colors",
                fallbackIcon: "paintpalette.fill"
            ),
            MockChannel(
                id: "3",
                name: "Zee TV",
                category: .entertainment,
                isHD: false,
                isLive: true,
                currentProgram: "Kumkum Bhagya",
                logoImageName: "zee_tv",
                fallbackIcon: "tv.fill"
            ),
            
            // Sports Channels
            MockChannel(
                id: "4",
                name: "Star Sports 1",
                category: .sports,
                isHD: true,
                isLive: true,
                currentProgram: "Cricket Live",
                logoImageName: "star_sports",
                fallbackIcon: "sportscourt.fill"
            ),
            MockChannel(
                id: "5",
                name: "Sony Sports",
                category: .sports,
                isHD: true,
                isLive: true,
                currentProgram: "Football Match",
                logoImageName: "sony_sports",
                fallbackIcon: "soccer.fill"
            ),
            
            // News Channels
            MockChannel(
                id: "6",
                name: "Times Now",
                category: .news,
                isHD: true,
                isLive: true,
                currentProgram: "Breaking News",
                logoImageName: "times_now",
                fallbackIcon: "newspaper.fill"
            ),
            MockChannel(
                id: "7",
                name: "Republic TV",
                category: .news,
                isHD: false,
                isLive: true,
                currentProgram: "Debate Tonight",
                logoImageName: "republic",
                fallbackIcon: "megaphone.fill"
            ),
            
            // Kids Channels
            MockChannel(
                id: "8",
                name: "Cartoon Network",
                category: .kids,
                isHD: true,
                isLive: true,
                currentProgram: "Tom & Jerry",
                logoImageName: "cartoon_network",
                fallbackIcon: "face_smiling.fill"
            ),
            MockChannel(
                id: "9",
                name: "Disney Channel",
                category: .kids,
                isHD: true,
                isLive: true,
                currentProgram: "Mickey Mouse",
                logoImageName: "disney_channel",
                fallbackIcon: "sparkles"
            ),
            
            // Movies
            MockChannel(
                id: "10",
                name: "Star Gold",
                category: .movies,
                isHD: true,
                isLive: true,
                currentProgram: "Bollywood Blockbuster",
                logoImageName: "star_gold",
                fallbackIcon: "film.fill"
            ),
            MockChannel(
                id: "11",
                name: "Sony Max",
                category: .movies,
                isHD: false,
                isLive: true,
                currentProgram: "Action Movie",
                logoImageName: "sony_max",
                fallbackIcon: "play.rectangle.fill"
            ),
            
            // Music
            MockChannel(
                id: "12",
                name: "MTV",
                category: .music,
                isHD: true,
                isLive: true,
                currentProgram: "Music Videos",
                logoImageName: "mtv",
                fallbackIcon: "music.note"
            ),
            
            // Regional
            MockChannel(
                id: "13",
                name: "Asianet",
                category: .regional,
                isHD: true,
                isLive: true,
                currentProgram: "Malayalam Show",
                logoImageName: "asianet",
                fallbackIcon: "globe.asia.australia.fill"
            ),
        ]
    }

    // MARK: - Mock Channel Model
    struct MockChannel: Identifiable, Hashable {
        let id: String
        let name: String
        let category: ChannelCategory
        let isHD: Bool
        let isLive: Bool
        let currentProgram: String
        let logoImageName: String? // Actual logo image asset name
        let fallbackIcon: String   // System icon for fallback
    }
    
    // MARK: - Supporting UI Components

    struct CategoryFilterChip: View {
        let category: ChannelCategory
        let isSelected: Bool
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                HStack(spacing: SpacingTokens.xs) {
                    Image(systemName: category.iconName)
                        .font(.caption)
                    
                    Text(category.displayName)
                        .font(.caption)
                        .fontWeight(isSelected ? .medium : .regular)
                }
                .padding(.horizontal, SpacingTokens.md)
                .padding(.vertical, SpacingTokens.sm)
                .background(isSelected ? category.color : TataPlayColors.cardBackground)
                .foregroundColor(isSelected ? .white : TataPlayColors.accent)
                .cornerRadius(20)
                .shadow(
                    color: isSelected ? category.color.opacity(0.3) : .clear,
                    radius: 4,
                    x: 0,
                    y: 2
                )
            }
            .buttonStyle(PlainButtonStyle())
        }
    }

    struct ChannelCard: View {
        let channel: MockChannel
        let recommendations: PersonalizationResponse? // Move this parameter
        let action: () -> Void
        
        private func isHighlyRecommended(channel: MockChannel) -> Bool {
            guard let recommendations = recommendations else { return false }
            return recommendations.isRecommended(channelId: channel.id, threshold: 0.8)
        }
        
        var body: some View {
            Button(action: action) {
                VStack(spacing: SpacingTokens.sm) {
                    // Channel Logo and Status
                    ZStack(alignment: .topTrailing) {
                        // Channel Logo Background
                        RoundedRectangle(cornerRadius: LayoutConstants.smallCardCornerRadius)
                            .fill(channel.category.color.opacity(0.1))
                            .frame(height: 80)
                            .overlay(
                                Group {
                                    if let logoImageName = channel.logoImageName {
                                        ZStack {
                                            // Actual Channel Logo
                                            Image(logoImageName)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(height: 60)
                                                .clipped()
                                            
                                            // Subtle gradient overlay for better badge visibility
                                            LinearGradient(
                                                gradient: Gradient(colors: [
                                                    Color.black.opacity(0.0),
                                                    Color.black.opacity(0.1)
                                                ]),
                                                startPoint: .center,
                                                endPoint: .topTrailing
                                            )
                                        }
                                        .cornerRadius(LayoutConstants.smallCardCornerRadius)
                                    } else {
                                        // Fallback system icon
                                        Image(systemName: channel.fallbackIcon)
                                            .font(.title)
                                            .foregroundColor(channel.category.color)
                                    }
                                }
                            )
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            // Personalization Badge (highest priority)
                            if isHighlyRecommended(channel: channel) {
                                HStack(spacing: 2) {
                                    Image(systemName: "star.fill")
                                        .font(.caption2)
                                        .foregroundColor(.white)
                                    
                                    Text("FOR YOU")
                                        .font(.caption2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                }
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color.purple.opacity(0.8),
                                            Color.blue.opacity(0.8)
                                        ]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(4)
                            }
                            
                            // HD Badge
                            if channel.isHD {
                                Text("HD")
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(TataPlayColors.accentGradient)
                                    .cornerRadius(4)
                            }
                            
                            // Live Indicator
                            if channel.isLive {
                                HStack(spacing: 4) {
                                    Circle()
                                        .fill(TataPlayColors.liveIndicator)
                                        .frame(width: 6, height: 6)
                                    
                                    Text("LIVE")
                                        .font(.caption2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                }
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(TataPlayColors.liveIndicator)
                                .cornerRadius(4)
                            }
                        }
                        .offset(x: -4, y: 4) // Add this missing offset
                    }
                    
                    // Channel Info
                    VStack(spacing: SpacingTokens.xs) {
                        Text(channel.name)
                            .styled(.contentTitle)
                            .lineLimit(1)
                        
                        Text(channel.currentProgram)
                            .styled(.captionText)
                            .lineLimit(2)
                            .multilineTextAlignment(.center)
                    }
                }
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

    struct ChannelGuideView: View {
        @Environment(\.dismiss) private var dismiss
        
        var body: some View {
            NavigationView {
                VStack {
                    Text("Electronic Program Guide")
                        .styled(.sectionHeading)
                    
                    Text("EPG and program scheduling will be implemented here")
                        .styled(.bodyText)
                        .multilineTextAlignment(.center)
                        .contentPadding()
                    
                    Spacer()
                }
                .navigationTitle("Program Guide")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") { dismiss() }
                    }
                }
            }
        }
    }
}
