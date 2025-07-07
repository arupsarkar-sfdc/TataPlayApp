import SwiftUI

// MARK: - TataPlayTypography
// Typography system extracted from Tata Play website scaffolding JSON
// Primary font: "sans-serif", Font sizes: 12px-34px, Weights: 400, 500, normal

struct TataPlayTypography {
    
    // MARK: - Font Family (From JSON: primary_font: "sans-serif")
    
    /// Primary font family - System font (matches sans-serif from website)
    static let primaryFontFamily = "SF Pro Display" // iOS system font
    
    /// Secondary font family for body text
    static let secondaryFontFamily = "SF Pro Text" // iOS system font for smaller text
    
    /// Monospace font for technical content (channel numbers, etc.)
    static let monospaceFontFamily = "SF Mono"
    
    // MARK: - Font Weights (From JSON: font_weights: ["400", "500", "normal"])
    
    /// Regular weight (400/normal from JSON)
    static let regular: Font.Weight = .regular
    
    /// Medium weight (500 from JSON)
    static let medium: Font.Weight = .medium
    
    /// Semibold weight (for emphasis)
    static let semibold: Font.Weight = .semibold
    
    /// Bold weight (for headings)
    static let bold: Font.Weight = .bold
    
    // MARK: - Font Sizes (From JSON font_sizes - converted to semantic scale)
    
    /// Extra large title (34px from JSON)
    static let extraLargeTitle: CGFloat = 34
    
    /// Large title (30px from JSON)
    static let largeTitle: CGFloat = 30
    
    /// Title 1 (28px from JSON)
    static let title1: CGFloat = 28
    
    /// Title 2 (24px from JSON)
    static let title2: CGFloat = 24
    
    /// Title 3 (22px from JSON)
    static let title3: CGFloat = 22
    
    /// Headline (20px from JSON)
    static let headline: CGFloat = 20
    
    /// Body (18px from JSON)
    static let body: CGFloat = 18
    
    /// Body Large (18px from JSON)
    static let bodyLarge: CGFloat = 18
    
    /// Body Medium (16px from JSON)
    static let bodyMedium: CGFloat = 16
    
    /// Body Small (15px from JSON)
    static let bodySmall: CGFloat = 15
    
    /// Caption (14px from JSON)
    static let caption: CGFloat = 14
    
    /// Caption Small (12px from JSON)
    static let captionSmall: CGFloat = 12
    
    // MARK: - Semantic Font Styles (Entertainment Streaming App)
    
    /// Hero section title (large, bold)
    static let heroTitle = Font.custom(primaryFontFamily, size: extraLargeTitle)
        .weight(bold)
    
    /// Hero subtitle (medium size, regular weight)
    static let heroSubtitle = Font.custom(primaryFontFamily, size: title2)
        .weight(regular)
    
    /// Section heading (medium size, semibold)
    static let sectionHeading = Font.custom(primaryFontFamily, size: title3)
        .weight(semibold)
    
    /// Content title (for channel names, program titles)
    static let contentTitle = Font.custom(primaryFontFamily, size: headline)
        .weight(medium)
    
    /// Content subtitle (for channel descriptions)
    static let contentSubtitle = Font.custom(secondaryFontFamily, size: bodyMedium)
        .weight(regular)
    
    /// Body text (general content)
    static let bodyText = Font.custom(secondaryFontFamily, size: body)
        .weight(regular)
    
    /// Body emphasis (important information)
    static let bodyEmphasis = Font.custom(secondaryFontFamily, size: body)
        .weight(medium)
    
    /// Caption text (metadata, timestamps)
    static let captionText = Font.custom(secondaryFontFamily, size: caption)
        .weight(regular)
    
    /// Small caption (very small details)
    static let smallCaption = Font.custom(secondaryFontFamily, size: captionSmall)
        .weight(regular)
    
    // MARK: - UI Component Specific Fonts
    
    /// Tab bar text
    static let tabBarLabel = Font.custom(secondaryFontFamily, size: captionSmall)
        .weight(medium)
    
    /// Navigation title
    static let navigationTitle = Font.custom(primaryFontFamily, size: title3)
        .weight(semibold)
    
    /// Button text (primary buttons)
    static let buttonPrimary = Font.custom(primaryFontFamily, size: bodyMedium)
        .weight(semibold)
    
    /// Button text (secondary buttons)
    static let buttonSecondary = Font.custom(primaryFontFamily, size: bodyMedium)
        .weight(medium)
    
    /// Input field text
    static let inputField = Font.custom(secondaryFontFamily, size: bodyMedium)
        .weight(regular)
    
    /// Input field placeholder
    static let inputPlaceholder = Font.custom(secondaryFontFamily, size: bodyMedium)
        .weight(regular)
    
    // MARK: - Entertainment Streaming Specific Fonts
    
    /// Channel number (monospace for alignment)
    static let channelNumber = Font.custom(monospaceFontFamily, size: bodyMedium)
        .weight(medium)
    
    /// Channel name (clear, readable)
    static let channelName = Font.custom(primaryFontFamily, size: bodyMedium)
        .weight(medium)
    
    /// Program title (on EPG)
    static let programTitle = Font.custom(primaryFontFamily, size: bodySmall)
        .weight(semibold)
    
    /// Program description
    static let programDescription = Font.custom(secondaryFontFamily, size: captionSmall)
        .weight(regular)
    
    /// Time display (program times, duration)
    static let timeDisplay = Font.custom(monospaceFontFamily, size: caption)
        .weight(medium)
    
    /// Live indicator text
    static let liveIndicator = Font.custom(primaryFontFamily, size: captionSmall)
        .weight(bold)
    
    /// Price display (subscription costs)
    static let priceDisplay = Font.custom(primaryFontFamily, size: headline)
        .weight(bold)
    
    /// Currency symbol
    static let currencySymbol = Font.custom(primaryFontFamily, size: bodyMedium)
        .weight(medium)
    
    // MARK: - Text Styles with LineHeight and Spacing
    
    /// Hero title with proper line spacing
    static func heroTitleStyle() -> some View {
        return AnyView(
            Text("")
                .font(heroTitle)
                .lineSpacing(4)
                .multilineTextAlignment(.center)
        )
    }
    
    /// Section heading with spacing
    static func sectionHeadingStyle() -> some View {
        return AnyView(
            Text("")
                .font(sectionHeading)
                .lineSpacing(2)
                .multilineTextAlignment(.leading)
        )
    }
    
    /// Body text with optimal readability
    static func bodyTextStyle() -> some View {
        return AnyView(
            Text("")
                .font(bodyText)
                .lineSpacing(2)
                .multilineTextAlignment(.leading)
        )
    }
    
    // MARK: - Dynamic Type Support
    
    /// Get font that scales with accessibility sizes
    /// - Parameters:
    ///   - baseSize: Base font size
    ///   - weight: Font weight
    ///   - design: Font design (default, rounded, monospaced)
    /// - Returns: Scalable font
    static func scalableFont(
        size baseSize: CGFloat,
        weight: Font.Weight = .regular,
        design: Font.Design = .default
    ) -> Font {
        return Font.system(size: baseSize, weight: weight, design: design)
    }
    
    /// Get custom font that scales with accessibility
    static func scalableCustomFont(
        family: String,
        size: CGFloat,
        weight: Font.Weight = .regular
    ) -> Font {
        return Font.custom(family, size: size)
            .weight(weight)
    }
    
    // MARK: - Text Modifiers
    
    /// Apply consistent text styling
    static func textStyle(
        font: Font,
        color: Color = TataPlayColors.text,
        alignment: TextAlignment = .leading,
        lineSpacing: CGFloat = 0
    ) -> some ViewModifier {
        return TextStyleModifier(
            font: font,
            color: color,
            alignment: alignment,
            lineSpacing: lineSpacing
        )
    }
}

// MARK: - Custom Text Style Modifier

private struct TextStyleModifier: ViewModifier {
    let font: Font
    let color: Color
    let alignment: TextAlignment
    let lineSpacing: CGFloat
    
    func body(content: Content) -> some View {
        content
            .font(font)
            .foregroundColor(color)
            .multilineTextAlignment(alignment)
            .lineSpacing(lineSpacing)
    }
}

// MARK: - Font Token Enums

/// Semantic font tokens for consistent usage
enum FontToken {
    case heroTitle
    case heroSubtitle
    case sectionHeading
    case contentTitle
    case contentSubtitle
    case bodyText
    case bodyEmphasis
    case captionText
    case smallCaption
    case buttonPrimary
    case buttonSecondary
    case navigationTitle
    case tabBarLabel
    case channelNumber
    case channelName
    case programTitle
    case programDescription
    case timeDisplay
    case priceDisplay
    
    var font: Font {
        switch self {
        case .heroTitle: return TataPlayTypography.heroTitle
        case .heroSubtitle: return TataPlayTypography.heroSubtitle
        case .sectionHeading: return TataPlayTypography.sectionHeading
        case .contentTitle: return TataPlayTypography.contentTitle
        case .contentSubtitle: return TataPlayTypography.contentSubtitle
        case .bodyText: return TataPlayTypography.bodyText
        case .bodyEmphasis: return TataPlayTypography.bodyEmphasis
        case .captionText: return TataPlayTypography.captionText
        case .smallCaption: return TataPlayTypography.smallCaption
        case .buttonPrimary: return TataPlayTypography.buttonPrimary
        case .buttonSecondary: return TataPlayTypography.buttonSecondary
        case .navigationTitle: return TataPlayTypography.navigationTitle
        case .tabBarLabel: return TataPlayTypography.tabBarLabel
        case .channelNumber: return TataPlayTypography.channelNumber
        case .channelName: return TataPlayTypography.channelName
        case .programTitle: return TataPlayTypography.programTitle
        case .programDescription: return TataPlayTypography.programDescription
        case .timeDisplay: return TataPlayTypography.timeDisplay
        case .priceDisplay: return TataPlayTypography.priceDisplay
        }
    }
    
    var color: Color {
        switch self {
        case .heroTitle, .heroSubtitle: return TataPlayColors.adaptiveText
        case .sectionHeading, .contentTitle: return TataPlayColors.text
        case .contentSubtitle, .bodyText: return TataPlayColors.text
        case .bodyEmphasis: return TataPlayColors.accent
        case .captionText, .smallCaption: return TataPlayColors.textSecondary
        case .buttonPrimary: return .white
        case .buttonSecondary: return TataPlayColors.primary
        case .navigationTitle: return TataPlayColors.navigationTitle
        case .tabBarLabel: return TataPlayColors.tabBarSelected
        case .channelNumber, .channelName: return TataPlayColors.text
        case .programTitle: return TataPlayColors.text
        case .programDescription: return TataPlayColors.textSecondary
        case .timeDisplay: return TataPlayColors.textSecondary
        case .priceDisplay: return TataPlayColors.success
        }
    }
}

// MARK: - Text Extension for Easy Usage

extension Text {
    /// Apply font token with color
    func styled(_ token: FontToken) -> some View {
        self
            .font(token.font)
            .foregroundColor(token.color)
    }
    
    /// Apply custom typography style
    func tataPlayStyle(
        font: Font,
        color: Color = TataPlayColors.text,
        alignment: TextAlignment = .leading
    ) -> some View {
        self
            .font(font)
            .foregroundColor(color)
            .multilineTextAlignment(alignment)
    }
}

// MARK: - Preview for Typography System

#Preview("TataPlay Typography") {
    ScrollView {
        VStack(alignment: .leading, spacing: 24) {
            
            // Hero Section Typography
            VStack(alignment: .leading, spacing: 8) {
                Text("Typography Showcase")
                    .styled(.heroTitle)
                
                Text("Design system for Tata Play entertainment app")
                    .styled(.heroSubtitle)
            }
            .padding(.bottom)
            
            // Section Headings
            VStack(alignment: .leading, spacing: 16) {
                Text("Section Headings")
                    .styled(.sectionHeading)
                
                Text("Content Title Example")
                    .styled(.contentTitle)
                
                Text("Content subtitle with secondary information")
                    .styled(.contentSubtitle)
            }
            
            // Body Text Examples
            VStack(alignment: .leading, spacing: 12) {
                Text("Body Text")
                    .styled(.sectionHeading)
                
                Text("This is regular body text for general content. It's designed for optimal readability across different device sizes and accessibility settings.")
                    .styled(.bodyText)
                
                Text("This is emphasized body text for important information that needs to stand out.")
                    .styled(.bodyEmphasis)
                
                Text("Caption text for metadata and timestamps")
                    .styled(.captionText)
                
                Text("Small caption for very detailed information")
                    .styled(.smallCaption)
            }
            
            // Entertainment Specific Typography
            VStack(alignment: .leading, spacing: 16) {
                Text("Streaming App Specific")
                    .styled(.sectionHeading)
                
                HStack {
                    Text("101")
                        .styled(.channelNumber)
                    
                    Text("Star Sports HD")
                        .styled(.channelName)
                    
                    Spacer()
                    
                    Text("₹299")
                        .styled(.priceDisplay)
                }
                .padding()
                .background(TataPlayColors.cardBackground)
                .cornerRadius(8)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Live Cricket Match")
                        .styled(.programTitle)
                    
                    Text("India vs Australia - 3rd Test")
                        .styled(.programDescription)
                    
                    Text("14:30 - 18:00")
                        .styled(.timeDisplay)
                }
                .padding()
                .background(TataPlayColors.cardBackground)
                .cornerRadius(8)
            }
            
            // Button Typography
            VStack(alignment: .leading, spacing: 12) {
                Text("Buttons & Navigation")
                    .styled(.sectionHeading)
                
                HStack(spacing: 12) {
                    Button("Subscribe Now") {}
                        .font(TataPlayTypography.buttonPrimary)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(TataPlayColors.primary)
                        .cornerRadius(8)
                    
                    Button("Learn More") {}
                        .font(TataPlayTypography.buttonSecondary)
                        .foregroundColor(TataPlayColors.primary)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(TataPlayColors.primary, lineWidth: 1)
                        )
                }
                
                Text("Navigation Title")
                    .styled(.navigationTitle)
                
                Text("Tab Label")
                    .styled(.tabBarLabel)
            }
            
            // Font Sizes Reference
            VStack(alignment: .leading, spacing: 8) {
                Text("Font Size Reference")
                    .styled(.sectionHeading)
                
                Group {
                    Text("34px - Extra Large Title")
                        .font(.custom(TataPlayTypography.primaryFontFamily, size: 34))
                    
                    Text("30px - Large Title")
                        .font(.custom(TataPlayTypography.primaryFontFamily, size: 30))
                    
                    Text("28px - Title 1")
                        .font(.custom(TataPlayTypography.primaryFontFamily, size: 28))
                    
                    Text("24px - Title 2")
                        .font(.custom(TataPlayTypography.primaryFontFamily, size: 24))
                    
                    Text("22px - Title 3")
                        .font(.custom(TataPlayTypography.primaryFontFamily, size: 22))
                    
                    Text("20px - Headline")
                        .font(.custom(TataPlayTypography.primaryFontFamily, size: 20))
                    
                    Text("18px - Body")
                        .font(.custom(TataPlayTypography.secondaryFontFamily, size: 18))
                    
                    Text("16px - Body Medium")
                        .font(.custom(TataPlayTypography.secondaryFontFamily, size: 16))
                    
                    Text("14px - Caption")
                        .font(.custom(TataPlayTypography.secondaryFontFamily, size: 14))
                    
                    Text("12px - Small Caption")
                        .font(.custom(TataPlayTypography.secondaryFontFamily, size: 12))
                }
                .foregroundColor(TataPlayColors.textSecondary)
            }
        }
        .padding()
    }
    .background(TataPlayColors.background)
}
