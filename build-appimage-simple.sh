#!/bin/bash

# Simplified AppImage build script for WhatsApp Web

set -e

APP_NAME="WhatsApp-Web"
APP_DIR="AppDir"

echo "Creating AppImage for WhatsApp Web..."

# Check and install FUSE dependencies if needed
echo "Checking FUSE dependencies..."
if ! ldconfig -p | grep -q libfuse.so.2; then
    echo "FUSE2 libraries not found. Installing..."
    
    # Detect Linux distribution and install appropriate FUSE package
    if command -v apt-get >/dev/null 2>&1; then
        # Debian/Ubuntu
        echo "Detected Debian/Ubuntu system"
        sudo apt-get update
        sudo apt-get install -y libfuse2
    elif command -v dnf >/dev/null 2>&1; then
        # Fedora
        echo "Detected Fedora system"
        sudo dnf install -y fuse-libs
    elif command -v yum >/dev/null 2>&1; then
        # RHEL/CentOS
        echo "Detected RHEL/CentOS system"
        sudo yum install -y fuse-libs
    elif command -v pacman >/dev/null 2>&1; then
        # Arch Linux
        echo "Detected Arch Linux system"
        sudo pacman -S --noconfirm fuse2
    elif command -v zypper >/dev/null 2>&1; then
        # openSUSE
        echo "Detected openSUSE system"
        sudo zypper install -y libfuse2
    else
        echo "⚠️  Unknown package manager. Please install FUSE2 manually:"
        echo "   - Ubuntu/Debian: sudo apt install libfuse2"
        echo "   - Fedora: sudo dnf install fuse-libs"
        echo "   - Arch: sudo pacman -S fuse2"
        echo "   - openSUSE: sudo zypper install libfuse2"
        echo ""
        echo "Continuing with build (AppImage might not run without FUSE2)..."
    fi
else
    echo "✅ FUSE2 libraries found"
fi

# Clean previous build
rm -rf "$APP_DIR"
rm -f *.AppImage

# Create basic AppDir structure
mkdir -p "$APP_DIR"

# Create the main executable script
cat > "$APP_DIR/whatsapp" << 'EOF'
#!/usr/bin/env python3
import gi
gi.require_version('Gtk', '3.0')
gi.require_version('WebKit2', '4.1')
from gi.repository import Gtk, WebKit2

class WhatsApp(Gtk.Window):
    def __init__(self):
        super().__init__(title="WhatsApp")
        self.set_default_size(1100, 720)

        view = WebKit2.WebView()
        view.load_uri("https://web.whatsapp.com/")

        scrolled = Gtk.ScrolledWindow()
        scrolled.add(view)

        self.add(scrolled)
        self.connect("destroy", Gtk.main_quit)

win = WhatsApp()
win.show_all()
Gtk.main()
EOF

chmod +x "$APP_DIR/whatsapp"

# Copy desktop file
cp whatsapp.desktop "$APP_DIR/"

# Download WhatsApp icon if not present
if [ ! -f "whatsapp.png" ]; then
    echo "Downloading WhatsApp icon..."
    wget -q -O whatsapp.png "https://upload.wikimedia.org/wikipedia/commons/thumb/6/6b/WhatsApp.svg/256px-WhatsApp.svg.png" || {
        echo "Failed to download icon. Creating a placeholder..."
        # Create a simple placeholder if wget fails
        echo "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg==" | base64 -d > whatsapp.png 2>/dev/null || {
            # If base64 fails, create an empty file
            touch whatsapp.png
        }
    }
fi

# Copy icon
cp whatsapp.png "$APP_DIR/"

# Create AppRun script
cat > "$APP_DIR/AppRun" << 'EOF'
#!/bin/bash
HERE="$(dirname "$(readlink -f "${0}")")"
export PATH="${HERE}:${PATH}"
exec "${HERE}/whatsapp" "$@"
EOF

chmod +x "$APP_DIR/AppRun"

# Download appimagetool if not present
if [ ! -f "appimagetool-x86_64.AppImage" ]; then
    echo "Downloading appimagetool..."
    wget -q --show-progress -O appimagetool-x86_64.AppImage "https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage"
    chmod +x appimagetool-x86_64.AppImage
fi

# Create the AppImage
echo "Creating AppImage..."
ARCH=x86_64 ./appimagetool-x86_64.AppImage "$APP_DIR" "$APP_NAME-x86_64.AppImage"

if [ $? -eq 0 ]; then
    echo "✅ AppImage created successfully: $APP_NAME-x86_64.AppImage"
    echo "You can now run: ./$APP_NAME-x86_64.AppImage"
    ls -lh "$APP_NAME-x86_64.AppImage"
else
    echo "❌ Failed to create AppImage"
    exit 1
fi
