# 🌐 Helium Browser

A lightweight, privacy-first mobile browser for Android and iOS, built with Flutter.

## Features

- 🚀 Lightweight (<80MB with 3 tabs)
- 🛡️ Built-in ad & tracker blocking
- 🔒 Private/Incognito mode
- 📑 Tab management
- 🔖 Bookmarks
- 🕐 History
- 🌙 Dark mode support

## Tech Stack

- **Framework**: Flutter 3.19+
- **State Management**: Riverpod 2.x
- **Navigation**: go_router
- **Database**: Isar
- **WebView**: flutter_inappwebview
- **Ad Blocking**: EasyList + EasyPrivacy

## Getting Started

```bash
# Install dependencies
flutter pub get

# Run code generation
dart run build_runner build

# Run the app
flutter run
```

## Project Structure

```
lib/
├── core/          # Shared utilities, theme, router
├── features/      # Feature-first architecture
│   ├── browser/   # Core WebView
│   ├── tabs/      # Tab management
│   ├── address_bar/
│   ├── ad_blocking/
│   ├── bookmarks/
│   ├── history/
│   └── settings/
└── shared/        # Reusable widgets
```

## License

MIT License
