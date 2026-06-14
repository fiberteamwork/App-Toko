@echo off
REM Flutter APK Build Script for Windows

setlocal enabledelayedexpansion

echo.
echo 🚀 Flutter APK Build Script - Windows
echo =====================================
echo.

REM Get project directory
set PROJECT_DIR=%~dp0
cd /d "%PROJECT_DIR%"

echo Project: %PROJECT_DIR%
echo.

REM Check Flutter
where flutter >nul 2>nul
if %errorlevel% neq 0 (
    echo ❌ Flutter SDK not found in PATH!
    echo.
    echo Please install Flutter from:
    echo https://flutter.dev/docs/get-started/install/windows
    echo.
    echo Then add Flutter to PATH environment variable
    pause
    exit /b 1
)

echo ✓ Flutter found
flutter --version
echo.

REM Check Android setup
echo Checking Android setup...
flutter doctor
echo.

REM Clean previous build
echo 🧹 Cleaning previous build...
call flutter clean

REM Get dependencies
echo.
echo 📥 Getting dependencies...
call flutter pub get

REM Build APK
echo.
echo 🔨 Building APK Release...
echo (This may take 5-15 minutes on first build)
echo.

call flutter build apk --release

if %errorlevel% equ 0 (
    echo.
    echo ✅ BUILD SUCCESSFUL!
    echo.
    echo 📁 APK Location:
    for %%F in (build\app\outputs\flutter-apk\app-release.apk) do (
        echo    %%F
        for /F "usebackq" %%A in ('%%F') do set "size=%%~zA"
    )
    echo.
    echo 📦 You can now:
    echo    1. Install on Android device: flutter install
    echo    2. Share the APK file
    echo    3. Upload to Play Store
    echo.
) else (
    echo.
    echo ❌ BUILD FAILED!
    echo.
    echo Try running: flutter doctor -v
    echo For troubleshooting help
    echo.
)

pause
