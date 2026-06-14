#!/bin/bash
# Flutter APK Build Script for Linux/macOS

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$PROJECT_DIR"

echo "🚀 Flutter APK Build Script"
echo "============================"
echo ""
echo "Project: $PROJECT_DIR"
echo ""

# Check Flutter
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter SDK not found!"
    echo ""
    echo "Please install Flutter from: https://flutter.dev/docs/get-started/install"
    exit 1
fi

echo "✓ Flutter found: $(flutter --version)"
echo ""

# Check Android
echo "Checking Android setup..."
flutter doctor

echo ""
echo "📦 Building APK..."
echo ""

# Clean previous build
echo "Cleaning previous build..."
flutter clean

# Get dependencies
echo "Getting dependencies..."
flutter pub get

# Build APK
echo ""
echo "🔨 Building APK Release..."
flutter build apk --release

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ BUILD SUCCESSFUL!"
    echo ""
    echo "APK Location:"
    ls -lh build/app/outputs/flutter-apk/app-release.apk
    echo ""
else
    echo ""
    echo "❌ BUILD FAILED!"
    exit 1
fi
