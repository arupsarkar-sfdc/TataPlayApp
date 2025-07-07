# TataPlayApp

A modern iOS application for Tata Play streaming service built with SwiftUI, following clean architecture principles and modern iOS development practices.

**Business Model**: Entertainment Streaming  
**Target Platform**: iOS 16.0+  
**Architecture**: Feature-based MVVM + Clean Architecture  
**UI Framework**: SwiftUI  
**Package Manager**: Swift Package Manager  

## 🏗️ Architecture Principles

- **Separation of Concerns** - Clean boundaries between layers
- **Feature-Based Modules** - Each feature is self-contained
- **Protocol-Oriented Programming** - Dependency injection and testability
- **Modern iOS Patterns** - SwiftUI, Combine, async/await
- **Einstein AI Integration** - Personalization and recommendations

## 📁 Project Structure

```
TataPlayApp/
├── TataPlayApp.xcodeproj
├── TataPlayApp/
│   ├── Core/
│   │   ├── Architecture/          # ✅ App state management, NavigationCoordinator
│   │   ├── DependencyInjection/   # DI container, service locator
│   │   └── Extensions/            # Foundation, SwiftUI extensions
│   │
│   ├── DesignSystem/
│   │   ├── Colors/                # ✅ Brand colors, semantic colors
│   │   ├── Typography/            # ✅ Font system, text styles
│   │   ├── Spacing/               # ✅ Layout constants, spacing tokens
│   │   └── Components/            # Reusable UI components
│   │       ├── Buttons/
│   │       ├── Cards/
│   │       └── Navigation/
│   │
│   ├── Features/
│   │   ├── Authentication/        # Login, signup, forgot password
│   │   ├── Home/                  # Dashboard, recommendations
│   │   ├── LiveTV/                # Live streaming, EPG, video player
│   │   ├── MyAccount/             # Profile, subscription, billing
│   │   ├── Search/                # Content search and filters
│   │   └── Recharge/              # Payment, subscription management
│   │
│   ├── Shared/
│   │   ├── Models/                # ✅ Core data models
│   │   ├── Network/               # API client, endpoints
│   │   ├── Storage/               # Local storage, cache
│   │   ├── Analytics/             # Event tracking
│   │   └── Utils/                 # Helper utilities
│   │
│   ├── Einstein/
│   │   ├── PersonalizationEngine/ # AI recommendations
│   │   ├── Models/                # ML data models
│   │   └── Services/              # Einstein API integration
│   │
│   └── Resources/
│       ├── Assets.xcassets
│       └── Localizable.strings
│
├── TataPlayAppTests/
└── README.md                     # This file
```

## 🚀 Development Progress

### **Phase 1: Project Foundation** ✅
- **Status**: ✅ Complete
- **Date**: Current
- **Details**:
  - Created proper iOS app project structure
  - Added Swift Package Manager dependencies:
    - `Alamofire` (5.8.0+) - Networking
    - `Nuke` (12.0+) - Image loading and caching
    - `KeychainAccess` (4.2.2+) - Secure storage
    - `AnyCodable` (0.6.0+) - JSON handling
    - `Lottie` (4.3.0+) - Animations
    - `ComposableArchitecture` (1.5.0+) - State management
  - Organized feature-based folder structure
  - Set up proper separation of concerns

### **Phase 2: Design System Foundation** ✅
- **Status**: ✅ Complete
- **Date**: Current

#### **Step 2: Color System** ✅
- **File**: `TataPlayApp/DesignSystem/Colors/TataPlayColors.swift`
- **Details**:
  - Extracted brand colors from website scaffolding JSON:
    - Primary: `#007bff` (Tata Play Blue)
    - Secondary: `#6610f2` (Purple)
    - Accent: `#6f42c1` (Violet)
  - Created comprehensive color system:
    - 10 brand colors from JSON extracted_colors
    - Semantic colors (success, warning, error, info)
    - Entertainment-specific colors (live indicators, HD badges)
    - Channel category colors (sports, news, kids, etc.)
    - Subscription tier colors (basic, standard, premium, VIP)
    - Modern gradients for hero sections
    - Dark mode support with adaptive colors
  - Added live preview component for design system validation
  - Hex color support with proper Color extensions

#### **Step 3: Data Models** ✅
- **File**: `TataPlayApp/Shared/Models/BaseModels.swift`
- **Details**:
  - User System: Account management, preferences, subscription
  - Content Models: Channels, programs, content items
  - Subscription System: Plans, billing, transaction handling
  - Streaming-Specific Models:
    - `Channel` with categories (entertainment, sports, news, etc.)
    - `Program` with EPG data and content ratings
    - `ContentItem` for recommendations and search results
  - Business Logic Models (from JSON key_features):
    - Live TV streaming support
    - Channel management
    - Subscription billing
    - Parental controls
    - Multi-device support
  - Search & Discovery: Query handling, filters, results
  - Payment System: Multiple payment methods (UPI, cards, wallets)
  - API Integration: Response wrappers, pagination, error handling
  - Personalization Ready: Models support Einstein integration

#### **Step 4: Typography System** ✅
- **File**: `TataPlayApp/DesignSystem/Typography/TataPlayTypography.swift`
- **Details**:
  - Font Family System: SF Pro Display/Text (iOS system fonts matching "sans-serif" from JSON)
  - Font Sizes: Extracted from JSON font_sizes (12px-34px) mapped to semantic scales:
    - `34px` → `extraLargeTitle` (hero sections)
    - `30px` → `largeTitle` (main headings)
    - `24px` → `title2` (section headings)
    - `18px` → `body` (main content)
    - `16px` → `bodyMedium` (secondary content)
    - `14px` → `caption` (metadata)
    - `12px` → `captionSmall` (fine details)
  - Font Weights: From JSON ("400"/"normal" → `.regular`, "500" → `.medium`)
  - Semantic Text Styles: Hero titles, section headings, body text, captions
  - Streaming-Specific Typography:
    - Channel numbers (monospace for alignment)
    - Program titles and descriptions
    - Time displays and price formatting
    - Live indicators and content ratings
  - UI Component Fonts: Tab bars, buttons, navigation, input fields
  - Font Token System: Enum-based approach for consistent usage (`.styled(.heroTitle)`)
  - Text Extensions: Easy styling with semantic tokens
  - Accessibility Support: Dynamic Type scaling
  - Live Preview: Complete typography showcase with examples

#### **Step 5: Spacing System** ✅
- **File**: `TataPlayApp/DesignSystem/Spacing/SpacingTokens.swift`
- **Details**:
  - Base Spacing Scale: xs(2pt) to ultra(64pt) following 4pt grid system
  - JSON Extracted Values: Direct mapping from spacing_patterns:
    - `"8px"` → `SpacingTokens.md` (standard element spacing)
    - `"24px"` → `SpacingTokens.xxl` (section spacing)
    - `"64px"` → `SpacingTokens.ultra` (hero spacing)
    - `"0px 15px"` → `contentPadding` (horizontal padding)
    - `"20px 0px 0px"` → `sectionPadding` (vertical padding)
  - Semantic Spacing: Entertainment-specific spacing tokens:
    - Channel grid spacing
    - EPG item spacing
    - Content card spacing
    - Video player control spacing
    - Subscription card spacing
  - Component Spacing: Buttons, forms, cards, navigation with EdgeInsets
  - Layout Constants: Touch targets (44pt minimum), corner radius, aspect ratios
  - Grid Helpers: Channel grid and content grid with device responsiveness
  - View Modifiers: Easy-to-use extensions (`.contentPadding()`, `.sectionSpacing()`)
  - Entertainment-Specific: Video player dimensions, subscription layouts
  - Live Preview: Visual spacing showcase with examples

### **Phase 3: Core Navigation** ✅
- **Status**: ✅ Complete
- **Date**: Current

#### **Step 8: Navigation Coordinator Pattern** ✅
- **File**: `TataPlayApp/Core/Architecture/NavigationCoordinator.swift`
- **Details**:
  - **Core Navigation Foundation**:
    - Tab-based navigation for 5 main sections (Home, Watch, Search, Account, More)
    - NavigationPath management for each tab
    - Sheet and full-screen presentation coordination
    - Alert system integration
  - **External Navigation System** (JSON-driven):
    - `ExternalNavigationTarget` enum based on scaffolding URLs
    - Integration with `watch.tataplay.com`, `tataplayrecharge.com`
    - User confirmation dialogs for external links
    - Parameter-based URL construction
  - **Entertainment-Specific Navigation**:
    - Channel detail navigation with live TV integration
    - Content detail flows with watch functionality
    - Recharge and billing flows
    - Help center and support navigation
  - **Navigation Helpers**:
    - Pop to root and back navigation
    - Tab-specific navigation state management
    - String-based destination routing
  - **UI Integration**:
    - Complete MainTabView with navigation stacks
    - Sheet and full-screen view builders
    - External navigation buttons in detail views
    - Proper environment object injection

## 🎯 Next Phase: Base App Structure

### **Phase 4: Base App Structure** ⏳
- **Status**: ⏳ Next
- **Files**:
  - `TataPlayApp/TataPlayAppApp.swift` (main app)
  - `TataPlayApp/ContentView.swift` (root view)
- **Planned Features**:
  - App entry point configuration
  - Basic navigation shell setup
  - Tab bar implementation
  - Clean navigation management
  - Empty views for each main feature
  - MVVM base classes and protocols

### **Future Phases**:
- **Phase 5**: API Integration & Networking
- **Phase 6**: Feature Development (Authentication, Home, LiveTV, etc.)
- **Phase 7**: Einstein AI Integration
- **Phase 8**: Advanced Features (PiP, Chromecast, Offline)

## 🎬 Key Features (From JSON Scaffolding)

- ✅ Live TV streaming
- ✅ Channel management
- ✅ Subscription billing
- ✅ Content discovery
- ✅ Parental controls
- ✅ Multi-device support
- ✅ Remote control functionality
- ✅ Catch-up TV
- ✅ Recording functionality

## 🤖 Personalization Features (Einstein Ready)

- ✅ Viewing history recommendations
- ✅ Channel preference learning
- ✅ Time-based content suggestions
- ✅ Family profile personalization
- ✅ Genre preference tracking
- ✅ Content discovery enhancement

## 📦 Dependencies

```swift
.package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.8.0")
.package(url: "https://github.com/kean/Nuke.git", from: "12.0.0")
.package(url: "https://github.com/kishikawakatsumi/KeychainAccess.git", from: "4.2.2")
.package(url: "https://github.com/Flight-School/AnyCodable.git", from: "0.6.0")
.package(url: "https://github.com/airbnb/lottie-spm.git", from: "4.3.0")
.package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.5.0")
```

## 💻 Requirements

- iOS 16.0+
- Xcode 15.0+
- Swift 5.9+
- macOS 13.0+ (for development)

## 🚀 Getting Started

1. **Clone/Open Project**:
   ```bash
   cd TataPlayApp
   open TataPlayApp.xcodeproj
   ```

2. **Install Dependencies**:
   - Dependencies are automatically resolved by Xcode via SPM
   - Trust all macros when prompted on first build

3. **Build & Run**:
   ```bash
   # In Xcode
   Product > Build (⌘+B)
   Product > Run (⌘+R)
   ```

4. **Select Target**:
   - Choose iPhone 16 Pro Max simulator
   - Or any iOS 16.0+ device

## 🧪 Testing

- ✅ Models compilation and basic structure
- ✅ Design system color validation
- ✅ Navigation coordinator functionality
- ⏳ UI component tests (planned)
- ⏳ Business logic tests (planned)
- ⏳ Integration tests (planned)

```bash
# In Xcode
Product > Test (⌘+U)
```

## 📝 Development Notes

- Each phase is implemented step-by-step
- All changes are validated with builds
- Progress is documented in this README
- Clean commits for each completed step
- SwiftUI for all UI components
- MVVM pattern with ViewModels
- Protocol-oriented programming
- Comprehensive documentation
- Unit tests for business logic

**Current Priority**: Complete Phase 4 (Base App Structure)

## 🎯 Architecture Highlights

- **Architecture**: Clean MVVM with feature modules
- **Design System**: Color palette extracted from brand analysis
- **Models**: Comprehensive data structures for streaming business
- **Navigation**: Tab-based coordinator with external link support
- **API Integration**: Ready for Tata Play backend integration
- **Personalization**: Einstein AI framework prepared

---

**Last Updated**: Current Session  
**Project Status**: Phase 3 Complete ✅, Phase 4 Next 🔄  
**Next Step**: Base App Structure Implementation
