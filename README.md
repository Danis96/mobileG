
## 📋 Overview

Genie AI Mobile is a powerful AI assistant application built with Flutter that provides real-time conversational AI capabilities through WebSocket streaming. The app features AWS Cognito authentication, markdown-rendered responses with syntax highlighting, and comprehensive file handling capabilities.

## ✨ Features

### 🔐 Authentication
- **AWS Cognito Integration**: Secure user authentication
- Email/Password login
- Forgot password functionality
- Session management with token refresh

### 💬 Real-time Chat
- **WebSocket Streaming**: Real-time message streaming using STOMP protocol
- **Markdown Support**: Beautiful markdown rendering with:
  - Syntax-highlighted code blocks
  - Multiple language support
  - Copy-to-clipboard functionality
  - Line numbering
- **Smart Message Bubbles**:
  - User messages (right-aligned)
  - Assistant responses (left-aligned)
  - Streaming indicators

### 📁 File Management
- **Multi-source Upload**:
  - 📷 Camera capture
  - 🖼️ Gallery selection
  - 📄 File picker (documents, images, etc.)
- **File Mentions**: @ mention files in conversation
- **Drag & Drop** support (tablets)

### 📜 Chat History
- **Session Management**:
  - Save/Load chat sessions
  - Session organization by project
  - Search through history
- **Hamburger Menu Drawer**: Easy access to all past conversations
- **Local Storage**: Offline access to chat history

### 🎨 UI/UX
- Modern Material Design 3
- Dark/Light theme support
- Smooth animations
- Pull-to-refresh
- Responsive layouts (phone & tablet)

## 🔧 Project Configuration

1. Run `flutter pub get`
2. Run `dart run build_runner build`
3. Run `flutter gen-l10n`
3. Copy and paste provided `.jks` files to `android/app` directory
4. Copy and paste provided `key.properties` file to `android` directory
5. Add provided iOS certificates and provisioning profiles to Keychain Access.
  - To do so, simply double click on each file.
  - When adding certificates, you will be prompted to enter a password. You may find it in the `readme.md` file that is provided with certificates and provisioning profiles.
7. (Android Studio): Add run configurations for development and production environments.
  - Development: Set `Dart entrypoint` to `lib/main_dev.dart` and set build flavor to `development`
  - Production: Set `Dart entrypoint` to `lib/main.dart` and set build flavor to `production`
8. `flutter run --flavor <desired-flavor>`
