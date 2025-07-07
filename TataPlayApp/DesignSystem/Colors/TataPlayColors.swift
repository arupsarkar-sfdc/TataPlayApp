import SwiftUI

// MARK: - TataPlayColors
// Color system extracted from Tata Play website scaffolding JSON
// Primary: #007bff, Secondary: #6610f2, Accent: #6f42c1

struct TataPlayColors {
    
    // MARK: - Brand Colors (From JSON scaffolding)
    
    /// Primary brand color - Tata Play Blue (#007bff)
    static let primary = Color(hex: "#007bff")
    
    /// Secondary brand color - Purple (#6610f2)
    static let secondary = Color(hex: "#6610f2")
    
    /// Accent color - Violet (#6f42c1)
    static let accent = Color(hex: "#6f42c1")
    
    /// Background color - White
    static let background = Color(hex: "#FFFFFF")
    
    /// Primary text color - Black
    static let text = Color(hex: "#000000")
    
    // MARK: - Extended Brand Palette (From JSON extracted_colors)
    
    /// Pink accent (#e83e8c)
    static let brandPink = Color(hex: "#e83e8c")
    
    /// Red accent (#dc3545)
    static let brandRed = Color(hex: "#dc3545")
    
    /// Orange accent (#fd7e14)
    static let brandOrange = Color(hex: "#fd7e14")
    
    /// Yellow accent (#ffc107)
    static let brandYellow = Color(hex: "#ffc107")
    
    /// Green accent (#28a745)
    static let brandGreen = Color(hex: "#28a745")
    
    /// Teal accent (#20c997)
    static let brandTeal = Color(hex: "#20c997")
    
    /// Cyan accent (#17a2b8)
    static let brandCyan = Color(hex: "#17a2b8")
    
    // MARK: - Semantic Colors (Business Logic)
    
    /// Success state color (subscriptions, payments)
    static let success = brandGreen
    
    /// Warning state color (account issues, low balance)
    static let warning = brandYellow
    
    /// Error state color (failed payments, network issues)
    static let error = brandRed
    
    /// Information state color (notifications, tips)
    static let info = primary
    
    // MARK: - Entertainment Streaming Specific Colors
    
    /// Live TV indicator (red for live content)
    static let liveIndicator = Color(hex: "#FF0000")
    
    /// Premium content indicator (gold for premium channels)
    static let premiumIndicator = Color(hex: "#FFD700")
    
    /// HD content indicator (blue for HD quality)
    static let hdIndicator = primary
    
    /// Recording indicator (red dot for recording)
    static let recordingIndicator = brandRed
    
    // MARK: - UI Element Colors
    
    /// Tab bar selected state
    static let tabBarSelected = primary
    
    /// Tab bar unselected state
    static let tabBarUnselected = Color.gray
    
    /// Navigation bar background
    static let navigationBackground = background
    
    /// Navigation bar title
    static let navigationTitle = text
    
    /// Card background color
    static let cardBackground = Color(hex: "#F8F9FA")
    
    /// Separator line color
    static let separator = Color(hex: "#E9ECEF")
    
    /// Placeholder text color
    static let placeholder = Color(hex: "#6C757D")
    
    /// Secondary text color
    static let textSecondary = Color(hex: "#6C757D")
    
    // MARK: - Channel Category Colors (Entertainment Streaming)
    
    /// Entertainment channels
    static let entertainmentCategory = accent
    
    /// Sports channels
    static let sportsCategory = brandGreen
    
    /// News channels
    static let newsCategory = brandRed
    
    /// Kids channels
    static let kidsCategory = brandYellow
    
    /// Movies channels
    static let moviesCategory = brandPink
    
    /// Music channels
    static let musicCategory = brandTeal
    
    /// Regional channels
    static let regionalCategory = brandOrange
    
    /// International channels
    static let internationalCategory = brandCyan
    
    // MARK: - Subscription Tier Colors
    
    /// Basic subscription tier
    static let basicTier = Color(hex: "#95A5A6")
    
    /// Standard subscription tier
    static let standardTier = primary
    
    /// Premium subscription tier
    static let premiumTier = Color(hex: "#F39C12")
    
    /// VIP subscription tier
    static let vipTier = Color(hex: "#8E44AD")
    
    // MARK: - Gradient Colors (Modern UI)
    
    /// Primary gradient for hero sections
    static let primaryGradient = LinearGradient(
        colors: [primary, secondary],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    /// Accent gradient for CTAs
    static let accentGradient = LinearGradient(
        colors: [accent, brandPink],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    /// Success gradient for completion states
    static let successGradient = LinearGradient(
        colors: [brandGreen, brandTeal],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    // MARK: - Dark Mode Support
    
    /// Adaptive background (white in light, dark in dark mode)
    static let adaptiveBackground = Color(
        light: background,
        dark: Color(hex: "#1C1C1E")
    )
    
    /// Adaptive text (black in light, white in dark mode)
    static let adaptiveText = Color(
        light: text,
        dark: Color(hex: "#FFFFFF")
    )
    
    /// Adaptive card background
    static let adaptiveCardBackground = Color(
        light: cardBackground,
        dark: Color(hex: "#2C2C2E")
    )
}

// MARK: - Color Extension for Hex Support

extension Color {
    /// Initialize Color from hex string
    /// - Parameter hex: Hex color string (e.g., "#007bff" or "007bff")
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    /// Initialize Color with light and dark mode variants
    /// - Parameters:
    ///   - light: Color for light mode
    ///   - dark: Color for dark mode
    init(light: Color, dark: Color) {
        self.init(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(dark)
            default:
                return UIColor(light)
            }
        })
    }
}

// MARK: - Preview for SwiftUI Canvas

#Preview("TataPlay Colors") {
    ScrollView {
        LazyVStack(spacing: 20) {
            // Brand Colors Section
            VStack(alignment: .leading, spacing: 12) {
                Text("Brand Colors")
                    .font(.title2)
                    .fontWeight(.bold)
                
                HStack(spacing: 12) {
                    ColorSwatch(color: TataPlayColors.primary, name: "Primary")
                    ColorSwatch(color: TataPlayColors.secondary, name: "Secondary")
                    ColorSwatch(color: TataPlayColors.accent, name: "Accent")
                }
            }
            
            // Semantic Colors Section
            VStack(alignment: .leading, spacing: 12) {
                Text("Semantic Colors")
                    .font(.title2)
                    .fontWeight(.bold)
                
                HStack(spacing: 12) {
                    ColorSwatch(color: TataPlayColors.success, name: "Success")
                    ColorSwatch(color: TataPlayColors.warning, name: "Warning")
                    ColorSwatch(color: TataPlayColors.error, name: "Error")
                    ColorSwatch(color: TataPlayColors.info, name: "Info")
                }
            }
            
            // Channel Category Colors
            VStack(alignment: .leading, spacing: 12) {
                Text("Channel Categories")
                    .font(.title2)
                    .fontWeight(.bold)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 12) {
                    ColorSwatch(color: TataPlayColors.entertainmentCategory, name: "Entertainment")
                    ColorSwatch(color: TataPlayColors.sportsCategory, name: "Sports")
                    ColorSwatch(color: TataPlayColors.newsCategory, name: "News")
                    ColorSwatch(color: TataPlayColors.kidsCategory, name: "Kids")
                    ColorSwatch(color: TataPlayColors.moviesCategory, name: "Movies")
                    ColorSwatch(color: TataPlayColors.musicCategory, name: "Music")
                    ColorSwatch(color: TataPlayColors.regionalCategory, name: "Regional")
                    ColorSwatch(color: TataPlayColors.internationalCategory, name: "International")
                }
            }
            
            // Subscription Tiers
            VStack(alignment: .leading, spacing: 12) {
                Text("Subscription Tiers")
                    .font(.title2)
                    .fontWeight(.bold)
                
                HStack(spacing: 12) {
                    ColorSwatch(color: TataPlayColors.basicTier, name: "Basic")
                    ColorSwatch(color: TataPlayColors.standardTier, name: "Standard")
                    ColorSwatch(color: TataPlayColors.premiumTier, name: "Premium")
                    ColorSwatch(color: TataPlayColors.vipTier, name: "VIP")
                }
            }
            
            // Gradients Section
            VStack(alignment: .leading, spacing: 12) {
                Text("Gradients")
                    .font(.title2)
                    .fontWeight(.bold)
                
                VStack(spacing: 8) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(TataPlayColors.primaryGradient)
                        .frame(height: 60)
                        .overlay(
                            Text("Primary Gradient")
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
                        )
                    
                    RoundedRectangle(cornerRadius: 12)
                        .fill(TataPlayColors.accentGradient)
                        .frame(height: 60)
                        .overlay(
                            Text("Accent Gradient")
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
                        )
                }
            }
        }
        .padding()
    }
}

// MARK: - Helper Views

private struct ColorSwatch: View {
    let color: Color
    let name: String
    
    var body: some View {
        VStack(spacing: 8) {
            RoundedRectangle(cornerRadius: 8)
                .fill(color)
                .frame(width: 60, height: 60)
                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
            
            Text(name)
                .font(.caption)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(maxWidth: 80)
    }
}
