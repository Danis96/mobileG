# PresentationGenie

An AI-powered chatbot presentation app built with Flutter, featuring a clean and modern interface inspired by mihFIBER design.

## Features

### 🚀 Core Screens
- **Splash Screen**: Animated mihFIBER branding with loading indicator
- **Login Screen**: Email/password authentication with Microsoft login option and base URL configuration
- **Chat Screen**: Clean chat interface with AI assistant interaction
- **Settings Screen**: Comprehensive settings with profile management and configuration options

### 🎨 Design Highlights
- Modern Material Design 3 implementation
- Custom gradient branding elements
- Reusable widget components
- Responsive and accessible UI
- Clean typography and spacing

### 🛠 Technical Features
- **Clean Architecture**: Organized folder structure with separation of concerns
- **Reusable Components**: Custom buttons, text fields, and modal dialogs
- **State Management**: Efficient state handling with StatefulWidget
- **Navigation**: Smooth screen transitions and navigation flow
- **Form Validation**: Comprehensive input validation for all forms
- **Base URL Configuration**: Dynamic API endpoint configuration through settings modal

## Project Structure

```
lib/
├── core/
│   └── constants/
│       ├── app_colors.dart      # Color palette and theme colors
│       ├── app_strings.dart     # Centralized string constants
│       └── app_assets.dart      # Asset path constants
├── screens/
│   ├── splash_screen.dart       # App launch screen
│   ├── login_screen.dart        # Authentication screen
│   ├── chat_screen.dart         # Main chat interface
│   └── settings_screen.dart     # Settings and configuration
├── widgets/
│   ├── custom_button.dart       # Reusable button component
│   ├── custom_text_field.dart   # Reusable input field component
│   └── configure_modal.dart     # Base URL configuration dialog
└── main.dart                    # App entry point and theme configuration
```

## Getting Started

### Prerequisites
- Flutter SDK (3.9.0 or higher)
- Dart SDK
- iOS Simulator / Android Emulator or physical device

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd presentationgenie
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Configuration

The app includes a configuration modal accessible from the login screen that allows you to set:
- **Base URL**: Configure the API endpoint for your AI chatbot service

## App Flow

1. **Splash Screen** (3 seconds) → **Login Screen**
2. **Login Screen** → **Chat Screen** (after authentication)
3. **Chat Screen** ↔ **Settings Screen** (via app bar icon)
4. **Settings Screen** → **Login Screen** (sign out)

## Key Components

### Custom Widgets
- **CustomButton**: Supports primary, secondary, and outline styles with loading states
- **CustomTextField**: Includes validation, prefix/suffix icons, and password visibility toggle
- **ConfigureModal**: Reusable dialog for base URL configuration

### Color Scheme
- Primary colors: Purple (#8B5CF6), Blue (#3B82F6), Green (#10B981), Orange (#F59E0B)
- UI colors: Clean whites and grays for optimal readability
- Semantic colors: Success, error, and warning states

## Development Notes

- **Material Design 3**: Uses the latest Material Design guidelines
- **Responsive Design**: Adapts to different screen sizes
- **Accessibility**: Proper semantic labels and contrast ratios
- **Performance**: Optimized widget rebuilds and efficient state management

## Future Enhancements

- [ ] Real API integration for chat functionality
- [ ] Push notifications
- [ ] Dark mode support
- [ ] Multi-language support
- [ ] Chat history persistence
- [ ] File upload capabilities
- [ ] Voice input support

## License

This project is created for presentation and demonstration purposes.
