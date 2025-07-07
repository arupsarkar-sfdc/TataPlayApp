import SwiftUI

// MARK: - SpacingTokens
// Spacing system extracted from Tata Play website scaffolding JSON
// From JSON spacing_patterns: ["0.5rem", "24px", "1rem", "8px", "64px", etc.]

struct SpacingTokens {
    
    // MARK: - Base Spacing Scale (From JSON patterns converted to iOS points)
    
    /// Extra small spacing (2pt) - for fine details
    static let xs: CGFloat = 2
    
    /// Small spacing (4pt) - minimal gaps
    static let sm: CGFloat = 4
    
    /// Medium spacing (8pt) - standard element spacing (from JSON: "8px")
    static let md: CGFloat = 8
    
    /// Large spacing (12pt) - section spacing
    static let lg: CGFloat = 12
    
    /// Extra large spacing (16pt) - major section spacing (from JSON: "0px 16px")
    static let xl: CGFloat = 16
    
    /// Extra extra large spacing (24pt) - page-level spacing (from JSON: "24px")
    static let xxl: CGFloat = 24
    
    /// Huge spacing (32pt) - hero section spacing
    static let huge: CGFloat = 32
    
    /// Massive spacing (48pt) - major layout blocks
    static let massive: CGFloat = 48
    
    /// Ultra spacing (64pt) - hero sections (from JSON: "64px")
    static let ultra: CGFloat = 64
    
    // MARK: - Extracted Spacing Values (Direct from JSON)
    
    /// 3px spacing (from JSON: "3px")
    static let spacing3: CGFloat = 3
    
    /// 5px spacing (from JSON: "5px", "0px 5px !important")
    static let spacing5: CGFloat = 5
    
    /// 13px spacing (from JSON: "0px 13px")
    static let spacing13: CGFloat = 13
    
    /// 15px spacing (from JSON: "0px 15px")
    static let spacing15: CGFloat = 15
    
    /// 18px spacing (from JSON: "18px auto", "0px 18px")
    static let spacing18: CGFloat = 18
    
    /// 20px spacing (from JSON: "20px 0px 0px", "20px !important")
    static let spacing20: CGFloat = 20
    
    // MARK: - Semantic Spacing (Entertainment Streaming Context)
    
    /// Spacing between channel cards in grid
    static let channelGridSpacing: CGFloat = md
    
    /// Spacing between program items in EPG
    static let epgItemSpacing: CGFloat = sm
    
    /// Spacing around content cards
    static let contentCardSpacing: CGFloat = lg
    
    /// Spacing between content sections (Home screen)
    static let sectionSpacing: CGFloat = xxl
    
    /// Spacing for hero section margins
    static let heroSpacing: CGFloat = ultra
    
    /// Spacing between navigation tabs
    static let tabSpacing: CGFloat = xl
    
    /// Spacing for form elements
    static let formSpacing: CGFloat = lg
    
    /// Spacing for button groups
    static let buttonGroupSpacing: CGFloat = md
    
    /// Spacing for list items
    static let listItemSpacing: CGFloat = lg
    
    // MARK: - Layout Spacing (Based on JSON patterns)
    
    /// Content padding (horizontal) - from JSON: "0px 15px"
    static let contentPadding: CGFloat = spacing15
    
    /// Section padding (vertical) - from JSON: "20px 0px 0px"
    static let sectionPadding: CGFloat = spacing20
    
    /// Card internal padding
    static let cardPadding: CGFloat = xl
    
    /// Screen edge margins
    static let screenMargin: CGFloat = xl
    
    /// Safe area padding
    static let safeAreaPadding: CGFloat = md
    
    // MARK: - Component-Specific Spacing
    
    /// Button internal padding
    static let buttonPadding: EdgeInsets = EdgeInsets(
        top: lg,
        leading: xl,
        bottom: lg,
        trailing: xl
    )
    
    /// Input field padding
    static let inputPadding: EdgeInsets = EdgeInsets(
        top: lg,
        leading: lg,
        bottom: lg,
        trailing: lg
    )
    
    /// Card padding
    static let cardInternalPadding: EdgeInsets = EdgeInsets(
        top: xl,
        leading: xl,
        bottom: xl,
        trailing: xl
    )
    
    /// Navigation bar spacing
    static let navigationSpacing: EdgeInsets = EdgeInsets(
        top: sm,
        leading: xl,
        bottom: sm,
        trailing: xl
    )
    
    // MARK: - Grid Spacing (For channel grids, content grids)
    
    /// Channel grid column spacing
    static let gridColumnSpacing: CGFloat = md
    
    /// Channel grid row spacing
    static let gridRowSpacing: CGFloat = lg
    
    /// Content grid spacing (for movies, shows)
    static let contentGridSpacing: CGFloat = lg
    
    /// Carousel item spacing
    static let carouselSpacing: CGFloat = lg
    
    // MARK: - Video Player Specific Spacing
    
    /// Video player control spacing
    static let playerControlSpacing: CGFloat = xl
    
    /// Video overlay padding
    static let videoOverlayPadding: EdgeInsets = EdgeInsets(
        top: xxl,
        leading: xl,
        bottom: xxl,
        trailing: xl
    )
    
    /// Progress bar padding
    static let progressBarPadding: CGFloat = md
    
    // MARK: - Subscription & Billing Spacing
    
    /// Price display spacing
    static let priceSpacing: CGFloat = sm
    
    /// Subscription card spacing
    static let subscriptionCardSpacing: CGFloat = xl
    
    /// Payment method spacing
    static let paymentMethodSpacing: CGFloat = lg
    
    // MARK: - Search & Filter Spacing
    
    /// Search result spacing
    static let searchResultSpacing: CGFloat = md
    
    /// Filter chip spacing
    static let filterChipSpacing: CGFloat = sm
    
    /// Search category spacing
    static let searchCategorySpacing: CGFloat = lg
}

// MARK: - LayoutConstants
// Layout-specific measurements and breakpoints

struct LayoutConstants {
    
    // MARK: - Container Widths
    
    /// Maximum content width for readability
    static let maxContentWidth: CGFloat = 1200
    
    /// Minimum touch target size (44pt minimum for accessibility)
    static let minTouchTarget: CGFloat = 44
    
    /// Standard touch target size
    static let standardTouchTarget: CGFloat = 48
    
    /// Large touch target size
    static let largeTouchTarget: CGFloat = 56
    
    // MARK: - Card Dimensions
    
    /// Standard card corner radius
    static let cardCornerRadius: CGFloat = 12
    
    /// Small card corner radius
    static let smallCardCornerRadius: CGFloat = 8
    
    /// Large card corner radius
    static let largeCardCornerRadius: CGFloat = 16
    
    /// Channel card aspect ratio (16:9 for TV content)
    static let channelCardAspectRatio: CGFloat = 16/9
    
    /// Content card aspect ratio (poster style)
    static let contentCardAspectRatio: CGFloat = 3/4
    
    /// Hero card aspect ratio
    static let heroCardAspectRatio: CGFloat = 21/9
    
    // MARK: - Video Player Dimensions
    
    /// Video player aspect ratio (16:9 standard)
    static let videoAspectRatio: CGFloat = 16/9
    
    /// Mini player height
    static let miniPlayerHeight: CGFloat = 200
    
    /// Full screen player control height
    static let playerControlHeight: CGFloat = 80
    
    // MARK: - Navigation Dimensions
    
    /// Tab bar height
    static let tabBarHeight: CGFloat = 83
    
    /// Navigation bar height
    static let navigationBarHeight: CGFloat = 44
    
    /// Search bar height
    static let searchBarHeight: CGFloat = 40
    
    // MARK: - Grid Layout (From JSON patterns analysis)
    
    /// Channel grid columns (portrait)
    static let channelGridColumnsPortrait: Int = 3
    
    /// Channel grid columns (landscape)
    static let channelGridColumnsLandscape: Int = 5
    
    /// Content grid columns (portrait)
    static let contentGridColumnsPortrait: Int = 2
    
    /// Content grid columns (landscape)
    static let contentGridColumnsLandscape: Int = 4
    
    // MARK: - Animation Durations
    
    /// Fast animation (UI feedback)
    static let fastAnimation: Double = 0.2
    
    /// Standard animation (transitions)
    static let standardAnimation: Double = 0.3
    
    /// Slow animation (complex transitions)
    static let slowAnimation: Double = 0.5
    
    // MARK: - Device-Specific Breakpoints
    
    /// iPhone width breakpoint
    static let iPhoneWidthBreakpoint: CGFloat = 428
    
    /// iPad width breakpoint
    static let iPadWidthBreakpoint: CGFloat = 768
    
    /// Large iPad width breakpoint
    static let largeiPadWidthBreakpoint: CGFloat = 1024
    
    // MARK: - Safe Area Adjustments
    
    /// Bottom safe area offset for tab bar
    static let bottomSafeAreaOffset: CGFloat = 34
    
    /// Top safe area offset for status bar
    static let topSafeAreaOffset: CGFloat = 47
    
    // MARK: - Shadow and Elevation
    
    /// Card shadow radius
    static let cardShadowRadius: CGFloat = 8
    
    /// Card shadow offset
    static let cardShadowOffset: CGSize = CGSize(width: 0, height: 2)
    
    /// Card shadow opacity
    static let cardShadowOpacity: Double = 0.1
    
    /// Elevated component shadow radius
    static let elevatedShadowRadius: CGFloat = 16
    
    /// Elevated component shadow opacity
    static let elevatedShadowOpacity: Double = 0.15
}

// MARK: - Spacing Modifiers

extension View {
    
    /// Apply standard content padding
    func contentPadding() -> some View {
        self.padding(.horizontal, SpacingTokens.contentPadding)
    }
    
    /// Apply section spacing
    func sectionSpacing() -> some View {
        self.padding(.vertical, SpacingTokens.sectionSpacing)
    }
    
    /// Apply card padding
    func cardPadding() -> some View {
        self.padding(SpacingTokens.cardInternalPadding)
    }
    
    /// Apply safe area padding
    func safeAreaPadding() -> some View {
        self.padding(.all, SpacingTokens.safeAreaPadding)
    }
    
    /// Apply custom spacing token
    func spacing(_ token: CGFloat) -> some View {
        self.padding(.all, token)
    }
    
    /// Apply horizontal content margins
    func horizontalContentMargins() -> some View {
        self.padding(.horizontal, SpacingTokens.screenMargin)
    }
    
    /// Apply vertical section spacing
    func verticalSectionSpacing() -> some View {
        self.padding(.vertical, SpacingTokens.sectionSpacing)
    }
}



// MARK: - Grid Helpers

struct GridHelpers {
    /// Create channel grid layout
    static func channelGrid(isLandscape: Bool = false) -> [GridItem] {
        let columns = isLandscape ?
            LayoutConstants.channelGridColumnsLandscape :
            LayoutConstants.channelGridColumnsPortrait
        
        return Array(repeating: GridItem(
            .flexible(),
            spacing: SpacingTokens.gridColumnSpacing
        ), count: columns)
    }
    
    /// Create content grid layout
    static func contentGrid(isLandscape: Bool = false) -> [GridItem] {
        let columns = isLandscape ?
            LayoutConstants.contentGridColumnsLandscape :
            LayoutConstants.contentGridColumnsPortrait
        
        return Array(repeating: GridItem(
            .flexible(),
            spacing: SpacingTokens.gridColumnSpacing
        ), count: columns)
    }
}

// MARK: - Spacing Token Enum

enum SpacingToken {
    case xs, sm, md, lg, xl, xxl, huge, massive, ultra
    case custom(CGFloat)
    
    var value: CGFloat {
        switch self {
        case .xs: return SpacingTokens.xs
        case .sm: return SpacingTokens.sm
        case .md: return SpacingTokens.md
        case .lg: return SpacingTokens.lg
        case .xl: return SpacingTokens.xl
        case .xxl: return SpacingTokens.xxl
        case .huge: return SpacingTokens.huge
        case .massive: return SpacingTokens.massive
        case .ultra: return SpacingTokens.ultra
        case .custom(let value): return value
        }
    }
}

// MARK: - Preview for Spacing System

#Preview("TataPlay Spacing System") {
    ScrollView {
        VStack(spacing: SpacingTokens.sectionSpacing) {
            
            // Spacing Scale Showcase
            VStack(alignment: .leading, spacing: SpacingTokens.lg) {
                Text("Spacing Scale")
                    .styled(.sectionHeading)
                
                VStack(spacing: SpacingTokens.sm) {
                    SpacingExample(token: .xs, name: "XS (2pt)")
                    SpacingExample(token: .sm, name: "SM (4pt)")
                    SpacingExample(token: .md, name: "MD (8pt)")
                    SpacingExample(token: .lg, name: "LG (12pt)")
                    SpacingExample(token: .xl, name: "XL (16pt)")
                    SpacingExample(token: .xxl, name: "XXL (24pt)")
                    SpacingExample(token: .huge, name: "HUGE (32pt)")
                    SpacingExample(token: .massive, name: "MASSIVE (48pt)")
                    SpacingExample(token: .ultra, name: "ULTRA (64pt)")
                }
            }
            
            // Component Spacing Examples
            VStack(alignment: .leading, spacing: SpacingTokens.lg) {
                Text("Component Spacing")
                    .styled(.sectionHeading)
                
                // Button Example
                HStack(spacing: SpacingTokens.buttonGroupSpacing) {
                    Button("Primary") {}
                        .font(TataPlayTypography.buttonPrimary)
                        .foregroundColor(.white)
                        .padding(SpacingTokens.buttonPadding)
                        .background(TataPlayColors.primary)
                        .cornerRadius(LayoutConstants.smallCardCornerRadius)
                    
                    Button("Secondary") {}
                        .font(TataPlayTypography.buttonSecondary)
                        .foregroundColor(TataPlayColors.primary)
                        .padding(SpacingTokens.buttonPadding)
                        .overlay(
                            RoundedRectangle(cornerRadius: LayoutConstants.smallCardCornerRadius)
                                .stroke(TataPlayColors.primary, lineWidth: 1)
                        )
                }
                
                // Card Example
                VStack(alignment: .leading, spacing: SpacingTokens.md) {
                    Text("Channel Card")
                        .styled(.contentTitle)
                    
                    Text("Star Sports HD")
                        .styled(.contentSubtitle)
                    
                    Text("Live Cricket Match")
                        .styled(.captionText)
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
            
            // Grid Layout Example
            VStack(alignment: .leading, spacing: SpacingTokens.lg) {
                Text("Grid Layouts")
                    .styled(.sectionHeading)
                
                LazyVGrid(columns: GridHelpers.channelGrid(), spacing: SpacingTokens.gridRowSpacing) {
                    ForEach(1...6, id: \.self) { index in
                        RoundedRectangle(cornerRadius: LayoutConstants.smallCardCornerRadius)
                            .fill(TataPlayColors.brandCyan)
                            .aspectRatio(LayoutConstants.channelCardAspectRatio, contentMode: .fit)
                            .overlay(
                                Text("Ch \(index)")
                                    .styled(.channelNumber)
                                    .foregroundColor(.white)
                            )
                    }
                }
            }
            
            // Extracted JSON Spacing Values
            VStack(alignment: .leading, spacing: SpacingTokens.lg) {
                Text("JSON Extracted Values")
                    .styled(.sectionHeading)
                
                VStack(spacing: SpacingTokens.sm) {
                    SpacingExample(token: .custom(SpacingTokens.spacing3), name: "3px (JSON)")
                    SpacingExample(token: .custom(SpacingTokens.spacing5), name: "5px (JSON)")
                    SpacingExample(token: .custom(SpacingTokens.spacing13), name: "13px (JSON)")
                    SpacingExample(token: .custom(SpacingTokens.spacing15), name: "15px (JSON)")
                    SpacingExample(token: .custom(SpacingTokens.spacing18), name: "18px (JSON)")
                    SpacingExample(token: .custom(SpacingTokens.spacing20), name: "20px (JSON)")
                }
            }
        }
        .contentPadding()
        .verticalSectionSpacing()
    }
    .background(TataPlayColors.background)
}

// MARK: - Helper Views

private struct SpacingExample: View {
    let token: SpacingToken
    let name: String
    
    var body: some View {
        HStack {
            Rectangle()
                .fill(TataPlayColors.primary)
                .frame(width: token.value, height: 20)
            
            Text(name)
                .styled(.captionText)
            
            Spacer()
            
            Text("\(Int(token.value))pt")
                .styled(.captionText)
                .foregroundColor(TataPlayColors.textSecondary)
        }
        .padding(.vertical, SpacingTokens.xs)
    }
}
