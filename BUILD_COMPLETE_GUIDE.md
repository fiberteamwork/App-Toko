# 🚀 APK BUILD COMPLETE SETUP GUIDE

## ⚠️ Current System Status

**Flutter SDK**: ❌ Not installed  
**Java (JDK)**: ❌ Not installed  
**Android SDK**: ❌ Not installed  

**Status**: Build environment needs setup

---

## 🎯 Two Options to Get APK

### OPTION A: Quick Setup (Recommended) ⭐

If you have another Windows computer with internet, download pre-configured Flutter:

1. **Download Flutter Windows Bundle** (~2GB)
   - Go to: https://flutter.dev/docs/get-started/install/windows
   - Download latest stable
   - Extract to `C:\flutter`

2. **Setup Environment**
   ```
   Add C:\flutter\bin to PATH
   ```

3. **Verify Setup**
   ```bash
   flutter doctor
   flutter doctor --android-licenses
   ```

4. **Build APK**
   ```bash
   cd app_toko_extracted
   flutter build apk --release
   ```

5. **Output**: `build/app/outputs/flutter-apk/app-release.apk` (~15-20 MB)

---

### OPTION B: Use Online Build Services (Easiest) ⭐⭐

Use cloud-based build services that don't require local setup:

1. **GitHub Actions** (Free)
   - Push code to GitHub
   - Auto-builds APK
   - Download from artifacts

2. **Firebase App Distribution** (Free tier available)
   - Upload source code
   - Auto-builds
   - Easy distribution

3. **AppCenter** (Free)
   - Connect GitHub repo
   - Auto-builds APK
   - Distribute to testers

4. **Appetize.io** (Web builds)
   - Upload source
   - Get web-based APK
   - No download needed

---

## 📥 Installation Steps (Local Setup)

### Step 1: Download Flutter

**Windows:**
- Go to: https://flutter.dev/docs/get-started/install/windows
- Download latest stable Flutter Windows bundle
- Extract to: `C:\flutter` or `D:\flutter`
- Size: ~2.5 GB

**macOS:**
```bash
brew install flutter
```

**Linux:**
```bash
git clone https://github.com/flutter/flutter.git
export PATH="$PATH:`pwd`/flutter/bin"
```

### Step 2: Add Flutter to PATH

**Windows:**
1. Open Environment Variables
2. Add `C:\flutter\bin` to PATH
3. Restart terminal

**macOS/Linux:**
```bash
export PATH="$PATH:$HOME/flutter/bin"
```

### Step 3: Install Java (JDK 11+)

**Windows:**
- Download from: https://www.oracle.com/java/technologies/downloads/
- Or use: `choco install jdk11` (if Chocolatey installed)

**macOS:**
```bash
brew install openjdk@11
```

**Linux:**
```bash
sudo apt-get install openjdk-11-jdk
```

### Step 4: Setup Android SDK

Option A: Use Android Studio (Easiest)
- Download from: https://developer.android.com/studio
- Install Android Studio
- SDK Manager installs automatically

Option B: Command Line
```bash
flutter config --android-sdk-path /path/to/android/sdk
```

### Step 5: Accept Licenses

```bash
flutter doctor --android-licenses
```

Type 'y' for each license

### Step 6: Verify Setup

```bash
flutter doctor
```

All items should show ✓ (green)

---

## 🔨 Building APK

### Using Batch File (Windows) ⭐ EASIEST

1. Navigate to: `app_toko_extracted`
2. Double-click: `build-apk.bat`
3. Wait 10-15 minutes
4. Done! APK is ready

### Using Command Line

```bash
cd app_toko_extracted
flutter clean
flutter pub get
flutter build apk --release
```

### Output Location

```
build/app/outputs/flutter-apk/app-release.apk
```

Size: 15-20 MB

---

## ⏱️ Build Time Estimates

- **First build**: 10-15 minutes
  - Gradle setup
  - Dependency download
  - Full compilation
  
- **Subsequent builds**: 5-10 minutes
  - Cached builds
  - Faster compilation

---

## 📱 After Build - Install APK

### Option 1: Using Flutter

```bash
flutter install
```

Requirements:
- Android device connected via USB
- USB debugging enabled
- USB cable

### Option 2: Using ADB

```bash
adb install -r build/app/outputs/flutter-apk/app-release.apk
```

### Option 3: Manual Install

1. Copy APK to phone via USB
2. Open file manager on phone
3. Tap APK to install
4. Grant permissions
5. Launch app

---

## 🐛 Common Problems & Solutions

### Problem 1: Flutter Command Not Found

**Cause**: Flutter not in PATH

**Solution**:
1. Verify Flutter extracted
2. Add to PATH environment variable
3. Restart terminal
4. Test: `flutter --version`

### Problem 2: Android SDK Not Found

**Cause**: Android SDK not installed

**Solution**:
```bash
flutter config --android-sdk-path "C:\Users\YourName\AppData\Local\Android\sdk"
```

Or install Android Studio which includes SDK.

### Problem 3: Java Not Found

**Cause**: Java not installed

**Solution**:
1. Download Java 11+ from oracle.com
2. Install
3. Set JAVA_HOME environment variable
4. Test: `java -version`

### Problem 4: Build Fails - Out of Memory

**Cause**: Not enough RAM

**Solution**:
```bash
set GRADLE_OPTS=-Xmx4g
flutter build apk --release
```

### Problem 5: Build Takes Too Long

**Tip**: First build is slow (10-15 min). Subsequent builds are faster.

**Speed up**:
- Close unnecessary apps
- Check internet connection
- Ensure 4GB+ RAM available
- Check disk space (5GB+ free)

### Problem 6: APK Won't Install

**Cause**: Architecture mismatch

**Solution**:
```bash
flutter build apk --release --split-per-abi
```

Creates:
- app-release-armeabi-v7a.apk (ARM 32-bit)
- app-release-arm64-v8a.apk (ARM 64-bit)
- app-release-x86.apk (x86 32-bit)
- app-release-x86_64.apk (x86 64-bit)

Choose matching your device architecture.

---

## 📊 Disk Space Requirements

| Component | Size |
|-----------|------|
| Flutter SDK | 2-3 GB |
| Android SDK | 2-3 GB |
| Java JDK | 300-500 MB |
| Build artifacts | 1-2 GB |
| **Total** | **5-8 GB** |

Ensure you have at least 5GB free space.

---

## 🎯 Alternative: Use GitHub Actions (No Local Setup)

### Setup CI/CD Build

1. **Push code to GitHub**
   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   git push -u origin main
   ```

2. **Create GitHub Actions Workflow**
   
   File: `.github/workflows/build-apk.yml`
   ```yaml
   name: Build APK
   on: [push]
   
   jobs:
     build:
       runs-on: ubuntu-latest
       steps:
         - uses: actions/checkout@v2
         - uses: subosito/flutter-action@v2
           with:
             flutter-version: '3.x'
         - run: flutter pub get
         - run: flutter build apk --release
         - uses: actions/upload-artifact@v2
           with:
             name: app-release.apk
             path: build/app/outputs/flutter-apk/app-release.apk
   ```

3. **Trigger Build**
   - Push to GitHub
   - GitHub Actions auto-builds
   - Download APK from artifacts

---

## ✅ Complete Checklist

- [ ] Download Flutter SDK
- [ ] Extract Flutter to C:\flutter
- [ ] Add Flutter to PATH
- [ ] Install Java JDK 11+
- [ ] Download Android Studio (or Android SDK)
- [ ] Run `flutter doctor`
- [ ] Accept Android licenses: `flutter doctor --android-licenses`
- [ ] Navigate to project: `cd app_toko_extracted`
- [ ] Run: `flutter clean`
- [ ] Run: `flutter pub get`
- [ ] Run: `flutter build apk --release`
- [ ] Wait 10-15 minutes
- [ ] Get APK from: `build/app/outputs/flutter-apk/app-release.apk`
- [ ] Test on Android device
- [ ] Share or upload to Play Store

---

## 📞 Getting Help

### Resources
- Flutter Docs: https://flutter.dev/docs
- Android Docs: https://developer.android.com/docs
- Flutter Community: https://flutter.dev/community

### Check Build Logs

```bash
flutter build apk --release -v
```

Shows detailed build information for debugging.

---

## 🎯 Expected Build Output

### Successful Build:

```
✓ Built build\app\outputs\flutter-apk\app-release.apk (XX.X MB).
```

### APK File Details:

```
File: app-release.apk
Size: 15-20 MB
Location: build/app/outputs/flutter-apk/app-release.apk
Signature: Debug (release build)
Supports: Android 5.0+ (API 21+)
```

---

## 📋 TLDR (Quick Summary)

1. **Install Flutter**: https://flutter.dev/docs/get-started/install
2. **Install Java**: https://www.oracle.com/java/technologies/downloads/
3. **Install Android SDK**: Download Android Studio
4. **Setup**: `flutter doctor --android-licenses`
5. **Build**: `flutter build apk --release` (in project directory)
6. **Get APK**: `build/app/outputs/flutter-apk/app-release.apk`

---

## Next Steps

Choose one:

1. **Local Build**: Follow installation steps above
2. **GitHub Actions**: Use CI/CD for automated builds
3. **Cloud Services**: Use appetize.io, Firebase, or AppCenter
4. **Pre-built**: Download from releases (if available)

Once you complete setup, come back and run:
```bash
cd app_toko_extracted
flutter build apk --release
```

Good luck! 🚀
