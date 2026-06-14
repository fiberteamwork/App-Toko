# Building Flutter APK Release - Complete Guide

## Prerequisites

Before building the APK, ensure you have:

1. **Flutter SDK** installed
2. **Android SDK** with API 21+
3. **Java Development Kit (JDK)** 11 or higher
4. Minimum 4GB RAM available
5. ~5GB disk space for Android SDK and build files

## Installation Steps

### Step 1: Install Flutter

#### Windows
```powershell
# Download from https://flutter.dev/docs/get-started/install/windows
# Extract to C:\flutter (or your preferred location)
# Add C:\flutter\bin to PATH environment variable

# Verify
flutter --version
```

#### macOS
```bash
# Using Homebrew
brew install flutter

# Or download from https://flutter.dev/docs/get-started/install/macos

# Verify
flutter --version
```

#### Linux
```bash
# Download from https://flutter.dev/docs/get-started/install/linux
# Extract and add to PATH

# Verify
flutter --version
```

### Step 2: Setup Flutter Doctor

```bash
flutter doctor
```

This will check your setup and show what's missing.

### Step 3: Accept Android Licenses

```bash
flutter doctor --android-licenses
```

Type 'y' and press Enter for each license agreement.

### Step 4: Verify Setup

```bash
flutter doctor
```

Should show all green checkmarks (warnings are OK for non-Android targets).

## Building APK

### Method 1: Using Batch File (Windows)

1. Navigate to project directory:
   ```
   cd app_toko_extracted
   ```

2. Double-click `build-apk.bat`

3. Wait for build to complete (5-15 minutes)

4. APK will be at: `build/app/outputs/flutter-apk/app-release.apk`

### Method 2: Using Bash Script (Linux/macOS)

```bash
cd app_toko_extracted
chmod +x build-apk.sh
./build-apk.sh
```

### Method 3: Manual Build Commands

```bash
# Navigate to project
cd app_toko_extracted

# Clean previous build
flutter clean

# Get dependencies
flutter pub get

# Build APK Release
flutter build apk --release

# (Optional) Build split APKs for smaller size
flutter build apk --release --split-per-abi
```

## Build Output

### Successful Build

```
✓ Build successful!
✓ APK saved to: build/app/outputs/flutter-apk/app-release.apk
```

### APK Location

- **Standard**: `build/app/outputs/flutter-apk/app-release.apk` (10-20 MB)
- **Split ABIs**: `build/app/outputs/flutter-apk/app-release-*.apk` (smaller per-architecture)

## Next Steps After Build

### Install on Device

```bash
flutter install
```

Requires:
- Android device connected via USB
- USB debugging enabled on device
- USB cable connected

### Install Manually

```bash
# Using adb (Android Debug Bridge)
adb install -r build/app/outputs/flutter-apk/app-release.apk

# Or manually copy APK to device and open with file manager
```

### Prepare for Play Store

For Google Play Store distribution, you need to:

1. Sign the APK (already done with release build)
2. Create Google Play Developer account
3. Create app listing
4. Upload APK/AAB to Play Store
5. Fill in store listing details
6. Submit for review

### Build App Bundle (Play Store Recommended)

```bash
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

This is smaller and Google Play handles device-specific APK generation.

## Build Options

### Standard Release APK
```bash
flutter build apk --release
```

### Split APKs by Architecture (Smaller)
```bash
flutter build apk --release --split-per-abi
```

Creates:
- `app-release-armeabi-v7a.apk` (~8 MB)
- `app-release-arm64-v8a.apk` (~9 MB)
- `app-release-x86.apk` (~9 MB)
- `app-release-x86_64.apk` (~10 MB)

### Verbose Build (for debugging)
```bash
flutter build apk --release -v
```

## Troubleshooting

### Build Fails - Android SDK Not Found

```bash
flutter config --android-sdk-path /path/to/android/sdk
```

Example:
```bash
# Windows
flutter config --android-sdk-path "C:\Users\YourName\AppData\Local\Android\sdk"

# Linux/macOS
flutter config --android-sdk-path "$HOME/Android/Sdk"
```

### Build Fails - Java Not Found

```bash
java -version
```

If not found, install Java:
- Download from: https://www.oracle.com/java/technologies/downloads/
- Or use OpenJDK via package manager
- Add JAVA_HOME to environment variables

### Build Fails - Out of Memory

```bash
# Increase Gradle memory
export GRADLE_OPTS="-Xmx4g"

# Then retry build
flutter build apk --release
```

### Build Takes Too Long

First build takes longer (10-15 min). Subsequent builds are faster (2-5 min).

Tips to speed up:
- Close other applications
- Use USB 3.0 ports if copying files
- Ensure sufficient RAM (4GB+)
- Check disk space (need 5GB+ free)

### Build Succeeds but APK Won't Install

Common causes:
1. **Different architecture**: Device is ARM but APK is x86
   - Use `flutter build apk --release --split-per-abi`
   - Choose matching architecture

2. **API level too low**: Device is too old
   - Minimum API: 21 (Android 5.0)
   - Check `minSdkVersion` in `android/app/build.gradle`

3. **Signature mismatch**: Reinstalling old APK
   - Uninstall old version first
   - Or use: `adb install -r` (force reinstall)

## Verification

### Check APK Info

```bash
# On Windows
aapt dump badging build/app/outputs/flutter-apk/app-release.apk

# On Linux/macOS
aapt dump badging build/app/outputs/flutter-apk/app-release.apk
```

Shows:
- Package name
- Version name
- Target SDK level
- Permissions
- Features

### Check APK Size

```bash
# Windows
dir build/app/outputs/flutter-apk/app-release.apk

# Linux/macOS
ls -lh build/app/outputs/flutter-apk/app-release.apk
```

## Build Time Estimates

| Build Type | Time | Notes |
|-----------|------|-------|
| First debug | 5-10 min | Gradle setup |
| Subsequent debug | 2-3 min | Cached builds |
| First release | 10-15 min | Full optimization |
| Subsequent release | 5-10 min | Incremental build |
| Split APKs | 8-12 min | Per-architecture |

## Security Considerations

- **Release APK is signed** with default keystore
- For Play Store, create/use signing keystore
- Never share private keystore file
- Password protect keystore file
- Keep backup of keystore (can't rebuild without it)

## Release Checklist

Before distributing APK:

- [ ] Test on multiple device architectures
- [ ] Test on different API levels (API 21+)
- [ ] Update version number in pubspec.yaml
- [ ] Update CHANGELOG with release notes
- [ ] Test all features in release build
- [ ] Check for debug logs (flutter run with --release)
- [ ] Verify app permissions in AndroidManifest.xml
- [ ] Test on real device (not just emulator)
- [ ] Check file size is acceptable (~15-20 MB)

## Resources

- Flutter Build Documentation: https://flutter.dev/docs/deployment/android
- Android Developers: https://developer.android.com/
- Play Store Console: https://play.google.com/console/
- Flutter Troubleshooting: https://flutter.dev/docs/testing/troubleshooting

## Next Steps

1. Install Flutter SDK
2. Run `flutter doctor`
3. Accept Android licenses
4. Run `build-apk.bat` (Windows) or `./build-apk.sh` (Linux/macOS)
5. Wait for build completion
6. APK ready in `build/app/outputs/flutter-apk/app-release.apk`
7. Test on device with `flutter install`
8. Share or upload to Play Store
