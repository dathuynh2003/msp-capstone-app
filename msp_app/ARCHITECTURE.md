# MSP App Architecture

## 🏗️ Kiến Trúc Tổng Quan

Dự án MSP App được xây dựng theo **Clean Architecture** với **Feature-Based Organization** và sử dụng **Riverpod** cho state management.

## 📁 Cấu Trúc Thư Mục

```
lib/
├── core/                    # Core layer - tầng cơ sở
│   ├── constants/          # Constants và configuration
│   ├── errors/             # Error handling
│   ├── network/            # Network layer
│   ├── utils/              # Utilities và helpers
│   ├── di/                 # Dependency Injection
│   └── core.dart           # Core exports
├── features/               # Feature-based modules
│   ├── auth/               # Authentication feature
│   │   ├── data/           # Data layer
│   │   ├── domain/         # Domain layer
│   │   └── presentation/   # Presentation layer
│   └── dashboard/          # Dashboard feature
│       ├── data/           # Data layer
│       ├── domain/         # Domain layer
│       └── presentation/   # Presentation layer
├── shared/                 # Shared components
│   ├── entities/           # Shared entities
│   ├── mock_data/          # Mock data
│   └── theme/              # App theme
├── main.dart               # App entry point
└── app.dart                # App configuration
```

## 🔧 Core Layer

### Constants
- `app_constants.dart`: App-wide constants
- `api_endpoints.dart`: API endpoints configuration

### Error Handling
- `failures.dart`: Failure classes cho error handling
- `exceptions.dart`: Exception classes

### Network
- `api_client.dart`: HTTP client wrapper
- `network_info.dart`: Network connectivity check

### Utils
- `validators.dart`: Form validation utilities
- `date_utils.dart`: Date/time utilities

### Dependency Injection
- `injection_container.dart`: GetIt service locator setup

## 🎯 Features

Mỗi feature có cấu trúc Clean Architecture:

### Data Layer
- **DataSources**: API calls, local storage
- **Models**: Data transfer objects
- **Repository Implementations**: Concrete implementations

### Domain Layer
- **Entities**: Business objects
- **Repositories**: Abstract interfaces
- **Use Cases**: Business logic

### Presentation Layer
- **Pages**: UI screens
- **Widgets**: Reusable UI components
- **Providers**: Riverpod state management

## 🔄 Dependency Injection

Sử dụng **GetIt** service locator:

```dart
// Khởi tạo trong main.dart
await di.init();

// Sử dụng trong providers
final authNotifier = AuthNotifier(loginUseCase: sl<LoginUseCase>());
```

## 📦 Dependencies

### Core Dependencies
- `flutter_riverpod`: State management
- `get_it`: Dependency injection
- `dartz`: Functional programming (Either)
- `equatable`: Value equality
- `http`: HTTP client
- `shared_preferences`: Local storage
- `connectivity_plus`: Network connectivity
- `intl`: Internationalization

### Development Dependencies
- `freezed`: Code generation
- `json_annotation`: JSON serialization
- `build_runner`: Code generation runner

## 🚀 Best Practices

### 1. Error Handling
- Sử dụng Either<Failure, Success> pattern
- Custom exceptions và failures
- Proper error propagation

### 2. State Management
- Riverpod providers cho state
- Immutable state objects
- Proper loading và error states

### 3. Network Layer
- Centralized API client
- Proper error handling
- Timeout configuration

### 4. Code Organization
- Feature-based structure
- Clear separation of concerns
- Consistent naming conventions

## 🔧 Setup Instructions

1. **Install dependencies**:
   ```bash
   flutter pub get
   ```

2. **Run code generation** (if using freezed):
   ```bash
   flutter packages pub run build_runner build
   ```

3. **Run the app**:
   ```bash
   flutter run
   ```

## 📝 Notes

- Tất cả entities được đặt trong `shared/entities`
- Core layer chứa các utilities và configurations chung
- Mỗi feature có thể phát triển độc lập
- Dependency injection được setup tự động khi app khởi động

