#!/bin/bash

# Script to create a new release

set -e

echo "🚀 WhatsApp Web AppImage Release Helper"
echo "======================================"

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "❌ Error: Not in a git repository"
    exit 1
fi

# Check if working directory is clean
if ! git diff-index --quiet HEAD --; then
    echo "❌ Error: Working directory is not clean. Please commit your changes first."
    echo "Uncommitted changes:"
    git status --porcelain
    exit 1
fi

# Get current version from tags
CURRENT_VERSION=$(git describe --tags --abbrev=0 2>/dev/null || echo "v0.0.0")
echo "Current version: $CURRENT_VERSION"

# Ask for new version
echo ""
echo "Enter new version (e.g., v1.0.0, v1.1.0, v2.0.0):"
read -r NEW_VERSION

# Validate version format
if [[ ! $NEW_VERSION =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "❌ Error: Invalid version format. Please use format like v1.0.0"
    exit 1
fi

# Check if tag already exists
if git rev-parse "$NEW_VERSION" >/dev/null 2>&1; then
    echo "❌ Error: Tag $NEW_VERSION already exists"
    exit 1
fi

echo ""
echo "📝 Creating release notes..."
echo "Enter a brief description of this release (press Enter when done):"
read -r RELEASE_DESCRIPTION

# Confirm release
echo ""
echo "🔍 Release Summary:"
echo "   Version: $NEW_VERSION"
echo "   Previous: $CURRENT_VERSION"
echo "   Description: $RELEASE_DESCRIPTION"
echo ""
echo "This will:"
echo "   1. Create and push tag $NEW_VERSION"
echo "   2. Trigger GitHub Actions to build AppImage"
echo "   3. Create GitHub Release with the AppImage"
echo ""
read -p "Continue? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Release cancelled"
    exit 1
fi

# Create and push tag
echo "🏷️  Creating tag $NEW_VERSION..."
git tag -a "$NEW_VERSION" -m "Release $NEW_VERSION

$RELEASE_DESCRIPTION"

echo "📤 Pushing tag to GitHub..."
git push origin "$NEW_VERSION"

echo ""
echo "✅ Release $NEW_VERSION created successfully!"
echo ""
echo "🔄 GitHub Actions is now building the AppImage..."
echo "   Check progress at: https://github.com/lokendarjangid/whatsapp_webview_linux/actions"
echo ""
echo "📦 Once complete, the release will be available at:"
echo "   https://github.com/lokendarjangid/whatsapp_webview_linux/releases/tag/$NEW_VERSION"
