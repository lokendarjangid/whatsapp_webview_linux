#!/bin/bash

# Test script for WhatsApp Web AppImage

echo "🧪 Testing WhatsApp Web AppImage setup..."

# Test 1: Check if Python dependencies are available
echo "1. Testing Python dependencies..."
if python3 -c "import gi; gi.require_version('Gtk', '3.0'); gi.require_version('WebKit2', '4.0'); from gi.repository import Gtk, WebKit2" 2>/dev/null; then
    echo "   ✅ Python GTK dependencies OK"
else
    echo "   ❌ Python GTK dependencies missing"
    echo "   Run: ./install-dependencies.sh"
    exit 1
fi

# Test 2: Check FUSE2 availability
echo "2. Testing FUSE2 libraries..."
if ldconfig -p | grep -q libfuse.so.2; then
    echo "   ✅ FUSE2 libraries found"
else
    echo "   ❌ FUSE2 libraries missing"
    echo "   Run: ./install-dependencies.sh"
fi

# Test 3: Check if AppImage exists and is executable
echo "3. Testing AppImage..."
if [ -f "WhatsApp-Web-x86_64.AppImage" ] && [ -x "WhatsApp-Web-x86_64.AppImage" ]; then
    echo "   ✅ AppImage exists and is executable"
    echo "   Size: $(du -h WhatsApp-Web-x86_64.AppImage | cut -f1)"
else
    echo "   ❌ AppImage not found or not executable"
    echo "   Run: ./build-appimage-simple.sh"
fi

# Test 4: Test Python script directly
echo "4. Testing Python script..."
if [ -f "whatsapp.py" ]; then
    echo "   ✅ Main script found"
    echo "   You can run directly with: python3 whatsapp.py"
else
    echo "   ❌ Main script missing"
fi

echo ""
echo "🎯 Test Summary:"
echo "   - To install dependencies: ./install-dependencies.sh"
echo "   - To build AppImage: ./build-appimage-simple.sh"
echo "   - To run AppImage: ./WhatsApp-Web-x86_64.AppImage"
echo "   - To run directly: python3 whatsapp.py"
