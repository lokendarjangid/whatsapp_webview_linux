#!/bin/bash

# Cleanup script for WhatsApp Web AppImage build

echo "Cleaning up build artifacts..."

# Remove build directories
rm -rf AppDir
rm -rf squashfs-root

# Remove downloaded tools (optional - uncomment if you want to remove them)
# rm -f appimagetool-x86_64.AppImage

echo "✅ Cleanup complete!"
echo ""
echo "Remaining files:"
ls -la WhatsApp-Web-x86_64.AppImage whatsapp.py whatsapp.desktop whatsapp.png README.md 2>/dev/null

echo ""
echo "🎉 Your WhatsApp Web AppImage is ready!"
echo "   File: WhatsApp-Web-x86_64.AppImage"
echo "   Size: $(du -h WhatsApp-Web-x86_64.AppImage | cut -f1)"
echo ""
echo "To run: ./WhatsApp-Web-x86_64.AppImage"
