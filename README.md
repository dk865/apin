# Apin Chat

**Made by dk865**

An intelligent AI chat application for iOS built with SwiftUI and Apple's Foundation Models framework, optimized for iPad Mini A17 Pro and iOS 26.

## Features

- 🤖 **Apple Intelligence Integration** - Powered by Apple's on-device Foundation Models
- 💬 **Multiple Chats** - Create and manage separate conversation threads
- 🎨 **Modern Design** - Beautiful, ChatGPT-inspired interface optimized for iPad Mini
- 💾 **Persistent Memory** - Conversations persist within each chat session
- 🔄 **Real-time Responses** - Fast, on-device AI processing
- 🎯 **Smart Chat Naming** - Automatically names chats based on content
- 📱 **iPad Optimized** - Specially designed for iPad Mini A17 Pro

## Requirements

- iOS 26.0+ (Public Beta)
- iPad Mini A17 Pro (recommended) or compatible device
- Apple Intelligence enabled
- Xcode 16.0+ for development

## Architecture

### Core Components

- **AIService**: Manages Foundation Models integration and session handling
- **ChatManager**: Handles chat creation, persistence, and message management
- **Models**: Data structures for Chat and ChatMessage
- **Views**: SwiftUI interface components

### Foundation Models Integration

The app uses Apple's Foundation Models framework with proper availability checking:

```swift
private var model = SystemLanguageModel.default

switch model.availability {
case .available:
    // Full AI functionality
case .unavailable(.deviceNotEligible):
    // Fallback UI
case .unavailable(.appleIntelligenceNotEnabled):
    // Prompt to enable Apple Intelligence
case .unavailable(.modelNotReady):
    // Loading state
}
```

## Building

### Local Development
Requires a Mac with Xcode 16.0+ and iOS 26 SDK.

### GitHub Actions
The project includes automated building via GitHub Actions:
- Builds for iOS Simulator (iPad Mini)
- Creates archive for device builds
- Uploads build artifacts
- No Mac required for CI/CD

## Installation

1. Clone the repository
2. Open `ApinChat.xcodeproj` in Xcode 16+
3. Select your target device or simulator
4. Build and run

For GitHub Actions builds, check the Actions tab for downloadable build artifacts.

## Usage

1. **First Launch**: Grant Apple Intelligence permissions if prompted
2. **New Chat**: Tap the pencil icon to create a new conversation
3. **Send Messages**: Type in the input field and tap send
4. **Switch Chats**: Use the sidebar to navigate between conversations
5. **Delete Chats**: Long press on a chat in the sidebar for options

## Privacy & Security

- All AI processing happens on-device via Apple Intelligence
- No data is sent to external servers
- Conversations are stored locally on your device
- Full privacy protection with Apple's Foundation Models

## Technical Details

- **Language**: Swift 6.0
- **Framework**: SwiftUI
- **AI**: Foundation Models (Apple Intelligence)
- **Deployment**: iOS 26.0+
- **Architecture**: MVVM with ObservableObject

## License

MIT License - see LICENSE file for details.

## About

Apin Chat demonstrates the power of Apple's on-device AI with a beautiful, functional chat interface. Built specifically for the iPad Mini A17 Pro and iOS 26, it showcases modern iOS development with cutting-edge AI integration.

**Made with ❤️ by dk865**
