# LUV: Design Inspiration - Project Documentation

## Project Overview

LUV is a comprehensive Flutter mobile application that serves as a client for [COLOURlovers.com](https://www.colourlovers.com), providing designers and artists with endless inspiration through colors, palettes, and patterns. The app transforms the COLOURlovers community database into an optimized mobile experience with powerful discovery, organization, and sharing tools.

**Primary Purpose:** Enable designers, developers, and color enthusiasts to discover, explore, and organize color inspiration from the COLOURlovers community.

## Key Features

- **Discovery**: Browse individual colors, palettes, and patterns with comprehensive metadata.
- **Search & Filtering**: Advanced filtering by popularity, color ranges, keywords, and creators.
- **Random Discovery**: Get random colors, palettes, or patterns for unexpected inspiration.
- **Favorites Management**: Save and organize colors, palettes, and patterns for quick access.
- **Copy & Share**: Copy color values in multiple formats (hex, RGB, CSS) and share content.
- **Theming**: Light and dark theme support with customizable color schemes.
- **Cross-Platform**: Seamless experience across iOS, Android, macOS, Windows, and Linux.
- **Offline Favorites**: Local storage for saved items and preferences.
- **Community Profiles**: Explore user profiles and discover creations from COLOURlovers community members.

## Technical Stack

### Core Framework
- **Flutter**
- **Dart**
- **Material Design**

### State Management & Architecture
- **flutter_bloc**: BLoC pattern implementation with Cubit
- **equatable**: Value equality for state objects
- **fast_immutable_collections**: Immutable data structures

### Data & Storage
- **flutter_data_storage**: Local data persistence
- **path_provider**: File system access
- **crypto**: Cryptographic operations

### UI & Design
- **flex_color_scheme**: Theming and color scheme management
- **google_fonts**: Typography with Google Fonts
- **lucide_icons**: Icon set
- **another_xlider**: Custom slider components
- **aurora**: Additional UI components

### API & External Services
- **colourlovers_api**: COLOURlovers.com API integration
- **sentry_flutter**: Error tracking and performance monitoring

### Platform Integration
- **package_info_plus**: App version and build information
- **device_info_plus**: Device information access
- **share_plus**: Native sharing capabilities
- **url_launcher**: External URL handling
- **clipboard**: Clipboard operations
- **in_app_review**: App store review prompts
- **send_support_email**: Support email functionality

### Development & Testing
- **very_good_analysis**: Dart/Flutter linting rules
- **mocktail**: Mocking framework for testing
- **golden_screenshot**: Screenshot testing
- **build_runner**: Code generation
- **icons_launcher**: App icon generation
- **package_rename**: Package renaming utilities

## Project Structure

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
- iOS
- Android
- macOS
- Windows
- Linux
- Web (limited support)

## Development Information

### Build Requirements
- Flutter SDK >=3.29.0
- Dart SDK >=3.7.0
- Platform-specific development tools (Xcode, Android Studio)

### Key Configuration Files
- **pubspec.yaml**: Dependencies, assets, and platform configuration
- **analysis_options.yaml**: Dart/Flutter linting and analysis rules
- **Platform directories**: `ios/`, `android/`, `macos/`, `windows/`, `linux/`
- **fastlane/**: Automated deployment configurations

### Development Workflow
1. **Setup**: `flutter pub get`
2. **Development**: `flutter run`
3. **Testing**: Screenshot testing with golden files
4. **Building**: See `scripts/` directory
5. **Deployment**: Automated via fastlane

### Data Management
- **Local Storage**: `flutter_data_storage` for preferences and favorites
- **API Integration**: `colourlovers_api` for external data
- **State Persistence**: Automatic state persistence for user preferences
- **Data Migration**: Built-in migration support for app updates

This documentation provides a comprehensive overview of the LUV application's architecture, technical implementation, and development approach, serving as a reference for understanding the project structure and facilitating future development work.
