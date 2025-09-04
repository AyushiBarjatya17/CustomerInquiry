# Customer Inquiry App

A modern iOS application built with SwiftUI featuring a comprehensive dashboard and chat functionality.

## 🏗️ Architecture

The app follows a clean, modular architecture with clear separation of concerns:

### 📁 Project Structure

```
CustomerInquiryApp/
├── Extensions/
│   └── ColorExtensions.swift          # Color theme and extensions
├── Models/
│   ├── Models.swift                   # Core data models (Post)
│   └── DashboardModels.swift          # Dashboard-specific models
├── ViewModels/
│   └── DashboardViewModel.swift       # Dashboard business logic
├── Views/
│   ├── Dashboard/
│   │   ├── DashboardView.swift        # Main dashboard container
│   │   ├── DashboardTopBar.swift      # Top navigation bar
│   │   ├── DashboardComponents.swift  # Reusable UI components
│   │   ├── DashboardSections.swift    # Dashboard sections
│   │   └── ChartView.swift            # Interactive chart component
│   └── Chat/
│       └── Message.swift              # Chat functionality
├── Services/
│   └── APIService.swift               # API communication
├── Utils/
│   └── ColorUtils.swift               # Color conversion utilities
├── ContentView.swift                  # Main app container
└── CustomerInquiryAppApp.swift        # App entry point
```

### 🎯 Key Features

#### Dashboard
- **Responsive Design**: Optimized for both iPad and iPhone
- **Interactive Charts**: Chatting statistics with time frame selection
- **Event Cards**: Jewish holiday events with chat functionality
- **Statistics**: Key metrics display
- **Recent Chats**: Quick access to previous conversations

#### Chat System
- **Real-time Messaging**: Interactive chat interface
- **API Integration**: Backend communication
- **Data Persistence**: Core Data integration

### 🔧 Technical Implementation

#### Responsive Layout
- **iPad**: Grid-based layout with optimal spacing
- **iPhone**: Stacked layout preserving visual hierarchy
- **Universal**: Scales properly on all screen sizes

#### Component Architecture
- **Reusable Components**: EventCard, StatCard, ChartView
- **Modular Views**: Separated by functionality
- **Clean Dependencies**: Minimal coupling between components

#### State Management
- **MVVM Pattern**: ViewModels for business logic
- **ObservableObject**: SwiftUI state management
- **Async Operations**: Proper async/await implementation

### 🎨 Design System

#### Color Scheme
- **Primary**: Purple (#8B5CF6)
- **Secondary**: Blue (#3B82F6)
- **Accent**: Orange (#F97316)
- **Semantic Colors**: Consistent across components

#### Typography
- **Hierarchy**: Clear text sizing and weights
- **Accessibility**: Proper contrast and readability
- **Consistency**: Unified font usage

### 🚀 Getting Started

1. **Clone the repository**
2. **Open in Xcode**
3. **Build and run on simulator/device**

### 📱 Device Support

- **iOS 15.0+**
- **iPhone**: All screen sizes
- **iPad**: All screen sizes
- **Universal**: Adaptive layouts

### 🔮 Future Enhancements

- [ ] Real-time chat functionality
- [ ] Push notifications
- [ ] Offline support
- [ ] User authentication
- [ ] Data synchronization
- [ ] Advanced analytics

### 🛠️ Dependencies

- **SwiftUI**: Modern UI framework
- **Core Data**: Data persistence
- **Foundation**: Core functionality
- **Combine**: Reactive programming (future)

### 📄 License

This project is proprietary and confidential.

