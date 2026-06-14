# Quick APK Build Instructions

## ⚠️ Prerequisites Required

Before you can build APK, you **MUST** have:

1. **Flutter SDK** (3.0+) - https://flutter.dev/docs/get-started/install
2. **Android SDK** (API 21+) 
3. **Java Development Kit (JDK)** 11+
4. **4GB+ RAM** and **5GB+ disk space**

---

## 🚀 Build APK - Two Options

### Option 1: Automatic (Windows) ⭐ RECOMMENDED
```
Double-click: build-apk.bat
```
Handles all steps automatically!

### Option 2: Automatic (Linux/macOS)
```bash
chmod +x build-apk.sh
./build-apk.sh
```

### Option 3: Manual Build
```bash
cd app_toko_extracted
flutter clean
flutter pub get
flutter build apk --release
```

---

## ✅ Setup Check

Before building, verify setup:

```bash
flutter doctor
flutter doctor --android-licenses
```

All should show ✓ (green checkmarks)

---

## 📍 Build Output Location

After successful build, APK will be at:

```
build/app/outputs/flutter-apk/app-release.apk
```

Size: ~15-20 MB

---

## ⏱️ Build Time

- **First build**: 10-15 minutes (includes Gradle setup)
- **Subsequent builds**: 5-10 minutes

---

## 📱 Install on Device

```bash
flutter install
```

Or manually:

```bash
adb install -r build/app/outputs/flutter-apk/app-release.apk
```

---

## 🐛 Troubleshooting

| Problem | Solution |
|---------|----------|
| Flutter not found | Install Flutter SDK and add to PATH |
| Android SDK not found | Run `flutter doctor` and follow instructions |
| Build fails | Run `flutter clean` then try again |
| Out of memory | Close other apps, ensure 4GB+ RAM |
| APK won't install | Use `adb install -r` to force reinstall |

---

## 📚 Full Guide

See: **BUILD_APK_GUIDE.md** for detailed instructions

---

## ✨ After Build

The APK can be:
- ✓ Installed on Android devices
- ✓ Shared with others
- ✓ Uploaded to Google Play Store
- ✓ Signed and released

---

## 🎯 Next Steps

1. **Install Flutter**: https://flutter.dev/docs/get-started/install
2. **Setup Android**: `flutter doctor --android-licenses`
3. **Build APK**: Double-click `build-apk.bat` or use commands above
4. **Test**: `flutter install` on device
5. **Share**: Distribute the APK file

---

**For more help**: See BUILD_APK_GUIDE.md in this directory
