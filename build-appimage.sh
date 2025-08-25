#!/bin/bash

# Build script for WhatsApp WebView AppImage

set -e

APP_NAME="WhatsApp-Web"
APP_DIR="AppDir"
PYTHON_VERSION="3.11"

echo "Creating AppImage for WhatsApp Web..."

# Clean previous build
rm -rf "$APP_DIR"
rm -f *.AppImage

# Create AppDir structure
mkdir -p "$APP_DIR/usr/bin"
mkdir -p "$APP_DIR/usr/lib"
mkdir -p "$APP_DIR/usr/share/applications"
mkdir -p "$APP_DIR/usr/share/icons/hicolor/256x256/apps"

# Copy main application
cp whatsapp.py "$APP_DIR/usr/bin/whatsapp"
chmod +x "$APP_DIR/usr/bin/whatsapp"

# Copy desktop file
cp whatsapp.desktop "$APP_DIR/usr/share/applications/"
cp whatsapp.desktop "$APP_DIR/"

# Download WhatsApp icon
if [ ! -f "whatsapp.png" ]; then
    echo "Downloading WhatsApp icon..."
    wget -O whatsapp.png "https://upload.wikimedia.org/wikipedia/commons/thumb/6/6b/WhatsApp.svg/256px-WhatsApp.svg.png" || {
        echo "Failed to download icon. Creating a simple placeholder..."
        # Create a simple green square as placeholder
        convert -size 256x256 xc:green whatsapp.png 2>/dev/null || {
            echo "ImageMagick not found. Please provide whatsapp.png icon manually."
            exit 1
        }
    }
fi

# Copy icon
cp whatsapp.png "$APP_DIR/usr/share/icons/hicolor/256x256/apps/"
cp whatsapp.png "$APP_DIR/"

# Create AppRun script
cat > "$APP_DIR/AppRun" << 'EOF'
#!/bin/bash
HERE="$(dirname "$(readlink -f "${0}")")"
export PATH="${HERE}/usr/bin:${PATH}"
export LD_LIBRARY_PATH="${HERE}/usr/lib:${LD_LIBRARY_PATH}"
export PYTHONPATH="${HERE}/usr/lib/python3/dist-packages:${PYTHONPATH}"
export GI_TYPELIB_PATH="${HERE}/usr/lib/girepository-1.0:${GI_TYPELIB_PATH}"

exec "${HERE}/usr/bin/whatsapp" "$@"
EOF

chmod +x "$APP_DIR/AppRun"

# Download and extract appimagetool if not present
if [ ! -f "appimagetool-x86_64.AppImage" ]; then
    echo "Downloading appimagetool..."
    wget -O appimagetool-x86_64.AppImage "https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage"
    chmod +x appimagetool-x86_64.AppImage
fi

# Bundle Python dependencies
echo "Installing Python dependencies..."
python3 -m pip install --target "$APP_DIR/usr/lib/python3/dist-packages" -r requirements.txt

# Copy system libraries (this is a simplified approach)
echo "Copying system libraries..."

# Copy GTK and WebKit libraries
for lib in libgtk-3.so.0 libwebkit2gtk-4.0.so.37 libgdk-3.so.0 libgobject-2.0.so.0 libglib-2.0.so.0; do
    if [ -f "/usr/lib/x86_64-linux-gnu/$lib" ]; then
        cp "/usr/lib/x86_64-linux-gnu/$lib" "$APP_DIR/usr/lib/"
    fi
done

# Copy GI typelibs
mkdir -p "$APP_DIR/usr/lib/girepository-1.0"
for typelib in Gtk-3.0.typelib WebKit2-4.0.typelib; do
    if [ -f "/usr/lib/x86_64-linux-gnu/girepository-1.0/$typelib" ]; then
        cp "/usr/lib/x86_64-linux-gnu/girepository-1.0/$typelib" "$APP_DIR/usr/lib/girepository-1.0/"
    fi
done

# Create the AppImage
echo "Creating AppImage..."
ARCH=x86_64 ./appimagetool-x86_64.AppImage "$APP_DIR" "$APP_NAME-x86_64.AppImage"

echo "AppImage created successfully: $APP_NAME-x86_64.AppImage"
echo "You can now run: ./$APP_NAME-x86_64.AppImage"
