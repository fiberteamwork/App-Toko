# Installation Guide

## System Requirements

### Windows/Mac/Linux
- **Flutter SDK**: >= 3.0.0
- **Dart SDK**: Included with Flutter
- **Java**: JDK 11+ (for Android builds)
- **Android SDK**: API 21+ (for Android development)
- **Git**: For version control (optional)

### Device Requirements
- **Android**: 5.0+ (API 21+)
- **RAM**: Minimum 2GB
- **Storage**: 50MB for app + database

## Pre-Installation Setup

### 1. Install Flutter

#### Windows
1. Download Flutter from: https://flutter.dev/docs/get-started/install
2. Extract to a folder (e.g., `C:\flutter`)
3. Add Flutter to PATH:
   - Go to System Environment Variables
   - Add `C:\flutter\bin` to PATH
4. Verify installation:
   ```bash
   flutter doctor
   ```

#### macOS
```bash
brew install flutter
flutter doctor
```

#### Linux
```bash
# Download from https://flutter.dev/docs/get-started/install/linux
tar xf flutter_linux_*.tar.xz
export PATH="$PATH:`pwd`/flutter/bin"
flutter doctor
```

### 2. Install Android SDK (Optional, for APK builds)

```bash
# Flutter provides Android SDK setup
flutter config --android-sdk-path /path/to/android/sdk
flutter doctor --android-licenses  # Accept all licenses
```

Or use Android Studio:
1. Download from https://developer.android.com/studio
2. Install and open Android Studio
3. Install SDKs via SDK Manager

## Installation Steps

### Method 1: From ZIP File

1. **Extract the ZIP**
   ```bash
   unzip app_toko.zip
   cd app_toko_extracted
   ```

2. **Get Dependencies**
   ```bash
   flutter pub get
   ```

3. **Verify Setup**
   ```bash
   flutter doctor
   ```
   Should show no errors or just warnings about iOS (if not on Mac).

### Method 2: From Git Repository

```bash
git clone <repository-url> app_toko
cd app_toko
flutter pub get
```

## Running the App

### Debug Mode (Android)
```bash
# Using connected Android device
flutter run

# Using Android emulator
flutter emulators launch <emulator-id>
flutter run
```

### Debug Mode (Web)
```bash
flutter run -d chrome
```

### Debug Mode (Windows/Linux)
```bash
flutter run -d windows
# or
flutter run -d linux
```

### Release Mode
```bash
flutter run --release
```

## Building for Distribution

### Build APK (Android)
```bash
# Debug APK
flutter build apk

# Release APK (recommended)
flutter build apk --release

# Split ABIs for smaller size
flutter build apk --release --split-per-abi
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

### Build App Bundle (Google Play)
```bash
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

### Build for Web
```bash
flutter build web --release
```

Output: `build/web/`

### Build for Windows
```bash
flutter build windows --release
```

Output: `build/windows/runner/Release/`

### Build for Linux
```bash
flutter build linux --release
```

Output: `build/linux/release/bundle/`

## Troubleshooting Installation

### Flutter doctor errors

**Error: Android SDK not found**
```bash
flutter config --android-sdk-path /path/to/android/sdk
```

**Error: No connected devices**
```bash
# List available emulators
flutter emulators

# Launch emulator
flutter emulators launch <emulator-id>

# Enable USB debugging on physical device and connect
```

**Error: Android licenses not accepted**
```bash
flutter doctor --android-licenses
# Type 'y' and press Enter for each license
```

### Dependency issues

**Clear and reinstall**
```bash
flutter clean
flutter pub get
```

**Pub cache corrupted**
```bash
rm -rf ~/.pub-cache  # Linux/Mac
rmdir %APPDATA%\Pub\Cache  # Windows
flutter pub get
```

### Build errors

**Dart analysis errors**
```bash
flutter analyze
```

**Lint warnings**
```bash
flutter analyze --no-congratulate
```

**Run build with verbose output**
```bash
flutter run -v
```

## Post-Installation

### First Run
1. App will create SQLite database automatically
2. Database location: `/data/data/com.example.nota_toko/databases/nota_toko.db` (Android)
3. Check app works without errors

### Initial Data
- Database is empty on first run
- You can start adding categories and products
- Use "Pengaturan Toko" to set store name before printing

### Printer Setup (Optional)
1. Pair Bluetooth printer via device Settings
2. Enable Bluetooth on device
3. Use "Nota" menu to print test receipt

## Development Setup

### IDE Setup

#### VS Code
```bash
# Install extensions
code --install-extension Dart-Code.dart-code
code --install-extension Dart-Code.flutter
```

#### Android Studio
1. Install Flutter and Dart plugins
2. Open project as Flutter project

#### IntelliJ IDEA
1. Install Flutter plugin
2. Open project as Flutter project

### Run Tests
```bash
flutter test
```

### Code Analysis
```bash
flutter analyze
```

### Format Code
```bash
dart format .
```

## Upgrade Flutter

```bash
flutter upgrade
flutter pub get
flutter pub upgrade
```

## Uninstall

### Windows
1. Delete Flutter SDK folder
2. Remove from PATH
3. Delete app if installed

### macOS
```bash
rm -rf ~/flutter
rm -rf ~/.pub-cache
```

### Android
1. Uninstall app from Play Store or device
2. Or run: `flutter uninstall`

## Deployment Checklist

- [ ] Tested all CRUD operations
- [ ] Tested on target device/OS
- [ ] Updated version in pubspec.yaml
- [ ] Updated CHANGELOG.md
- [ ] Removed debug prints and logs
- [ ] Code analyzed with `flutter analyze`
- [ ] Built release APK/AAB successfully
- [ ] Tested release build
- [ ] Signed APK for Play Store
- [ ] Updated store listing

## Support

For installation issues, refer to:
- Flutter Docs: https://flutter.dev/docs
- Dart Docs: https://dart.dev/guides
- GitHub Issues: Check repository issues
- StackOverflow: Tag with `flutter` and `dart`

## Next Steps

1. Read README.md for usage guide
2. Run app and test CRUD features
3. Refer to TODO.md for feature checklist
4. Check CHANGELOG.md for version history
