# CustomerInquiryApp - Project Structure

This document outlines the organized folder structure for the CustomerInquiryApp iOS project.

## 📁 Project Organization

### 🎯 App Entry Point
- `CustomerInquiryAppApp.swift` - Main app entry point

### 👁️ Views
- `Views/` - All UI-related files
  - `ContentView.swift` - Main content view
  - `Message.swift` - Message-related views
  - `Dashboard/` - Dashboard-specific views
    - `DashboardView.swift` - Main dashboard view
  - `Components/` - Reusable UI components
  - `Forms/` - Form-related views
  - `Modals/` - Modal and popup views

### 🏗️ Models
- `Models/` - Data models and structures
  - `Models.swift` - Core data models
  - `Core/` - Core business models
  - `DTOs/` - Data Transfer Objects

### 🎮 ViewModels
- `ViewModels/` - Business logic and state management

### 🔧 Services
- `Services/` - Business logic and external integrations
  - `Network/` - API and network services
    - `APIService.swift` - API communication
  - `Database/` - Data persistence
    - `Persistence.swift` - Core Data management
  - `Analytics/` - Analytics and tracking services

### 🔌 Extensions
- `Extensions/` - Swift extensions
  - `UI/` - UIKit extensions
  - `Foundation/` - Foundation framework extensions
  - `SwiftUI/` - SwiftUI-specific extensions

### 🛠️ Utils
- `Utils/` - Utility functions and helpers
  - `Helpers/` - Helper functions
  - `Constants/` - App constants and configuration
  - `Validators/` - Input validation utilities

### 📱 Resources
- `Assets.xcassets/` - Images, colors, and app icons
- `CustomerInquiryApp.xcdatamodeld/` - Core Data model

## 🚀 Benefits of This Structure

1. **Separation of Concerns** - Clear separation between UI, business logic, and data
2. **Maintainability** - Easy to locate and modify specific functionality
3. **Scalability** - Structure supports growth as the app expands
4. **Team Collaboration** - Clear ownership and organization for team members
5. **Testing** - Easier to write and organize unit tests

## 📋 Best Practices

- Keep related files together in appropriate folders
- Use descriptive folder names that clearly indicate their purpose
- Maintain consistent naming conventions across the project
- Group similar functionality together
- Avoid deep nesting (max 3-4 levels)

## 🔄 Future Considerations

As the app grows, consider:
- Adding a `Resources/` folder for non-code assets
- Creating a `Protocols/` folder for protocol definitions
- Adding a `Tests/` folder for unit tests
- Creating a `Documentation/` folder for project documentation

