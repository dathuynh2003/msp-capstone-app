# MSP Capstone App

<div align="center">

**Meeting Support Platform - Mobile Application for Meeting Management**

[![Flutter](https://img.shields.io/badge/Flutter-3.9.0+-02569B?style=flat&logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-92.6%25-0175C2?style=flat&logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

</div>

## 📋 Introduction

**MSP Capstone App** (Meeting Support Platform) is a comprehensive mobile application built with Flutter, focused on efficient meeting management and organization. The app provides features such as meeting scheduling, real-time notifications, video calling, and project management.

### ✨ Key Features

- 🔐 **User Authentication**:  Login with Google Sign-In
- 📅 **Meeting Management**: Schedule, track, and organize meetings
- 📹 **Video Conference**: Integrated Stream Video for high-quality video calls
- 🔔 **Real-time Notifications**: Push notifications via Firebase Cloud Messaging
- 💬 **SignalR Integration**: Real-time data updates
- 📊 **Dashboard**: Track progress and manage projects
- 🎨 **Modern UI/UX**: User-friendly, responsive interface

## 🏗️ Architecture

The project is built following **Clean Architecture** with a clear layered structure:

```
lib/
├── core/                    # Core layer - Base layer
│   ├── constants/          # Constants and configuration
│   ├── errors/             # Error handling
│   ├── network/            # Network layer
│   ├── utils/              # Utilities and helpers
│   └── di/                 # Dependency Injection
├── features/               # Feature-based modules
│   ├── auth/               # Authentication
│   └── dashboard/          # Dashboard
├── shared/                 # Shared components
│   ├── entities/           # Shared entities
│   ├── mock_data/          # Mock data
│   └── theme/              # App theme
└── main.dart               # App entry point
```

See details in [ARCHITECTURE.md](msp_app/ARCHITECTURE.md)

## 🛠️ Technology Stack

### Framework & Language
- **Dart** (Flutter): 92.6%
- **C++**:  3.9%
- **CMake**: 2.9%
- **Swift**: 0.3%
- **HTML**: 0.2%
- **C**: 0.1%

### Core Dependencies
| Package | Purpose |
|---------|----------|
| `flutter_riverpod` | State management |
| `get_it` | Dependency injection |
| `dartz` | Functional programming (Either) |
| `http` | HTTP client |
| `shared_preferences` | Local storage |
| `stream_video_flutter` | Video calling |
| `firebase_messaging` | Push notifications |
| `signalr_netcore` | Real-time communication |
| `google_sign_in` | Google authentication |
| `jwt_decoder` | JWT token handling |

## 🚀 Installation Guide

### System Requirements

- Flutter SDK: ^3.9.0
- Dart SDK: ^3.9.0
- Android Studio / VS Code
- Xcode (for iOS development)

### 1. Clone Repository

```bash
git clone https://github.com/dathuynh2003/msp-capstone-app.git
cd msp-capstone-app/msp_app
```

### 2. Install Dependencies

```bash
flutter clean
flutter pub get
```

### 3. Firebase Configuration

1. Create a project on [Firebase Console](https://console.firebase.google.com/)
2. Add Android/iOS app to the project
3. Download and add configuration files:
   - Android: `google-services.json` → `android/app/`
   - iOS: `GoogleService-Info.plist` → `ios/Runner/`

### 4. Run Application

```bash
# Run on emulator/device
flutter run

# Run with profile mode
flutter run --profile

# Run with release mode
flutter run --release
```

### 5. Build Application

#### Android (APK)
```bash
flutter build apk --release
```

#### Android (App Bundle)
```bash
flutter build appbundle --release
```

#### iOS (requires macOS + Xcode)
```bash
flutter build ios --release
```

## 📱 Platform Support

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Windows
- ✅ macOS
- ✅ Linux

## 📖 Documentation

- [Architecture Guide](msp_app/ARCHITECTURE.md) - Detailed project architecture
- [Flutter Documentation](https://docs.flutter.dev/) - Flutter documentation
- [Stream Video SDK](https://getstream.io/video/docs/flutter/) - Video calling integration

## 🤝 Contributing

All contributions are welcome! Please: 

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 🐛 Bug Reports

If you find a bug or have suggestions, please [create an issue](https://github.com/dathuynh2003/msp-capstone-app/issues/new).

## 📄 License

This project is released under the [MIT License](LICENSE).

## 👨‍💻 Author

**dathuynh2003**
- GitHub:  [@dathuynh2003](https://github.com/dathuynh2003)

## 🙏 Acknowledgments

- [Flutter Team](https://flutter.dev) - Amazing framework
- [Riverpod](https://riverpod.dev) - State management solution
- [Stream](https://getstream.io) - Video calling infrastructure
- [Firebase](https://firebase.google.com) - Backend services

---

<div align="center">

**⭐ If you find this project useful, please give it a star!  ⭐**

Made with ❤️ using Flutter

</div>
