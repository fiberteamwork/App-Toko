#!/bin/bash
# Automatic Flutter Setup Script for macOS and Linux

echo ""
echo "===================================="
echo "  Flutter Automatic Setup"
echo "===================================="
echo ""

# Check if already installed
if command -v flutter &> /dev/null; then
    echo "✓ Flutter already installed!"
    flutter --version
    exit 0
fi

# Determine OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    echo "Detected: macOS"
    echo ""
    echo "Installing Flutter using Homebrew..."
    
    # Check for Homebrew
    if ! command -v brew &> /dev/null; then
        echo "⚠️ Homebrew not found!"
        echo "Please install Homebrew first:"
        echo "/bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
        exit 1
    fi
    
    # Install Flutter
    brew install flutter
    
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    echo "Detected: Linux"
    echo ""
    echo "Setting up Flutter on Linux..."
    
    # Download Flutter
    FLUTTER_DIR="$HOME/flutter"
    
    if [ -d "$FLUTTER_DIR" ]; then
        echo "✓ Flutter directory exists"
    else
        echo "📥 Downloading Flutter..."
        git clone https://github.com/flutter/flutter.git -b stable "$FLUTTER_DIR"
    fi
    
    # Add to PATH
    if grep -q "$FLUTTER_DIR/bin" ~/.bashrc; then
        echo "✓ Flutter already in PATH"
    else
        echo "export PATH=\"\$PATH:$FLUTTER_DIR/bin\"" >> ~/.bashrc
        echo "✓ Flutter added to PATH"
    fi
    
    source ~/.bashrc
else
    echo "❌ Unsupported OS: $OSTYPE"
    exit 1
fi

echo ""
echo "✅ Flutter setup complete!"
echo ""
echo "Next steps:"
echo "1. Run: flutter doctor"
echo "2. Run: flutter doctor --android-licenses"
echo "3. Install Java JDK 11 if needed"
echo "4. Install Android Studio if needed"
echo ""
