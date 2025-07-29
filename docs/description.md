# LUV: Design Inspiration - Project Documentation

## Project Overview

LUV is a comprehensive Flutter mobile application that serves as a client for [COLOURlovers.com](https://www.colourlovers.com), providing designers and artists with endless inspiration through colors, palettes, and patterns. The app transforms the COLOURlovers community database into an optimized mobile experience with powerful discovery, organization, and sharing tools.

**Primary Purpose:** Enable designers, developers, and color enthusiasts to discover, explore, and organize color inspiration from the COLOURlovers community.

**Target Audience:** 
- Graphic designers and UI/UX designers
- Web developers and mobile app developers
- Artists and creative professionals
- Anyone seeking color inspiration and design resources

## Key Features

### Core Functionality
- **Color Discovery**: Browse individual colors with comprehensive metadata including hex values, RGB/HSV components, popularity metrics, and creator information
- **Palette Exploration**: Access curated color palettes with advanced filtering and composition viewing
- **Pattern Browsing**: Discover decorative patterns with high-resolution images and color information
- **Community Profiles**: Explore user profiles and discover creations from COLOURlovers community members

### Advanced Features
- **Search & Filtering**: Advanced filtering by popularity, color ranges, keywords, creators, and more
- **Random Discovery**: Get random colors, palettes, or patterns for unexpected inspiration
- **Favorites Management**: Save and organize colors, palettes, and patterns for quick access
- **Copy & Share**: Copy color values in multiple formats (hex, RGB, CSS) and share content
- **Theming**: Light and dark theme support with customizable color schemes

### User Experience
- **Cross-Platform**: Seamless experience across iOS, Android, macOS, Windows, and Linux
- **Responsive Design**: Optimized for mobile browsing and discovery
- **Offline Favorites**: Local storage for saved items and preferences

## Technical Stack

### Core Framework
- **Flutter**: >=3.29.0
- **Dart**: >=3.7.0 <4.0.0
- **Material Design**: Flutter's material design implementation

### State Management & Architecture
- **flutter_bloc**: ^9.0.0 - BLoC pattern implementation with Cubit
- **equatable**: ^2.0.7 - Value equality for state objects
- **fast_immutable_collections**: ^11.0.4 - Immutable data structures

### Data & Storage
- **flutter_data_storage**: Custom git dependency for local data persistence
- **path_provider**: ^2.1.5 - File system access for data migration
- **crypto**: ^3.0.3 - Cryptographic operations for data security

### UI & Design
- **flex_color_scheme**: ^8.2.0 - Advanced theming and color scheme management
- **google_fonts**: ^6.2.1 - Typography with Google Fonts integration
- **lucide_icons**: ^0.257.0 - Modern icon set
- **another_xlider**: ^3.0.2 - Custom slider components
- **aurora**: ^1.0.0 - Additional UI components

### API & External Services
- **colourlovers_api**: Custom git dependency for COLOURlovers.com API integration
- **sentry_flutter**: ^9.3.0 - Error tracking and performance monitoring

### Platform Integration
- **package_info_plus**: ^8.3.0 - App version and build information
- **device_info_plus**: ^11.4.0 - Device information access
- **share_plus**: ^11.0.0 - Native sharing capabilities
- **url_launcher**: ^6.3.1 - External URL handling
- **clipboard**: ^0.1.3 - Clipboard operations
- **in_app_review**: ^2.0.10 - App store review prompts
- **send_support_email**: Custom git dependency for support email functionality

### Development & Testing
- **very_good_analysis**: ^8.0.0 - Dart/Flutter linting rules
- **mocktail**: ^1.0.4 - Mocking framework for testing
- **golden_screenshot**: ^3.1.3 - Screenshot testing
- **build_runner**: ^2.5.4 - Code generation
- **icons_launcher**: ^3.0.1 - App icon generation
- **package_rename**: ^1.10.0 - Package renaming utilities

## Project Structure

### Architecture Pattern
The application follows a **View-Controller-State (VCS)** pattern with BLoC state management:

```
lib/
├── main.dart                    # App entry point with BLoC providers
├── app/                         # Root app configuration
│   ├── view.dart               # Main app widget and theme setup
│   ├── view-controller.dart    # App-level state management
│   ├── view-state.dart         # App-level state definitions
│   └── defines.dart            # App constants and definitions
├── app-content/                # Main content container
├── explore/                    # Discovery and exploration features
├── lists/                      # List views for different content types
│   ├── colors/                 # Color list implementations
│   ├── palettes/               # Palette list implementations
│   ├── patterns/               # Pattern list implementations
│   └── users/                  # User list implementations
├── details/                    # Detail views for content
│   ├── color/                  # Color detail screens
│   ├── palette/                # Palette detail screens
│   ├── pattern/                # Pattern detail screens
│   └── user/                   # User profile screens
├── filters/                    # Filtering system
│   ├── color/                  # Color-specific filters
│   ├── palette/                # Palette-specific filters
│   ├── pattern/                # Pattern-specific filters
│   ├── user/                   # User-specific filters
│   └── favorites/              # Favorites filtering
├── favorites/                  # Favorites management
├── preferences/                # User preferences and settings
├── share/                      # Sharing functionality
├── widgets/                    # Reusable UI components
├── theme/                      # Theme definitions and utilities
└── urls/                       # URL handling and deep linking
```

### Key Architectural Principles

1. **Separation of Concerns**: Each feature is organized into view, controller, and state files
2. **Data Controllers**: Separate controllers handle data persistence and business logic using `StoredCubit`
3. **Modular Design**: Features are self-contained with clear boundaries
4. **State Management**: Reactive state management using BLoC pattern with Cubit
5. **Dependency Injection**: BLoC providers manage dependency injection at the app level

### Data Flow
1. **Views** render UI based on state and handle user interactions
2. **View Controllers** manage feature-specific state and business logic
3. **Data Controllers** handle data persistence, API calls, and cross-feature state
4. **State Objects** define immutable state structures with copyWith methods

## Supported Platforms

### Primary Platforms
- **iOS**: Full support with App Store deployment via fastlane
- **Android**: Full support with Play Store deployment via fastlane  
- **macOS**: Full support with Mac App Store deployment via fastlane

### Secondary Platforms
- **Windows**: Desktop support with custom app configuration
- **Linux**: Desktop support with custom app configuration
- **Web**: Configured but with limited icon support (disabled in current config)

### Platform-Specific Features
- **Mobile (iOS/Android)**: Optimized touch interfaces, native sharing, app store reviews
- **Desktop (macOS/Windows/Linux)**: Keyboard navigation, window management, desktop integration
- **Cross-Platform**: Consistent theming, data synchronization, responsive layouts

## Development Information

### Build Requirements
- Flutter SDK >=3.29.0
- Dart SDK >=3.7.0
- Platform-specific development tools (Xcode for iOS/macOS, Android Studio for Android)

### Key Configuration Files
- **pubspec.yaml**: Dependencies, assets, and platform configuration
- **analysis_options.yaml**: Dart/Flutter linting and analysis rules
- **Platform directories**: iOS, Android, macOS, Windows, Linux specific configurations
- **fastlane/**: Automated deployment configurations for iOS, Android, and macOS

### Development Workflow
1. **Setup**: `flutter pub get` to install dependencies
2. **Development**: `flutter run` for hot reload development
3. **Testing**: Screenshot testing with golden files
4. **Building**: Platform-specific build scripts in `scripts/` directory
5. **Deployment**: Automated via fastlane for app stores

### Code Organization
- **Feature-based structure**: Each major feature has its own directory
- **Consistent naming**: view.dart, view-controller.dart, view-state.dart pattern
- **Shared utilities**: Common functionality in root-level utility files
- **Asset management**: Organized assets with proper Flutter asset configuration

### Data Management
- **Local Storage**: Custom flutter_data_storage for preferences and favorites
- **API Integration**: Custom colourlovers_api package for external data
- **State Persistence**: Automatic state persistence for user preferences
- **Data Migration**: Built-in migration support for app updates

This documentation provides a comprehensive overview of the LUV application's architecture, technical implementation, and development approach, serving as a reference for understanding the project structure and facilitating future development work.
