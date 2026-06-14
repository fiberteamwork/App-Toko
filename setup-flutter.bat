@echo off
REM Automatic Flutter Setup Script for Windows
REM This script downloads and configures Flutter on Windows

setlocal enabledelayedexpansion

echo.
echo ====================================
echo  Flutter Automatic Setup - Windows
echo ====================================
echo.

REM Check if already installed
where flutter >nul 2>nul
if %errorlevel% equ 0 (
    echo ✓ Flutter already installed!
    flutter --version
    goto :end
)

REM Check for administrator rights
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo ⚠️ This script requires Administrator privileges!
    echo.
    echo Please run Command Prompt as Administrator:
    echo 1. Right-click Command Prompt
    echo 2. Select "Run as Administrator"
    echo 3. Run this script again
    echo.
    pause
    goto :end
)

echo Checking system prerequisites...
echo.

REM Check for Git
where git >nul 2>nul
if %errorlevel% neq 0 (
    echo ⚠️ Git not found. Downloading Flutter directly instead...
)

REM Choose install directory
set INSTALL_DIR=C:\flutter
echo.
echo ℹ️ Flutter will be installed to: %INSTALL_DIR%
echo.

REM Check if directory exists
if exist "%INSTALL_DIR%" (
    echo ✓ Directory exists
) else (
    echo Creating directory: %INSTALL_DIR%
    mkdir "%INSTALL_DIR%"
)

REM Download Flutter
echo.
echo 📥 Downloading Flutter SDK (~2.5 GB)...
echo This may take 10-30 minutes depending on internet speed...
echo.

REM Create temp download location
set TEMP_ZIP=%TEMP%\flutter_windows.zip

if not exist "%TEMP_ZIP%" (
    REM Use PowerShell to download
    powershell -NoProfile -ExecutionPolicy Bypass -Command ^
        "$progressPreference = 'SilentlyContinue'; ^
        Invoke-WebRequest -Uri 'https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.16.0-stable.zip' ^
        -OutFile '%TEMP_ZIP%'; ^
        Write-Host 'Download complete'"
    
    if %errorlevel% neq 0 (
        echo.
        echo ❌ Download failed!
        echo.
        echo Please download Flutter manually from:
        echo https://flutter.dev/docs/get-started/install/windows
        echo.
        echo Then extract to: %INSTALL_DIR%
        echo.
        pause
        goto :end
    )
) else (
    echo ✓ ZIP already downloaded
)

echo.
echo 📦 Extracting Flutter...
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "Expand-Archive -Path '%TEMP_ZIP%' -DestinationPath 'C:\' -Force"

echo.
echo ✓ Flutter extracted!

REM Clean up
del "%TEMP_ZIP%"

REM Add to PATH
echo.
echo 🔧 Adding Flutter to PATH...

REM Check if already in PATH
echo %PATH% | find /i "flutter" >nul
if %errorlevel% equ 0 (
    echo ✓ Flutter already in PATH
) else (
    setx PATH "%PATH%;%INSTALL_DIR%\bin"
    echo ✓ Flutter added to PATH
)

echo.
echo ✅ Flutter installation complete!
echo.
echo Next steps:
echo 1. Restart Command Prompt
echo 2. Run: flutter doctor
echo 3. Run: flutter doctor --android-licenses
echo 4. Install Java JDK 11 if needed
echo 5. Install Android Studio if needed
echo.

:end
pause
