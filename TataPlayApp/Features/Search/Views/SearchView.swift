import SwiftUI

// MARK: - SearchView
// Content search and discovery based on JSON: search_content, content_discovery

struct SearchView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var navigationCoordinator: NavigationCoordinator
    @State private var searchText = ""
    @State private var selectedContentType: ContentType = .all
    @State private var showingFilters = false
    @State private var isSearching = false
    
    var body: some View {
        NavigationStack(path: $navigationCoordinator.searchNavigationPath) {
            VStack(spacing: 0) {
                // Search Header
                searchHeaderSection
                
                // Content Type Filter
                contentTypeFilterSection
                
                // Main Content Area
                if searchText.isEmpty {
                    searchSuggestionsSection
                } else {
                    searchResultsSection
                }
            }
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.large)
            .background(TataPlayColors.background)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    filterButton
                }
            }
            .navigationDestination(for: String.self) { destination in
                destinationView(for: destination)
            }
        }
    }
    
    // MARK: - Content Types (from JSON content discovery)
    enum ContentType: String, CaseIterable {
        case all = "All"
        case channels = "Channels"
        case programs = "Programs"
        case movies = "Movies"
        case series = "Series"
        case sports = "Sports"
        case news = "News"
        case kids = "Kids"
        
        var displayName: String {
            return rawValue
        }
        
        var iconName: String {
            switch self {
            case .all: return "magnifyingglass"
            case .channels: return "tv"
            case .programs: return "calendar"
            case .movies: return "film"
            case .series: return "tv.and.hifispeaker.fill"
            case .sports: return "sportscourt"
            case .news: return "newspaper"
            case .kids: return "face.smiling"
            }
        }
        
        var color: Color {
            switch self {
            case .all: return TataPlayColors.primary
            case .channels: return TataPlayColors.entertainmentCategory
            case .programs: return TataPlayColors.accent
            case .movies: return TataPlayColors.moviesCategory
            case .series: return TataPlayColors.secondary
            case .sports: return TataPlayColors.sportsCategory
            case .news: return TataPlayColors.newsCategory
            case .kids: return TataPlayColors.kidsCategory
            }
        }
    }

    // MARK: - Search Header Section
    private var searchHeaderSection: some View {
        VStack(spacing: SpacingTokens.md) {
            // Search Bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(TataPlayColors.textSecondary)
                
                TextField("Search channels, shows, movies...", text: $searchText)
                    .font(TataPlayTypography.inputField)
                    .onChange(of: searchText) { _ in
                        performSearch()
                    }
                
                if !searchText.isEmpty {
                    Button(action: clearSearch) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(TataPlayColors.textSecondary)
                    }
                }
            }
            .padding(SpacingTokens.inputPadding)
            .background(TataPlayColors.cardBackground)
            .cornerRadius(LayoutConstants.smallCardCornerRadius)
            
            // Search Status
            if isSearching {
                HStack {
                    ProgressView()
                        .scaleEffect(0.8)
                    
                    Text("Searching...")
                        .styled(.captionText)
                        .foregroundColor(TataPlayColors.textSecondary)
                    
                    Spacer()
                }
            }
        }
        .padding(.horizontal, SpacingTokens.contentPadding)
        .padding(.top, SpacingTokens.sm)
    }
    
    // MARK: - Content Type Filter Section
    private var contentTypeFilterSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: SpacingTokens.md) {
                ForEach(ContentType.allCases, id: \.self) { contentType in
                    ContentTypeChip(
                        contentType: contentType,
                        isSelected: selectedContentType == contentType
                    ) {
                        selectedContentType = contentType
                        if !searchText.isEmpty {
                            performSearch()
                        }
                    }
                }
            }
            .padding(.horizontal, SpacingTokens.contentPadding)
        }
        .padding(.vertical, SpacingTokens.sm)
    }

    // MARK: - Filter Button
    private var filterButton: some View {
        Button(action: {
            showingFilters = true
        }) {
            Image(systemName: "slider.horizontal.3")
                .font(.title3)
                .foregroundColor(TataPlayColors.primary)
        }
        .sheet(isPresented: $showingFilters) {
            SearchFiltersView()
        }
    }

    // MARK: - Search Functions
    private func performSearch() {
        guard !searchText.isEmpty else { return }
        
        isSearching = true
        
        // Simulate search delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            isSearching = false
        }
    }

    private func clearSearch() {
        searchText = ""
        isSearching = false
    }
    
    // MARK: - Search Suggestions Section
    private var searchSuggestionsSection: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SpacingTokens.sectionSpacing) {
                // Recent Searches
                if !recentSearches.isEmpty {
                    VStack(alignment: .leading, spacing: SpacingTokens.lg) {
                        Text("Recent Searches")
                            .styled(.sectionHeading)
                        
                        LazyVGrid(columns: suggestionGridColumns, spacing: SpacingTokens.md) {
                            ForEach(recentSearches, id: \.self) { search in
                                RecentSearchChip(searchTerm: search) {
                                    searchText = search
                                    performSearch()
                                }
                            }
                        }
                    }
                }
                
                // Popular Content
                VStack(alignment: .leading, spacing: SpacingTokens.lg) {
                    Text("Popular Right Now")
                        .styled(.sectionHeading)
                    
                    LazyVGrid(columns: contentGridColumns, spacing: SpacingTokens.gridRowSpacing) {
                        ForEach(popularContent, id: \.id) { content in
                            SearchContentCard(content: content) {
                                navigationCoordinator.navigateToContentDetail(contentId: content.id, in: .search)
                            }
                        }
                    }
                }
                
                // Trending Searches
                VStack(alignment: .leading, spacing: SpacingTokens.lg) {
                    Text("Trending Searches")
                        .styled(.sectionHeading)
                    
                    LazyVGrid(columns: suggestionGridColumns, spacing: SpacingTokens.md) {
                        ForEach(trendingSearches, id: \.self) { search in
                            TrendingSearchChip(searchTerm: search) {
                                searchText = search
                                performSearch()
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, SpacingTokens.contentPadding)
            .padding(.bottom, SpacingTokens.sectionSpacing)
        }
    }

    // MARK: - Search Results Section
    private var searchResultsSection: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SpacingTokens.lg) {
                // Results Header
                HStack {
                    Text("Results for \"\(searchText)\"")
                        .styled(.sectionHeading)
                    
                    Spacer()
                    
                    Text("\(filteredSearchResults.count) found")
                        .styled(.captionText)
                        .foregroundColor(TataPlayColors.textSecondary)
                }
                
                // Results Grid
                LazyVGrid(columns: contentGridColumns, spacing: SpacingTokens.gridRowSpacing) {
                    ForEach(filteredSearchResults, id: \.id) { content in
                        SearchContentCard(content: content) {
                            addToRecentSearches(searchText)
                            navigationCoordinator.navigateToContentDetail(contentId: content.id, in: .search)
                        }
                    }
                }
            }
            .padding(.horizontal, SpacingTokens.contentPadding)
            .padding(.bottom, SpacingTokens.sectionSpacing)
        }
    }
    // MARK: - Grid Configurations (using your actual spacing system)
    private var suggestionGridColumns: [GridItem] {
        [
            GridItem(.flexible(), spacing: SpacingTokens.gridColumnSpacing),
            GridItem(.flexible(), spacing: SpacingTokens.gridColumnSpacing)
        ]
    }

    private var contentGridColumns: [GridItem] {
        GridHelpers.contentGrid()
    }

    // MARK: - Search Helper Functions
    private func addToRecentSearches(_ search: String) {
        // In production, this would save to UserDefaults or Core Data
        print("Added to recent searches: \(search)")
    }

    // MARK: - Sample Data (from JSON content_discovery and personalization)
    private var recentSearches: [String] {
        ["Cricket", "Bollywood Movies", "News", "Kids Shows"]
    }

    private var trendingSearches: [String] {
        ["IPL 2024", "Web Series", "Comedy Shows", "Regional Cinema", "Live News", "Music Videos"]
    }

    private var popularContent: [MockSearchContent] {
        [
            MockSearchContent(id: "1", title: "Star Sports 1 HD", type: .channels, category: "Sports", imageIcon: "sportscourt.fill"),
            MockSearchContent(id: "2", title: "KBC 2024", type: .programs, category: "Entertainment", imageIcon: "tv.fill"),
            MockSearchContent(id: "3", title: "Pathaan", type: .movies, category: "Bollywood", imageIcon: "film.fill"),
            MockSearchContent(id: "4", title: "Scam 1992", type: .series, category: "Drama", imageIcon: "tv.and.hifispeaker.fill"),
            MockSearchContent(id: "5", title: "IPL Highlights", type: .sports, category: "Cricket", imageIcon: "sportscourt.fill"),
            MockSearchContent(id: "6", title: "Breaking News", type: .news, category: "Current Affairs", imageIcon: "newspaper.fill")
        ]
    }

    private var filteredSearchResults: [MockSearchContent] {
        let typeFiltered = selectedContentType == .all ?
            allSearchContent :
            allSearchContent.filter { $0.type == selectedContentType }
        
        return typeFiltered.filter { content in
            content.title.localizedCaseInsensitiveContains(searchText) ||
            content.category.localizedCaseInsensitiveContains(searchText)
        }
    }

    private var allSearchContent: [MockSearchContent] {
        popularContent + [
            MockSearchContent(id: "7", title: "Colors HD", type: .channels, category: "Entertainment", imageIcon: "tv.fill"),
            MockSearchContent(id: "8", title: "Anupamaa", type: .programs, category: "Drama", imageIcon: "heart.fill"),
            MockSearchContent(id: "9", title: "RRR", type: .movies, category: "Action", imageIcon: "film.fill"),
            MockSearchContent(id: "10", title: "The Family Man", type: .series, category: "Thriller", imageIcon: "person.fill")
        ]
    }
    
    // MARK: - Navigation Destination Handler
    @ViewBuilder
    private func destinationView(for destination: String) -> some View {
        if destination.starts(with: "contentDetail_") {
            let contentId = String(destination.dropFirst("contentDetail_".count))
            SearchContentDetailView(contentId: contentId)
        } else if destination.starts(with: "searchResults_") {
            let query = String(destination.dropFirst("searchResults_".count))
            Text("Search Results for: \(query)")
                .styled(.contentTitle)
                .navigationTitle("Results")
        } else {
            Text("Search Content: \(destination)")
                .styled(.bodyText)
                .navigationTitle("Details")
        }
    }

    // MARK: - Mock Search Content Model
    struct MockSearchContent: Identifiable, Hashable {
        let id: String
        let title: String
        let type: ContentType
        let category: String
        let imageIcon: String
        
        var typeColor: Color {
            type.color
        }
        
        var displayCategory: String {
            "\(type.displayName) • \(category)"
        }
    }

    // MARK: - Supporting UI Components

    struct ContentTypeChip: View {
        let contentType: ContentType
        let isSelected: Bool
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                HStack(spacing: SpacingTokens.xs) {
                    Image(systemName: contentType.iconName)
                        .font(.caption)
                    
                    Text(contentType.displayName)
                        .font(TataPlayTypography.smallCaption)
                        .fontWeight(isSelected ? .medium : .regular)
                }
                .padding(.horizontal, SpacingTokens.md)
                .padding(.vertical, SpacingTokens.sm)
                .background(isSelected ? contentType.color : TataPlayColors.cardBackground)
                .foregroundColor(isSelected ? .white : TataPlayColors.text)
                .cornerRadius(20)
                .shadow(
                    color: isSelected ? contentType.color.opacity(0.3) : .clear,
                    radius: 4,
                    x: 0,
                    y: 2
                )
            }
            .buttonStyle(PlainButtonStyle())
        }
    }

    struct RecentSearchChip: View {
        let searchTerm: String
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                HStack(spacing: SpacingTokens.sm) {
                    Image(systemName: "clock.arrow.circlepath")
                        .font(.caption)
                        .foregroundColor(TataPlayColors.textSecondary)
                    
                    Text(searchTerm)
                        .font(TataPlayTypography.captionText)
                        .foregroundColor(TataPlayColors.text)
                    
                    Spacer()
                }
                .padding(.horizontal, SpacingTokens.md)
                .padding(.vertical, SpacingTokens.sm)
                .background(TataPlayColors.cardBackground)
                .cornerRadius(LayoutConstants.smallCardCornerRadius)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }

    struct TrendingSearchChip: View {
        let searchTerm: String
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                HStack(spacing: SpacingTokens.sm) {
                    Image(systemName: "flame.fill")
                        .font(.caption)
                        .foregroundColor(TataPlayColors.brandOrange)
                    
                    Text(searchTerm)
                        .font(TataPlayTypography.captionText)
                        .foregroundColor(TataPlayColors.text)
                    
                    Spacer()
                }
                .padding(.horizontal, SpacingTokens.md)
                .padding(.vertical, SpacingTokens.sm)
                .background(TataPlayColors.brandOrange.opacity(0.1))
                .cornerRadius(LayoutConstants.smallCardCornerRadius)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    struct SearchContentCard: View {
        let content: MockSearchContent
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                VStack(alignment: .leading, spacing: SpacingTokens.sm) {
                    // Content Icon and Type Badge
                    ZStack(alignment: .topTrailing) {
                        RoundedRectangle(cornerRadius: LayoutConstants.smallCardCornerRadius)
                            .fill(content.typeColor.opacity(0.1))
                            .frame(height: 100)
                            .overlay(
                                Image(systemName: content.imageIcon)
                                    .font(.title)
                                    .foregroundColor(content.typeColor)
                            )
                        
                        // Type Badge
                        Text(content.type.displayName)
                            .font(TataPlayTypography.smallCaption)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .padding(.horizontal, SpacingTokens.sm)
                            .padding(.vertical, SpacingTokens.xs)
                            .background(content.typeColor)
                            .cornerRadius(12)
                            .offset(x: -SpacingTokens.xs, y: SpacingTokens.xs)
                    }
                    
                    // Content Info
                    VStack(alignment: .leading, spacing: SpacingTokens.xs) {
                        Text(content.title)
                            .styled(.contentTitle)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                        
                        Text(content.displayCategory)
                            .styled(.captionText)
                            .lineLimit(1)
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

    struct SearchFiltersView: View {
        @Environment(\.dismiss) private var dismiss
        
        var body: some View {
            NavigationView {
                ScrollView {
                    VStack(alignment: .leading, spacing: SpacingTokens.sectionSpacing) {
                        // Content Type Filters
                        VStack(alignment: .leading, spacing: SpacingTokens.lg) {
                            Text("Content Type")
                                .styled(.sectionHeading)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: SpacingTokens.md) {
                                ForEach(ContentType.allCases, id: \.self) { type in
                                    FilterOptionCard(
                                        title: type.displayName,
                                        iconName: type.iconName,
                                        color: type.color,
                                        isSelected: false
                                    ) {
                                        // Filter action
                                    }
                                }
                            }
                        }
                        
                        // Genre Filters
                        VStack(alignment: .leading, spacing: SpacingTokens.lg) {
                            Text("Genres")
                                .styled(.sectionHeading)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: SpacingTokens.sm) {
                                ForEach(sampleGenres, id: \.self) { genre in
                                    FilterChip(title: genre, isSelected: false) {
                                        // Genre filter action
                                    }
                                }
                            }
                        }
                        
                        // Language Filters
                        VStack(alignment: .leading, spacing: SpacingTokens.lg) {
                            Text("Languages")
                                .styled(.sectionHeading)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: SpacingTokens.sm) {
                                ForEach(sampleLanguages, id: \.self) { language in
                                    FilterChip(title: language, isSelected: false) {
                                        // Language filter action
                                    }
                                }
                            }
                        }
                    }
                    .padding(SpacingTokens.contentPadding)
                }
                .navigationTitle("Search Filters")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Reset") {
                            // Reset filters
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") { dismiss() }
                    }
                }
            }
        }
        
        private var sampleGenres: [String] {
            ["Action", "Comedy", "Drama", "Thriller", "Romance", "Horror", "Sci-Fi", "Documentary"]
        }
        
        private var sampleLanguages: [String] {
            ["Hindi", "English", "Tamil", "Telugu", "Malayalam", "Kannada", "Bengali", "Marathi"]
        }
    }

    struct SearchContentDetailView: View {
        let contentId: String
        
        var body: some View {
            ScrollView {
                VStack(alignment: .leading, spacing: SpacingTokens.lg) {
                    Text("Content Details")
                        .styled(.contentTitle)
                    
                    Text("Content ID: \(contentId)")
                        .styled(.bodyText)
                    
                    Text("Detailed information about this content will be displayed here.")
                        .styled(.captionText)
                }
                .contentPadding()
            }
            .navigationTitle("Details")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    struct FilterOptionCard: View {
        let title: String
        let iconName: String
        let color: Color
        let isSelected: Bool
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                HStack(spacing: SpacingTokens.sm) {
                    Image(systemName: iconName)
                        .foregroundColor(isSelected ? .white : color)
                    
                    Text(title)
                        .font(TataPlayTypography.captionText)
                        .foregroundColor(isSelected ? .white : TataPlayColors.text)
                    
                    Spacer()
                }
                .padding(SpacingTokens.md)
                .background(isSelected ? color : TataPlayColors.cardBackground)
                .cornerRadius(LayoutConstants.smallCardCornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: LayoutConstants.smallCardCornerRadius)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
            }
            .buttonStyle(PlainButtonStyle())
        }
    }

    struct FilterChip: View {
        let title: String
        let isSelected: Bool
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                Text(title)
                    .font(TataPlayTypography.smallCaption)
                    .foregroundColor(isSelected ? .white : TataPlayColors.text)
                    .padding(.horizontal, SpacingTokens.md)
                    .padding(.vertical, SpacingTokens.sm)
                    .background(isSelected ? TataPlayColors.primary : TataPlayColors.cardBackground)
                    .cornerRadius(16)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}
